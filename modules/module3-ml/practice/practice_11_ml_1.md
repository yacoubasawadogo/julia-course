# Practice 11.1 : Prédiction des Rendements Agricoles basée sur les Données Météorologiques

## 🎯 Objectif
Développer un système de prédiction des rendements agricoles pour les principales céréales du Burkina Faso en utilisant les données météorologiques, pédologiques et des pratiques agricoles. Ce système aidera les agriculteurs et décideurs à optimiser la production et anticiper les variations de rendement.

## 📋 Prérequis
```julia
using MLJ
using DataFrames
using Statistics
using Random
using Plots
using StatsBase
using Dates

# Chargement des modèles
LinearRegressor = @load LinearRegressor pkg=MLJLinearModels
DecisionTreeRegressor = @load DecisionTreeRegressor pkg=DecisionTree
RandomForestRegressor = @load RandomForestRegressor pkg=MLJScikitLearnInterface

Random.seed!(2024)
```

## 🌾 Phase 1: Création du Dataset Agricole Réaliste

### Étape 1: Dataset météorologique détaillé
```julia
# Création d'un dataset complet pour prédiction de rendements
function create_agricultural_dataset(n_observations=500)
    # Base temporelle (5 années de données)
    dates = Date(2019,1,1):Month(1):Date(2023,12,1)
    
    # Génération des observations
    data = []
    
    for i in 1:n_observations
        # Sélection aléatoire d'une année et région
        year = rand(2019:2023)
        region = rand(["Centre", "Nord", "Hauts-Bassins", "Est", "Sud-Ouest", "Sahel", "Cascades"])
        cereale = rand(["Mil", "Sorgho", "Maïs", "Riz"])
        
        # Facteurs régionaux (impact zone climatique)
        regional_factor = region == "Centre" ? 1.1 :
                         region == "Nord" ? 0.9 :
                         region == "Sahel" ? 0.7 :
                         region == "Sud-Ouest" ? 1.2 : 1.0
        
        # Variables météorologiques (avec saisonnalité réaliste)
        # Pluviométrie annuelle selon la région
        base_precip = region in ["Sahel", "Nord"] ? 400 : 
                     region in ["Centre", "Est"] ? 700 :
                     region in ["Sud-Ouest", "Cascades"] ? 1000 : 600
        
        precipitation_totale = round(base_precip + randn() * 150, digits=1)
        precipitation_juin_sept = round(precipitation_totale * (0.7 + randn() * 0.1), digits=1)
        precipitation_avril_mai = round(precipitation_totale * (0.15 + randn() * 0.05), digits=1)
        
        # Températures selon la région
        base_temp = region in ["Sahel", "Nord"] ? 29 :
                   region in ["Sud-Ouest", "Cascades"] ? 26 : 27.5
        
        temperature_moyenne = round(base_temp + randn() * 1.5, digits=1)
        temperature_max_saison = round(temperature_moyenne + 8 + randn() * 2, digits=1)
        temperature_min_saison = round(temperature_moyenne - 8 + randn() * 2, digits=1)
        
        # Autres variables météo
        humidite_relative = round(40 + (precipitation_totale - 400) * 0.03 + randn() * 5, digits=1)
        jours_secheresse_consecutifs = round(Int, max(0, 25 - precipitation_totale/30 + randn() * 10))
        vent_vitesse_moy = round(6 + randn() * 2, digits=1)
        
        # Variables sol et pratiques agricoles
        type_sol = rand(["Argileux", "Sableux", "Limoneux", "Mixte"])
        ph_sol = round(5.5 + randn() * 1.2, digits=1)
        matiere_organique_pct = round(max(0.5, 2.0 + randn() * 1.0), digits=1)
        
        # Pratiques agricoles
        irrigation_disponible = rand([0, 1])  # 0=non, 1=oui
        engrais_npk_kg_ha = round(Int, max(0, 40 + randn() * 30))
        engrais_organique_kg_ha = round(Int, max(0, 500 + randn() * 300))
        semences_certifiees = rand([0, 1])
        traitement_semences = rand([0, 1])
        
        # Variables socio-économiques
        experience_agriculteur = rand(5:45)
        superficie_parcelle_ha = round(rand() * 8 + 0.5, digits=1)
        main_oeuvre_personnes = rand(2:8)
        acces_credit_agricole = rand([0, 1])
        formation_technique = rand([0, 1])
        equipement_score = rand(1:5)  # Score d'équipement (1=basique, 5=complet)
        
        # Variables temporelles
        date_semis_retard_jours = rand(0:30)  # Retard par rapport à la date optimale
        periode_sarclage_adequat = rand([0, 1])
        
        # Calcul du rendement (variable cible) basé sur un modèle réaliste
        rendement = calculer_rendement_realiste(
            cereale, region, precipitation_totale, precipitation_juin_sept,
            temperature_moyenne, jours_secheresse_consecutifs,
            type_sol, ph_sol, matiere_organique_pct,
            engrais_npk_kg_ha, engrais_organique_kg_ha,
            semences_certifiees, irrigation_disponible,
            experience_agriculteur, date_semis_retard_jours,
            equipement_score, formation_technique
        )
        
        push!(data, (
            # Identification
            annee = year,
            region = region,
            cereale = cereale,
            
            # Météorologie
            precipitation_totale_mm = precipitation_totale,
            precipitation_juin_sept_mm = precipitation_juin_sept,
            precipitation_avril_mai_mm = precipitation_avril_mai,
            temperature_moyenne_c = temperature_moyenne,
            temperature_max_saison_c = temperature_max_saison,
            temperature_min_saison_c = temperature_min_saison,
            humidite_relative_pct = humidite_relative,
            jours_secheresse_consecutifs = jours_secheresse_consecutifs,
            vent_vitesse_moy_kmh = vent_vitesse_moy,
            
            # Sol
            type_sol = type_sol,
            ph_sol = ph_sol,
            matiere_organique_pct = matiere_organique_pct,
            
            # Pratiques
            irrigation_disponible = irrigation_disponible,
            engrais_npk_kg_ha = engrais_npk_kg_ha,
            engrais_organique_kg_ha = engrais_organique_kg_ha,
            semences_certifiees = semences_certifiees,
            traitement_semences = traitement_semences,
            
            # Socio-économique
            experience_agriculteur = experience_agriculteur,
            superficie_parcelle_ha = superficie_parcelle_ha,
            main_oeuvre_personnes = main_oeuvre_personnes,
            acces_credit_agricole = acces_credit_agricole,
            formation_technique = formation_technique,
            equipement_score = equipement_score,
            
            # Temporel
            date_semis_retard_jours = date_semis_retard_jours,
            periode_sarclage_adequat = periode_sarclage_adequat,
            
            # Variable cible
            rendement_tonnes_ha = rendement
        ))
    end
    
    return DataFrame(data)
end

# Fonction de calcul de rendement réaliste
function calculer_rendement_realiste(cereale, region, precip_tot, precip_saison, temp_moy,
                                   jours_sech, type_sol, ph, mat_org, engrais_npk, engrais_org,
                                   semences_cert, irrigation, experience, retard_semis,
                                   equipement, formation)
    
    # Rendement de base par céréale
    base_rendement = cereale == "Mil" ? 0.8 :
                    cereale == "Sorgho" ? 0.9 :
                    cereale == "Maïs" ? 1.5 :
                    cereale == "Riz" ? 2.2 : 1.0
    
    # Facteur régional
    facteur_region = region in ["Sud-Ouest", "Cascades"] ? 1.3 :
                    region == "Centre" ? 1.1 :
                    region in ["Sahel", "Nord"] ? 0.7 : 1.0
    
    # Impact météorologique
    facteur_meteo = 1.0
    
    # Précipitations optimales par céréale
    precip_opt = cereale == "Riz" ? 1200 :
                cereale == "Maïs" ? 800 :
                cereale in ["Mil", "Sorgho"] ? 600 : 700
    
    # Pénalité pour précipitations inadéquates
    if abs(precip_tot - precip_opt) > 200
        facteur_meteo *= 0.8
    elseif abs(precip_tot - precip_opt) > 100
        facteur_meteo *= 0.9
    else
        facteur_meteo *= 1.1
    end
    
    # Impact température
    temp_opt = 28
    if abs(temp_moy - temp_opt) > 3
        facteur_meteo *= 0.85
    end
    
    # Impact sécheresse
    if jours_sech > 20
        facteur_meteo *= 0.7
    elseif jours_sech > 10
        facteur_meteo *= 0.9
    end
    
    # Impact sol
    facteur_sol = 1.0
    if type_sol == "Argileux"
        facteur_sol = 1.2
    elseif type_sol == "Limoneux"
        facteur_sol = 1.1
    elseif type_sol == "Sableux"
        facteur_sol = 0.8
    end
    
    # pH optimal
    if ph < 5.5 || ph > 7.5
        facteur_sol *= 0.9
    end
    
    # Matière organique
    facteur_sol *= (1 + mat_org * 0.1)
    
    # Impact pratiques agricoles
    facteur_pratiques = 1.0
    
    # Engrais
    facteur_pratiques *= (1 + min(engrais_npk * 0.005, 0.4))
    facteur_pratiques *= (1 + min(engrais_org * 0.0003, 0.2))
    
    # Semences et traitement
    if semences_cert == 1
        facteur_pratiques *= 1.25
    end
    
    # Irrigation
    if irrigation == 1
        facteur_pratiques *= 1.4
    end
    
    # Impact socio-économique
    facteur_socio = 1.0
    
    # Expérience
    facteur_socio *= (1 + min(experience * 0.01, 0.3))
    
    # Formation
    if formation == 1
        facteur_socio *= 1.15
    end
    
    # Équipement
    facteur_socio *= (1 + equipement * 0.05)
    
    # Retard semis
    if retard_semis > 15
        facteur_socio *= 0.85
    elseif retard_semis > 7
        facteur_socio *= 0.95
    end
    
    # Calcul final avec variabilité
    rendement_final = base_rendement * facteur_region * facteur_meteo * 
                     facteur_sol * facteur_pratiques * facteur_socio
    
    # Ajout de bruit réaliste
    rendement_final *= (1 + randn() * 0.15)
    
    # Contrainte de réalisme
    return max(0.1, min(5.0, round(rendement_final, digits=2)))
end

# Création du dataset
df_agri = create_agricultural_dataset(800)

println("🌾 Dataset agricole créé :")
println("📊 Observations : $(nrow(df_agri))")
println("📈 Rendement moyen : $(round(mean(df_agri.rendement_tonnes_ha), digits=2)) t/ha")
println("📉 Rendement médian : $(round(median(df_agri.rendement_tonnes_ha), digits=2)) t/ha")
println("🔄 Écart-type : $(round(std(df_agri.rendement_tonnes_ha), digits=2)) t/ha")
```

**🎯 Défi 1 :** Explorez les distributions des variables et identifiez les relations apparentes avec le rendement.

---

### Étape 2: Analyse exploratoire des données
```julia
# Statistiques descriptives par céréale
stats_cereales = combine(groupby(df_agri, :cereale),
    :rendement_tonnes_ha => mean => :rendement_moyen,
    :rendement_tonnes_ha => std => :rendement_std,
    :rendement_tonnes_ha => minimum => :rendement_min,
    :rendement_tonnes_ha => maximum => :rendement_max,
    nrow => :nombre_observations
)

println("📊 Statistiques par céréale :")
println(stats_cereales)

# Corrélations avec le rendement
variables_numeriques = [:precipitation_totale_mm, :temperature_moyenne_c, :jours_secheresse_consecutifs,
                       :ph_sol, :matiere_organique_pct, :engrais_npk_kg_ha, :experience_agriculteur,
                       :superficie_parcelle_ha, :rendement_tonnes_ha]

correlation_matrix = cor(Matrix(df_agri[!, variables_numeriques]))

# Variables les plus corrélées avec le rendement
correlations_rendement = correlation_matrix[end, 1:end-1]
var_names = string.(variables_numeriques[1:end-1])

# Tri par corrélation absolue
indices_sorted = sortperm(abs.(correlations_rendement), rev=true)

println("\n🔗 Variables les plus corrélées avec le rendement :")
for i in indices_sorted[1:5]
    println("$(var_names[i]): $(round(correlations_rendement[i], digits=3))")
end
```

**🎯 Défi 2 :** Créez un graphique de corrélation et identifiez les 3 variables les plus prédictives.

---

### Étape 3: Préparation des données pour ML
```julia
# Encodage des variables catégorielles
function encoder_variables_categoriques!(df::DataFrame)
    # Région (one-hot encoding)
    for region in unique(df.region)
        df[!, Symbol("region_" * replace(region, " " => "_", "-" => "_"))] = 
            (df.region .== region) * 1
    end
    
    # Céréale
    for cereale in unique(df.cereale)
        df[!, Symbol("cereale_" * cereale)] = (df.cereale .== cereale) * 1
    end
    
    # Type de sol
    for sol in unique(df.type_sol)
        df[!, Symbol("sol_" * sol)] = (df.type_sol .== sol) * 1
    end
    
    # Supprimer colonnes originales catégorielles
    select!(df, Not([:region, :cereale, :type_sol]))
    
    return df
end

# Application de l'encodage
df_encoded = copy(df_agri)
encoder_variables_categoriques!(df_encoded)

# Sélection des features et target
feature_columns = names(df_encoded)[names(df_encoded) .!= "rendement_tonnes_ha"]
X = select(df_encoded, feature_columns)
y = df_encoded.rendement_tonnes_ha

println("🔧 Données préparées :")
println("📊 Features : $(ncol(X))")
println("📈 Observations : $(nrow(X))")
```

**🎯 Défi 3 :** Vérifiez qu'il n'y a pas de valeurs manquantes et que toutes les variables sont numériques.

---

## 🤖 Phase 2: Développement des Modèles Prédictifs

### Étape 4: Division des données et baseline
```julia
# Division train/validation/test
train_ratio, val_ratio, test_ratio = 0.6, 0.2, 0.2

# Première division : train+val vs test
train_val_indices, test_indices = partition(eachindex(y), train_ratio + val_ratio, shuffle=true, rng=42)

# Deuxième division : train vs val
train_indices, val_indices = partition(train_val_indices, 
                                     train_ratio / (train_ratio + val_ratio), shuffle=true, rng=42)

# Extraction des ensembles
X_train = X[train_indices, :]
X_val = X[val_indices, :]
X_test = X[test_indices, :]

y_train = y[train_indices]
y_val = y[val_indices]
y_test = y[test_indices]

println("📊 Division des données :")
println("Train : $(length(train_indices)) observations")
println("Validation : $(length(val_indices)) observations") 
println("Test : $(length(test_indices)) observations")

# Modèle baseline : moyenne
baseline_pred = fill(mean(y_train), length(y_val))
baseline_rmse = sqrt(mean((y_val .- baseline_pred).^2))

println("🎯 Baseline RMSE (moyenne) : $(round(baseline_rmse, digits=3))")
```

**🎯 Défi 4 :** Calculez une baseline plus sophistiquée utilisant la médiane par céréale.

---

### Étape 5: Modèle de régression linéaire
```julia
# Modèle 1 : Régression linéaire
linear_model = LinearRegressor()
linear_machine = machine(linear_model, X_train, y_train)

# Entraînement
fit!(linear_machine, verbosity=0)

# Prédictions
y_pred_linear_val = predict(linear_machine, X_val)
y_pred_linear_test = predict(linear_machine, X_test)

# Évaluation
linear_rmse_val = sqrt(mean((y_val .- y_pred_linear_val).^2))
linear_rmse_test = sqrt(mean((y_test .- y_pred_linear_test).^2))
linear_r2_val = 1 - sum((y_val .- y_pred_linear_val).^2) / sum((y_val .- mean(y_val)).^2)

println("📈 Régression Linéaire :")
println("RMSE validation : $(round(linear_rmse_val, digits=3))")
println("RMSE test : $(round(linear_rmse_test, digits=3))")
println("R² validation : $(round(linear_r2_val, digits=3))")

# Analyse des résidus
residus_linear = y_val .- y_pred_linear_val
println("Résidus - Moyenne : $(round(mean(residus_linear), digits=4))")
println("Résidus - Std : $(round(std(residus_linear), digits=3))")
```

**🎯 Défi 5 :** Créez un graphique des résidus pour détecter des patterns non-linéaires.

---

### Étape 6: Modèle d'arbre de décision
```julia
# Modèle 2 : Arbre de décision
tree_model = DecisionTreeRegressor(max_depth=10, min_samples_leaf=5)
tree_machine = machine(tree_model, X_train, y_train)

# Entraînement
fit!(tree_machine, verbosity=0)

# Prédictions
y_pred_tree_val = predict(tree_machine, X_val)
y_pred_tree_test = predict(tree_machine, X_test)

# Évaluation
tree_rmse_val = sqrt(mean((y_val .- y_pred_tree_val).^2))
tree_rmse_test = sqrt(mean((y_test .- y_pred_tree_test).^2))
tree_r2_val = 1 - sum((y_val .- y_pred_tree_val).^2) / sum((y_val .- mean(y_val)).^2)

println("🌳 Arbre de Décision :")
println("RMSE validation : $(round(tree_rmse_val, digits=3))")
println("RMSE test : $(round(tree_rmse_test, digits=3))")
println("R² validation : $(round(tree_r2_val, digits=3))")
```

**🎯 Défi 6 :** Testez différentes profondeurs d'arbre (5, 15, 20) et observez l'overfitting.

---

### Étape 7: Modèle Random Forest
```julia
# Modèle 3 : Random Forest
rf_model = RandomForestRegressor(n_estimators=100, max_depth=15, random_state=42)
rf_machine = machine(rf_model, X_train, y_train)

# Entraînement
fit!(rf_machine, verbosity=0)

# Prédictions
y_pred_rf_val = predict(rf_machine, X_val)
y_pred_rf_test = predict(rf_machine, X_test)

# Évaluation
rf_rmse_val = sqrt(mean((y_val .- y_pred_rf_val).^2))
rf_rmse_test = sqrt(mean((y_test .- y_pred_rf_test).^2))
rf_r2_val = 1 - sum((y_val .- y_pred_rf_val).^2) / sum((y_val .- mean(y_val)).^2)

println("🌲 Random Forest :")
println("RMSE validation : $(round(rf_rmse_val, digits=3))")
println("RMSE test : $(round(rf_rmse_test, digits=3))")
println("R² validation : $(round(rf_r2_val, digits=3))")
```

**🎯 Défi 7 :** Comparez les performances des 3 modèles et sélectionnez le meilleur.

---

### Étape 8: Optimisation des hyperparamètres
```julia
using MLJTuning

# Optimisation du Random Forest (meilleur modèle supposé)
# Définition des plages de paramètres
r_n_estimators = range(rf_model, :n_estimators, values=[50, 100, 150, 200])
r_max_depth = range(rf_model, :max_depth, values=[10, 15, 20, 25])

# Grid search avec validation croisée
tuning = Grid(resolution=8)
tuned_rf = TunedModel(
    model=rf_model,
    tuning=tuning,
    resampling=CV(nfolds=5, shuffle=true, rng=123),
    ranges=[r_n_estimators, r_max_depth],
    measure=rmse
)

# Entraînement du modèle optimisé
tuned_rf_machine = machine(tuned_rf, X_train, y_train)
fit!(tuned_rf_machine, verbosity=1)

# Meilleurs paramètres
best_rf_model = fitted_params(tuned_rf_machine).best_model
println("🎯 Meilleurs paramètres Random Forest :")
println("n_estimators: $(best_rf_model.n_estimators)")
println("max_depth: $(best_rf_model.max_depth)")

# Prédictions avec modèle optimisé
y_pred_tuned_val = predict(tuned_rf_machine, X_val)
y_pred_tuned_test = predict(tuned_rf_machine, X_test)

tuned_rmse_val = sqrt(mean((y_val .- y_pred_tuned_val).^2))
tuned_rmse_test = sqrt(mean((y_test .- y_pred_tuned_test).^2))

println("🚀 Random Forest Optimisé :")
println("RMSE validation : $(round(tuned_rmse_val, digits=3))")
println("RMSE test : $(round(tuned_rmse_test, digits=3))")
```

**🎯 Défi 8 :** L'optimisation a-t-elle amélioré significativement les performances ?

---

## 📊 Phase 3: Analyse et Interprétation des Résultats

### Étape 9: Analyse de l'importance des variables
```julia
# Pour Random Forest, nous pouvons estimer l'importance par permutation
function feature_importance_permutation(model_machine, X_val, y_val)
    # Score de référence
    baseline_pred = predict(model_machine, X_val)
    baseline_score = sqrt(mean((y_val .- baseline_pred).^2))
    
    importances = Dict{String, Float64}()
    
    for col in names(X_val)
        # Copie des données avec permutation de la colonne
        X_permuted = copy(X_val)
        X_permuted[!, col] = shuffle(X_permuted[!, col])
        
        # Prédiction avec données permutées
        permuted_pred = predict(model_machine, X_permuted)
        permuted_score = sqrt(mean((y_val .- permuted_pred).^2))
        
        # Importance = dégradation de performance
        importance = permuted_score - baseline_score
        importances[col] = importance
    end
    
    return importances
end

# Calcul de l'importance des variables
importance_scores = feature_importance_permutation(tuned_rf_machine, X_val, y_val)

# Tri par importance décroissante
sorted_importance = sort(collect(importance_scores), by=x->x[2], rev=true)

println("🔍 Importance des variables (Top 10) :")
for (i, (feature, importance)) in enumerate(sorted_importance[1:min(10, length(sorted_importance))])
    println("$(i). $(feature): $(round(importance, digits=4))")
end
```

**🎯 Défi 9 :** Interprétez les variables les plus importantes d'un point de vue agronomique.

---

### Étape 10: Analyse par céréale et région
```julia
# Performance du modèle par céréale
function analyser_performance_par_groupe(y_true, y_pred, groupes, nom_groupe)
    resultats = DataFrame()
    
    for groupe in unique(groupes)
        indices = groupes .== groupe
        if sum(indices) > 0
            y_true_groupe = y_true[indices]
            y_pred_groupe = y_pred[indices]
            
            rmse_groupe = sqrt(mean((y_true_groupe .- y_pred_groupe).^2))
            mae_groupe = mean(abs.(y_true_groupe .- y_pred_groupe))
            r2_groupe = 1 - sum((y_true_groupe .- y_pred_groupe).^2) / 
                           sum((y_true_groupe .- mean(y_true_groupe)).^2)
            
            push!(resultats, (
                groupe = groupe,
                n_observations = sum(indices),
                rmse = rmse_groupe,
                mae = mae_groupe,
                r2 = r2_groupe,
                rendement_moyen_reel = mean(y_true_groupe),
                rendement_moyen_predit = mean(y_pred_groupe)
            ))
        end
    end
    
    return resultats
end

# Analyse par céréale
cereales_test = df_encoded[test_indices, :].cereale  # Récupération des céréales pour le test
performance_cereales = analyser_performance_par_groupe(
    y_test, y_pred_tuned_test, cereales_test, "cereale"
)

println("📊 Performance par céréale :")
println(performance_cereales)

# Analyse par région
regions_test = df_agri[test_indices, :].region
performance_regions = analyser_performance_par_groupe(
    y_test, y_pred_tuned_test, regions_test, "region"
)

println("\n🗺️ Performance par région :")
println(performance_regions)
```

**🎯 Défi 10 :** Identifiez les céréales et régions les plus difficiles à prédire.

---

### Étape 11: Validation avec données extrêmes
```julia
# Test de robustesse avec conditions extrêmes
function tester_conditions_extremes()
    # Création de scénarios extrêmes
    scenarios = DataFrame(
        scenario = ["Sécheresse sévère", "Précipitations excessives", "Très bonne pratique", "Pratique minimale"],
        precipitation_totale_mm = [250.0, 1500.0, 800.0, 800.0],
        temperature_moyenne_c = [32.0, 26.0, 27.0, 27.0],
        jours_secheresse_consecutifs = [45, 5, 10, 25],
        engrais_npk_kg_ha = [0, 30, 80, 10],
        semences_certifiees = [0, 0, 1, 0],
        irrigation_disponible = [0, 0, 1, 0],
        formation_technique = [0, 0, 1, 0]
    )
    
    # Compléter avec valeurs moyennes pour autres variables
    for col in names(X_train)
        if !(col in names(scenarios))
            scenarios[!, col] = [mean(X_train[!, col]) for _ in 1:nrow(scenarios)]
        end
    end
    
    # Réorganiser les colonnes pour correspondre à X_train
    scenarios_ordered = select(scenarios, names(X_train))
    
    # Prédictions
    predictions_extremes = predict(tuned_rf_machine, scenarios_ordered)
    
    for i in 1:nrow(scenarios)
        println("$(scenarios.scenario[i]): $(round(predictions_extremes[i], digits=2)) t/ha")
    end
    
    return scenarios, predictions_extremes
end

scenarios_test, pred_extremes = tester_conditions_extremes()
```

**🎯 Défi 11 :** Les prédictions pour les conditions extrêmes sont-elles cohérentes avec vos attentes ?

---

### Étape 12: Système de recommandations
```julia
# Fonction de recommandation pour optimiser le rendement
function recommander_optimisations(donnees_parcelle, modele, top_n=5)
    println("🎯 Recommandations pour optimiser le rendement :")
    
    # Prédiction actuelle
    rendement_actuel = predict(modele, donnees_parcelle)[1]
    println("Rendement prédit actuel : $(round(rendement_actuel, digits=2)) t/ha")
    
    recommandations = []
    
    # Test d'améliorations possibles
    ameliorations = [
        ("Utiliser semences certifiées", :semences_certifiees, 1),
        ("Ajouter irrigation", :irrigation_disponible, 1),
        ("Augmenter engrais NPK à 60 kg/ha", :engrais_npk_kg_ha, 60),
        ("Suivre formation technique", :formation_technique, 1),
        ("Améliorer traitement semences", :traitement_semences, 1)
    ]
    
    for (description, variable, nouvelle_valeur) in ameliorations
        # Copie des données avec modification
        donnees_modifiees = copy(donnees_parcelle)
        
        if variable in names(donnees_modifiees)
            donnees_modifiees[1, variable] = nouvelle_valeur
            
            # Nouvelle prédiction
            nouveau_rendement = predict(modele, donnees_modifiees)[1]
            gain = nouveau_rendement - rendement_actuel
            
            if gain > 0.05  # Gain significatif
                push!(recommandations, (description, gain, nouveau_rendement))
            end
        end
    end
    
    # Tri par gain décroissant
    sort!(recommandations, by=x->x[2], rev=true)
    
    println("\nRecommandations prioritaires :")
    for (i, (desc, gain, nouveau_rend)) in enumerate(recommandations[1:min(top_n, length(recommandations))])
        println("$(i). $(desc)")
        println("   Gain estimé : +$(round(gain, digits=2)) t/ha ($(round(nouveau_rend, digits=2)) t/ha total)")
    end
    
    return recommandations
end

# Test avec une parcelle exemple
parcelle_exemple = X_test[1:1, :]  # Première observation du test
recommandations = recommander_optimisations(parcelle_exemple, tuned_rf_machine)
```

**🎯 Défi 12 :** Testez le système de recommandation sur plusieurs parcelles différentes.

---

### Étape 13: Prédiction saisonnière
```julia
# Fonction de prédiction basée sur prévisions météo
function predire_rendement_saison(region, cereale, prevision_meteo, pratiques_agricoles)
    println("🌦️ Prédiction de rendement pour la saison $(Dates.year(now())) :")
    println("Région : $region, Céréale : $cereale")
    
    # Création du vecteur de features
    donnees_prediction = DataFrame()
    
    # Initialiser avec des valeurs par défaut
    for col in names(X_train)
        donnees_prediction[!, col] = [0.0]
    end
    
    # Remplir avec données météo
    for (key, value) in prevision_meteo
        if key in names(donnees_prediction)
            donnees_prediction[1, key] = value
        end
    end
    
    # Remplir avec pratiques agricoles
    for (key, value) in pratiques_agricoles
        if key in names(donnees_prediction)
            donnees_prediction[1, key] = value
        end
    end
    
    # Encodage région et céréale
    region_col = "region_" * replace(region, " " => "_", "-" => "_")
    cereale_col = "cereale_" * cereale
    
    if region_col in names(donnees_prediction)
        donnees_prediction[1, region_col] = 1.0
    end
    
    if cereale_col in names(donnees_prediction)
        donnees_prediction[1, cereale_col] = 1.0
    end
    
    # Prédiction
    rendement_predit = predict(tuned_rf_machine, donnees_prediction)[1]
    
    println("Rendement prédit : $(round(rendement_predit, digits=2)) t/ha")
    
    # Intervalle de confiance approximatif (basé sur erreur validation)
    erreur_std = tuned_rmse_val
    intervalle_inf = max(0, rendement_predit - 1.96 * erreur_std)
    intervalle_sup = rendement_predit + 1.96 * erreur_std
    
    println("Intervalle de confiance 95% : [$(round(intervalle_inf, digits=2)), $(round(intervalle_sup, digits=2))] t/ha")
    
    return rendement_predit, (intervalle_inf, intervalle_sup)
end

# Exemple de prédiction saisonnière
previsions_meteo = Dict(
    :precipitation_totale_mm => 750.0,
    :temperature_moyenne_c => 27.5,
    :jours_secheresse_consecutifs => 15
)

pratiques = Dict(
    :engrais_npk_kg_ha => 50.0,
    :semences_certifiees => 1,
    :irrigation_disponible => 0,
    :experience_agriculteur => 15
)

rendement_saison, intervalle = predire_rendement_saison("Centre", "Mil", previsions_meteo, pratiques)
```

**🎯 Défi 13 :** Créez des prédictions pour 3 scénarios météo (optimiste, normal, pessimiste).

---

### Étape 14: Évaluation économique
```julia
# Analyse de l'impact économique des prédictions
function analyser_impact_economique(rendements_predits, rendements_reels, prix_tonne_fcfa=200000)
    
    println("💰 Analyse d'impact économique :")
    
    # Erreurs de prédiction
    erreurs = rendements_predits .- rendements_reels
    erreurs_absolues = abs.(erreurs)
    
    # Impact financier des erreurs (par hectare)
    impact_financier = erreurs .* prix_tonne_fcfa
    impact_absolu = erreurs_absolues .* prix_tonne_fcfa
    
    println("Erreur moyenne : $(round(mean(erreurs), digits=2)) t/ha")
    println("Erreur absolue moyenne : $(round(mean(erreurs_absolues), digits=2)) t/ha")
    println("Impact financier moyen : $(round(mean(impact_absolu), digits=0)) FCFA/ha")
    
    # Pourcentage de prédictions dans marge d'erreur acceptable (±20%)
    marge_acceptable = 0.2
    predictions_acceptables = sum(erreurs_absolues ./ rendements_reels .< marge_acceptable)
    taux_acceptabilite = predictions_acceptables / length(rendements_reels) * 100
    
    println("Prédictions dans marge ±20% : $(round(taux_acceptabilite, digits=1))%")
    
    # Économies potentielles avec optimisation
    # Supposons qu'une optimisation basée sur nos recommandations apporte +0.3 t/ha en moyenne
    gain_optimisation = 0.3
    superficie_moyenne = 2.0  # hectares par exploitation
    economie_par_exploitation = gain_optimisation * superficie_moyenne * prix_tonne_fcfa
    
    println("Économie potentielle par exploitation : $(round(economie_par_exploitation, digits=0)) FCFA")
    
    return Dict(
        "erreur_moyenne" => mean(erreurs_absolues),
        "impact_financier_moyen" => mean(impact_absolu),
        "taux_acceptabilite" => taux_acceptabilite,
        "economie_potentielle" => economie_par_exploitation
    )
end

# Analyse sur données de test
impact_eco = analyser_impact_economique(y_pred_tuned_test, y_test)
```

**🎯 Défi Final :** Calculez le ROI du système de prédiction si son déploiement coûte 50 millions FCFA.

---

## 🎯 Exercices Supplémentaires

### Exercice A: Modèle ensemble
```julia
# Créez un modèle ensemble combinant les 3 meilleurs modèles
```

### Exercice B: Analyse temporelle
```julia
# Analysez si le modèle performe différemment selon l'année
```

### Exercice C: Prédiction à long terme
```julia
# Intégrez les projections climatiques pour prédire les rendements futurs
```

### Exercice D: Interface utilisateur
```julia
# Créez une interface simple pour que les agriculteurs saisissent leurs données
```

## 🏆 Points Clés Appris
- ✅ Création de datasets agricoles réalistes
- ✅ Préparation de données pour machine learning
- ✅ Comparaison de modèles de régression (linéaire, arbre, random forest)
- ✅ Optimisation d'hyperparamètres avec validation croisée
- ✅ Analyse de l'importance des variables
- ✅ Évaluation de performance par sous-groupes
- ✅ Système de recommandations basé sur ML
- ✅ Prédictions avec intervalles de confiance
- ✅ Analyse d'impact économique des prédictions
- ✅ Validation avec conditions extrêmes

Ce système de prédiction des rendements peut considérablement aider les agriculteurs burkinabè à optimiser leurs pratiques et anticiper les variations de production. Dans la prochaine pratique, nous aborderons la classification de textes en langues locales !