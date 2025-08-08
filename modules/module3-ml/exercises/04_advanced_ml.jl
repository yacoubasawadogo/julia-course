# Exercice 4 : Machine Learning Avancé avec Julia
# Module 3 : Apprentissage Automatique avec Julia
# Durée : 75 minutes

# 📚 AVANT DE COMMENCER
# Lisez le résumé d'apprentissage : resume_04_advanced_ml.md
# Découvrez les techniques ML de pointe avec applications burkinabè !

println("📚 Consultez le résumé : modules/module3-ml/resume_04_advanced_ml.md")
println("Appuyez sur Entrée quand vous êtes prêt pour le ML expert...")
readline()

println("🧠 Machine Learning Avancé : Applications Burkina Faso")
println("="^70)

# TODO 1 : Configuration environnement ML expert (10 minutes)
# Configurez un environnement ML de production avec tous les paquets nécessaires

# TODO : Importez MLJ, MLJModels, MLJTuning
using MLJ

# TODO : Importez DataFrames, CSV, Statistics, Random


# TODO : Importez Plots, StatsPlots pour visualisation


# TODO : Importez Dates, LinearAlgebra


# TODO : Importez Clustering, MultivariateStats


# Configuration pour reproductibilité
Random.seed!(42)
MLJ.color_off()

println("🤖 Environnement ML avancé configuré")

# TODO 2 : Génération de données agricoles réalistes (15 minutes)
println("\n🌾 Génération de données agricoles du Burkina Faso")

# TODO : Créez une fonction pour générer des données agricoles réalistes
# Cette fonction doit prendre en compte :
# - Les 13 régions du Burkina Faso
# - Les types de sol (Ferrugineux, Vertisol, Sols-bruns, Lithosol, Hydromorphe)  
# - Les cultures principales (Mil, Sorgho, Maïs, Riz, Coton, Niébé, Arachide)
# - Les facteurs climatiques (température, précipitations)
# - Les pratiques agricoles (engrais, irrigation, mécanisation)

function générer_données_agricoles_bf(n_observations=1000)
    println("Génération de données agricoles burkinabè...")

    # TODO : Définissez les régions du BF
    régions = [
    # TODO : Listez les 13 régions
    ]

    # TODO : Définissez les types de sol
    sols = [
    # TODO : Types de sol burkinabè
    ]

    # TODO : Définissez les cultures principales  
    cultures = [
    # TODO : Cultures burkinabè
    ]

    données = DataFrame()

    for i in 1:n_observations
        # TODO : Sélectionnez aléatoirement région, culture, sol
        région = rand(régions)
        # TODO : Complétez...

        # TODO : Générez des paramètres climatiques réalistes selon la région
        # Astuce : Sahel = moins de pluie, Centre = intermédiaire, Sud = plus de pluie
        if région in ["Sahel", "Nord"]
            précipitations = 11111
            # TODO : 300-700mm pour zone sahélienne
            température_moy = 11111
            # TODO : 28-36°C
        elseif région in ["Centre", "Plateau-Central"]
            # TODO : Zone soudano-sahélienne
        else  # Sud
            # TODO : Zone soudanienne
        end

        # TODO : Générez variables agricoles
        superficie = # TODO : 0.5-5 hectares (petits producteurs)
            engrais_kg_ha = # TODO : 0-100 kg/ha (30% des producteurs utilisent)
                irrigation = # TODO : 5% ont accès à l'irrigation

                # TODO : Calculez le rendement basé sur un modèle réaliste
                # Facteurs : climat, sol, pratiques agricoles, région
                    rendement = # TODO : Utilisez les facteurs pour calculer rendement réaliste

                    # TODO : Ajoutez l'observation au DataFrame
                        push!(données, (
                            région=région,
                            culture=culture,
                            type_sol=sol,
                            # TODO : Ajoutez toutes les variables
                        ))
    end

    return données
end

# TODO : Générez le dataset avec 1500 observations
df_agri = # TODO
    println("✅ Dataset généré : $(nrow(df_agri)) observations")

# TODO 3 : Préparation des données pour ML (10 minutes)
println("\n🔧 Préparation des données pour Machine Learning")

# TODO : Convertissez les variables catégorielles avec categorical()
# df_ml = copy(df_agri)
# df_ml.région_encoded = 
# df_ml.culture_encoded = 
# df_ml.sol_encoded = 

# TODO : Sélectionnez les features pour le modèle
features = [
# TODO : Listez vos features numériques et catégorielles
]

# TODO : Créez X et y
X = # TODO : select(df_ml, features)
    y = # TODO : df_ml.rendement

    # TODO : Division train/test avec partition()
    # Utilisez 80% pour l'entraînement
        train_idx, test_idx = # TODO
            X_train, X_test = # TODO
                y_train, y_test = # TODO
                    println("Données d'entraînement : $(length(train_idx)) observations")
println("Données de test : $(length(test_idx)) observations")

# TODO 4 : Modèle 1 - Random Forest (15 minutes)
println("\n🌲 Modèle 1 : Random Forest Ensemble")

# TODO : Chargez RandomForestRegressor
RandomForestRegressor = @load RandomForestRegressor pkg = DecisionTree

# TODO : Créez et configurez le modèle Random Forest
rf_model = # TODO : Configurez avec n_trees=100, max_depth=10

# TODO : Créez la machine MLJ
    rf_machine = # TODO

    # TODO : Entraînez le modèle
        println("Entraînement Random Forest...")
# TODO : fit!(rf_machine)

# TODO : Faites des prédictions
rf_predictions = # TODO : predict(rf_machine, X_test)

# TODO : Calculez les métriques de performance
    rf_mae = # TODO : mean(abs.(rf_predictions - y_test))
        rf_rmse = # TODO : sqrt(mean((rf_predictions - y_test).^2))
            rf_r2 = # TODO : 1 - sum((y_test - rf_predictions).^2) / sum((y_test .- mean(y_test)).^2)
                println("Performance Random Forest :")
println("  MAE : $(round(rf_mae, digits=3)) t/ha")
println("  RMSE : $(round(rf_rmse, digits=3)) t/ha")
println("  R² : $(round(rf_r2, digits=3))")

# TODO 5 : Modèle 2 - Gradient Boosting (10 minutes)
println("\n🚀 Modèle 2 : Gradient Boosting")

# TODO : Chargez EvoTreeRegressor (plus stable que XGBoost)
try
    EvoTreeRegressor = @load EvoTreeRegressor pkg = EvoTrees
    # TODO : Créez et entraînez le modèle
    gb_model = # TODO
        gb_machine = # TODO
            println("Entraînement Gradient Boosting...")
    # TODO : fit!(gb_machine)

    # TODO : Prédictions et évaluation
    gb_predictions = # TODO
        gb_mae = # TODO
            gb_r2 = # TODO
                println("Performance Gradient Boosting :")
    println("  MAE : $(round(gb_mae, digits=3)) t/ha")
    println("  R² : $(round(gb_r2, digits=3))")

catch e
    println("⚠️ EvoTrees non disponible : $e")
    println("Continuons avec les autres modèles...")
end

# TODO 6 : Clustering des régions climatiques (10 minutes)
println("\n🗺️ Clustering des Régions Climatiques du BF")

# TODO : Préparez les données pour clustering
println("Analyse climatique des régions burkinabè...")

# TODO : Calculez les statistiques par région
données_régions = combine(groupby(df_agri, :région)) do group
    DataFrame(
    # TODO : Calculez moyennes des variables climatiques par région
    # précipitations_moy = 
    # température_moy = 
    # rendement_moy = 
    )
end

# TODO : Standardisez les données pour clustering
Standardizer = @load Standardizer
standardizer = Standardizer()

# TODO : Sélectionnez variables pour clustering
vars_clustering = [
# TODO : Variables climatiques importantes
]

X_cluster = # TODO : select(données_régions, vars_clustering)

# TODO : Standardisez les données
    std_machine = # TODO
    # TODO : fit! et transform

    # TODO : Appliquez K-means clustering
        using Clustering

# TODO : Convertissez en matrice pour Clustering.jl
X_matrix = # TODO

# TODO : Testez différents nombres de clusters (2 à 6)
    println("Recherche du nombre optimal de clusters...")
for k in 2:6
    # TODO : Appliquez k-means
    kmeans_result = # TODO
        println("k=$k : coût total=$(kmeans_result.totalcost)")
end

# TODO : Choisissez k optimal et faites clustering final
k_optimal = 3  # Ajustez selon vos résultats
kmeans_final = # TODO
    clusters = assignments(kmeans_final)

# TODO : Ajoutez clusters au DataFrame
données_régions.cluster = clusters

println("\n🔍 Résultats du clustering :")
for i in 1:k_optimal
    régions_cluster = données_régions[données_régions.cluster.==i, :région]
    println("  Cluster $i : $(join(régions_cluster, ", "))")
end

# TODO 7 : Visualisations des résultats (10 minutes)
println("\n📊 Visualisation des résultats ML")

# TODO : Graphique 1 - Prédictions vs Réalité
p1 = scatter(y_test, rf_predictions,
    title="Prédictions vs Réalité - Random Forest",
    xlabel="Rendement Réel (t/ha)",
    ylabel="Rendement Prédit (t/ha)",
    alpha=0.6, size=(600, 500))

# TODO : Ajoutez la ligne y=x pour prédiction parfaite
plot!([minimum(y_test), maximum(y_test)],
    [minimum(y_test), maximum(y_test)],
    color=:red, linestyle=:dash, linewidth=2, label="Prédiction Parfaite")

display(p1)

# TODO : Graphique 2 - Clustering des régions
# TODO : Créez un scatter plot avec les coordonnées des régions
# Colorez selon les clusters trouvés

# Coordonnées approximatives des régions (fournies)
coords_régions = DataFrame(
    région=["Sahel", "Nord", "Centre-Nord", "Centre", "Plateau-Central",
        "Est", "Centre-Est", "Boucle du Mouhoun", "Hauts-Bassins",
        "Centre-Ouest", "Sud-Ouest", "Cascades", "Centre-Sud"],
    latitude=[14.0, 13.5, 13.2, 12.4, 12.3, 12.0, 11.9, 12.3,
        11.2, 12.1, 10.3, 10.8, 11.2],
    longitude=[-0.2, -2.3, -1.5, -1.5, -1.2, 0.5, -0.3, -2.9,
        -4.3, -2.3, -3.2, -4.3, -1.0]
)

# TODO : Fusionnez données régions avec coordonnées
régions_avec_coords = # TODO : leftjoin(données_régions, coords_régions, on=:région)

# TODO : Créez le graphique de clustering géographique
    p2 = # TODO : scatter plot avec longitude/latitude coloré par cluster
        display(p2)

println("✅ Visualisations créées !")

# TODO 8 : Défi bonus - Analyse de séries temporelles (Optionnel)
println("\n📈 Défi Bonus : Analyse Temporelle")

# TODO : Si vous avez le temps, créez des données temporelles
# et analysez l'évolution des rendements sur plusieurs années

# TODO 9 : Évaluation et comparaison de modèles
println("\n🏆 Comparaison finale des modèles")

# TODO : Créez un tableau comparatif des performances
# Comparez MAE, RMSE, R² des différents modèles

println("🥇 Meilleur modèle basé sur R² : Random Forest")

# Bilan d'apprentissage
println("\n📈 BILAN D'APPRENTISSAGE")
println("="^70)
println("🧠 FÉLICITATIONS ! MAÎTRISE DU ML AVANCÉ AVEC JULIA !")
println("="^70)
println("✅ Techniques ML avancées maîtrisées :")
println("  🌲 Random Forest pour prédiction de rendements")
println("  🚀 Gradient Boosting avec EvoTrees.jl")
println("  🗺️ Clustering K-means pour segmentation régionale")
println("  📊 Évaluation rigoureuse avec métriques multiples")
println("  📈 Visualisation des résultats ML")
println("  🇧🇫 Applications contextualisées agriculture BF")

println("\n🌟 BADGE DÉBLOQUÉ : 'Expert ML Burkina Faso'")
println("Vous maîtrisez maintenant les techniques avancées pour")
println("résoudre des problèmes agricoles complexes !")

println("\n🚀 PROCHAINE ÉTAPE : 05_python_bridge.jl")
println("   (Combinez Julia et Python pour maximum de puissance !)")

# NOTES POUR L'INSTRUCTEUR :
# Cet exercice couvre :
# 1. Génération de données réalistes contextualisées
# 2. Preprocessing et feature engineering
# 3. Modèles ensemble (Random Forest, Gradient Boosting)
# 4. Clustering non-supervisé 
# 5. Évaluation et validation rigoureuse
# 6. Visualisation des résultats
# 7. Applications agriculture sahélienne

# Extensions possibles :
# - Hyperparameter tuning avec MLJTuning
# - Cross-validation avec MLJ
# - Feature importance analysis
# - Time series forecasting
# - Deep learning avec Flux.jl