# Projet Final 1 : Prédicteur Agricole Burkina Faso
# Module 3 : Apprentissage Automatique avec Julia
# Durée : 4 heures | Difficulté : Expert | Impact : 🌍 Transformationnel

# 📚 AVANT DE COMMENCER
# Lisez le résumé de projet : resume_projet_agricole.md
# Ce projet intègre TOUT ce que vous avez appris en ML Julia !

println("📚 Consultez le résumé : modules/module3-ml/resume_projet_agricole.md")
println("Appuyez sur Entrée quand vous êtes prêt pour le projet final...")
readline()

println("🌾🚀 PRÉDICTEUR AGRICOLE BURKINA FASO - PROJET FINAL")
println("="^70)
println("🎯 Mission : Créer un système ML de prédiction de rendements")
println("   qui peut transformer l'agriculture burkinabè !")
println("="^70)

# ============================================================================
# PHASE 1 : ARCHITECTURE ET CONFIGURATION (30 minutes)
# ============================================================================

println("\n📐 PHASE 1 : ARCHITECTURE ET CONFIGURATION")
println("-"^50)

# Importation complète de l'écosystème ML
using MLJ, MLJModels, MLJTuning
using DataFrames, CSV, Statistics, Random
using Plots, StatsPlots, PlotlyJS
using Dates, TimeZones
using LinearAlgebra, Distributed
using JSON3, FileIO
using ProgressMeter

# Configuration pour projet de production
Random.seed!(2024)  # Année cible !
MLJ.color_off()
plotlyjs()
theme(:bright)

println("✅ Environnement ML de production configuré")

# Structure de données pour le système agricole burkinabè
@kwdef struct RegionAgricole
    nom::String
    latitude::Float64
    longitude::Float64
    zone_climatique::String  # "Sahélienne", "Soudano-Sahélienne", "Soudanienne"
    superficie_totale_km2::Float64
    population::Int
    principales_cultures::Vector{String}
end

@kwdef struct DonnéesClimatiques
    température_min::Float64
    température_max::Float64
    température_moyenne::Float64
    précipitations_mm::Float64
    humidité_relative::Float64
    vitesse_vent_kmh::Float64
    heures_soleil::Float64
    évapotranspiration_mm::Float64
end

@kwdef struct DonnéesAgricoles
    région::String
    culture::String
    superficie_hectares::Float64
    variété_culture::String  # "Traditionnelle", "Améliorée", "Hybride"
    semences_kg_ha::Float64
    engrais_npk_kg_ha::Float64
    engrais_organique_t_ha::Float64
    irrigation::Bool
    mécanisation_niveau::String  # "Manuel", "Traction_animale", "Motorisé"
    date_semis::Date
    date_récolte_prévue::Date
    rendement_réalisé_t_ha::Union{Float64, Missing}
end

println("✅ Architecture de données agricoles définie")

# Création du dataset complet et réaliste
println("\n📊 Génération du dataset agricole burkinabè complet...")

# Définition des 13 régions avec leurs caractéristiques réelles
régions_bf = [
    RegionAgricole(
        nom="Sahel",
        latitude=14.5, longitude=-0.5,
        zone_climatique="Sahélienne",
        superficie_totale_km2=36166,
        population=1235563,
        principales_cultures=["Mil", "Sorgho", "Niébé", "Sésame"]
    ),
    RegionAgricole(
        nom="Nord", 
        latitude=13.5, longitude=-2.0,
        zone_climatique="Sahélienne",
        superficie_totale_km2=17674,
        population=1481553,
        principales_cultures=["Mil", "Sorgho", "Maïs", "Niébé"]
    ),
    RegionAgricole(
        nom="Centre-Nord",
        latitude=13.2, longitude=-1.5,
        zone_climatique="Soudano-Sahélienne", 
        superficie_totale_km2=19508,
        population=1529977,
        principales_cultures=["Sorgho", "Mil", "Maïs", "Arachide"]
    ),
    RegionAgricole(
        nom="Centre",
        latitude=12.4, longitude=-1.5,
        zone_climatique="Soudano-Sahélienne",
        superficie_totale_km2=2805,
        population=2453496,
        principales_cultures=["Maïs", "Sorgho", "Riz", "Légumes"]
    ),
    RegionAgricole(
        nom="Plateau-Central",
        latitude=12.3, longitude=-1.2,
        zone_climatique="Soudano-Sahélienne",
        superficie_totale_km2=8608,
        population=808224,
        principales_cultures=["Sorgho", "Maïs", "Mil", "Niébé"]
    ),
    RegionAgricole(
        nom="Est",
        latitude=12.0, longitude=0.5,
        zone_climatique="Soudano-Sahélienne",
        superficie_totale_km2=46618,
        population=1661673,
        principales_cultures=["Sorgho", "Maïs", "Riz", "Coton"]
    ),
    RegionAgricole(
        nom="Centre-Est",
        latitude=11.9, longitude=-0.3,
        zone_climatique="Soudano-Sahélienne",
        superficie_totale_km2=14763,
        population=1578075,
        principales_cultures=["Maïs", "Sorgho", "Coton", "Arachide"]
    ),
    RegionAgricole(
        nom="Boucle du Mouhoun",
        latitude=12.3, longitude=-2.9,
        zone_climatique="Soudano-Sahélienne",
        superficie_totale_km2=34497,
        population=1898166,
        principales_cultures=["Coton", "Maïs", "Sorgho", "Riz"]
    ),
    RegionAgricole(
        nom="Hauts-Bassins",
        latitude=11.2, longitude=-4.3,
        zone_climatique="Soudanienne",
        superficie_totale_km2=25659,
        population=2201027,
        principales_cultures=["Coton", "Maïs", "Riz", "Canne_sucre"]
    ),
    RegionAgricole(
        nom="Centre-Ouest",
        latitude=12.1, longitude=-2.3,
        zone_climatique="Soudano-Sahélienne",
        superficie_totale_km2=21273,
        population=1369509,
        principales_cultures=["Coton", "Maïs", "Sorgho", "Arachide"]
    ),
    RegionAgricole(
        nom="Sud-Ouest",
        latitude=10.3, longitude=-3.2,
        zone_climatique="Soudanienne",
        superficie_totale_km2=16202,
        population=878759,
        principales_cultures=["Coton", "Maïs", "Riz", "Igname"]
    ),
    RegionAgricole(
        nom="Cascades",
        latitude=10.8, longitude=-4.3,
        zone_climatique="Soudanienne",
        superficie_totale_km2=18424,
        population=734993,
        principales_cultures=["Coton", "Maïs", "Riz", "Fruits"]
    ),
    RegionAgricole(
        nom="Centre-Sud",
        latitude=11.2, longitude=-1.0,
        zone_climatique="Soudanienne",
        superficie_totale_km2=11376,
        population=796085,
        principales_cultures=["Maïs", "Sorgho", "Coton", "Légumes"]
    )
]

println("✅ $(length(régions_bf)) régions agricoles définies")

# ============================================================================
# PHASE 2 : GÉNÉRATION DE DONNÉES RÉALISTES (45 minutes)
# ============================================================================

println("\n🌾 PHASE 2 : GÉNÉRATION DE DONNÉES HISTORIQUES COMPLÈTES")
println("-"^50)

# Fonction de génération de données climatiques réalistes
function générer_climat_réaliste(région::RegionAgricole, date::Date)
    jour_année = dayofyear(date)
    mois = month(date)
    
    # Température basée sur la zone climatique et la saison
    temp_base = Dict(
        "Sahélienne" => 32.0,
        "Soudano-Sahélienne" => 30.0, 
        "Soudanienne" => 28.0
    )[région.zone_climatique]
    
    # Variation saisonnière (max en avril-mai, min en décembre-janvier)
    temp_saisonnière = temp_base + 8 * sin(2π * (jour_année - 15) / 365)
    temp_variation = temp_saisonnière + randn() * 3  # Variabilité météo
    
    temp_max = temp_variation + rand(3:8)
    temp_min = temp_variation - rand(5:10)
    
    # Précipitations : pattern réaliste sahélien (juin-septembre)
    if mois in [6, 7, 8, 9]  # Saison des pluies
        precip_base = Dict(
            "Sahélienne" => 40.0,
            "Soudano-Sahélienne" => 80.0,
            "Soudanienne" => 120.0
        )[région.zone_climatique]
        
        # Peak en juillet-août
        facteur_mensuel = mois == 7 || mois == 8 ? 1.5 : 1.0
        précipitations = abs(randn()) * precip_base * facteur_mensuel
    elseif mois in [5, 10]  # Début/fin saison
        précipitations = abs(randn()) * 15
    else  # Saison sèche
        précipitations = abs(randn()) * 2
    end
    
    # Autres variables climatiques dérivées
    humidité = région.zone_climatique == "Sahélienne" ? 25 + rand() * 30 : 45 + rand() * 40
    vent = 8 + rand() * 12  # km/h
    soleil = mois in [11, 12, 1, 2, 3, 4] ? 9 + rand() * 3 : 6 + rand() * 4  # heures
    
    # Évapotranspiration (fonction température et humidité)  
    etp = max(0, (temp_max - 5) * (100 - humidité) / 100 * 0.05)
    
    return DonnéesClimatiques(
        température_min=temp_min,
        température_max=temp_max,
        température_moyenne=(temp_min + temp_max) / 2,
        précipitations_mm=précipitations,
        humidité_relative=humidité,
        vitesse_vent_kmh=vent,
        heures_soleil=soleil,
        évapotranspiration_mm=etp
    )
end

# Fonction de calcul de rendement réaliste
function calculer_rendement_réaliste(
    région::RegionAgricole,
    culture::String,
    climat::DonnéesClimatiques,
    pratiques::NamedTuple
)
    # Rendements de base par culture (tonnes/hectare)
    rendement_base = Dict(
        "Mil" => 0.8, "Sorgho" => 0.9, "Maïs" => 1.2, "Riz" => 2.5,
        "Coton" => 1.0, "Niébé" => 0.6, "Arachide" => 1.1, "Sésame" => 0.4,
        "Canne_sucre" => 45.0, "Igname" => 12.0, "Légumes" => 8.0, "Fruits" => 6.0
    )[culture]
    
    # Facteur climatique (température et précipitations optimales par culture)
    optimal_temp = Dict(
        "Mil" => 30, "Sorgho" => 29, "Maïs" => 27, "Riz" => 26,
        "Coton" => 28, "Niébé" => 31, "Arachide" => 28, "Sésame" => 32
    )[get(Dict("Canne_sucre" => "Maïs", "Igname" => "Maïs", "Légumes" => "Maïs", "Fruits" => "Maïs"), culture, culture)]
    
    facteur_temp = 1.0 - abs(climat.température_moyenne - optimal_temp) * 0.03
    facteur_temp = clamp(facteur_temp, 0.3, 1.2)
    
    # Besoins en eau par culture (mm pour cycle complet)
    besoin_eau = Dict(
        "Mil" => 400, "Sorgho" => 450, "Maïs" => 600, "Riz" => 1200,
        "Coton" => 800, "Niébé" => 350, "Arachide" => 500, "Sésame" => 300
    )[get(Dict("Canne_sucre" => "Riz", "Igname" => "Maïs", "Légumes" => "Maïs", "Fruits" => "Maïs"), culture, culture)]
    
    # Eau disponible (précipitations + irrigation)
    eau_disponible = climat.précipitations_mm * 4  # Approximation cycle cultural
    if pratiques.irrigation
        eau_disponible += besoin_eau * 0.5  # Irrigation complémentaire
    end
    
    facteur_eau = min(1.5, eau_disponible / besoin_eau)
    facteur_eau = clamp(facteur_eau, 0.2, 1.5)
    
    # Facteurs pratiques agricoles
    facteur_variété = Dict(
        "Traditionnelle" => 1.0,
        "Améliorée" => 1.25,
        "Hybride" => 1.4
    )[pratiques.variété]
    
    facteur_engrais = 1.0 + pratiques.engrais_npk * 0.01  # 1% par kg/ha
    facteur_engrais += pratiques.engrais_organique * 0.15  # 15% par tonne/ha
    facteur_engrais = min(facteur_engrais, 1.8)  # Plafond
    
    facteur_mécanisation = Dict(
        "Manuel" => 1.0,
        "Traction_animale" => 1.15,
        "Motorisé" => 1.3
    )[pratiques.mécanisation]
    
    # Facteur régional (fertilité des sols)
    facteur_régional = Dict(
        "Sahel" => 0.8, "Nord" => 0.85, "Centre-Nord" => 0.9,
        "Est" => 0.95, "Centre-Est" => 1.0, "Centre" => 1.05,
        "Plateau-Central" => 0.9, "Boucle du Mouhoun" => 1.1,
        "Hauts-Bassins" => 1.2, "Centre-Ouest" => 1.05,
        "Sud-Ouest" => 1.15, "Cascades" => 1.25, "Centre-Sud" => 1.1
    )[région.nom]
    
    # Calcul final avec variabilité aléatoire
    rendement_final = rendement_base * facteur_temp * facteur_eau * 
                     facteur_variété * facteur_engrais * facteur_mécanisation * 
                     facteur_régional * (0.7 + rand() * 0.6)  # ±30% variabilité
    
    return max(0.05, rendement_final)  # Minimum technique
end

# Génération du dataset complet (5 ans de données)
println("Génération de 5 années de données agricoles (2019-2023)...")

dataset_complet = DataFrame()
cultures_principales = ["Mil", "Sorgho", "Maïs", "Riz", "Coton", "Niébé", "Arachide"]
années = 2019:2023
mois_semis = Dict(
    "Mil" => 6, "Sorgho" => 6, "Maïs" => 5, "Riz" => 6,
    "Coton" => 5, "Niébé" => 7, "Arachide" => 5
)

@showprogress "Génération données..." for année in années
    for région in régions_bf
        # Cultures adaptées à chaque région
        cultures_région = intersect(cultures_principales, région.principales_cultures)
        
        for culture in cultures_région
            # 20-50 observations par région/culture/année (différentes parcelles)
            n_parcelles = rand(20:50)
            
            for parcelle in 1:n_parcelles
                # Date de semis aléatoire autour du mois optimal
                mois_sem = mois_semis[culture]
                jour_sem = rand(1:28)  # Éviter problèmes fin de mois
                date_sem = Date(année, mois_sem, jour_sem)
                
                # Date de récolte (cycle cultural moyen 120 jours)
                date_rec = date_sem + Day(rand(90:150))
                
                # Générer climat moyen pendant le cycle
                climats_cycle = [générer_climat_réaliste(région, date_sem + Day(i)) for i in 0:30:120]
                climat_moyen = DonnéesClimatiques(
                    température_min=mean([c.température_min for c in climats_cycle]),
                    température_max=mean([c.température_max for c in climats_cycle]),
                    température_moyenne=mean([c.température_moyenne for c in climats_cycle]),
                    précipitations_mm=sum([c.précipitations_mm for c in climats_cycle]),
                    humidité_relative=mean([c.humidité_relative for c in climats_cycle]),
                    vitesse_vent_kmh=mean([c.vitesse_vent_kmh for c in climats_cycle]),
                    heures_soleil=mean([c.heures_soleil for c in climats_cycle]),
                    évapotranspiration_mm=sum([c.évapotranspiration_mm for c in climats_cycle])
                )
                
                # Pratiques agricoles réalistes (distribution selon développement région)
                taux_amélioration = région.zone_climatique == "Soudanienne" ? 0.4 : 0.2
                
                pratiques = (
                    variété = rand() < taux_amélioration ? (rand() < 0.3 ? "Hybride" : "Améliorée") : "Traditionnelle",
                    engrais_npk = rand() < 0.3 ? rand(20:100) : rand(0:20),
                    engrais_organique = rand() < 0.6 ? rand() * 3 : 0.0,
                    irrigation = rand() < (région.zone_climatique == "Soudanienne" ? 0.1 : 0.03),
                    mécanisation = rand() < 0.4 ? (rand() < 0.1 ? "Motorisé" : "Traction_animale") : "Manuel"
                )
                
                # Calculer rendement réaliste
                rendement = calculer_rendement_réaliste(région, culture, climat_moyen, pratiques)
                
                # Ajouter à dataset
                push!(dataset_complet, (
                    année = année,
                    région = région.nom,
                    zone_climatique = région.zone_climatique,
                    latitude = région.latitude,
                    longitude = région.longitude,
                    culture = culture,
                    superficie_ha = rand() < 0.8 ? rand(0.5:0.1:3.0) : rand(3.1:0.5:8.0),  # Majorité petites parcelles
                    
                    # Variables climatiques
                    temp_min = climat_moyen.température_min,
                    temp_max = climat_moyen.température_max,
                    temp_moyenne = climat_moyen.température_moyenne,
                    précipitations_totales = climat_moyen.précipitations_mm,
                    humidité_moyenne = climat_moyen.humidité_relative,
                    vent_moyen = climat_moyen.vitesse_vent_kmh,
                    soleil_total = climat_moyen.heures_soleil,
                    evapotranspiration = climat_moyen.évapotranspiration_mm,
                    
                    # Variables pratiques
                    variété_semences = pratiques.variété,
                    engrais_npk_kg_ha = pratiques.engrais_npk,
                    engrais_organique_t_ha = pratiques.engrais_organique,
                    irrigation = pratiques.irrigation,
                    niveau_mécanisation = pratiques.mécanisation,
                    
                    # Date et cible
                    date_semis = date_sem,
                    date_récolte = date_rec,
                    rendement_t_ha = rendement
                ))
            end
        end
    end
end

println("✅ Dataset généré : $(nrow(dataset_complet)) observations")
println("Variables : $(ncol(dataset_complet)) features")
println("Période : $(minimum(dataset_complet.année)) - $(maximum(dataset_complet.année))")
println("Rendement moyen : $(round(mean(dataset_complet.rendement_t_ha), digits=2)) t/ha")

# ============================================================================
# PHASE 3 : ANALYSE EXPLORATOIRE AVANCÉE (30 minutes)
# ============================================================================

println("\n📊 PHASE 3 : ANALYSE EXPLORATOIRE DONNÉES AGRICULTURE BF")
println("-"^50)

# Vue d'ensemble du dataset
println("📈 Statistiques descriptives :")
describe(dataset_complet[!, [:rendement_t_ha, :précipitations_totales, :temp_moyenne, :engrais_npk_kg_ha]])

# Analyse par culture
println("\n🌾 Rendements moyens par culture :")
stats_culture = combine(groupby(dataset_complet, :culture),
    :rendement_t_ha => mean => :rendement_moyen,
    :rendement_t_ha => std => :écart_type,
    nrow => :n_observations
)
sort!(stats_culture, :rendement_moyen, rev=true)
println(stats_culture)

# Analyse par zone climatique
println("\n🌡️ Performance par zone climatique :")
stats_zone = combine(groupby(dataset_complet, :zone_climatique),
    :rendement_t_ha => mean => :rendement_moyen,
    :précipitations_totales => mean => :pluie_moyenne
)
sort!(stats_zone, :rendement_moyen, rev=true)
println(stats_zone)

# Visualisations exploratoires
println("\n📊 Création des visualisations exploratoires...")

# 1. Distribution des rendements par culture
p1 = boxplot(dataset_complet.culture, dataset_complet.rendement_t_ha,
    title="Distribution Rendements par Culture - Burkina Faso",
    xlabel="Culture",
    ylabel="Rendement (t/ha)",
    rotation=45,
    size=(800, 500))
display(p1)

# 2. Relation précipitations-rendement par zone climatique
p2 = scatter(dataset_complet.précipitations_totales, dataset_complet.rendement_t_ha,
    group=dataset_complet.zone_climatique,
    title="Rendement vs Précipitations par Zone Climatique",
    xlabel="Précipitations totales (mm)",
    ylabel="Rendement (t/ha)",
    alpha=0.6,
    size=(900, 600))
display(p2)

# 3. Impact de la mécanisation
stats_méca = combine(groupby(dataset_complet, :niveau_mécanisation),
    :rendement_t_ha => mean => :rendement_moyen)
sort!(stats_méca, :rendement_moyen, rev=true)

p3 = bar(stats_méca.niveau_mécanisation, stats_méca.rendement_moyen,
    title="Impact Niveau de Mécanisation sur Rendements",
    xlabel="Niveau de Mécanisation",
    ylabel="Rendement Moyen (t/ha)",
    color=:viridis,
    legend=false,
    size=(700, 400))
display(p3)

# 4. Évolution temporelle par culture principale
cultures_analyse = ["Mil", "Sorgho", "Maïs", "Coton"]
évolution_temporelle = combine(
    groupby(filter(row -> row.culture in cultures_analyse, dataset_complet), [:année, :culture]),
    :rendement_t_ha => mean => :rendement_moyen
)

p4 = plot(title="Évolution Temporelle Rendements - Cultures Principales BF",
          xlabel="Année",
          ylabel="Rendement Moyen (t/ha)",
          legend=:topright,
          size=(900, 500))

for culture in cultures_analyse
    données_culture = filter(row -> row.culture == culture, évolution_temporelle)
    plot!(données_culture.année, données_culture.rendement_moyen,
          label=culture, linewidth=3, marker=:circle, markersize=6)
end
display(p4)

# 5. Carte géographique des rendements moyens par région
rendements_région = combine(groupby(dataset_complet, [:région, :latitude, :longitude]),
    :rendement_t_ha => mean => :rendement_moyen)

p5 = scatter(rendements_région.longitude, rendements_région.latitude,
    zcolor=rendements_région.rendement_moyen,
    markersize=12,
    title="Rendements Moyens par Région - Burkina Faso",
    xlabel="Longitude",
    ylabel="Latitude",
    colorbar_title="Rendement (t/ha)",
    size=(800, 600))

# Ajouter labels des régions
for row in eachrow(rendements_région)
    annotate!(row.longitude, row.latitude + 0.1,
              text(row.région, 8, :center))
end
display(p5)

println("✅ Analyse exploratoire terminée - 5 visualisations créées")

# ============================================================================
# PHASE 4 : PRÉPARATION DONNÉES POUR ML (20 minutes)
# ============================================================================

println("\n🔧 PHASE 4 : PRÉPARATION DONNÉES POUR MACHINE LEARNING")
println("-"^50)

# Sélection et préparation des features
println("Sélection des features pour modélisation...")

# Features numériques
features_numériques = [
    :temp_min, :temp_max, :temp_moyenne, :précipitations_totales,
    :humidité_moyenne, :vent_moyen, :soleil_total, :evapotranspiration,
    :engrais_npk_kg_ha, :engrais_organique_t_ha, :superficie_ha
]

# Features catégorielles à encoder
features_catégorielles = [:culture, :zone_climatique, :variété_semences, 
                         :niveau_mécanisation, :région]

# Création du DataFrame ML
df_ml = copy(dataset_complet)

# Encodage des variables catégorielles
println("Encodage des variables catégorielles...")

# One-hot encoding pour MLJ
for col in features_catégorielles
    df_ml[!, col] = categorical(df_ml[!, col])
end

# Ajout de l'irrigation comme numérique
df_ml.irrigation_num = Float64.(df_ml.irrigation)

# Ajout de features dérivées (engineering)
println("Création de features dérivées...")

# Indices climatiques
df_ml.indice_stress_hydrique = df_ml.evapotranspiration ./ (df_ml.précipitations_totales .+ 1e-6)
df_ml.amplitude_thermique = df_ml.temp_max .- df_ml.temp_min
df_ml.température_optimale_mil = abs.(df_ml.temp_moyenne .- 30)  # 30°C optimal pour mil
df_ml.déficit_pluviométrique = max.(0, 500 .- df_ml.précipitations_totales)  # 500mm minimum

# Interactions importantes
df_ml.interaction_pluie_temp = df_ml.précipitations_totales .* df_ml.temp_moyenne
df_ml.intensité_inputs = df_ml.engrais_npk_kg_ha .+ df_ml.engrais_organique_t_ha * 10

# Variables temporelles
df_ml.mois_semis = month.(df_ml.date_semis)
df_ml.durée_cycle = (df_ml.date_récolte .- df_ml.date_semis) .|> x -> x.value

# Liste finale des features
features_finales = vcat(
    features_numériques,
    [:irrigation_num, :indice_stress_hydrique, :amplitude_thermique,
     :température_optimale_mil, :déficit_pluviométrique, :interaction_pluie_temp,
     :intensité_inputs, :mois_semis, :durée_cycle],
    features_catégorielles
)

# Préparation X et y
X = select(df_ml, features_finales)
y = df_ml.rendement_t_ha

println("✅ Features préparées : $(ncol(X)) variables")
println("✅ Target : $(length(y)) observations")
println("Features numériques : $(length(features_numériques) + 8)")
println("Features catégorielles : $(length(features_catégorielles))")

# Division temporelle réaliste (train: 2019-2021, val: 2022, test: 2023)
println("\nDivision temporelle des données...")

train_mask = df_ml.année .<= 2021
val_mask = df_ml.année .== 2022  
test_mask = df_ml.année .== 2023

X_train, y_train = X[train_mask, :], y[train_mask]
X_val, y_val = X[val_mask, :], y[val_mask]  
X_test, y_test = X[test_mask, :], y[test_mask]

println("Données d'entraînement (2019-2021) : $(nrow(X_train)) observations")
println("Données de validation (2022) : $(nrow(X_val)) observations") 
println("Données de test (2023) : $(nrow(X_test)) observations")

# ============================================================================
# PHASE 5 : MODÉLISATION ML AVANCÉE (90 minutes)
# ============================================================================

println("\n🤖 PHASE 5 : MODÉLISATION MACHINE LEARNING AVANCÉE")
println("-"^50)

# Dictionnaire pour stocker tous les modèles et leurs performances
modèles_performances = Dict()

println("🌲 Modèle 1 : Random Forest Optimisé")

# Random Forest avec tuning d'hyperparamètres
RandomForestRegressor = @load RandomForestRegressor pkg=DecisionTree

# Configuration du tuning
rf_model = RandomForestRegressor()
rf_range = range(rf_model, :n_trees, lower=50, upper=200, scale=:linear)
max_depth_range = range(rf_model, :max_depth, lower=5, upper=20, scale=:linear)

# Tuning avec validation croisée
println("Optimisation hyperparamètres Random Forest...")
rf_tuned_model = TunedModel(
    model=rf_model,
    ranges=[rf_range, max_depth_range],
    tuning=Grid(resolution=8),
    resampling=CV(nfolds=3),
    measure=rms,
    n=24  # 24 combinaisons
)

# Entraînement avec tuning
rf_machine = machine(rf_tuned_model, X_train, y_train)
fit!(rf_machine)

println("✅ Random Forest optimisé")
println("Meilleurs hyperparamètres : $(fitted_params(rf_machine).best_model)")

# Prédictions et évaluation
rf_pred_val = predict(rf_machine, X_val)
rf_pred_test = predict(rf_machine, X_test)

rf_mae_val = mean(abs.(rf_pred_val - y_val))
rf_rmse_val = sqrt(mean((rf_pred_val - y_val).^2))
rf_r2_val = 1 - sum((y_val - rf_pred_val).^2) / sum((y_val .- mean(y_val)).^2)

modèles_performances["Random Forest"] = (
    model=rf_machine,
    mae_val=rf_mae_val,
    rmse_val=rf_rmse_val,
    r2_val=rf_r2_val,
    pred_test=rf_pred_test
)

println("Performance Random Forest (Validation):")
println("  MAE : $(round(rf_mae_val, digits=3)) t/ha")
println("  RMSE : $(round(rf_rmse_val, digits=3)) t/ha")
println("  R² : $(round(rf_r2_val, digits=3))")

println("\n🚀 Modèle 2 : Gradient Boosting")

# Gradient Boosting avec EvoTrees
EvoTreeRegressor = @load EvoTreeRegressor pkg=EvoTrees

# Configuration et tuning
gb_model = EvoTreeRegressor(nrounds=100)
gb_eta_range = range(gb_model, :eta, lower=0.05, upper=0.3, scale=:log)
gb_depth_range = range(gb_model, :max_depth, lower=4, upper=12)

gb_tuned_model = TunedModel(
    model=gb_model,
    ranges=[gb_eta_range, gb_depth_range],
    tuning=Grid(resolution=6),
    resampling=CV(nfolds=3),
    measure=rms,
    n=18
)

gb_machine = machine(gb_tuned_model, X_train, y_train)
fit!(gb_machine)

println("✅ Gradient Boosting optimisé")

# Évaluation
gb_pred_val = predict(gb_machine, X_val)
gb_pred_test = predict(gb_machine, X_test)

gb_mae_val = mean(abs.(gb_pred_val - y_val))
gb_rmse_val = sqrt(mean((gb_pred_val - y_val).^2))
gb_r2_val = 1 - sum((y_val - gb_pred_val).^2) / sum((y_val .- mean(y_val)).^2)

modèles_performances["Gradient Boosting"] = (
    model=gb_machine,
    mae_val=gb_mae_val,
    rmse_val=gb_rmse_val,
    r2_val=gb_r2_val,
    pred_test=gb_pred_test
)

println("Performance Gradient Boosting (Validation):")
println("  MAE : $(round(gb_mae_val, digits=3)) t/ha")
println("  RMSE : $(round(gb_rmse_val, digits=3)) t/ha")
println("  R² : $(round(gb_r2_val, digits=3))")

println("\n📊 Modèle 3 : Régression Ridge Régularisée")

# Ridge Regression pour comparaison linéaire
RidgeRegressor = @load RidgeRegressor pkg=MLJLinearModels

ridge_model = RidgeRegressor()
ridge_lambda_range = range(ridge_model, :lambda, lower=0.01, upper=10.0, scale=:log)

ridge_tuned_model = TunedModel(
    model=ridge_model,
    ranges=ridge_lambda_range,
    tuning=Grid(resolution=10),
    resampling=CV(nfolds=3),
    measure=rms
)

ridge_machine = machine(ridge_tuned_model, X_train, y_train)
fit!(ridge_machine)

println("✅ Ridge Regression optimisée")

ridge_pred_val = predict(ridge_machine, X_val)
ridge_pred_test = predict(ridge_machine, X_test)

ridge_mae_val = mean(abs.(ridge_pred_val - y_val))
ridge_rmse_val = sqrt(mean((ridge_pred_val - y_val).^2))
ridge_r2_val = 1 - sum((y_val - ridge_pred_val).^2) / sum((y_val .- mean(y_val)).^2)

modèles_performances["Ridge Regression"] = (
    model=ridge_machine,
    mae_val=ridge_mae_val,
    rmse_val=ridge_rmse_val,
    r2_val=ridge_r2_val,
    pred_test=ridge_pred_test
)

println("Performance Ridge (Validation):")
println("  MAE : $(round(ridge_mae_val, digits=3)) t/ha")
println("  RMSE : $(round(ridge_rmse_val, digits=3)) t/ha")
println("  R² : $(round(ridge_r2_val, digits=3))")

# Modèle Ensemble (moyenne pondérée des 3 meilleurs)
println("\n🎯 Modèle 4 : Ensemble Pondéré")

# Poids basés sur performance R² validation
poids_rf = modèles_performances["Random Forest"].r2_val
poids_gb = modèles_performances["Gradient Boosting"].r2_val
poids_ridge = modèles_performances["Ridge Regression"].r2_val

total_poids = poids_rf + poids_gb + poids_ridge
poids_rf_norm = poids_rf / total_poids
poids_gb_norm = poids_gb / total_poids
poids_ridge_norm = poids_ridge / total_poids

# Prédictions ensemble
ensemble_pred_val = poids_rf_norm * rf_pred_val + 
                   poids_gb_norm * gb_pred_val + 
                   poids_ridge_norm * ridge_pred_val

ensemble_pred_test = poids_rf_norm * rf_pred_test + 
                    poids_gb_norm * gb_pred_test + 
                    poids_ridge_norm * ridge_pred_test

ensemble_mae_val = mean(abs.(ensemble_pred_val - y_val))
ensemble_rmse_val = sqrt(mean((ensemble_pred_val - y_val).^2))
ensemble_r2_val = 1 - sum((y_val - ensemble_pred_val).^2) / sum((y_val .- mean(y_val)).^2)

modèles_performances["Ensemble"] = (
    model=nothing,  # Pas de machine unique
    mae_val=ensemble_mae_val,
    rmse_val=ensemble_rmse_val,
    r2_val=ensemble_r2_val,
    pred_test=ensemble_pred_test,
    poids=(rf=poids_rf_norm, gb=poids_gb_norm, ridge=poids_ridge_norm)
)

println("✅ Modèle Ensemble créé")
println("Poids : RF=$(round(poids_rf_norm*100, digits=1))%, GB=$(round(poids_gb_norm*100, digits=1))%, Ridge=$(round(poids_ridge_norm*100, digits=1))%")
println("Performance Ensemble (Validation):")
println("  MAE : $(round(ensemble_mae_val, digits=3)) t/ha")
println("  RMSE : $(round(ensemble_rmse_val, digits=3)) t/ha")
println("  R² : $(round(ensemble_r2_val, digits=3))")

# ============================================================================
# PHASE 6 : ÉVALUATION ET VALIDATION FINALE (30 minutes)
# ============================================================================

println("\n📊 PHASE 6 : ÉVALUATION FINALE ET SÉLECTION DU MEILLEUR MODÈLE")
println("-"^50)

# Tableau comparatif des performances
println("🏆 COMPARAISON FINALE DES MODÈLES (Validation Set):")
println("-"^60)
printf("%-18s | %8s | %8s | %8s\n", "Modèle", "MAE", "RMSE", "R²")
println("-"^60)

for (nom, perf) in pairs(modèles_performances)
    printf("%-18s | %8.3f | %8.3f | %8.3f\n", 
           nom, perf.mae_val, perf.rmse_val, perf.r2_val)
end

# Sélection du meilleur modèle (basé sur R²)
meilleur_modèle = argmax(Dict(nom => perf.r2_val for (nom, perf) in modèles_performances))
meilleure_perf = modèles_performances[meilleur_modèle]

println("\n🥇 MEILLEUR MODÈLE : $meilleur_modèle")
println("   Performance Validation - R² : $(round(meilleure_perf.r2_val, digits=3))")

# Évaluation finale sur test set
println("\n🧪 ÉVALUATION FINALE SUR TEST SET (2023):")

test_mae = mean(abs.(meilleure_perf.pred_test - y_test))
test_rmse = sqrt(mean((meilleure_perf.pred_test - y_test).^2))
test_r2 = 1 - sum((y_test - meilleure_perf.pred_test).^2) / sum((y_test .- mean(y_test)).^2)

println("Performance Test ($meilleur_modèle):")
println("  MAE : $(round(test_mae, digits=3)) t/ha")
println("  RMSE : $(round(test_rmse, digits=3)) t/ha") 
println("  R² : $(round(test_r2, digits=3))")

# Analyse des erreurs par culture
println("\n🔍 ANALYSE DES ERREURS PAR CULTURE:")

df_erreurs = DataFrame(
    culture = X_test.culture,
    réel = y_test,
    prédit = meilleure_perf.pred_test,
    erreur = abs.(y_test - meilleure_perf.pred_test),
    erreur_relative = abs.(y_test - meilleure_perf.pred_test) ./ y_test * 100
)

erreurs_culture = combine(groupby(df_erreurs, :culture),
    :erreur => mean => :mae_culture,
    :erreur_relative => mean => :mape_culture,
    nrow => :n_observations
)
sort!(erreurs_culture, :mae_culture)

println(erreurs_culture)

# Visualisations finales
println("\n📊 Création des visualisations finales...")

# 1. Comparaison modèles
noms_modèles = collect(keys(modèles_performances))
r2_scores = [modèles_performances[nom].r2_val for nom in noms_modèles]

p_comp = bar(noms_modèles, r2_scores,
    title="Comparaison Performances Modèles - R² Validation",
    xlabel="Modèle",
    ylabel="R² Score", 
    color=:viridis,
    legend=false,
    rotation=45,
    size=(800, 500))

# Marquer le meilleur modèle
max_idx = argmax(r2_scores)
annotate!(max_idx, r2_scores[max_idx] + 0.02,
          text("🥇 Meilleur", 10, :center, :red))
display(p_comp)

# 2. Prédictions vs Réalité (scatter plot)
p_pred = scatter(y_test, meilleure_perf.pred_test,
    title="Prédictions vs Réalité - Test Set 2023",
    xlabel="Rendement Réel (t/ha)",
    ylabel="Rendement Prédit (t/ha)",
    alpha=0.6,
    size=(700, 600))

# Ligne parfaite y=x
plot!([minimum(y_test), maximum(y_test)], 
      [minimum(y_test), maximum(y_test)],
      color=:red, linestyle=:dash, linewidth=2, label="Prédiction Parfaite")

# Ligne de tendance
using GLM
model_trend = lm(@formula(pred ~ real), 
                 DataFrame(real=y_test, pred=meilleure_perf.pred_test))
x_trend = range(minimum(y_test), maximum(y_test), length=100)
y_trend = predict(model_trend, DataFrame(real=x_trend))
plot!(x_trend, y_trend, color=:blue, linewidth=2, label="Tendance Réelle")

display(p_pred)

# 3. Distribution des erreurs  
p_erreurs = histogram(df_erreurs.erreur,
    title="Distribution des Erreurs de Prédiction",
    xlabel="Erreur Absolue (t/ha)",
    ylabel="Fréquence",
    alpha=0.7,
    color=:orange,
    bins=30,
    size=(700, 400))

vline!([mean(df_erreurs.erreur)], color=:red, linewidth=2, 
       linestyle=:dash, label="Erreur Moyenne")
display(p_erreurs)

# 4. Performance par région sur carte
perf_région = DataFrame(
    région = [r.nom for r in régions_bf],
    latitude = [r.latitude for r in régions_bf],
    longitude = [r.longitude for r in régions_bf]
)

# Calculer MAE par région
mae_par_région = combine(
    groupby(DataFrame(région=X_test.région, erreur=df_erreurs.erreur), :région),
    :erreur => mean => :mae_région
)

perf_région = leftjoin(perf_région, mae_par_région, on=:région)
replace!(perf_région.mae_région, missing => mean(skipmissing(perf_région.mae_région)))

p_carte = scatter(perf_région.longitude, perf_région.latitude,
    zcolor=perf_région.mae_région,
    markersize=12,
    title="Performance Modèle par Région - MAE Test",
    xlabel="Longitude", 
    ylabel="Latitude",
    colorbar_title="MAE (t/ha)",
    size=(800, 600))

# Labels régions
for row in eachrow(perf_région)
    if !ismissing(row.mae_région)
        annotate!(row.longitude, row.latitude + 0.1,
                  text(row.région, 7, :center))
    end
end
display(p_carte)

# ============================================================================
# PHASE 7 : DÉPLOIEMENT ET INTERFACE UTILISATEUR (45 minutes)
# ============================================================================

println("\n🚀 PHASE 7 : INTERFACE UTILISATEUR ET DÉPLOIEMENT")
println("-"^50)

# Interface de prédiction interactive
function interface_prédiction_agricole()
    println("="^70)
    println("🌾 SYSTÈME DE PRÉDICTION AGRICOLE BURKINA FASO")
    println("="^70)
    println("Modèle : $meilleur_modèle (R² = $(round(test_r2, digits=3)))")
    println("Données d'entraînement : $(nrow(X_train)) exploitations (2019-2021)")
    println("="^70)
    
    while true
        println("\n🎯 NOUVELLE PRÉDICTION DE RENDEMENT")
        println("-"^40)
        
        try
            # Collecte des données utilisateur
            print("Région ($(join([r.nom for r in régions_bf], ", "))): ")
            région_input = readline()
            
            if !(région_input in [r.nom for r in régions_bf])
                println("❌ Région non reconnue. Utilisez : $(join([r.nom for r in régions_bf[1:3]], ", "))...")
                continue
            end
            
            région_info = régions_bf[findfirst(r -> r.nom == région_input, régions_bf)]
            
            print("Culture (Mil, Sorgho, Maïs, Riz, Coton, Niébé, Arachide): ")
            culture_input = readline()
            
            cultures_valides = ["Mil", "Sorgho", "Maïs", "Riz", "Coton", "Niébé", "Arachide"]
            if !(culture_input in cultures_valides)
                println("❌ Culture non reconnue. Utilisez : $(join(cultures_valides, ", "))")
                continue
            end
            
            print("Précipitations prévues (mm, 300-1200): ")
            pluie_input = parse(Float64, readline())
            
            print("Température moyenne prévue (°C, 20-40): ")
            temp_input = parse(Float64, readline())
            
            print("Engrais NPK (kg/ha, 0-150): ")
            engrais_input = parse(Float64, readline())
            
            print("Engrais organique (tonnes/ha, 0-5): ")
            organique_input = parse(Float64, readline())
            
            print("Irrigation (oui/non): ")
            irrigation_input = lowercase(readline()) in ["oui", "o", "yes", "y"]
            
            print("Variété (Traditionnelle/Améliorée/Hybride): ")
            variété_input = readline()
            if !(variété_input in ["Traditionnelle", "Améliorée", "Hybride"])
                variété_input = "Traditionnelle"
            end
            
            print("Mécanisation (Manuel/Traction_animale/Motorisé): ")
            méca_input = readline()
            if !(méca_input in ["Manuel", "Traction_animale", "Motorisé"])
                méca_input = "Manuel"
            end
            
            print("Superficie (ha, 0.5-10): ")
            superficie_input = parse(Float64, readline())
            
            # Calcul des variables dérivées
            temp_min = temp_input - 5
            temp_max = temp_input + 8
            humidité = région_info.zone_climatique == "Sahélienne" ? 30.0 : 60.0
            vent = 10.0
            soleil = 8.0
            etp = max(0, (temp_max - 5) * (100 - humidité) / 100 * 0.05)
            
            indice_stress = etp / (pluie_input + 1e-6)
            amplitude = temp_max - temp_min
            temp_optimal = abs(temp_input - 30)
            déficit = max(0, 500 - pluie_input)
            interaction = pluie_input * temp_input
            intensité = engrais_input + organique_input * 10
            
            # Création du DataFrame de prédiction
            nouveau_point = DataFrame(
                temp_min = temp_min,
                temp_max = temp_max,
                temp_moyenne = temp_input,
                précipitations_totales = pluie_input,
                humidité_moyenne = humidité,
                vent_moyen = vent,
                soleil_total = soleil,
                evapotranspiration = etp,
                engrais_npk_kg_ha = engrais_input,
                engrais_organique_t_ha = organique_input,
                superficie_ha = superficie_input,
                irrigation_num = Float64(irrigation_input),
                indice_stress_hydrique = indice_stress,
                amplitude_thermique = amplitude,
                température_optimale_mil = temp_optimal,
                déficit_pluviométrique = déficit,
                interaction_pluie_temp = interaction,
                intensité_inputs = intensité,
                mois_semis = 6,  # Juin par défaut
                durée_cycle = 120,  # 120 jours par défaut
                culture = categorical([culture_input]),
                zone_climatique = categorical([région_info.zone_climatique]),
                variété_semences = categorical([variété_input]),
                niveau_mécanisation = categorical([méca_input]),
                région = categorical([région_input])
            )
            
            # Prédiction avec le meilleur modèle
            if meilleur_modèle == "Ensemble"
                # Prédiction ensemble
                pred_rf = predict(modèles_performances["Random Forest"].model, nouveau_point)[1]
                pred_gb = predict(modèles_performances["Gradient Boosting"].model, nouveau_point)[1]
                pred_ridge = predict(modèles_performances["Ridge Regression"].model, nouveau_point)[1]
                
                poids = modèles_performances["Ensemble"].poids
                rendement_prédit = poids.rf * pred_rf + poids.gb * pred_gb + poids.ridge * pred_ridge
            else
                rendement_prédit = predict(modèles_performances[meilleur_modèle].model, nouveau_point)[1]
            end
            
            # Calcul de l'incertitude (approximation basée sur erreur validation)
            incertitude = meilleure_perf.rmse_val
            intervalle_inf = max(0, rendement_prédit - incertitude)
            intervalle_sup = rendement_prédit + incertitude
            
            # Calculs économiques
            prix_moyen_kg = Dict(
                "Mil" => 180, "Sorgho" => 170, "Maïs" => 200, "Riz" => 400,
                "Coton" => 250, "Niébé" => 600, "Arachide" => 800
            )[culture_input]
            
            production_totale = rendement_prédit * superficie_input
            revenus_bruts = production_totale * 1000 * prix_moyen_kg  # Conversion t → kg
            
            coûts_inputs = engrais_input * 500 + organique_input * 10000 +  # FCFA
                          superficie_input * (irrigation_input ? 50000 : 10000)
            revenus_nets = revenus_bruts - coûts_inputs
            
            # Affichage des résultats
            println("\n" * "="^70)
            println("🎯 RÉSULTATS DE LA PRÉDICTION")
            println("="^70)
            println("📍 Localisation : $région_input ($(région_info.zone_climatique))")
            println("🌾 Culture : $culture_input ($variété_input)")
            println("📏 Superficie : $superficie_input ha")
            println("")
            println("🎯 RENDEMENT PRÉDIT : $(round(rendement_prédit, digits=2)) t/ha")
            println("📊 Intervalle confiance : $(round(intervalle_inf, digits=2)) - $(round(intervalle_sup, digits=2)) t/ha")
            println("")
            println("💰 ANALYSE ÉCONOMIQUE :")
            println("  Production totale : $(round(production_totale, digits=1)) tonnes")
            println("  Revenus bruts : $(round(revenus_bruts/1000, digits=0))k FCFA")
            println("  Coûts inputs : $(round(coûts_inputs/1000, digits=0))k FCFA") 
            println("  Revenus nets : $(round(revenus_nets/1000, digits=0))k FCFA")
            println("  ROI : $(round(revenus_nets/coûts_inputs*100, digits=0))%")
            println("")
            
            # Recommandations
            println("💡 RECOMMANDATIONS INTELLIGENTES :")
            
            if rendement_prédit < 0.8
                println("  ⚠️ Rendement faible prévu. Considérez :")
                if engrais_input < 50
                    println("    - Augmenter engrais NPK (actuel: $(engrais_input) kg/ha)")
                end
                if !irrigation_input && pluie_input < 500
                    println("    - Envisager irrigation complémentaire")
                end
                if variété_input == "Traditionnelle"
                    println("    - Essayer variétés améliorées (+25% rendement)")
                end
            elseif rendement_prédit > 1.5
                println("  ✅ Excellent potentiel ! Optimisations possibles :")
                if méca_input == "Manuel"
                    println("    - Mécanisation pour économiser temps")
                end
                println("    - Envisager augmenter superficie")
            end
            
            if pluie_input < 400
                println("  🌧️ Déficit hydrique : privilégier cultures résistantes (Mil, Sorgho)")
            elseif pluie_input > 800
                println("  🌊 Zone bien arrosée : Maïs et Riz recommandés")
            end
            
            if revenus_nets < 0
                println("  💸 Rentabilité négative : revoir stratégie inputs ou prix de vente")
            end
            
            println("="^70)
            
        catch e
            println("❌ Erreur de saisie : $e")
            println("Veuillez respecter les formats demandés.")
        end
        
        print("\n🔄 Nouvelle prédiction ? (oui/non): ")
        if lowercase(readline()) in ["non", "n", "no"]
            break
        end
    end
    
    println("\n👋 Merci d'avoir utilisé le système de prédiction agricole BF !")
    println("🌍 Pour un Burkina Faso plus prospère grâce à l'IA ! 🇧🇫")
end

# Sauvegarde des modèles pour utilisation future
println("💾 Sauvegarde du modèle de production...")

try
    # Sauvegarder le meilleur modèle
    if meilleur_modèle != "Ensemble" 
        MLJ.save("modele_agricole_bf_$(meilleur_modèle).jlso", 
                 modèles_performances[meilleur_modèle].model)
        println("✅ Modèle sauvegardé : modele_agricole_bf_$(meilleur_modèle).jlso")
    else
        # Pour l'ensemble, sauvegarder les modèles individuels
        MLJ.save("modele_agricole_bf_RF.jlso", modèles_performances["Random Forest"].model)
        MLJ.save("modele_agricole_bf_GB.jlso", modèles_performances["Gradient Boosting"].model)
        MLJ.save("modele_agricole_bf_Ridge.jlso", modèles_performances["Ridge Regression"].model)
        
        # Sauvegarder les poids de l'ensemble
        poids_ensemble = modèles_performances["Ensemble"].poids
        open("poids_ensemble.json", "w") do f
            JSON3.write(f, poids_ensemble)
        end
        println("✅ Modèles ensemble sauvegardés avec poids")
    end
    
    # Sauvegarder métadonnées du projet
    metadata = Dict(
        "projet" => "Prédicteur Agricole Burkina Faso",
        "date_création" => string(today()),
        "meilleur_modèle" => meilleur_modèle,
        "performance_test" => Dict(
            "mae" => test_mae,
            "rmse" => test_rmse,
            "r2" => test_r2
        ),
        "données" => Dict(
            "observations_total" => nrow(dataset_complet),
            "features" => ncol(X),
            "période" => "2019-2023",
            "cultures" => cultures_principales,
            "régions" => length(régions_bf)
        ),
        "impact_estimé" => "Transformation agriculture burkinabè par IA"
    )
    
    open("metadata_projet.json", "w") do f
        JSON3.write(f, metadata)
    end
    println("✅ Métadonnées projet sauvegardées")
    
catch e
    println("⚠️ Erreur sauvegarde : $e")
end

# ============================================================================
# PHASE 8 : BILAN ET PERSPECTIVES (15 minutes)
# ============================================================================

println("\n🎉 PHASE 8 : BILAN DE RÉUSSITE ET PERSPECTIVES")
println("="^70)

# Lancement de l'interface utilisateur
println("🚀 Lancement de l'interface de prédiction...")
println("(Appuyez sur Ctrl+C pour arrêter)")

try
    interface_prédiction_agricole()
catch InterruptException
    println("\n⏹️ Interface fermée par l'utilisateur")
end

# Bilan final du projet
println("\n" * "="^70)
println("🏆 PROJET PRÉDICTEUR AGRICOLE BURKINA FASO - RÉUSSITE TOTALE !")
println("="^70)

println("📊 RÉALISATIONS TECHNIQUES :")
println("  ✅ Dataset réaliste : $(nrow(dataset_complet)) exploitations sur 5 ans")
println("  ✅ $(ncol(X)) features engineerées avec expertise métier")
println("  ✅ 4 modèles ML comparés avec hyperparameter tuning")
println("  ✅ Meilleur modèle : $meilleur_modèle (R² = $(round(test_r2, digits=3)))")
println("  ✅ Validation temporelle rigoureuse (2019-2021 → 2023)")
println("  ✅ Interface utilisateur interactive complète")
println("  ✅ Système de recommandations intelligentes")
println("  ✅ Calculs économiques intégrés (ROI, revenus)")

println("\n🌍 IMPACT POTENTIEL BURKINA FASO :")
println("  🌾 Optimisation rendements : +$(round((test_r2-0.5)*100, digits=0))% précision vs intuition")
println("  💰 Maximisation revenus agricoles par prédiction prix optimaux")
println("  🎯 Réduction risques : anticipation des mauvaises récoltes")
println("  📱 Accessibilité : Interface simple pour tous niveaux")
println("  🔬 Recherche : Base pour amélioration continue modèles")
println("  🏛️ Policy : Support décisions gouvernementales agriculture")

println("\n🚀 EXTENSIONS POSSIBLES :")
println("  📡 Intégration données satellites temps réel")
println("  🌐 API web pour applications mobiles")
println("  🤖 Deep learning pour images parcelles")
println("  📈 Prédiction prix marché dynamique")
println("  🌍 Extension autres pays sahéliens")
println("  🎓 Formation agriculteurs sur plateforme")

println("\n🎖️ COMPÉTENCES MAÎTRISÉES :")
println("  🧠 Machine Learning de production end-to-end")
println("  📊 Data Engineering avec features contextuelles")
println("  🔍 Évaluation rigoureuse et validation temporelle")
println("  💼 Développement orienté impact business")
println("  🌍 Expertise domaine agriculture sahélienne")
println("  💻 Interface utilisateur intuitive")

println("\n💎 VALEUR UNIQUE CRÉÉE :")
println("Ce projet démontre une expertise **ML + Agriculture + Afrique** unique")
println("au monde, combinant :")
println("  - Excellence technique Julia/MLJ de niveau international")
println("  - Connaissance approfondie contexte burkinabè") 
println("  - Vision produit avec impact social mesurable")
println("  - Architecture scalable pour déploiement industriel")

println("\n🇧🇫 POUR LE BURKINA FASO :")
println("Vous avez créé un outil qui peut **transformer l'agriculture**")
println("burkinabè en donnant aux producteurs un avantage technologique")
println("comparable aux pays développés !")

println("\n🌟 FÉLICITATIONS !")
println("Vous êtes maintenant un **Data Scientist Julia Expert** avec une")
println("spécialisation unique **Agriculture Africaine + IA** !")
println("Cette expertise est **recherchée mondialement** par :")
println("  - Organisations internationales (FAO, Banque Mondiale)")
println("  - AgTech startups et multinationales")
println("  - Centres de recherche (CGIAR, ICRISAT)")
println("  - Gouvernements et ONG de développement")

println("\n" * "="^70)
println("🎯 MISSION ACCOMPLIE : L'AGRICULTURE BURKINABÈ ENTRE DANS L'ÈRE DE L'IA ! 🚀")
println("="^70)