# Exercice 1 : Fondamentaux MLJ (Machine Learning en Julia)
# Module 3 : Apprentissage Automatique avec Julia
# Durée : 60 minutes

# 📚 AVANT DE COMMENCER
# Lisez le résumé d'apprentissage : resume_01_mlj_basics.md
# Découvrez pourquoi Julia révolutionne le Machine Learning !

println("📚 Consultez le résumé : modules/module3-ml/resume_01_mlj_basics.md")
println("Appuyez sur Entrée quand vous êtes prêt à découvrir le ML Julia...")
readline()

println("🤖 Fondamentaux MLJ : Machine Learning avec Julia")
println("="^60)

# Installation et importation des paquets ML
using MLJ
using DataFrames, CSV
using Plots, StatsPlots
using Statistics, Random
using MLJModels

# Configuration pour reproductibilité
Random.seed!(42)
MLJ.color_off() # Désactiver les couleurs pour la sortie console

# Partie 1 : Chargement et Exploration de Données
println("📊 Partie 1 : Exploration de Données avec MLJ")

# Charger un dataset intégré
println("Chargement du dataset Iris...")
X, y = @load_iris;

println("Informations sur le dataset :")
println("  - Nombre d'observations : ", nrows(X))
println("  - Nombre de features : ", ncols(X))
println("  - Types des colonnes :")
for name in names(X)
    println("    $name : $(eltype(X[!, name]))")
end

println("\nPremières observations :")
println(first(X, 5))

println("\nDistribution des classes :")
countmap_y = Dict()
for classe in y
    countmap_y[classe] = get(countmap_y, classe, 0) + 1
end
for (classe, count) in countmap_y
    println("  $classe : $count observations")
end

# Visualisation des données
println("\nCréation de visualisations...")
try
    # Scatter plot des features
    p1 = scatter(X.sepal_length, X.sepal_width, 
                group=y, xlabel="Longueur Sépale", ylabel="Largeur Sépale",
                title="Iris Dataset - Sépales")
    
    p2 = scatter(X.petal_length, X.petal_width,
                group=y, xlabel="Longueur Pétale", ylabel="Largeur Pétale", 
                title="Iris Dataset - Pétales")
    
    plot_combined = plot(p1, p2, layout=(1,2), size=(800,300))
    display(plot_combined)
    
    println("✅ Graphiques générés avec succès !")
catch e
    println("⚠️ Visualisation non disponible : $e")
end

# Partie 2 : Préparation des Données
println("\n🔧 Partie 2 : Préparation et Nettoyage des Données")

# Division train/test
println("Division des données en train/test (70/30)...")
train_indices, test_indices = partition(eachindex(y), 0.7, shuffle=true, rng=42)

X_train = X[train_indices, :]
y_train = y[train_indices]
X_test = X[test_indices, :]
y_test = y[test_indices]

println("Tailles des ensembles :")
println("  - Entraînement : $(length(y_train)) observations")
println("  - Test : $(length(y_test)) observations")

# Standardisation des features
println("\nStandardisation des features...")
standardizer = Standardizer()
mach_standardizer = machine(standardizer, X_train)
fit!(mach_standardizer)

X_train_scaled = MLJ.transform(mach_standardizer, X_train)
X_test_scaled = MLJ.transform(mach_standardizer, X_test)

println("Statistiques après standardisation (train) :")
for name in names(X_train_scaled)
    col_mean = round(mean(X_train_scaled[!, name]), digits=3)
    col_std = round(std(X_train_scaled[!, name]), digits=3)
    println("  $name : moyenne = $col_mean, écart-type = $col_std")
end

# Partie 3 : Modèles de Classification
println("\n🎯 Partie 3 : Entraînement de Modèles de Classification")

# Modèle 1 : Decision Tree
println("Modèle 1 : Arbre de Décision")
DecisionTreeClassifier = @load DecisionTreeClassifier pkg=DecisionTree

tree_model = DecisionTreeClassifier(max_depth=5, min_samples_leaf=2)
mach_tree = machine(tree_model, X_train_scaled, y_train)

println("Entraînement de l'arbre de décision...")
fit!(mach_tree)

# Prédictions avec l'arbre
tree_predictions = predict(mach_tree, X_test_scaled)
tree_predictions_mode = mode.(tree_predictions)  # Prendre la classe la plus probable

# Évaluation
tree_accuracy = accuracy(tree_predictions_mode, y_test)
println("Précision Arbre de Décision : $(round(tree_accuracy, digits=4))")

# Modèle 2 : Random Forest
println("\nModèle 2 : Random Forest")
RandomForestClassifier = @load RandomForestClassifier pkg=DecisionTree

rf_model = RandomForestClassifier(n_trees=100, max_depth=10)
mach_rf = machine(rf_model, X_train_scaled, y_train)

println("Entraînement du Random Forest...")
fit!(mach_rf)

rf_predictions = predict(mach_rf, X_test_scaled)
rf_predictions_mode = mode.(rf_predictions)

rf_accuracy = accuracy(rf_predictions_mode, y_test)
println("Précision Random Forest : $(round(rf_accuracy, digits=4))")

# Modèle 3 : SVM (si disponible)
println("\nModèle 3 : Support Vector Machine")
try
    SVC = @load SVC pkg=LIBSVM
    svm_model = SVC(kernel="rbf", gamma="scale")
    mach_svm = machine(svm_model, X_train_scaled, y_train)
    
    println("Entraînement du SVM...")
    fit!(mach_svm)
    
    svm_predictions = predict(mach_svm, X_test_scaled)
    svm_accuracy = accuracy(svm_predictions, y_test)
    println("Précision SVM : $(round(svm_accuracy, digits=4))")
    
    svm_available = true
    global svm_predictions_final = svm_predictions
catch e
    println("⚠️ SVM non disponible : $e")
    println("Utilisation des prédictions Random Forest à la place")
    svm_available = false
    global svm_predictions_final = rf_predictions_mode
end

# Partie 4 : Validation Croisée
println("\n📈 Partie 4 : Validation Croisée")

println("Validation croisée 5-fold pour le Random Forest...")
cv_results = evaluate!(mach_rf, resampling=CV(nfolds=5, shuffle=true, rng=42),
                      measure=accuracy)

println("Résultats de la validation croisée :")
println("  - Précision moyenne : $(round(cv_results.measurement[1], digits=4))")

# Calculer intervalle de confiance approximatif
if length(cv_results.per_fold) >= 1 && length(cv_results.per_fold[1]) >= 5
    fold_accuracies = [acc for fold in cv_results.per_fold for acc in fold]
    std_cv = std(fold_accuracies)
    mean_cv = mean(fold_accuracies)
    println("  - Écart-type : $(round(std_cv, digits=4))")
    println("  - Intervalle confiance 95% : [$(round(mean_cv - 1.96*std_cv, digits=4)), $(round(mean_cv + 1.96*std_cv, digits=4))]")
end

# Partie 5 : Métriques d'Évaluation Avancées
println("\n📊 Partie 5 : Métriques d'Évaluation Détaillées")

# Matrice de confusion
println("Matrice de confusion (Random Forest) :")
conf_matrix = confusion_matrix(rf_predictions_mode, y_test)

# Affichage de la matrice de confusion
classes = unique(y_test)
println("        Prédictions")
print("Réalité  ")
for c in classes
    print("$c  ")
end
println()

for (i, true_class) in enumerate(classes)
    print("$true_class        ")
    for (j, pred_class) in enumerate(classes)
        # Compter les occurrences
        count = sum((rf_predictions_mode .== pred_class) .& (y_test .== true_class))
        print("$count    ")
    end
    println()
end

# Métriques par classe
println("\nMétriques détaillées par classe :")
for classe in classes
    # Calcul manuel des métriques
    true_positives = sum((rf_predictions_mode .== classe) .& (y_test .== classe))
    false_positives = sum((rf_predictions_mode .== classe) .& (y_test .!= classe))
    false_negatives = sum((rf_predictions_mode .!= classe) .& (y_test .== classe))
    
    precision = true_positives / (true_positives + false_positives + 1e-10)
    recall = true_positives / (true_positives + false_negatives + 1e-10)
    f1 = 2 * (precision * recall) / (precision + recall + 1e-10)
    
    println("  Classe $classe :")
    println("    - Précision : $(round(precision, digits=3))")
    println("    - Rappel : $(round(recall, digits=3))")
    println("    - F1-Score : $(round(f1, digits=3))")
end

# Partie 6 : Sélection d'Hyperparamètres
println("\n🎛️ Partie 6 : Optimisation d'Hyperparamètres")

println("Recherche de grille pour Random Forest...")
# Définir la grille de paramètres
param_grid = (n_trees = [50, 100, 200],
              max_depth = [5, 10, 15])

println("Test de différentes combinaisons d'hyperparamètres :")
best_score = 0.0
best_params = nothing

for n_trees in param_grid.n_trees
    for max_depth in param_grid.max_depth
        # Créer et entraîner le modèle
        model_test = RandomForestClassifier(n_trees=n_trees, max_depth=max_depth)
        mach_test = machine(model_test, X_train_scaled, y_train)
        fit!(mach_test)
        
        # Évaluer avec validation croisée
        cv_test = evaluate!(mach_test, resampling=CV(nfolds=3, shuffle=true, rng=42),
                           measure=accuracy)
        
        score = cv_test.measurement[1]
        println("  n_trees=$n_trees, max_depth=$max_depth : précision = $(round(score, digits=4))")
        
        if score > best_score
            best_score = score
            best_params = (n_trees=n_trees, max_depth=max_depth)
        end
    end
end

println("Meilleurs paramètres : $best_params")
println("Meilleure précision CV : $(round(best_score, digits=4))")

# Partie 7 : Pipeline ML Complet
println("\n🔄 Partie 7 : Pipeline ML Intégré")

println("Création d'un pipeline complet...")
# Pipeline avec préprocessing et modèle
pipe = Standardizer() |> RandomForestClassifier(n_trees=best_params.n_trees, 
                                               max_depth=best_params.max_depth)

mach_pipe = machine(pipe, X_train, y_train)
fit!(mach_pipe)

# Évaluation du pipeline
pipe_predictions = predict(mach_pipe, X_test)
pipe_predictions_mode = mode.(pipe_predictions)
pipe_accuracy = accuracy(pipe_predictions_mode, y_test)

println("Précision du pipeline complet : $(round(pipe_accuracy, digits=4))")

# Partie 8 : Importance des Features
println("\n🔍 Partie 8 : Analyse d'Importance des Features")

# Entraîner un modèle simple pour analyser l'importance
simple_rf = RandomForestClassifier(n_trees=100)
mach_simple = machine(simple_rf, X_train, y_train)
fit!(mach_simple)

println("Analyse qualitative de l'importance des features :")
println("(Basée sur l'observation des données)")

# Calcul manuel de corrélations simples
feature_names = names(X_train)
println("Corrélations approximatives avec les classes :")

for feature in feature_names
    # Calculer une métrique simple de séparation
    feature_values = X_train[!, feature]
    
    # Calculer la variance inter-classes vs intra-classe
    class_means = Dict()
    for classe in unique(y_train)
        class_indices = y_train .== classe
        class_means[classe] = mean(feature_values[class_indices])
    end
    
    # Mesure de séparation simple
    mean_differences = [abs(class_means[c1] - class_means[c2]) 
                       for c1 in keys(class_means) for c2 in keys(class_means) if c1 < c2]
    avg_separation = mean(mean_differences)
    
    println("  $feature : séparation inter-classes ≈ $(round(avg_separation, digits=3))")
end

# Partie 9 : Prédictions sur Nouvelles Données
println("\n🔮 Partie 9 : Prédictions sur Nouvelles Observations")

# Créer quelques observations synthétiques
nouvelles_obs = DataFrame(
    sepal_length = [5.0, 6.5, 7.0],
    sepal_width = [3.5, 3.0, 3.2],
    petal_length = [1.5, 4.5, 6.0],
    petal_width = [0.2, 1.5, 2.0]
)

println("Nouvelles observations à classifier :")
println(nouvelles_obs)

# Prédictions avec le pipeline
nouvelles_predictions = predict(mach_pipe, nouvelles_obs)
nouvelles_predictions_mode = mode.(nouvelles_predictions)

println("\nPrédictions :")
for (i, pred) in enumerate(nouvelles_predictions_mode)
    proba = maximum(pdf.(nouvelles_predictions[i], [pred]))
    println("  Observation $i : $pred (confiance ≈ $(round(proba, digits=3)))")
end

# Partie 10 : Comparaison de Modèles
println("\n🏆 Partie 10 : Comparaison Finale des Modèles")

models_comparison = DataFrame(
    Modèle = ["Arbre de Décision", "Random Forest", "Pipeline Optimisé"],
    Précision = [tree_accuracy, rf_accuracy, pipe_accuracy],
    Complexité = ["Faible", "Élevée", "Élevée"],
    Temps_Entraînement = ["Rapide", "Moyen", "Moyen"]
)

println("Comparaison des modèles :")
println(models_comparison)

# Recommandation
best_model_idx = argmax(models_comparison.Précision)
best_model_name = models_comparison.Modèle[best_model_idx]
println("\n🏅 Modèle recommandé : $best_model_name")
println("Précision : $(round(models_comparison.Précision[best_model_idx], digits=4))")

# Partie 11 : Sauvegarde du Modèle
println("\n💾 Partie 11 : Persistance du Modèle")

println("Sauvegarde du meilleur modèle...")
try
    MLJ.save("./best_iris_model.jlso", mach_pipe)
    println("✅ Modèle sauvegardé dans 'best_iris_model.jlso'")
    
    # Test de rechargement
    loaded_mach = machine("./best_iris_model.jlso")
    test_prediction = predict(loaded_mach, first(X_test, 1))
    println("✅ Test de rechargement réussi")
    
catch e
    println("⚠️ Sauvegarde échouée : $e")
    println("(Normal dans certains environnements)")
end

# Bilan d'apprentissage
println("\n📈 BILAN D'APPRENTISSAGE")
println("="^60)
println("🤖 MAÎTRISE DES FONDAMENTAUX MLJ !")
println("="^60)
println("✅ Compétences Machine Learning développées :")
println("  - Chargement et exploration de datasets avec MLJ")
println("  - Préparation et standardisation des données")  
println("  - Entraînement de modèles : Decision Tree, Random Forest")
println("  - Validation croisée et métriques d'évaluation")
println("  - Optimisation d'hyperparamètres par grille")
println("  - Pipelines ML complets avec préprocessing")
println("  - Analyse d'importance des features")
println("  - Comparaison et sélection de modèles")
println("  - Persistance et déploiement de modèles")

println("\n🎯 COMPÉTENCES TRANSFÉRABLES :")
println("  - Méthodologie scientifique rigoureuse")
println("  - Évaluation objective de performance")
println("  - Optimisation systématique d'hyperparamètres")
println("  - Workflow reproductible de Machine Learning")

println("\n🚀 Vous maîtrisez maintenant le cycle complet de ML en Julia !")
println("📆 PROCHAINE ÉTAPE : 02_dataframes.jl - Manipulation avancée de données")
println("   (Les pipelines MLJ s'intègrent parfaitement avec DataFrames)")
println("   (Conseil : Expérimentez avec d'autres datasets !)")