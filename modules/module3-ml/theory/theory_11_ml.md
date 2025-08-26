# Session 11 : Statistiques et Machine Learning avec MLJ.jl

## 🎯 Objectifs de la Session
- Comprendre les concepts fondamentaux des statistiques et du machine learning
- Maîtriser l'écosystème MLJ.jl pour l'analyse prédictive
- Implémenter des modèles de régression linéaire et multiple
- Effectuer de la classification avec différents algorithmes
- Évaluer et valider les performances des modèles
- Appliquer le ML à des problématiques concrètes du Burkina Faso

## 📊 Introduction aux Statistiques et Machine Learning

### Qu'est-ce que le Machine Learning ?
Le Machine Learning (apprentissage automatique) permet aux ordinateurs d'apprendre des patterns dans les données sans être explicitement programmés pour chaque tâche. Il est particulièrement utile pour :
- **Prédire** des valeurs futures (prix, rendements agricoles)
- **Classifier** des éléments (spam/non-spam, maladie/santé)
- **Détecter** des anomalies (fraude, pannes)
- **Recommander** des actions (politiques publiques optimales)

### Types de Machine Learning
1. **Supervisé** : Apprendre avec des exemples étiquetés
   - Régression (prédire des valeurs continues)
   - Classification (prédire des catégories)

2. **Non-supervisé** : Découvrir des patterns sans étiquettes
   - Clustering (groupement)
   - Réduction de dimension

3. **Par renforcement** : Apprendre par essai-erreur avec récompenses

## 🔧 Installation et Configuration MLJ.jl

### Packages nécessaires
```julia
using Pkg

# Écosystème MLJ
Pkg.add("MLJ")
Pkg.add("MLJBase")
Pkg.add("MLJModels")

# Modèles spécifiques
Pkg.add("DecisionTree")      # Arbres de décision
Pkg.add("GLM")              # Modèles linéaires généralisés
Pkg.add("MLJLinearModels")  # Régression linéaire
Pkg.add("MLJDecisionTreeInterface")

# Utilitaires
Pkg.add("StatsBase")
Pkg.add("Statistics")
Pkg.add("Random")

using MLJ
using DataFrames
using Statistics
using StatsBase
using Random
using Plots
```

### Interface MLJ.jl
```julia
# Exploration des modèles disponibles
models()

# Recherche de modèles par tâche
models(matching(X, y)) # X: features, y: target

# Modèles pour la régression
models(matching(X, y)) |> DataFrame |> 
    x -> filter(row -> row.prediction_type == :deterministic, x)
```

## 📈 Statistiques Descriptives et Inférentielles

### Analyse descriptive avec StatsBase
```julia
# Données d'exemple : rendements agricoles par région
rendements_mil = [0.8, 1.2, 0.9, 1.5, 1.1, 0.7, 1.3, 1.0, 0.9, 1.4]
regions = ["Cascades", "Centre", "Est", "Hauts-Bassins", "Nord", 
           "Sahel", "Sud-Ouest", "Boucle du Mouhoun", "Centre-Nord", "Plateau Central"]

# Statistiques descriptives
println("Statistiques des rendements (tonnes/ha):")
println("Moyenne: $(round(mean(rendements_mil), digits=2))")
println("Médiane: $(round(median(rendements_mil), digits=2))")
println("Écart-type: $(round(std(rendements_mil), digits=2))")
println("Variance: $(round(var(rendements_mil), digits=2))")
println("Étendue: $(round(maximum(rendements_mil) - minimum(rendements_mil), digits=2))")

# Quantiles
quantiles = quantile(rendements_mil, [0.25, 0.5, 0.75])
println("Q1: $(quantiles[1]), Q2: $(quantiles[2]), Q3: $(quantiles[3])")
```

### Tests statistiques
```julia
using HypothesisTests

# Test de normalité (Shapiro-Wilk)
# shapiro_test = ShapiroWilkTest(rendements_mil)

# Test t pour comparaison de moyennes
# Exemple: comparer rendements Nord vs Sud
rendements_nord = [0.7, 0.8, 0.9, 0.6, 0.8]
rendements_sud = [1.2, 1.4, 1.3, 1.5, 1.1]

# Test t de Student
# t_test = UnequalVarianceTTest(rendements_nord, rendements_sud)
# println("p-value: $(pvalue(t_test))")
```

## 🏗️ Préparation des Données pour ML

### Création d'un dataset agricole
```julia
# Dataset pour prédiction de rendements agricoles
Random.seed!(123)

n_observations = 200
df_agri = DataFrame(
    # Variables météorologiques
    precipitation_mm = rand(300:1200, n_observations),
    temperature_moy = rand(25.0:30.0, n_observations),
    humidite_pct = rand(40:80, n_observations),
    
    # Variables sol et pratiques
    qualite_sol = rand(["Pauvre", "Moyenne", "Bonne"], n_observations),
    irrigation = rand([0, 1], n_observations),  # 0=non, 1=oui
    engrais_kg_ha = rand(0:100, n_observations),
    semences_ameliorees = rand([0, 1], n_observations),
    
    # Variables socio-économiques
    experience_agriculteur = rand(1:40, n_observations),
    superficie_hectares = rand(0.5:10.0, n_observations),
    acces_credit = rand([0, 1], n_observations),
    
    # Variable cible : rendement (tonnes/hectare)
    rendement_tonnes_ha = zeros(n_observations)
)

# Génération réaliste de la variable cible
for i in 1:n_observations
    base_rendement = 0.6
    
    # Impact de la météo
    if df_agri.precipitation_mm[i] > 800
        base_rendement += 0.3
    elseif df_agri.precipitation_mm[i] < 500
        base_rendement -= 0.2
    end
    
    # Impact de la température
    if df_agri.temperature_moy[i] > 28
        base_rendement -= 0.1
    end
    
    # Impact des pratiques
    if df_agri.irrigation[i] == 1
        base_rendement += 0.4
    end
    
    if df_agri.engrais_kg_ha[i] > 50
        base_rendement += 0.3
    end
    
    if df_agri.semences_ameliorees[i] == 1
        base_rendement += 0.2
    end
    
    # Impact qualité sol
    if df_agri.qualite_sol[i] == "Bonne"
        base_rendement += 0.3
    elseif df_agri.qualite_sol[i] == "Pauvre"
        base_rendement -= 0.2
    end
    
    # Impact expérience
    base_rendement += df_agri.experience_agriculteur[i] * 0.01
    
    # Bruit aléatoire
    base_rendement += randn() * 0.1
    
    df_agri.rendement_tonnes_ha[i] = max(0.1, base_rendement)
end

println("Dataset agricole créé : $(nrow(df_agri)) observations")
println("Rendement moyen : $(round(mean(df_agri.rendement_tonnes_ha), digits=2)) t/ha")
```

### Encodage des variables catégorielles
```julia
# Conversion des variables catégorielles
function encoder_variables_categoriques!(df::DataFrame)
    # One-hot encoding pour qualité du sol
    df.sol_bon = (df.qualite_sol .== "Bonne") * 1
    df.sol_moyen = (df.qualite_sol .== "Moyenne") * 1
    df.sol_pauvre = (df.qualite_sol .== "Pauvre") * 1
    
    # Supprimer la colonne originale
    select!(df, Not(:qualite_sol))
    
    return df
end

encoder_variables_categoriques!(df_agri)
```

## 📊 Régression Linéaire

### Régression linéaire simple
```julia
# Relation entre précipitations et rendement
X_simple = select(df_agri, :precipitation_mm)
y_simple = df_agri.rendement_tonnes_ha

# Chargement du modèle
LinearRegressor = @load LinearRegressor pkg=MLJLinearModels

# Création de l'instance du modèle
model_simple = LinearRegressor()

# Ajustement du modèle
machine_simple = machine(model_simple, X_simple, y_simple)
fit!(machine_simple)

# Prédictions
y_pred_simple = predict(machine_simple, X_simple)

# Visualisation
scatter(X_simple.precipitation_mm, y_simple, 
        title="Relation Précipitations-Rendement",
        xlabel="Précipitations (mm)", ylabel="Rendement (t/ha)",
        label="Observations", alpha=0.6)

plot!(X_simple.precipitation_mm, y_pred_simple, 
      label="Régression linéaire", linewidth=2, color=:red)
```

### Régression linéaire multiple
```julia
# Sélection des variables explicatives
X_multiple = select(df_agri, Not([:rendement_tonnes_ha]))
y_multiple = df_agri.rendement_tonnes_ha

# Division train/test
train_indices, test_indices = partition(eachindex(y_multiple), 0.7, shuffle=true, rng=123)

X_train = X_multiple[train_indices, :]
X_test = X_multiple[test_indices, :]
y_train = y_multiple[train_indices]
y_test = y_multiple[test_indices]

# Modèle de régression multiple
model_multiple = LinearRegressor()
machine_multiple = machine(model_multiple, X_train, y_train)
fit!(machine_multiple)

# Prédictions
y_pred_train = predict(machine_multiple, X_train)
y_pred_test = predict(machine_multiple, X_test)

# Évaluation
train_rmse = rmse(y_pred_train, y_train)
test_rmse = rmse(y_pred_test, y_test)
train_r2 = rsq(y_pred_train, y_train)
test_r2 = rsq(y_pred_test, y_test)

println("Performance du modèle :")
println("RMSE train: $(round(train_rmse, digits=3))")
println("RMSE test: $(round(test_rmse, digits=3))")
println("R² train: $(round(train_r2, digits=3))")
println("R² test: $(round(test_r2, digits=3))")
```

### Analyse des coefficients
```julia
# Extraction des coefficients (si disponible)
fitted_params = fitted_params(machine_multiple)
println("Coefficients du modèle :")
if haskey(fitted_params, :coefs)
    coefficients = fitted_params.coefs
    feature_names = names(X_train)
    
    for (i, coef) in enumerate(coefficients)
        println("$(feature_names[i]): $(round(coef, digits=4))")
    end
end
```

## 🎯 Classification

### Dataset de classification : Adoption de technologies agricoles
```julia
# Création d'un dataset pour classification binaire
Random.seed!(456)

n_farmers = 300
df_adoption = DataFrame(
    age = rand(20:70, n_farmers),
    education_annees = rand(0:15, n_farmers),
    superficie_ha = rand(0.5:20.0, n_farmers),
    revenus_annuels = rand(500000:5000000, n_farmers),
    acces_credit = rand([0, 1], n_farmers),
    distance_ville_km = rand(5:100, n_farmers),
    groupe_agriculteur = rand([0, 1], n_farmers),
    formation_recue = rand([0, 1], n_farmers)
)

# Variable cible : adoption de nouvelles variétés (0=non, 1=oui)
df_adoption.adoption = zeros(Int, n_farmers)

for i in 1:n_farmers
    prob_adoption = 0.2  # probabilité de base
    
    # Facteurs positifs
    if df_adoption.education_annees[i] > 8
        prob_adoption += 0.3
    end
    
    if df_adoption.acces_credit[i] == 1
        prob_adoption += 0.25
    end
    
    if df_adoption.formation_recue[i] == 1
        prob_adoption += 0.35
    end
    
    if df_adoption.groupe_agriculteur[i] == 1
        prob_adoption += 0.2
    end
    
    # Facteurs négatifs
    if df_adoption.age[i] > 50
        prob_adoption -= 0.15
    end
    
    if df_adoption.distance_ville_km[i] > 50
        prob_adoption -= 0.1
    end
    
    # Décision finale
    df_adoption.adoption[i] = rand() < prob_adoption ? 1 : 0
end

println("Dataset adoption créé :")
println("Taux d'adoption : $(round(mean(df_adoption.adoption) * 100, digits=1))%")
```

### Classification avec arbre de décision
```julia
# Préparation des données
X_classif = select(df_adoption, Not(:adoption))
y_classif = categorical(df_adoption.adoption)

# Division train/test
train_idx, test_idx = partition(eachindex(y_classif), 0.7, shuffle=true, rng=789)

X_train_c = X_classif[train_idx, :]
X_test_c = X_classif[test_idx, :]
y_train_c = y_classif[train_idx]
y_test_c = y_classif[test_idx]

# Modèle d'arbre de décision
DecisionTreeClassifier = @load DecisionTreeClassifier pkg=DecisionTree

tree_model = DecisionTreeClassifier(max_depth=5, min_samples_leaf=10)
tree_machine = machine(tree_model, X_train_c, y_train_c)
fit!(tree_machine)

# Prédictions
y_pred_tree = predict_mode(tree_machine, X_test_c)

# Matrice de confusion
conf_matrix = confusion_matrix(y_pred_tree, y_test_c)
println("Matrice de confusion :")
println(conf_matrix)

# Métriques de performance
accuracy = mean(y_pred_tree .== y_test_c)
println("Accuracy : $(round(accuracy, digits=3))")
```

### Classification avec régression logistique
```julia
# Modèle de régression logistique
LogisticClassifier = @load LogisticClassifier pkg=MLJLinearModels

logistic_model = LogisticClassifier()
logistic_machine = machine(logistic_model, X_train_c, y_train_c)
fit!(logistic_machine)

# Prédictions probabilistes
y_prob_logistic = predict(logistic_machine, X_test_c)
y_pred_logistic = predict_mode(logistic_machine, X_test_c)

# Évaluation
accuracy_logistic = mean(y_pred_logistic .== y_test_c)
println("Accuracy régression logistique : $(round(accuracy_logistic, digits=3))")

# Courbe ROC (si applicable)
# roc_curve = roc(y_prob_logistic, y_test_c)
```

## 🔄 Validation Croisée et Optimisation

### Validation croisée
```julia
# Validation croisée k-fold
function cross_validation_score(model, X, y, cv=5)
    scores = Float64[]
    
    # Stratification pour maintenir la proportion des classes
    cv_indices = MLJ.CV(nfolds=cv, shuffle=true, rng=123)
    
    for (train_idx, val_idx) in cv_indices(1:nrows(X), y)
        X_train_cv = selectrows(X, train_idx)
        X_val_cv = selectrows(X, val_idx)
        y_train_cv = y[train_idx]
        y_val_cv = y[val_idx]
        
        # Entraînement
        mach = machine(model, X_train_cv, y_train_cv)
        fit!(mach, verbosity=0)
        
        # Prédiction et évaluation
        y_pred = predict_mode(mach, X_val_cv)
        score = mean(y_pred .== y_val_cv)
        push!(scores, score)
    end
    
    return scores
end

# Test avec différents modèles
models_to_test = [
    ("Decision Tree", DecisionTreeClassifier(max_depth=5)),
    ("Logistic Regression", LogisticClassifier())
]

for (name, model) in models_to_test
    scores = cross_validation_score(model, X_classif, y_classif)
    println("$name - CV Score: $(round(mean(scores), digits=3)) ± $(round(std(scores), digits=3))")
end
```

### Optimisation des hyperparamètres
```julia
# Grid search pour optimiser les hyperparamètres de l'arbre de décision
using MLJTuning

# Définition de la grille de paramètres
r_max_depth = range(tree_model, :max_depth, values=[3, 5, 7, 10])
r_min_samples = range(tree_model, :min_samples_leaf, values=[5, 10, 20])

# Tuning avec grid search
tuning = Grid(resolution=8)
tuned_tree = TunedModel(
    model=tree_model,
    tuning=tuning,
    resampling=CV(nfolds=5),
    ranges=[r_max_depth, r_min_samples],
    measure=accuracy
)

# Entraînement du modèle optimisé
tuned_machine = machine(tuned_tree, X_train_c, y_train_c)
fit!(tuned_machine)

# Meilleurs paramètres
best_model = fitted_params(tuned_machine).best_model
println("Meilleurs paramètres :")
println("max_depth: $(best_model.max_depth)")
println("min_samples_leaf: $(best_model.min_samples_leaf)")
```

## 📊 Évaluation et Métriques

### Métriques pour la régression
```julia
function evaluer_regression(y_true, y_pred)
    mae_val = mean(abs.(y_true .- y_pred))
    mse_val = mean((y_true .- y_pred).^2)
    rmse_val = sqrt(mse_val)
    r2_val = 1 - sum((y_true .- y_pred).^2) / sum((y_true .- mean(y_true)).^2)
    
    println("Métriques de régression :")
    println("MAE (Mean Absolute Error): $(round(mae_val, digits=3))")
    println("MSE (Mean Squared Error): $(round(mse_val, digits=3))")
    println("RMSE (Root Mean Squared Error): $(round(rmse_val, digits=3))")
    println("R² (Coefficient de détermination): $(round(r2_val, digits=3))")
    
    return (mae=mae_val, mse=mse_val, rmse=rmse_val, r2=r2_val)
end

# Évaluation du modèle de rendement
metrics = evaluer_regression(y_test, y_pred_test)
```

### Métriques pour la classification
```julia
function evaluer_classification(y_true, y_pred)
    # Conversion en vecteurs si nécessaire
    y_true_vec = MLJ.int.(y_true)
    y_pred_vec = MLJ.int.(y_pred)
    
    # Matrice de confusion
    conf_mat = confusion_matrix(y_pred, y_true)
    
    # Calculs manuels des métriques
    tp = sum((y_true_vec .== 1) .& (y_pred_vec .== 1))
    tn = sum((y_true_vec .== 0) .& (y_pred_vec .== 0))
    fp = sum((y_true_vec .== 0) .& (y_pred_vec .== 1))
    fn = sum((y_true_vec .== 1) .& (y_pred_vec .== 0))
    
    accuracy = (tp + tn) / (tp + tn + fp + fn)
    precision = tp / (tp + fp)
    recall = tp / (tp + fn)
    f1 = 2 * (precision * recall) / (precision + recall)
    
    println("Métriques de classification :")
    println("Accuracy (Exactitude): $(round(accuracy, digits=3))")
    println("Precision (Précision): $(round(precision, digits=3))")
    println("Recall (Rappel): $(round(recall, digits=3))")
    println("F1-Score: $(round(f1, digits=3))")
    
    return (accuracy=accuracy, precision=precision, recall=recall, f1=f1)
end

# Évaluation du modèle d'adoption
classification_metrics = evaluer_classification(y_test_c, y_pred_logistic)
```

## 🎯 Applications Pratiques au Burkina Faso

### Modèle de prédiction de sécurité alimentaire
```julia
# Dataset pour prédiction de l'insécurité alimentaire
function create_food_security_data()
    Random.seed!(999)
    n_communes = 150
    
    DataFrame(
        # Variables météorologiques
        pluviometrie_cumul = rand(250:1000, n_communes),
        temp_moyenne = rand(26:32, n_communes),
        jours_secheresse = rand(0:60, n_communes),
        
        # Variables agricoles
        superficie_cultivee = rand(1000:50000, n_communes),
        rendement_moyen = rand(0.4:1.8, n_communes),
        stocks_cereales = rand(500:15000, n_communes),
        
        # Variables socio-économiques
        prix_cereales_fcfa = rand(180:350, n_communes),
        acces_marche_km = rand(5:80, n_communes),
        population_totale = rand(15000:200000, n_communes),
        taux_pauvrete = rand(30:80, n_communes),
        
        # Variables infrastructure
        routes_praticables = rand([0, 1], n_communes),
        centres_stockage = rand(0:5, n_communes),
        
        # Variable cible : niveau sécurité alimentaire (1=sécurisé, 0=insécurisé)
        securite_alimentaire = zeros(Int, n_communes)
    )
end

df_food = create_food_security_data()

# Génération réaliste de la variable cible
for i in 1:nrow(df_food)
    score_securite = 0.5
    
    # Impact pluviométrie
    if df_food.pluviometrie_cumul[i] > 600
        score_securite += 0.3
    elseif df_food.pluviometrie_cumul[i] < 400
        score_securite -= 0.4
    end
    
    # Impact rendement
    if df_food.rendement_moyen[i] > 1.2
        score_securite += 0.3
    elseif df_food.rendement_moyen[i] < 0.8
        score_securite -= 0.3
    end
    
    # Impact prix
    if df_food.prix_cereales_fcfa[i] > 280
        score_securite -= 0.2
    end
    
    # Impact pauvreté
    if df_food.taux_pauvrete[i] > 60
        score_securite -= 0.25
    end
    
    # Impact accès marché
    if df_food.acces_marche_km[i] > 40
        score_securite -= 0.15
    end
    
    df_food.securite_alimentaire[i] = rand() < score_securite ? 1 : 0
end

println("Dataset sécurité alimentaire :")
println("Taux de sécurité alimentaire : $(round(mean(df_food.securite_alimentaire) * 100, digits=1))%")
```

### Système d'alerte précoce
```julia
# Modèle d'alerte précoce pour l'insécurité alimentaire
X_food = select(df_food, Not(:securite_alimentaire))
y_food = categorical(df_food.securite_alimentaire)

# Entraînement du modèle
early_warning_model = LogisticClassifier()
ew_machine = machine(early_warning_model, X_food, y_food)
fit!(ew_machine)

# Prédictions probabilistes pour scoring de risque
risk_probabilities = predict(ew_machine, X_food)

# Création d'un système de scoring
df_food.risk_score = [prob.prob_given_ref[1] for prob in risk_probabilities]  # Probabilité d'insécurité
df_food.risk_level = ifelse.(df_food.risk_score .> 0.7, "Élevé",
                     ifelse.(df_food.risk_score .> 0.4, "Modéré", "Faible"))

println("Distribution des niveaux de risque :")
println(countmap(df_food.risk_level))
```

## 🔮 Clustering et Analyse Non-supervisée

### Clustering des régions par profil de développement
```julia
using Clustering

# Dataset pour clustering des régions
df_regions = DataFrame(
    region = ["Centre", "Hauts-Bassins", "Nord", "Sahel", "Est", "Sud-Ouest", 
              "Cascades", "Centre-Est", "Boucle du Mouhoun", "Centre-Nord"],
    pib_par_hab = [750000, 580000, 320000, 280000, 420000, 480000, 
                   520000, 450000, 540000, 380000],
    taux_alphabetisation = [78, 53, 29, 22, 36, 35, 
                           50, 49, 41, 32],
    acces_eau = [90, 68, 46, 34, 52, 50, 
                 68, 61, 59, 47],
    production_agricole = [485, 624, 723, 484, 557, 398, 
                          315, 452, 685, 398]
)

# Normalisation des données
using StatsBase
data_matrix = Matrix(select(df_regions, Not(:region)))
data_normalized = StatsBase.standardize(StatsBase.ZScoreTransform, data_matrix, dims=1)

# K-means clustering
k = 3  # Nombre de clusters
kmeans_result = kmeans(data_normalized', k)

# Ajout des clusters au DataFrame
df_regions.cluster = kmeans_result.assignments

println("Clustering des régions :")
for cluster_id in 1:k
    regions_cluster = df_regions[df_regions.cluster .== cluster_id, :region]
    println("Cluster $cluster_id: $(join(regions_cluster, ", "))")
end
```

## 📊 Visualisation des Résultats ML

### Graphiques de performance
```julia
# Graphique résidus vs prédictions pour régression
function plot_residuals(y_true, y_pred)
    residuals = y_true .- y_pred
    
    p1 = scatter(y_pred, residuals,
        title="Résidus vs Prédictions",
        xlabel="Valeurs prédites", ylabel="Résidus",
        alpha=0.6)
    hline!([0], linestyle=:dash, color=:red)
    
    p2 = histogram(residuals,
        title="Distribution des Résidus",
        xlabel="Résidus", ylabel="Fréquence",
        alpha=0.7)
    
    plot(p1, p2, layout=(1,2), size=(800, 300))
end

plot_residuals(y_test, y_pred_test)
```

### Importance des variables
```julia
# Pour les modèles qui le supportent
function plot_feature_importance(model, feature_names)
    # Cette fonction dépend du type de modèle
    # Pour les arbres de décision, on peut extraire l'importance
    println("Importance des variables (implémentation spécifique au modèle)")
end
```

## 🎓 Bonnes Pratiques ML

### Pipeline de machine learning
```julia
# Pipeline type pour un projet ML
function ml_pipeline(X, y; test_size=0.2, random_state=42)
    println("🔄 Pipeline Machine Learning")
    
    # 1. Division des données
    train_idx, test_idx = partition(eachindex(y), 1-test_size, shuffle=true, rng=random_state)
    X_train, X_test = X[train_idx, :], X[test_idx, :]
    y_train, y_test = y[train_idx], y[test_idx]
    
    println("✅ Données divisées: $(length(train_idx)) train, $(length(test_idx)) test")
    
    # 2. Préprocessing (si nécessaire)
    # Normalisation, encodage, etc.
    
    # 3. Entraînement de plusieurs modèles
    models = Dict(
        "LinearRegressor" => LinearRegressor(),
        # Ajouter d'autres modèles selon le type de problème
    )
    
    results = Dict()
    
    for (name, model) in models
        println("🚀 Entraînement $name...")
        
        # Validation croisée
        cv_scores = cross_validation_score(model, X_train, y_train)
        
        # Entraînement final
        mach = machine(model, X_train, y_train)
        fit!(mach, verbosity=0)
        
        # Évaluation
        y_pred = predict(mach, X_test)
        test_score = rmse(y_pred, y_test)  # ou autre métrique selon le problème
        
        results[name] = Dict(
            "cv_mean" => mean(cv_scores),
            "cv_std" => std(cv_scores),
            "test_score" => test_score,
            "model" => mach
        )
        
        println("   CV: $(round(mean(cv_scores), digits=3)) ± $(round(std(cv_scores), digits=3))")
        println("   Test: $(round(test_score, digits=3))")
    end
    
    # 4. Sélection du meilleur modèle
    best_model_name = argmin([results[name]["test_score"] for name in keys(results)])
    println("🏆 Meilleur modèle: $best_model_name")
    
    return results
end
```

### Validation et robustesse
```julia
# Tests de robustesse
function test_model_robustness(model, X, y)
    println("🔍 Tests de robustesse")
    
    # Test avec différentes graines aléatoires
    scores = []
    for seed in 1:10
        train_idx, test_idx = partition(eachindex(y), 0.8, shuffle=true, rng=seed)
        X_train, X_test = X[train_idx, :], X[test_idx, :]
        y_train, y_test = y[train_idx], y[test_idx]
        
        mach = machine(model, X_train, y_train)
        fit!(mach, verbosity=0)
        y_pred = predict(mach, X_test)
        
        score = rmse(y_pred, y_test)
        push!(scores, score)
    end
    
    println("Score moyen: $(round(mean(scores), digits=3))")
    println("Écart-type: $(round(std(scores), digits=3))")
    println("Coefficient de variation: $(round(std(scores)/mean(scores)*100, digits=1))%")
    
    return scores
end
```

## 🏆 Points Clés à Retenir

### Concepts Fondamentaux
1. **Overfitting vs Underfitting** : Équilibre entre complexité et généralisation
2. **Bias-Variance Tradeoff** : Compromis entre biais et variance
3. **Validation croisée** : Estimation robuste des performances
4. **Métriques appropriées** : Choisir selon le problème et le contexte

### Workflow MLJ.jl
1. **Chargement** : `@load ModelName pkg=PackageName`
2. **Instanciation** : `model = ModelName(params...)`
3. **Machine** : `mach = machine(model, X, y)`
4. **Entraînement** : `fit!(mach)`
5. **Prédiction** : `predict(mach, X_new)`

### Applications au Burkina Faso
- **Agriculture** : Prédiction de rendements, optimisation des pratiques
- **Santé** : Détection précoce d'épidémies, allocation de ressources
- **Économie** : Évaluation de politiques, ciblage des interventions
- **Environnement** : Surveillance déforestation, gestion ressources

### Éthique et Responsabilité
- **Biais dans les données** : Attention aux biais sociétaux
- **Interprétabilité** : Modèles explicables pour les décideurs
- **Impact social** : Considérer les conséquences des prédictions
- **Transparence** : Documenter les limites et incertitudes

Dans les prochaines sessions pratiques, nous appliquerons ces concepts à des cas d'usage concrets : prédiction de rendements agricoles et classification de messages en langues locales !