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

# Installation et importation des paquets
using MLJ, MLJModels, MLJTuning
using DataFrames, CSV, Statistics, Random
using Plots, StatsPlots
using Dates, TimeZones
using LinearAlgebra
using Clustering, MultivariateStats

# Configuration pour reproductibilité
Random.seed!(42)
MLJ.color_off()

println("🤖 Environnement ML avancé configuré")
println("Seed fixé à 42 pour reproductibilité")

# Partie 1 : Ensemble Learning pour Prédiction Agricole
println("\n🌾 Partie 1 : Ensemble Learning - Rendements Agricoles BF")

# Simulation de données agricoles réalistes pour le Burkina Faso
function générer_données_agricoles_bf(n_observations=2000)
    println("Génération de données agricoles burkinabè...")
    
    # Régions du Burkina Faso avec caractéristiques
    régions = ["Sahel", "Nord", "Centre-Nord", "Centre", "Plateau-Central", 
               "Centre-Est", "Est", "Boucle-Mouhoun", "Hauts-Bassins", 
               "Sud-Ouest", "Centre-Ouest", "Centre-Sud", "Cascades"]
    
    # Types de sol au BF
    sols = ["Ferrugineux", "Vertisol", "Sols-bruns", "Lithosol", "Hydromorphe"]
    
    # Cultures principales
    cultures = ["Mil", "Sorgho", "Maïs", "Riz", "Coton", "Niébé", "Arachide"]
    
    données = DataFrame()
    
    for i in 1:n_observations
        région = rand(régions)
        culture = rand(cultures)
        sol = rand(sols)
        
        # Paramètres climatiques basés sur la région
        if région in ["Sahel", "Nord"]
            précipitations = 300 + rand() * 400  # 300-700mm (zone sahélienne)
            température_moy = 28 + rand() * 8     # 28-36°C
        elseif région in ["Centre", "Plateau-Central"]
            précipitations = 600 + rand() * 400  # 600-1000mm (zone soudano-sahélienne)
            température_moy = 26 + rand() * 6     # 26-32°C
        else  # Sud
            précipitations = 800 + rand() * 600  # 800-1400mm (zone soudanienne)
            température_moy = 24 + rand() * 6     # 24-30°C
        end
        
        # Variables agricoles
        superficie = 0.5 + rand() * 4.5  # 0.5-5 hectares (typique petits producteurs BF)
        engrais_kg_ha = rand() < 0.3 ? rand() * 100 : 0  # 30% utilisent engrais
        semences_améliorées = rand() < 0.2  # 20% utilisent semences améliorées
        irrigation = rand() < 0.05  # 5% ont irrigation
        
        # Calcul du rendement basé sur modèle réaliste
        rendement_base = Dict(
            "Mil" => 0.8, "Sorgho" => 0.9, "Maïs" => 1.2, "Riz" => 2.5,
            "Coton" => 1.0, "Niébé" => 0.6, "Arachide" => 1.1
        )[culture]
        
        # Facteurs d'influence sur le rendement
        facteur_précip = min(2.0, précipitations / 800)  # Optimal vers 800mm
        facteur_temp = température_moy < 30 ? 1.0 : 1.0 - (température_moy - 30) * 0.05
        facteur_sol = sol == "Vertisol" ? 1.2 : (sol == "Ferrugineux" ? 1.0 : 0.8)
        facteur_engrais = 1.0 + engrais_kg_ha * 0.005  # Effet engrais
        facteur_semences = semences_améliorées ? 1.3 : 1.0
        facteur_irrigation = irrigation ? 1.5 : 1.0
        
        # Rendement final avec variabilité
        rendement = rendement_base * facteur_précip * facteur_temp * 
                   facteur_sol * facteur_engrais * facteur_semences * 
                   facteur_irrigation * (0.7 + rand() * 0.6)  # Variabilité ±30%
        
        push!(données, (
            région = région,
            culture = culture,
            type_sol = sol,
            précipitations = précipitations,
            température_moyenne = température_moy,
            superficie = superficie,
            engrais_kg_ha = engrais_kg_ha,
            semences_améliorées = semences_améliorées,
            irrigation = irrigation,
            rendement = max(0.1, rendement)  # Rendement minimum
        ))
    end
    
    return données
end

# Générer le dataset
df_agri = générer_données_agricoles_bf(2000)

println("Dataset généré : $(nrow(df_agri)) observations")
println("Variables : $(ncol(df_agri)) features")
println("Rendement moyen : $(round(mean(df_agri.rendement), digits=2)) t/ha")

# Préparation des données pour ML
println("\nPréparation des données pour ML...")

# Encodage des variables catégorielles
df_ml = copy(df_agri)
df_ml.région_encoded = categorical(df_ml.région)
df_ml.culture_encoded = categorical(df_ml.culture)  
df_ml.sol_encoded = categorical(df_ml.type_sol)

# Sélection des features pour le modèle
features = [:région_encoded, :culture_encoded, :sol_encoded, :précipitations, 
           :température_moyenne, :superficie, :engrais_kg_ha, :semences_améliorées, :irrigation]

X = select(df_ml, features)
y = df_ml.rendement

# Division train/test
train_idx, test_idx = partition(eachindex(y), 0.8, shuffle=true, rng=42)
X_train, X_test = X[train_idx, :], X[test_idx, :]
y_train, y_test = y[train_idx], y[test_idx]

println("Données d'entraînement : $(length(train_idx)) observations")
println("Données de test : $(length(test_idx)) observations")

# Modèle 1 : Random Forest
println("\n🌲 Modèle 1 : Random Forest Ensemble")

RandomForestRegressor = @load RandomForestRegressor pkg=DecisionTree
rf_model = RandomForestRegressor(n_trees=100, max_depth=10, min_samples_leaf=5)
rf_machine = machine(rf_model, X_train, y_train)

println("Entraînement Random Forest...")
fit!(rf_machine)

# Prédictions
rf_predictions = predict(rf_machine, X_test)
rf_mae = mean(abs.(rf_predictions - y_test))
rf_rmse = sqrt(mean((rf_predictions - y_test).^2))
rf_r2 = 1 - sum((y_test - rf_predictions).^2) / sum((y_test .- mean(y_test)).^2)

println("Performance Random Forest :")
println("  MAE : $(round(rf_mae, digits=3)) t/ha")
println("  RMSE : $(round(rf_rmse, digits=3)) t/ha") 
println("  R² : $(round(rf_r2, digits=3))")

# Modèle 2 : Gradient Boosting (via MLJ)
println("\n🚀 Modèle 2 : Gradient Boosting")

# Utiliser XGBoost si disponible, sinon AdaBoost
try
    XGBoostRegressor = @load XGBoostRegressor
    gb_model = XGBoostRegressor(max_depth=6, eta=0.1, num_round=100)
    println("Utilisation de XGBoost")
catch
    # Fallback vers un autre modèle de boosting
    EvoTreeRegressor = @load EvoTreeRegressor pkg=EvoTrees
    gb_model = EvoTreeRegressor(max_depth=6, eta=0.1, nrounds=100)
    println("Utilisation de EvoTrees")
end

gb_machine = machine(gb_model, X_train, y_train)

println("Entraînement Gradient Boosting...")
fit!(gb_machine)

gb_predictions = predict(gb_machine, X_test)
gb_mae = mean(abs.(gb_predictions - y_test))
gb_rmse = sqrt(mean((gb_predictions - y_test).^2))
gb_r2 = 1 - sum((y_test - gb_predictions).^2) / sum((y_test .- mean(y_test)).^2)

println("Performance Gradient Boosting :")
println("  MAE : $(round(gb_mae, digits=3)) t/ha")
println("  RMSE : $(round(gb_rmse, digits=3)) t/ha")
println("  R² : $(round(gb_r2, digits=3))")

# Modèle 3 : Support Vector Regression
println("\n📐 Modèle 3 : Support Vector Regression")

try
    SVMRegressor = @load SVMRegressor pkg=LIBSVM
    svm_model = SVMRegressor(kernel=:rbf, gamma=:scale, C=1.0)
    svm_machine = machine(svm_model, X_train, y_train)
    
    println("Entraînement SVM...")
    fit!(svm_machine)
    
    svm_predictions = predict(svm_machine, X_test)
    svm_mae = mean(abs.(svm_predictions - y_test))
    svm_rmse = sqrt(mean((svm_predictions - y_test).^2))
    svm_r2 = 1 - sum((y_test - svm_predictions).^2) / sum((y_test .- mean(y_test)).^2)
    
    println("Performance SVM :")
    println("  MAE : $(round(svm_mae, digits=3)) t/ha")
    println("  RMSE : $(round(svm_rmse, digits=3)) t/ha")
    println("  R² : $(round(svm_r2, digits=3))")
    
    svm_available = true
catch e
    println("⚠️ SVM non disponible : $e")
    svm_available = false
    svm_predictions = rf_predictions  # Fallback
end

# Comparaison des modèles
println("\n📊 Comparaison des Modèles :")
comparaison = DataFrame(
    Modèle = ["Random Forest", "Gradient Boosting", svm_available ? "SVM" : "SVM (indisponible)"],
    MAE = [rf_mae, gb_mae, svm_available ? svm_mae : missing],
    RMSE = [rf_rmse, gb_rmse, svm_available ? svm_rmse : missing],
    R2 = [rf_r2, gb_r2, svm_available ? svm_r2 : missing]
)

println(comparaison)

# Partie 2 : Clustering des Régions Climatiques
println("\n🗺️ Partie 2 : Clustering des Régions Climatiques du BF")

# Préparer données pour clustering
println("Analyse climatique des régions burkinabè...")

données_régions = combine(groupby(df_agri, :région)) do group
    DataFrame(
        précipitations_moy = mean(group.précipitations),
        température_moy = mean(group.température_moyenne),
        rendement_moy = mean(group.rendement),
        usage_engrais = mean(group.engrais_kg_ha),
        superficie_moy = mean(group.superficie)
    )
end

# Ajouter le nom de région comme première colonne
données_régions.région = unique(df_agri.région)

# Standardisation pour clustering
using MLJ
Standardizer = @load Standardizer
standardizer = Standardizer()

# Sélectionner variables pour clustering
vars_clustering = [:précipitations_moy, :température_moy, :rendement_moy, :usage_engrais]
X_cluster = select(données_régions, vars_clustering)

# Standardiser
std_machine = machine(standardizer, X_cluster)
fit!(std_machine)
X_cluster_std = MLJ.transform(std_machine, X_cluster)

# K-means clustering
println("Application du clustering K-means...")
using Clustering

# Convertir en matrix pour Clustering.jl
X_matrix = Matrix(X_cluster_std)'  # Transpose pour format attendu

# Essayer différents nombres de clusters
println("Recherche du nombre optimal de clusters...")
max_k = min(8, nrow(données_régions) - 1)
silhouettes = Float64[]

for k in 2:max_k
    kmeans_result = kmeans(X_matrix, k; maxiter=100)
    
    # Calculer silhouette approximative
    assignments = assignments(kmeans_result)
    
    # Silhouette simplifiée (approximation)
    intra_cluster_dist = sum(kmeans_result.totalcost) / nrow(données_régions)
    silhouette_approx = 1.0 / (1.0 + intra_cluster_dist)
    
    push!(silhouettes, silhouette_approx)
    println("  k=$k : score=$(round(silhouette_approx, digits=3))")
end

# Choisir k optimal
k_optimal = argmax(silhouettes) + 1
println("Nombre optimal de clusters : $k_optimal")

# Clustering final
kmeans_final = kmeans(X_matrix, k_optimal; maxiter=100)
clusters = assignments(kmeans_final)

# Ajouter clusters au DataFrame
données_régions.cluster = clusters

println("\nRésultats du clustering :")
for i in 1:k_optimal
    régions_cluster = données_régions[données_régions.cluster .== i, :région]
    println("  Cluster $i : $(join(régions_cluster, ", "))")
end

# Visualisation du clustering
println("\nVisualisation du clustering...")
scatter_plot = scatter(données_régions.précipitations_moy, données_régions.température_moy,
    group=données_régions.cluster,
    title="🗺️ Clustering Climatique des Régions - Burkina Faso",
    xlabel="Précipitations moyennes (mm)",
    ylabel="Température moyenne (°C)",
    markersize=8,
    legend=:topright)

# Ajouter labels des régions
for row in eachrow(données_régions)
    annotate!(row.précipitations_moy, row.température_moy + 0.3,
              text(row.région, 6, :center))
end

display(scatter_plot)

# Partie 3 : Analyse de Séries Temporelles Agricoles
println("\n📈 Partie 3 : Séries Temporelles - Production Agricole")

# Simuler données temporelles de production
println("Simulation de données temporelles...")

années = 2010:2023
mois = 1:12
cultures_principales = ["Mil", "Sorgho", "Maïs"]

# Générer série temporelle mensuelle
séries_temporelles = DataFrame()

for culture in cultures_principales
    for année in années
        for mois_num in mois
            # Production saisonnière (max en saison sèche pour traitement post-récolte)
            saisonnalité = mois_num in [11, 12, 1, 2] ? 1.0 : 
                          mois_num in [6, 7, 8, 9] ? 0.1 : 0.5  # Croissance
            
            # Tendance à long terme
            tendance = 1.0 + (année - 2010) * 0.02  # 2% croissance annuelle
            
            # Production de base par culture
            prod_base = Dict("Mil" => 1000, "Sorgho" => 800, "Maïs" => 600)[culture]
            
            # Variabilité climatique
            variabilité = 0.8 + rand() * 0.4
            
            production = prod_base * tendance * saisonnalité * variabilité
            
            push!(séries_temporelles, (
                date = Date(année, mois_num, 1),
                culture = culture,
                production = production,
                année = année,
                mois = mois_num
            ))
        end
    end
end

# Analyse tendances
println("Analyse des tendances temporelles...")

# Graphique des séries temporelles
ts_plot = plot(title="📈 Évolution Production Agricole - Burkina Faso",
               xlabel="Année", 
               ylabel="Production (milliers tonnes)",
               legend=:topleft,
               size=(900, 500))

for culture in cultures_principales
    données_culture = filter(row -> row.culture == culture, séries_temporelles)
    
    # Agrégation annuelle
    prod_annuelle = combine(groupby(données_culture, :année),
                           :production => sum => :production_totale)
    
    plot!(prod_annuelle.année, prod_annuelle.production_totale / 1000,
          label=culture, linewidth=2, marker=:circle, markersize=4)
end

display(ts_plot)

# Décomposition saisonnière pour le Mil
println("\nDécomposition saisonnière pour le Mil...")

données_mil = filter(row -> row.culture == "Mil", séries_temporelles)
sort!(données_mil, :date)

# Moyennes mensuelles sur toutes les années
saisonnalité_mil = combine(groupby(données_mil, :mois),
                          :production => mean => :production_moyenne)

seasonal_plot = bar(1:12, saisonnalité_mil.production_moyenne,
    title="🌾 Saisonnalité Production Mil - Burkina Faso",
    xlabel="Mois",
    ylabel="Production Moyenne",
    color=:green,
    legend=false,
    xticks=(1:12, ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"]))

display(seasonal_plot)

# Partie 4 : Détection d'Anomalies Climatiques
println("\n⚠️ Partie 4 : Détection d'Anomalies Climatiques")

# Simuler données météorologiques avec anomalies
println("Simulation de données météo avec anomalies...")

n_jours = 365 * 5  # 5 ans de données quotidiennes
dates_météo = Date(2019, 1, 1):Day(1):Date(2023, 12, 31)

données_météo = DataFrame(
    date = dates_météo[1:n_jours],
    température = 28 .+ 8 * sin.(2π * (1:n_jours) / 365) .+ randn(n_jours) * 2,
    précipitations = abs.(randn(n_jours) * 30),  # Précip aléatoires positives
    humidité = 40 .+ 30 * sin.(2π * (1:n_jours) / 365 + π/2) .+ randn(n_jours) * 5
)

# Ajouter quelques anomalies artificielles
indices_anomalies = rand(1:n_jours, 20)  # 20 jours d'anomalies
données_météo[indices_anomalies, :température] .+= randn(20) * 10  # Températures extrêmes
données_météo[indices_anomalies[1:10], :précipitations] .+= rand(10) * 200  # Fortes pluies

println("Données météo générées : $n_jours jours")
println("Anomalies ajoutées : $(length(indices_anomalies)) jours")

# Détection d'anomalies par Z-score
println("\nDétection d'anomalies par Z-score...")

function détecter_anomalies_zscore(série, seuil=3)
    moyenne = mean(série)
    écart_type = std(série)
    z_scores = abs.((série .- moyenne) / écart_type)
    return z_scores .> seuil
end

# Détecter anomalies de température
anomalies_temp = détecter_anomalies_zscore(données_météo.température)
anomalies_précip = détecter_anomalies_zscore(données_météo.précipitations)

nb_anomalies_temp = sum(anomalies_temp)
nb_anomalies_précip = sum(anomalies_précip)

println("Anomalies détectées :")
println("  Température : $nb_anomalies_temp jours")
println("  Précipitations : $nb_anomalies_précip jours")

# Visualisation des anomalies
temp_plot = plot(données_météo.date, données_météo.température,
    title="🌡️ Température avec Anomalies Détectées",
    xlabel="Date",
    ylabel="Température (°C)",
    label="Température",
    color=:blue,
    alpha=0.7)

# Marquer les anomalies
dates_anomalies_temp = données_météo.date[anomalies_temp]
temp_anomalies = données_météo.température[anomalies_temp]
scatter!(dates_anomalies_temp, temp_anomalies,
         color=:red, markersize=4, label="Anomalies")

display(temp_plot)

# Partie 5 : Modèle Prédictif Multi-Output
println("\n🎯 Partie 5 : Prédiction Multi-Output")

# Préparer données pour prédiction simultanée de plusieurs cultures
println("Préparation modèle multi-output...")

# Features climatiques et agricoles communes
features_communes = [:précipitations, :température_moyenne, :engrais_kg_ha, :irrigation]

# Préparer données par culture principale
cultures_principales = ["Mil", "Sorgho", "Maïs"]
X_multi = DataFrame()
y_multi = DataFrame()

# Pivot des données par culture
for (i, obs) in enumerate(eachrow(df_agri))
    if obs.culture in cultures_principales
        if nrow(X_multi) < i
            # Créer nouvelle observation
            push!(X_multi, (
                précipitations = obs.précipitations,
                température_moyenne = obs.température_moyenne,
                engrais_kg_ha = obs.engrais_kg_ha,
                irrigation = obs.irrigation
            ))
            
            # Initialiser rendements à 0
            new_y = DataFrame()
            for culture in cultures_principales
                new_y[!, "rendement_" * culture] = [0.0]
            end
            if nrow(y_multi) == 0
                y_multi = new_y
            else
                push!(y_multi, new_y[1, :])
            end
        end
        
        # Mettre à jour le rendement pour cette culture
        if nrow(y_multi) >= i
            col_name = "rendement_" * obs.culture
            if col_name in names(y_multi)
                y_multi[min(nrow(y_multi), i), col_name] = obs.rendement
            end
        end
    end
end

# Nettoyer les données (garder observations avec au moins une culture)
mask_valide = [any(row[col] > 0 for col in names(y_multi)) for row in eachrow(y_multi)]
X_multi_clean = X_multi[mask_valide, :]
y_multi_clean = y_multi[mask_valide, :]

println("Données multi-output préparées :")
println("  Observations : $(nrow(X_multi_clean))")
println("  Features : $(ncol(X_multi_clean))")
println("  Targets : $(ncol(y_multi_clean))")

if nrow(X_multi_clean) > 50  # S'assurer d'avoir assez de données
    # Entraîner modèle multi-output (un modèle par culture)
    println("\nEntraînement modèles par culture...")
    
    modèles_culture = Dict()
    performances_culture = DataFrame()
    
    for culture in cultures_principales
        col_target = "rendement_" * culture
        y_culture = y_multi_clean[!, col_target]
        
        # Filtrer observations avec cette culture
        mask_culture = y_culture .> 0
        if sum(mask_culture) > 20  # Au moins 20 observations
            X_culture = X_multi_clean[mask_culture, :]
            y_culture_filt = y_culture[mask_culture]
            
            # Train/test split
            train_cult, test_cult = partition(eachindex(y_culture_filt), 0.8, shuffle=true, rng=42)
            
            # Modèle simple pour cette culture
            model_culture = RandomForestRegressor(n_trees=50)
            machine_culture = machine(model_culture, X_culture, y_culture_filt)
            
            fit!(machine_culture, rows=train_cult)
            
            # Évaluation
            pred_culture = predict(machine_culture, rows=test_cult)
            actual_culture = y_culture_filt[test_cult]
            
            mae_culture = mean(abs.(pred_culture - actual_culture))
            r2_culture = 1 - sum((actual_culture - pred_culture).^2) / 
                           sum((actual_culture .- mean(actual_culture)).^2)
            
            println("  $culture : MAE=$(round(mae_culture, digits=3)), R²=$(round(r2_culture, digits=3))")
            
            modèles_culture[culture] = machine_culture
            
            push!(performances_culture, (
                culture = culture,
                mae = mae_culture,
                r2 = r2_culture,
                n_obs = sum(mask_culture)
            ))
        end
    end
    
    if !isempty(performances_culture)
        println("\nPerformances multi-output :")
        println(performances_culture)
    end
end

# Bilan d'apprentissage
println("\n📈 BILAN D'APPRENTISSAGE")
println("="^70)
println("🧠 MAÎTRISE DU MACHINE LEARNING AVANCÉ !")
println("="^70)
println("✅ Techniques ML expertises développées :")
println("  🌲 Ensemble Learning avec Random Forest et Gradient Boosting")
println("  📐 Support Vector Machines pour régression non-linéaire")
println("  🗺️ Clustering non-supervisé pour segmentation régionale")
println("  📈 Analyse de séries temporelles avec décomposition saisonnière")
println("  ⚠️ Détection d'anomalies climatiques par méthodes statistiques")
println("  🎯 Modélisation multi-output pour prédictions simultanées")
println("  📊 Évaluation comparative avec métriques multiples")
println("  🇧🇫 Applications contextualisées agriculture burkinabè")

println("\n🌟 BADGE DÉBLOQUÉ : 'Expert ML Burkina Faso'")
println("Vous maîtrisez maintenant les techniques avancées pour résoudre")
println("des problèmes complexes du secteur agricole !")

println("\n🎯 COMPÉTENCES INDUSTRIELLES :")
println("  - Systèmes de prédiction multi-modèles en production")
println("  - Analyse d'anomalies pour alertes précoces")
println("  - Segmentation intelligente de marchés/régions")
println("  - Optimisation de rendements par zone climatique")

println("\n🚀 PRÊT POUR L'ÉTAPE FINALE !")
println("📆 PROCHAINE ÉTAPE : 05_python_bridge.jl - Intégration Python-Julia")
println("   (Combinez le meilleur des deux écosystèmes ML)")
println("   (Conseil : Ces modèles servent de base aux projets finaux !)")