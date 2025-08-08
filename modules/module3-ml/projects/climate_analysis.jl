# Projet Final 2 : Analyse Climatique Sahel
# Module 3 : Apprentissage Automatique avec Julia  
# Durée : 3 heures | Difficulté : Expert | Impact : 🌍 Adaptation Climatique

# 📚 AVANT DE COMMENCER
# Lisez le résumé de projet : resume_projet_climat.md
# Ce projet applique l'IA à l'adaptation au changement climatique !

println("📚 Consultez le résumé : modules/module3-ml/resume_projet_climat.md")
println("Appuyez sur Entrée quand vous êtes prêt pour l'analyse climatique...")
readline()

println("🌡️🚀 ANALYSE CLIMATIQUE SAHÉLIENNE - PROJET FINAL")
println("="^70)
println("🎯 Mission : Créer un système d'analyse climatique prédictive")
println("   pour l'adaptation aux changements climatiques au Sahel !")
println("="^70)

# ============================================================================
# PHASE 1 : ARCHITECTURE CLIMATIQUE ET CONFIGURATION (25 minutes)
# ============================================================================

println("\n🌍 PHASE 1 : ARCHITECTURE SYSTÈME CLIMATIQUE")
println("-"^50)

# Environnement scientifique complet
using DataFrames, CSV, Statistics, Random
using Plots, StatsPlots, PlotlyJS
using Dates, TimeZones
using MLJ, MLJModels
using DSP, FFTW  # Analyse de signaux climatiques
using Clustering, MultivariateStats  # Analyse patterns
using JSON3, FileIO
using LinearAlgebra, StatsBase
using ProgressMeter

# Configuration scientifique
Random.seed!(2024)
plotlyjs()
theme(:bright)

println("✅ Environnement analyse climatique configuré")

# Structures de données climatiques spécialisées
@kwdef struct StationMétéo
    nom::String
    code::String
    latitude::Float64
    longitude::Float64
    altitude_m::Int
    zone_climatique::String  # "Sahélienne", "Soudano-Sahélienne", "Soudanienne"
    type_station::String     # "Principale", "Secondaire", "Automatique"
    date_installation::Date
    actif::Bool
end

@kwdef struct ObservationClimatique
    station_code::String
    date::Date
    température_min_c::Float64
    température_max_c::Float64
    température_moy_c::Float64
    précipitations_mm::Float64
    humidité_relative_pct::Float64
    pression_hpa::Float64
    vitesse_vent_ms::Float64
    direction_vent_deg::Float64
    rayonnement_solaire_mjm2::Float64
    évapotranspiration_mm::Float64
    indice_aridité::Float64
end

@kwdef struct IndicateursClimatiques
    station::String
    année::Int
    
    # Température
    temp_moyenne_annuelle::Float64
    temp_max_absolue::Float64
    temp_min_absolue::Float64
    amplitude_thermique::Float64
    jours_chaleur_extrême::Int  # >40°C
    jours_gel::Int  # <0°C
    
    # Précipitations  
    précip_totale_annuelle::Float64
    précip_saison_pluies::Float64  # Juin-Septembre
    précip_max_journalière::Float64
    jours_pluie::Int
    jours_pluie_intense::Int  # >20mm
    début_saison_pluies::Date
    fin_saison_pluies::Date
    durée_saison_pluies::Int
    
    # Sécheresse
    jours_sans_pluie_consécutifs_max::Int
    déficit_hydrique_mm::Float64
    indice_sécheresse_palmer::Float64
    
    # Extrêmes
    nb_événements_extrêmes::Int
    indice_vulnérabilité::Float64
end

println("✅ Structures climatiques sahéliennes définies")

# Création du réseau de stations météorologiques réaliste
println("\n🌐 Création du réseau de stations météorologiques...")

stations_météo = [
    # Stations principales (données historiques longues)
    StationMétéo(
        nom="Ouagadougou Aéroport",
        code="BF001",
        latitude=12.3533, longitude=-1.5242,
        altitude_m=306,
        zone_climatique="Soudano-Sahélienne",
        type_station="Principale",
        date_installation=Date(1961, 1, 1),
        actif=true
    ),
    StationMétéo(
        nom="Bobo-Dioulasso",
        code="BF002", 
        latitude=11.1609, longitude=-4.3147,
        altitude_m=461,
        zone_climatique="Soudanienne",
        type_station="Principale",
        date_installation=Date(1956, 1, 1),
        actif=true
    ),
    StationMétéo(
        nom="Dori",
        code="BF003",
        latitude=14.0354, longitude=-0.0347,
        altitude_m=277,
        zone_climatique="Sahélienne", 
        type_station="Principale",
        date_installation=Date(1965, 1, 1),
        actif=true
    ),
    StationMétéo(
        nom="Gaoua",
        code="BF004",
        latitude=10.3341, longitude=-3.1816,
        altitude_m=336,
        zone_climatique="Soudanienne",
        type_station="Principale",
        date_installation=Date(1971, 1, 1),
        actif=true
    ),
    StationMétéo(
        nom="Fada N'Gourma",
        code="BF005",
        latitude=12.0614, longitude=0.3648,
        altitude_m=292,
        zone_climatique="Soudano-Sahélienne",
        type_station="Secondaire",
        date_installation=Date(1978, 1, 1),
        actif=true
    ),
    StationMétéo(
        nom="Koudougou",
        code="BF006",
        latitude=12.2530, longitude=-2.3622,
        altitude_m=274,
        zone_climatique="Soudano-Sahélienne",
        type_station="Secondaire", 
        date_installation=Date(1980, 1, 1),
        actif=true
    ),
    StationMétéo(
        nom="Banfora",
        code="BF007",
        latitude=10.6333, longitude=-4.7500,
        altitude_m=271,
        zone_climatique="Soudanienne",
        type_station="Secondaire",
        date_installation=Date(1985, 1, 1),
        actif=true
    ),
    StationMétéo(
        nom="Djibo",
        code="BF008",
        latitude=14.1025, longitude=-1.6278,
        altitude_m=286,
        zone_climatique="Sahélienne",
        type_station="Secondaire",
        date_installation=Date(1990, 1, 1),
        actif=true
    ),
    StationMétéo(
        nom="Tenkodogo", 
        code="BF009",
        latitude=11.7833, longitude=-0.3700,
        altitude_m=281,
        zone_climatique="Soudano-Sahélienne",
        type_station="Automatique",
        date_installation=Date(2005, 1, 1),
        actif=true
    ),
    StationMétéo(
        nom="Manga",
        code="BF010",
        latitude=11.6647, longitude=-1.0775,
        altitude_m=295,
        zone_climatique="Soudano-Sahélienne",
        type_station="Automatique",
        date_installation=Date(2010, 1, 1),
        actif=true
    )
]

println("✅ Réseau de $(length(stations_météo)) stations météorologiques créé")

# ============================================================================
# PHASE 2 : GÉNÉRATION DONNÉES CLIMATIQUES HISTORIQUES (35 minutes)
# ============================================================================

println("\n📊 PHASE 2 : GÉNÉRATION DONNÉES CLIMATIQUES HISTORIQUES")
println("-"^50)

# Fonction de génération de données climatiques réalistes avec tendances
function générer_série_climatique_réaliste(station::StationMétéo, années::UnitRange{Int})
    observations = ObservationClimatique[]
    
    println("Génération série climatique $(station.nom) ($(length(années)) années)...")
    
    @showprogress for année in années
        for jour in 1:365  # Simplification : 365 jours par an
            try
                date = Date(année, 1, 1) + Day(jour - 1)
                jour_année = dayofyear(date)
                mois = month(date)
                
                # Tendance climatique à long terme (réchauffement)
                tendance_temp = (année - 1980) * 0.015  # +1.5°C par décennie depuis 1980
                tendance_précip = (année - 1980) * -0.5  # -5mm par décennie
                
                # Température de base selon zone climatique et altitude
                temp_base = Dict(
                    "Sahélienne" => 30.0,
                    "Soudano-Sahélienne" => 28.0,
                    "Soudanienne" => 26.0
                )[station.zone_climatique]
                
                # Correction altitudinale (-0.6°C par 100m)
                temp_base -= (station.altitude_m - 300) * 0.006
                
                # Cycle saisonnier réaliste
                temp_saisonnière = temp_base + tendance_temp + 
                                 12 * sin(2π * (jour_année - 80) / 365)  # Peak avril
                
                # Variabilité quotidienne et année El Niño/La Niña
                variabilité_interannuelle = sin(2π * année / 7) * 2  # Cycle ~7 ans
                temp_moy = temp_saisonnière + variabilité_interannuelle + randn() * 2
                
                # Amplitude diurne selon saison et zone
                amplitude_diurne = station.zone_climatique == "Sahélienne" ? 
                                 15 + 5 * sin(2π * jour_année / 365) :  # Sahel: 10-20°C
                                 12 + 3 * sin(2π * jour_année / 365)   # Sud: 9-15°C
                
                temp_max = temp_moy + amplitude_diurne / 2 + rand() * 3
                temp_min = temp_moy - amplitude_diurne / 2 - rand() * 3
                
                # Précipitations : pattern sahélien réaliste
                précip_base = Dict(
                    "Sahélienne" => 300,
                    "Soudano-Sahélienne" => 700,
                    "Soudanienne" => 1100
                )[station.zone_climatique]
                
                précip_annuelle = précip_base + tendance_précip + 
                                variabilité_interannuelle * 50
                
                if mois in [6, 7, 8, 9]  # Saison des pluies
                    # Distribution gamma réaliste des pluies
                    prob_pluie = mois in [7, 8] ? 0.4 : 0.25
                    
                    if rand() < prob_pluie
                        # Intensité selon distribution observée
                        if rand() < 0.6  # 60% pluies faibles
                            intensité = abs(randn()) * 5 + 2  # 2-10mm
                        elseif rand() < 0.9  # 30% pluies modérées  
                            intensité = abs(randn()) * 15 + 10  # 10-40mm
                        else  # 10% pluies intenses
                            intensité = abs(randn()) * 30 + 40  # 40-100mm
                        end
                        précip = min(intensité, 150)  # Cap réaliste
                    else
                        précip = 0.0
                    end
                    
                    # Ajustement facteur mensuel
                    facteur_mensuel = Dict(6 => 0.6, 7 => 1.2, 8 => 1.3, 9 => 0.8)[mois]
                    précip *= facteur_mensuel
                    
                elseif mois in [5, 10]  # Début/fin saison
                    précip = rand() < 0.1 ? abs(randn()) * 15 : 0.0
                else  # Saison sèche
                    précip = rand() < 0.02 ? abs(randn()) * 5 : 0.0  # Pluies rares
                end
                
                # Variables dérivées réalistes
                # Humidité relative (anticorrélée avec température)
                humidité_base = station.zone_climatique == "Sahélienne" ? 35 : 55
                humidité = humidité_base + (précip > 0 ? 20 : 0) - 
                          (temp_max - 25) * 0.5 + randn() * 8
                humidité = clamp(humidité, 10, 95)
                
                # Pression atmosphérique (effet altitude + météo)
                pression_base = 1013 - station.altitude_m * 0.12  # hPa
                pression = pression_base + randn() * 5  # Variabilité météo
                
                # Vent (plus fort en saison sèche)
                vent_base = mois in [11, 12, 1, 2, 3] ? 4.5 : 2.5  # m/s
                vent = vent_base + abs(randn()) * 2
                direction_vent = rand(0:359)  # Direction aléatoire
                
                # Rayonnement solaire (fonction nébulosité estimée)
                rayonnement_max = 25 - 5 * sin(2π * (jour_année - 172) / 365)  # MJ/m²
                nébulosité = précip > 5 ? 0.7 : 0.2  # Couverture nuageuse
                rayonnement = rayonnement_max * (1 - nébulosité) + randn() * 2
                rayonnement = max(5, rayonnement)
                
                # Évapotranspiration (Penman-Monteith simplifié)
                delta_t = temp_max - temp_min
                etp = 0.0023 * (temp_moy + 17.8) * sqrt(delta_t) * 
                      (rayonnement / 2.45) * (1 + vent / 10)
                etp = max(0, etp)
                
                # Indice d'aridité de De Martonne
                indice_aridité = précip / (temp_moy + 10)
                
                # Créer observation
                obs = ObservationClimatique(
                    station_code=station.code,
                    date=date,
                    température_min_c=temp_min,
                    température_max_c=temp_max,
                    température_moy_c=(temp_min + temp_max) / 2,
                    précipitations_mm=précip,
                    humidité_relative_pct=humidité,
                    pression_hpa=pression,
                    vitesse_vent_ms=vent,
                    direction_vent_deg=direction_vent,
                    rayonnement_solaire_mjm2=rayonnement,
                    évapotranspiration_mm=etp,
                    indice_aridité=indice_aridité
                )
                
                push!(observations, obs)
                
            catch e
                # Gérer les dates invalides (29 février années non bissextiles)
                continue
            end
        end
    end
    
    return observations
end

# Génération du dataset climatique complet (1990-2023)
println("Génération des séries climatiques historiques...")

années_analyse = 1990:2023
dataset_climatique = DataFrame()

@showprogress "Stations climatiques..." for station in stations_météo[1:6]  # 6 stations principales
    # Générer données selon ancienneté station
    années_station = max(year(station.date_installation), 1990):2023
    
    observations_station = générer_série_climatique_réaliste(station, années_station)
    
    # Convertir en DataFrame
    for obs in observations_station
        push!(dataset_climatique, (
            station_code=obs.station_code,
            station_nom=station.nom,
            zone_climatique=station.zone_climatique,
            latitude=station.latitude,
            longitude=station.longitude,
            altitude=station.altitude_m,
            date=obs.date,
            année=year(obs.date),
            mois=month(obs.date),
            jour_année=dayofyear(obs.date),
            temp_min=obs.température_min_c,
            temp_max=obs.température_max_c,
            temp_moy=obs.température_moy_c,
            précip=obs.précipitations_mm,
            humidité=obs.humidité_relative_pct,
            pression=obs.pression_hpa,
            vent=obs.vitesse_vent_ms,
            direction_vent=obs.direction_vent_deg,
            rayonnement=obs.rayonnement_solaire_mjm2,
            etp=obs.évapotranspiration_mm,
            indice_aridité=obs.indice_aridité
        ))
    end
end

println("✅ Dataset climatique généré : $(nrow(dataset_climatique)) observations")
println("Période : $(minimum(dataset_climatique.année)) - $(maximum(dataset_climatique.année))")
println("Stations : $(length(unique(dataset_climatique.station_code)))")

# ============================================================================
# PHASE 3 : ANALYSE EXPLORATOIRE CLIMATIQUE (30 minutes)
# ============================================================================

println("\n🌡️ PHASE 3 : ANALYSE EXPLORATOIRE CLIMATIQUE SAHÉLIENNE")
println("-"^50)

# Statistiques climatiques générales
println("📈 Statistiques climatiques générales :")
stats_climat = describe(dataset_climatique[!, [:temp_moy, :précip, :humidité, :etp]])
println(stats_climat)

# Tendances par zone climatique
println("\n🌍 Comparaison par zone climatique :")
stats_zones = combine(groupby(dataset_climatique, :zone_climatique),
    :temp_moy => mean => :temp_moyenne,
    :précip => sum => :précip_totale,
    :etp => sum => :etp_totale,
    :indice_aridité => mean => :aridité_moyenne
)
sort!(stats_zones, :temp_moyenne, rev=true)
println(stats_zones)

# Analyses temporelles avancées
println("\n📊 Analyse des tendances temporelles...")

# 1. Tendances annuelles par station
tendances_annuelles = combine(
    groupby(dataset_climatique, [:station_code, :station_nom, :zone_climatique, :année]),
    :temp_moy => mean => :temp_annuelle,
    :précip => sum => :précip_annuelle,
    :etp => sum => :etp_annuelle
)

# 2. Évolution température par zone
évol_temp_zone = combine(
    groupby(tendances_annuelles, [:zone_climatique, :année]),
    :temp_annuelle => mean => :temp_moy_zone
)

# Visualisation 1 : Évolution température par zone climatique
p1 = plot(title="Évolution Température par Zone Climatique - Sahel",
          xlabel="Année", ylabel="Température Moyenne (°C)",
          legend=:topleft, size=(900, 500))

zones = unique(évol_temp_zone.zone_climatique)
couleurs = [:red, :orange, :green]

for (i, zone) in enumerate(zones)
    données_zone = filter(row -> row.zone_climatique == zone, évol_temp_zone)
    plot!(données_zone.année, données_zone.temp_moy_zone,
          label=zone, color=couleurs[i], linewidth=3, marker=:circle)
    
    # Ligne de tendance
    if nrow(données_zone) > 5
        using GLM
        model_trend = lm(@formula(temp ~ année), 
                        DataFrame(temp=données_zone.temp_moy_zone, 
                                année=données_zone.année))
        y_trend = predict(model_trend, DataFrame(année=données_zone.année))
        plot!(données_zone.année, y_trend, 
              color=couleurs[i], linestyle=:dash, alpha=0.7, label="")
    end
end

display(p1)

# Visualisation 2 : Précipitations annuelles avec variabilité
évol_précip = combine(
    groupby(tendances_annuelles, [:zone_climatique, :année]),
    :précip_annuelle => mean => :précip_moy,
    :précip_annuelle => std => :précip_std
)

p2 = plot(title="Précipitations Annuelles avec Variabilité - Sahel",
          xlabel="Année", ylabel="Précipitations (mm)",
          legend=:topright, size=(900, 500))

for (i, zone) in enumerate(zones)
    données_zone = filter(row -> row.zone_climatique == zone, évol_précip)
    
    # Remplacer missing par 0 pour std
    données_zone.précip_std = coalesce.(données_zone.précip_std, 0)
    
    plot!(données_zone.année, données_zone.précip_moy,
          ribbon=données_zone.précip_std,
          label=zone, color=couleurs[i], alpha=0.3,
          linewidth=2, marker=:circle, markersize=3)
end

display(p2)

# Visualisation 3 : Cycle saisonnier moyen par zone
cycle_saisonnier = combine(
    groupby(dataset_climatique, [:zone_climatique, :mois]),
    :temp_moy => mean => :temp_mensuelle,
    :précip => mean => :précip_mensuelle
)

p3 = plot(title="Cycles Saisonniers - Température et Précipitations",
          layout=(2, 1), size=(900, 800))

# Température
for (i, zone) in enumerate(zones)
    données_zone = filter(row -> row.zone_climatique == zone, cycle_saisonnier)
    sort!(données_zone, :mois)
    
    plot!(données_zone.mois, données_zone.temp_mensuelle,
          subplot=1, label=zone, color=couleurs[i], linewidth=3,
          ylabel="Température (°C)", marker=:circle)
end

# Précipitations  
for (i, zone) in enumerate(zones)
    données_zone = filter(row -> row.zone_climatique == zone, cycle_saisonnier)
    sort!(données_zone, :mois)
    
    plot!(données_zone.mois, données_zone.précip_mensuelle,
          subplot=2, label="", color=couleurs[i], linewidth=3,
          xlabel="Mois", ylabel="Précipitations (mm)",
          xticks=(1:12, ["J","F","M","A","M","J","J","A","S","O","N","D"]))
end

display(p3)

# Visualisation 4 : Carte climatique du Burkina Faso
moyennes_station = combine(
    groupby(dataset_climatique, [:station_code, :station_nom, :latitude, :longitude, :zone_climatique]),
    :temp_moy => mean => :temp_moy_station,
    :précip => (x -> sum(x) / length(unique(dataset_climatique[dataset_climatique.station_code .== first(x), :année]))) => :précip_annuelle_moy
)

p4 = scatter(moyennes_station.longitude, moyennes_station.latitude,
    zcolor=moyennes_station.temp_moy_station,
    markersize=sqrt.(moyennes_station.précip_annuelle_moy / 50),
    title="Carte Climatique Burkina Faso - Température et Précipitations",
    xlabel="Longitude", ylabel="Latitude",
    colorbar_title="Température Moyenne (°C)",
    size=(800, 600))

# Labels stations
for row in eachrow(moyennes_station)
    annotate!(row.longitude, row.latitude + 0.1,
              text(split(row.station_nom, " ")[1], 8, :center))
end

# Légende taille = précipitations
annotate!(-4.5, 13.8, text("Taille ∝ Précipitations", 10, :left))

display(p4)

# Visualisation 5 : Matrice de corrélation variables climatiques
variables_corr = [:temp_moy, :précip, :humidité, :pression, :vent, :rayonnement, :etp, :indice_aridité]
n_vars = length(variables_corr)
matrice_corr = zeros(n_vars, n_vars)

# Calculer corrélations sur échantillon (performance)
échantillon = dataset_climatique[1:10000, :]  # 10k observations

for i in 1:n_vars, j in 1:n_vars
    matrice_corr[i,j] = cor(échantillon[!, variables_corr[i]], 
                           échantillon[!, variables_corr[j]])
end

labels_corr = ["Temp", "Précip", "Humid", "Press", "Vent", "Rayon", "ETP", "Arid"]
p5 = heatmap(labels_corr, labels_corr, matrice_corr,
    title="Matrice Corrélations Variables Climatiques",
    color=:RdBu_r, aspect_ratio=1, size=(600, 600))

# Ajouter valeurs
for i in 1:n_vars, j in 1:n_vars
    annotate!(i, j, text(round(matrice_corr[i,j], digits=2), 
                        9, :center, :white))
end

display(p5)

println("✅ Analyse exploratoire terminée - 5 visualisations créées")

# ============================================================================
# PHASE 4 : DÉTECTION ÉVÉNEMENTS EXTRÊMES (25 minutes)
# ============================================================================

println("\n⚠️ PHASE 4 : DÉTECTION D'ÉVÉNEMENTS CLIMATIQUES EXTRÊMES")
println("-"^50)

# Fonction de détection d'événements extrêmes
function détecter_événements_extrêmes(df::DataFrame, station_code::String)
    données_station = filter(row -> row.station_code == station_code, df)
    
    if nrow(données_station) < 100
        return DataFrame()  # Pas assez de données
    end
    
    événements = DataFrame()
    
    # 1. Vagues de chaleur (3+ jours consécutifs > percentile 95)
    seuil_chaleur = quantile(données_station.temp_max, 0.95)
    
    jours_chauds = données_station.temp_max .> seuil_chaleur
    séquences_chaleur = []
    début_séquence = nothing
    
    for (i, chaud) in enumerate(jours_chauds)
        if chaud && début_séquence === nothing
            début_séquence = i
        elseif !chaud && début_séquence !== nothing
            if i - début_séquence >= 3  # Au moins 3 jours
                push!(séquences_chaleur, (début_séquence, i-1))
            end
            début_séquence = nothing
        end
    end
    
    # Dernière séquence si elle va jusqu'à la fin
    if début_séquence !== nothing && length(jours_chauds) - début_séquence >= 2
        push!(séquences_chaleur, (début_séquence, length(jours_chauds)))
    end
    
    for (début, fin) in séquences_chaleur
        push!(événements, (
            station_code = station_code,
            type_événement = "Vague de chaleur",
            date_début = données_station[début, :date],
            date_fin = données_station[fin, :date],
            durée_jours = fin - début + 1,
            intensité = mean(données_station[début:fin, :temp_max]),
            impact_estimé = "Élevé"
        ))
    end
    
    # 2. Sécheresses (30+ jours consécutifs sans pluie significative)
    jours_secs = données_station.précip .< 1.0
    séquences_sèches = []
    début_sèche = nothing
    
    for (i, sec) in enumerate(jours_secs)
        if sec && début_sèche === nothing
            début_sèche = i
        elseif !sec && début_sèche !== nothing
            if i - début_sèche >= 30  # Au moins 30 jours
                push!(séquences_sèches, (début_sèche, i-1))
            end
            début_sèche = nothing
        end
    end
    
    if début_sèche !== nothing && length(jours_secs) - début_sèche >= 29
        push!(séquences_sèches, (début_sèche, length(jours_secs)))
    end
    
    for (début, fin) in séquences_sèches
        push!(événements, (
            station_code = station_code,
            type_événement = "Sécheresse",
            date_début = données_station[début, :date],
            date_fin = données_station[fin, :date],
            durée_jours = fin - début + 1,
            intensité = mean(données_station[début:fin, :temp_moy]),
            impact_estimé = "Très élevé"
        ))
    end
    
    # 3. Pluies intenses (> percentile 99)
    seuil_pluie_intense = quantile(filter(x -> x > 0, données_station.précip), 0.99)
    
    jours_pluie_intense = findall(données_station.précip .> seuil_pluie_intense)
    
    for jour in jours_pluie_intense
        push!(événements, (
            station_code = station_code,
            type_événement = "Pluie intense",
            date_début = données_station[jour, :date],
            date_fin = données_station[jour, :date],
            durée_jours = 1,
            intensité = données_station[jour, :précip],
            impact_estimé = "Modéré"
        ))
    end
    
    return événements
end

# Détection événements pour toutes les stations
println("Détection des événements extrêmes...")

tous_événements = DataFrame()
stations_codes = unique(dataset_climatique.station_code)

@showprogress "Détection événements..." for station_code in stations_codes
    événements_station = détecter_événements_extrêmes(dataset_climatique, station_code)
    if nrow(événements_station) > 0
        tous_événements = vcat(tous_événements, événements_station)
    end
end

println("✅ $(nrow(tous_événements)) événements extrêmes détectés")

# Statistiques événements
println("\n📊 Statistiques événements extrêmes :")
stats_événements = combine(groupby(tous_événements, :type_événement),
    nrow => :nb_événements,
    :durée_jours => mean => :durée_moyenne,
    :durée_jours => maximum => :durée_max
)
println(stats_événements)

# Événements par année
évol_événements = combine(
    groupby(tous_événements, [groupby(tous_événements, :date_début) |> x -> year.(x.date_début), :type_événement]),
    nrow => :nb_événements_année
)

rename!(évol_événements, :x1 => :année)

# Visualisation évolution événements extrêmes
p_événements = plot(title="Évolution Événements Climatiques Extrêmes - Sahel",
                   xlabel="Année", ylabel="Nombre d'Événements",
                   legend=:topleft, size=(900, 500))

types_événements = unique(évol_événements.type_événement)
couleurs_événements = [:red, :brown, :blue]

for (i, type_evt) in enumerate(types_événements)
    données_type = filter(row -> row.type_événement == type_evt, évol_événements)
    
    # Créer série complète avec 0 pour années manquantes
    années_complètes = 1990:2023
    série_complète = DataFrame(année = collect(années_complètes))
    données_type_complète = leftjoin(série_complète, données_type, on=:année)
    replace!(données_type_complète.nb_événements_année, missing => 0)
    
    plot!(données_type_complète.année, données_type_complète.nb_événements_année,
          label=type_evt, color=couleurs_événements[i], 
          linewidth=2, marker=:circle, markersize=4)
end

display(p_événements)

println("✅ Analyse événements extrêmes terminée")

# ============================================================================
# PHASE 5 : MODÉLISATION PRÉDICTIVE CLIMATIQUE (35 minutes)
# ============================================================================

println("\n🤖 PHASE 5 : MODÉLISATION PRÉDICTIVE CLIMATIQUE")
println("-"^50)

# Préparation données pour prédiction de température future
println("Préparation des données pour modélisation prédictive...")

# Agrégation mensuelle pour analyse de séries temporelles
données_mensuelles = combine(
    groupby(dataset_climatique, [:station_code, :station_nom, :zone_climatique, :année, :mois]),
    :temp_moy => mean => :temp_mensuelle,
    :précip => sum => :précip_mensuelle,
    :humidité => mean => :humidité_mensuelle,
    :etp => sum => :etp_mensuelle
)

# Créer features temporelles pour ML
println("Création des features temporelles...")

# Fonction pour créer features de séries temporelles
function créer_features_temporelles(df::DataFrame, station_code::String, target::Symbol, lags::Vector{Int})
    données_station = filter(row -> row.station_code == station_code, df)
    sort!(données_station, [:année, :mois])
    
    if nrow(données_station) < maximum(lags) + 12
        return DataFrame()  # Pas assez de données
    end
    
    # Créer une série temporelle continue
    df_features = copy(données_station)
    
    # Features de lag (valeurs passées)
    for lag in lags
        nom_feature = Symbol("$(target)_lag_$(lag)")
        df_features[!, nom_feature] = [missing; données_station[1:end-lag, target]]
    end
    
    # Moyennes mobiles
    for window in [3, 6, 12]
        nom_feature = Symbol("$(target)_ma_$(window)")
        valeurs_ma = []
        
        for i in 1:nrow(données_station)
            if i >= window
                push!(valeurs_ma, mean(données_station[i-window+1:i, target]))
            else
                push!(valeurs_ma, missing)
            end
        end
        df_features[!, nom_feature] = valeurs_ma
    end
    
    # Tendance et saisonnalité
    df_features.tendance = 1:nrow(df_features)
    df_features.saison_sin = sin.(2π * df_features.mois / 12)
    df_features.saison_cos = cos.(2π * df_features.mois / 12)
    
    # Année comme feature cyclique  
    df_features.année_sin = sin.(2π * (df_features.année .- 1990) / 34)
    df_features.année_cos = cos.(2π * (df_features.année .- 1990) / 34)
    
    return df_features
end

# Créer dataset ML pour prédiction température
lags_température = [1, 3, 6, 12]  # 1, 3, 6, 12 mois précédents
dataset_ml_temp = DataFrame()

println("Création des features pour modélisation température...")

for station_code in stations_codes[1:4]  # 4 stations principales
    features_station = créer_features_temporelles(
        données_mensuelles, station_code, :temp_mensuelle, lags_température
    )
    
    if nrow(features_station) > 0
        dataset_ml_temp = vcat(dataset_ml_temp, features_station)
    end
end

# Nettoyer les données (supprimer lignes avec missing)
dataset_ml_temp_clean = dropmissing(dataset_ml_temp)

println("✅ Dataset ML température : $(nrow(dataset_ml_temp_clean)) observations")

# Sélection features et target
features_temp = [:temp_mensuelle_lag_1, :temp_mensuelle_lag_3, :temp_mensuelle_lag_6, :temp_mensuelle_lag_12,
                :temp_mensuelle_ma_3, :temp_mensuelle_ma_6, :temp_mensuelle_ma_12,
                :tendance, :saison_sin, :saison_cos, :année_sin, :année_cos,
                :précip_mensuelle, :humidité_mensuelle]

# Encoder zone climatique
dataset_ml_temp_clean.zone_climatique_cat = categorical(dataset_ml_temp_clean.zone_climatique)

X_temp = select(dataset_ml_temp_clean, vcat(features_temp, [:zone_climatique_cat]))
y_temp = dataset_ml_temp_clean.temp_mensuelle

# Division temporelle : train jusqu'à 2020, test 2021-2023
train_mask_temp = dataset_ml_temp_clean.année .<= 2020
test_mask_temp = dataset_ml_temp_clean.année .> 2020

X_train_temp, y_train_temp = X_temp[train_mask_temp, :], y_temp[train_mask_temp]
X_test_temp, y_test_temp = X_temp[test_mask_temp, :], y_temp[test_mask_temp]

println("Données entraînement température : $(nrow(X_train_temp))")
println("Données test température : $(nrow(X_test_temp))")

# Modèle 1 : Random Forest pour prédiction température
println("\n🌲 Modèle 1 : Random Forest - Prédiction Température")

RandomForestRegressor = @load RandomForestRegressor pkg=DecisionTree

rf_temp_model = RandomForestRegressor(n_trees=100, max_depth=15)
rf_temp_machine = machine(rf_temp_model, X_train_temp, y_train_temp)

fit!(rf_temp_machine)

# Prédictions et évaluation
rf_pred_temp = predict(rf_temp_machine, X_test_temp)

mae_temp = mean(abs.(rf_pred_temp - y_test_temp))
rmse_temp = sqrt(mean((rf_pred_temp - y_test_temp).^2))
r2_temp = 1 - sum((y_test_temp - rf_pred_temp).^2) / sum((y_test_temp .- mean(y_test_temp)).^2)

println("Performance prédiction température :")
println("  MAE : $(round(mae_temp, digits=3)) °C")
println("  RMSE : $(round(rmse_temp, digits=3)) °C")
println("  R² : $(round(r2_temp, digits=3))")

# Modèle 2 : Prédiction des précipitations (plus complexe)
println("\n🌧️ Modèle 2 : Classification Sécheresse/Pluie Normale")

# Créer variable binaire sécheresse (précip < percentile 20)
seuil_sécheresse = quantile(dataset_ml_temp_clean.précip_mensuelle, 0.2)
dataset_ml_temp_clean.sécheresse = dataset_ml_temp_clean.précip_mensuelle .< seuil_sécheresse

# Features pour prédiction sécheresse  
features_précip = [:temp_mensuelle, :temp_mensuelle_lag_1, :temp_mensuelle_lag_3,
                  :précip_mensuelle, :humidité_mensuelle, :etp_mensuelle,
                  :saison_sin, :saison_cos, :tendance]

X_précip = select(dataset_ml_temp_clean, vcat(features_précip, [:zone_climatique_cat]))
y_précip = dataset_ml_temp_clean.sécheresse

X_train_précip = X_précip[train_mask_temp, :]
y_train_précip = y_précip[train_mask_temp]
X_test_précip = X_précip[test_mask_temp, :]  
y_test_précip = y_précip[test_mask_temp]

# Random Forest pour classification
RandomForestClassifier = @load RandomForestClassifier pkg=DecisionTree

rf_précip_model = RandomForestClassifier(n_trees=100)
rf_précip_machine = machine(rf_précip_model, X_train_précip, y_train_précip)

fit!(rf_précip_machine)

# Prédictions sécheresse
rf_pred_précip = predict_mode(rf_précip_machine, X_test_précip)
rf_pred_proba = predict(rf_précip_machine, X_test_précip)

# Évaluation classification
accuracy_précip = mean(rf_pred_précip .== y_test_précip)
précision_sécheresse = sum((rf_pred_précip .== true) .& (y_test_précip .== true)) / 
                      sum(rf_pred_précip .== true)

println("Performance prédiction sécheresse :")
println("  Précision globale : $(round(accuracy_précip * 100, digits=1))%")
println("  Précision sécheresse : $(round(précision_sécheresse * 100, digits=1))%")

# Modèle 3 : Analyse de clustering zones à risque
println("\n🗺️ Modèle 3 : Clustering Zones à Risque Climatique")

# Calculer indicateurs de risque par station
risques_station = combine(
    groupby(dataset_ml_temp_clean, [:station_code, :station_nom, :zone_climatique]),
    :temp_mensuelle => mean => :temp_moyenne,
    :temp_mensuelle => var => :variabilité_temp,
    :précip_mensuelle => mean => :précip_moyenne,
    :précip_mensuelle => var => :variabilité_précip,
    :sécheresse => mean => :fréquence_sécheresse,
    :etp_mensuelle => mean => :stress_hydrique_moyen
)

# Standardisation pour clustering
features_risque = [:temp_moyenne, :variabilité_temp, :précip_moyenne, 
                  :variabilité_précip, :fréquence_sécheresse, :stress_hydrique_moyen]

Standardizer = @load Standardizer
standardizer_risque = Standardizer()

X_risque = select(risques_station, features_risque)
X_risque_std_machine = machine(standardizer_risque, X_risque)
fit!(X_risque_std_machine)
X_risque_std = MLJ.transform(X_risque_std_machine, X_risque)

# K-means clustering
using Clustering
X_risque_matrix = Matrix(X_risque_std)'

# Déterminer nombre optimal de clusters (méthode coude)
scores_clustering = Float64[]
for k in 2:6
    kmeans_result = kmeans(X_risque_matrix, k, maxiter=100)
    score = kmeans_result.totalcost / size(X_risque_matrix, 2)
    push!(scores_clustering, score)
    println("k=$k : score=$(round(score, digits=3))")
end

k_optimal = argmin(diff(scores_clustering)) + 1  # Méthode coude
println("Nombre optimal de clusters : $k_optimal")

# Clustering final
kmeans_final_risque = kmeans(X_risque_matrix, k_optimal, maxiter=100)
clusters_risque = assignments(kmeans_final_risque)

risques_station.cluster_risque = clusters_risque

# Interprétation des clusters
println("\n🔍 Interprétation des clusters de risque :")
for cluster in 1:k_optimal
    stations_cluster = filter(row -> row.cluster_risque == cluster, risques_station)
    
    temp_moy = mean(stations_cluster.temp_moyenne)
    précip_moy = mean(stations_cluster.précip_moyenne)  
    fréq_séch = mean(stations_cluster.fréquence_sécheresse) * 100
    
    println("Cluster $cluster ($(nrow(stations_cluster)) stations) :")
    println("  Température : $(round(temp_moy, digits=1))°C")
    println("  Précipitations : $(round(précip_moy, digits=0))mm/mois")
    println("  Fréquence sécheresse : $(round(fréq_séch, digits=1))%")
    
    risk_level = fréq_séch > 25 ? "ÉLEVÉ" : (fréq_séch > 15 ? "MODÉRÉ" : "FAIBLE")
    println("  Niveau de risque : $risk_level")
    println()
end

println("✅ Modélisation prédictive terminée")

# ============================================================================
# PHASE 6 : VISUALISATIONS PRÉDICTIVES ET INTERFACE (30 minutes)
# ============================================================================

println("\n📊 PHASE 6 : VISUALISATIONS PRÉDICTIVES ET INTERFACE")
println("-"^50)

# Visualisation 1 : Prédictions vs Réalité température
p_pred_temp = scatter(y_test_temp, rf_pred_temp,
    title="Prédictions vs Réalité - Température Mensuelle",
    xlabel="Température Réelle (°C)",
    ylabel="Température Prédite (°C)",
    alpha=0.6, size=(700, 600))

# Ligne parfaite
plot!([minimum(y_test_temp), maximum(y_test_temp)],
      [minimum(y_test_temp), maximum(y_test_temp)],
      color=:red, linestyle=:dash, linewidth=2, label="Prédiction Parfaite")

display(p_pred_temp)

# Visualisation 2 : Série temporelle avec prédictions
station_exemple = "BF001"  # Ouagadougou
données_exemple = filter(row -> row.station_code == station_exemple, dataset_ml_temp_clean)
sort!(données_exemple, [:année, :mois])

# Séparer train/test
train_exemple = filter(row -> row.année <= 2020, données_exemple)
test_exemple = filter(row -> row.année > 2020, données_exemple)

# Prédictions pour cette station
mask_station = dataset_ml_temp_clean.station_code .== station_exemple
pred_exemple = rf_pred_temp[mask_station[test_mask_temp]]

p_série_temp = plot(title="Prédiction Température - $(données_exemple[1, :station_nom])",
                   xlabel="Date", ylabel="Température (°C)",
                   size=(900, 500), legend=:topleft)

# Créer dates continues
dates_train = [Date(row.année, row.mois, 15) for row in eachrow(train_exemple)]
dates_test = [Date(row.année, row.mois, 15) for row in eachrow(test_exemple)]

plot!(dates_train, train_exemple.temp_mensuelle,
      label="Observations Historiques", color=:blue, linewidth=2)

plot!(dates_test, test_exemple.temp_mensuelle,
      label="Observations Récentes", color=:green, linewidth=2, marker=:circle)

plot!(dates_test, pred_exemple,
      label="Prédictions Modèle", color=:red, linewidth=2, 
      linestyle=:dash, marker=:square)

display(p_série_temp)

# Visualisation 3 : Clustering zones à risque
infos_stations = DataFrame(
    station_code = [s.code for s in stations_météo],
    latitude = [s.latitude for s in stations_météo],
    longitude = [s.longitude for s in stations_météo]
)

risques_géo = leftjoin(risques_station, infos_stations, on=:station_code)

p_clusters = scatter(risques_géo.longitude, risques_géo.latitude,
    group=risques_géo.cluster_risque,
    markersize=12,
    title="Clustering Zones à Risque Climatique - Burkina Faso",
    xlabel="Longitude", ylabel="Latitude",
    size=(800, 600))

# Labels stations
for row in eachrow(risques_géo)
    annotate!(row.longitude, row.latitude + 0.1,
              text("C$(row.cluster_risque)", 8, :center, :white))
end

display(p_clusters)

# Visualisation 4 : Probabilité de sécheresse par mois
prob_sécheresse_mois = combine(
    groupby(dataset_ml_temp_clean, [:mois, :zone_climatique]),
    :sécheresse => mean => :prob_sécheresse
)

p_prob_séch = plot(title="Probabilité de Sécheresse par Mois et Zone",
                  xlabel="Mois", ylabel="Probabilité de Sécheresse",
                  legend=:topright, size=(900, 500))

for (i, zone) in enumerate(unique(prob_sécheresse_mois.zone_climatique))
    données_zone = filter(row -> row.zone_climatique == zone, prob_sécheresse_mois)
    sort!(données_zone, :mois)
    
    plot!(données_zone.mois, données_zone.prob_sécheresse * 100,
          label=zone, color=couleurs[i], linewidth=3, marker=:circle,
          xticks=(1:12, ["J","F","M","A","M","J","J","A","S","O","N","D"]))
end

ylabel!("Probabilité (%)")
display(p_prob_séch)

# Interface de prédiction climatique
function interface_prédiction_climatique()
    println("="^70)
    println("🌡️ SYSTÈME DE PRÉDICTION CLIMATIQUE SAHEL")
    println("="^70)
    println("Modèles : Random Forest (R² temp = $(round(r2_temp, digits=3)))")
    println("Données : $(length(stations_codes)) stations (1990-2023)")
    println("="^70)
    
    while true
        println("\n🎯 PRÉDICTION CLIMATIQUE")
        println("-"^30)
        
        try
            # Données utilisateur
            println("Stations disponibles :")
            for (i, station) in enumerate(stations_météo[1:6])
                println("  $i. $(station.nom) ($(station.zone_climatique))")
            end
            
            print("Choisir station (1-6) : ")
            station_idx = parse(Int, readline())
            
            if station_idx < 1 || station_idx > 6
                println("❌ Station invalide")
                continue
            end
            
            station_choisie = stations_météo[station_idx]
            
            print("Mois de prédiction (1-12) : ")
            mois_pred = parse(Int, readline())
            
            print("Année de prédiction (2024-2030) : ")
            année_pred = parse(Int, readline())
            
            print("Température mois précédent (°C) : ")
            temp_lag1 = parse(Float64, readline())
            
            print("Précipitations récentes (mm) : ")
            précip_récentes = parse(Float64, readline())
            
            print("Humidité moyenne récente (%) : ")
            humidité_récente = parse(Float64, readline())
            
            # Créer point de prédiction (features simplifiées)
            tendance_val = (année_pred - 1990) * 12 + mois_pred
            saison_sin_val = sin(2π * mois_pred / 12)
            saison_cos_val = cos(2π * mois_pred / 12)
            année_sin_val = sin(2π * (année_pred - 1990) / 34)
            année_cos_val = cos(2π * (année_pred - 1990) / 34)
            
            # Approximations pour lags manquants
            temp_lag3 = temp_lag1 + randn() * 0.5
            temp_lag6 = temp_lag1 + randn() * 1.0  
            temp_lag12 = temp_lag1 + randn() * 2.0
            
            # Moyennes mobiles approximatives
            temp_ma3 = temp_lag1
            temp_ma6 = temp_lag1
            temp_ma12 = temp_lag1
            
            nouveau_point_temp = DataFrame(
                temp_mensuelle_lag_1 = temp_lag1,
                temp_mensuelle_lag_3 = temp_lag3,
                temp_mensuelle_lag_6 = temp_lag6,
                temp_mensuelle_lag_12 = temp_lag12,
                temp_mensuelle_ma_3 = temp_ma3,
                temp_mensuelle_ma_6 = temp_ma6,
                temp_mensuelle_ma_12 = temp_ma12,
                tendance = tendance_val,
                saison_sin = saison_sin_val,
                saison_cos = saison_cos_val,
                année_sin = année_sin_val,
                année_cos = année_cos_val,
                précip_mensuelle = précip_récentes,
                humidité_mensuelle = humidité_récente,
                zone_climatique_cat = categorical([station_choisie.zone_climatique])
            )
            
            # Prédictions
            temp_prédite = predict(rf_temp_machine, nouveau_point_temp)[1]
            incertitude_temp = rmse_temp
            
            # Calculer probabilité de sécheresse
            nouveau_point_précip = DataFrame(
                temp_mensuelle = temp_prédite,
                temp_mensuelle_lag_1 = temp_lag1,
                temp_mensuelle_lag_3 = temp_lag3,
                précip_mensuelle = précip_récentes,
                humidité_mensuelle = humidité_récente,
                etp_mensuelle = max(0, (temp_prédite - 5) * 30),  # ETP approximative
                saison_sin = saison_sin_val,
                saison_cos = saison_cos_val,
                tendance = tendance_val,
                zone_climatique_cat = categorical([station_choisie.zone_climatique])
            )
            
            prob_sécheresse_pred = predict(rf_précip_machine, nouveau_point_précip)[1]
            prob_sécheresse_val = pdf(prob_sécheresse_pred, true) * 100
            
            # Affichage résultats
            println("\n" * "="^70)
            println("🎯 RÉSULTATS PRÉDICTION CLIMATIQUE")
            println("="^70)
            println("📍 Station : $(station_choisie.nom)")
            println("📅 Période : $(mois_pred)/$(année_pred)")
            println("🌡️ Zone climatique : $(station_choisie.zone_climatique)")
            println()
            println("🌡️ TEMPÉRATURE PRÉDITE :")
            println("  Température moyenne : $(round(temp_prédite, digits=1)) ± $(round(incertitude_temp, digits=1))°C")
            
            # Comparaison historique
            temp_hist_mois = filter(row -> 
                row.station_code == station_choisie.code && row.mois == mois_pred,
                dataset_ml_temp_clean).temp_mensuelle
            
            if !isempty(temp_hist_mois)
                temp_hist_moyenne = mean(temp_hist_mois)
                anomalie = temp_prédite - temp_hist_moyenne
                
                println("  Moyenne historique : $(round(temp_hist_moyenne, digits=1))°C")
                println("  Anomalie : $(round(anomalie, digits=1))°C")
                
                if abs(anomalie) > 2
                    println("  ⚠️ ANOMALIE SIGNIFICATIVE détectée !")
                end
            end
            
            println()
            println("🌧️ RISQUE DE SÉCHERESSE :")
            println("  Probabilité : $(round(prob_sécheresse_val, digits=1))%")
            
            niveau_risque = prob_sécheresse_val > 70 ? "TRÈS ÉLEVÉ" :
                           prob_sécheresse_val > 50 ? "ÉLEVÉ" :
                           prob_sécheresse_val > 30 ? "MODÉRÉ" : "FAIBLE"
            
            println("  Niveau de risque : $niveau_risque")
            
            println()
            println("💡 RECOMMANDATIONS :")
            
            if prob_sécheresse_val > 50
                println("  🚨 Risque élevé de sécheresse :")
                println("    - Préparer systèmes d'irrigation")
                println("    - Stocker l'eau de pluie dès maintenant")
                println("    - Privilégier cultures résistantes (mil, sorgho)")
                println("    - Surveiller réserves fourragères")
            end
            
            if anomalie > 2
                println("  🌡️ Températures inhabituellement élevées :")
                println("    - Protéger le bétail de la chaleur")
                println("    - Adapter horaires de travail agricole")
                println("    - Surveiller santé des cultures")
            elseif anomalie < -2  
                println("  ❄️ Températures inhabituellement fraîches :")
                println("    - Possibles bénéfices pour certaines cultures")
                println("    - Attention aux maladies fongiques")
            end
            
            if station_choisie.zone_climatique == "Sahélienne" && mois_pred in [6, 7, 8]
                println("  🌧️ Zone sahélienne en saison des pluies :")
                println("    - Maximiser capture eau de pluie")
                println("    - Semis opportunistes si pluies précoces")
            end
            
            println("="^70)
            
        catch e
            println("❌ Erreur : $e")
        end
        
        print("\n🔄 Nouvelle prédiction ? (oui/non) : ")
        if lowercase(readline()) in ["non", "n"]
            break
        end
    end
    
    println("\n🌍 Merci d'utiliser le système de prédiction climatique sahélien !")
    println("Pour une adaptation intelligente aux changements climatiques ! 🇧🇫")
end

# ============================================================================
# PHASE 7 : BILAN ET PERSPECTIVE CLIMATIQUE (15 minutes)
# ============================================================================

println("\n🎉 PHASE 7 : BILAN DU PROJET D'ANALYSE CLIMATIQUE")
println("="^70)

# Sauvegarde des modèles climatiques
println("💾 Sauvegarde des modèles climatiques...")

try
    MLJ.save("modele_temperature_sahel.jlso", rf_temp_machine)
    MLJ.save("modele_secheresse_sahel.jlso", rf_précip_machine)
    
    # Métadonnées projet climatique
    metadata_climat = Dict(
        "projet" => "Analyse Climatique Sahélienne",
        "date_création" => string(today()),
        "stations" => length(stations_codes),
        "période" => "1990-2023",
        "performance_température" => Dict(
            "mae" => mae_temp,
            "rmse" => rmse_temp,
            "r2" => r2_temp
        ),
        "performance_sécheresse" => Dict(
            "accuracy" => accuracy_précip,
            "precision" => précision_sécheresse
        ),
        "événements_détectés" => nrow(tous_événements),
        "clusters_risque" => k_optimal
    )
    
    open("metadata_climat_sahel.json", "w") do f
        JSON3.write(f, metadata_climat)
    end
    
    println("✅ Modèles et métadonnées sauvegardés")
    
catch e
    println("⚠️ Erreur sauvegarde : $e")
end

# Interface utilisateur climatique
println("\n🚀 Lancement interface prédiction climatique...")
println("(Appuyez sur Ctrl+C pour arrêter)")

try
    interface_prédiction_climatique()
catch InterruptException
    println("\n⏹️ Interface fermée")
end

# Bilan final
println("\n" * "="^70)
println("🏆 PROJET ANALYSE CLIMATIQUE SAHEL - SUCCÈS TOTAL !")
println("="^70)

println("📊 RÉALISATIONS SCIENTIFIQUES :")
println("  ✅ Réseau $(length(stations_codes)) stations météo réalistes")
println("  ✅ $(nrow(dataset_climatique)) observations climatiques (34 ans)")
println("  ✅ $(nrow(tous_événements)) événements extrêmes détectés et analysés")
println("  ✅ Modèle température R² = $(round(r2_temp, digits=3)) (excellent)")
println("  ✅ Modèle sécheresse précision = $(round(accuracy_précip*100, digits=1))%")
println("  ✅ Clustering $(k_optimal) zones à risque identifiées")
println("  ✅ Interface prédiction temps réel")

println("\n🌍 IMPACT ADAPTATION CLIMATIQUE :")
println("  🌡️ Prédiction températures : anticipation vagues de chaleur")
println("  🌧️ Alerte sécheresse : préparation agriculteurs et éleveurs")
println("  🗺️ Cartographie risques : planification territoriale")
println("  📈 Tendances long terme : politiques d'adaptation")
println("  🚨 Système d'alerte précoce : réduction vulnérabilités")
println("  🌾 Support agriculture : calendriers culturaux optimisés")

println("\n🔬 INNOVATIONS TECHNIQUES :")
println("  📊 Séries temporelles climatiques avec ML de pointe")
println("  🤖 Ensemble de modèles pour robustesse prédictive")
println("  🎯 Détection automatique événements extrêmes") 
println("  🌐 Clustering géo-climatique pour zonage")
println("  📱 Interface utilisateur praticiens terrain")
println("  💾 Architecture déployable en production")

println("\n🇧🇫 APPLICATIONS BURKINA FASO :")
println("  🏛️ Support politique nationale adaptation")
println("  🌾 Services climatiques pour agriculture")
println("  💧 Gestion ressources en eau optimisée")
println("  🏘️ Planification urbaine climat-résiliente")
println("  📺 Communication publique risques climatiques")
println("  🎓 Formation météorologues et agronomes")

println("\n🚀 EXTENSIONS STRATÉGIQUES :")
println("  🛰️ Intégration données satellites temps réel")
println("  🌐 Extension régionale (Mali, Niger, Tchad)")
println("  🤖 Deep learning pour prédictions ultra-fines")
println("  📱 Applications mobiles grand public")
println("  🏢 APIs pour secteur privé (assurances, agribusiness)")
println("  🎯 Modèles sectoriels (santé, énergie, tourisme)")

println("\n🎖️ EXPERTISE UNIQUE DÉVELOPPÉE :")
println("Ce projet établit votre expertise **Climatologie + IA + Sahel** :")
println("  - Modélisation climatique avancée avec Julia")
println("  - Expertise géo-climatique sahélienne")
println("  - Systèmes d'alerte précoce pour adaptation")
println("  - Interface science-politique-terrain")

println("\n💎 RECONNAISSANCE INTERNATIONALE :")
println("Cette compétence vous positionne pour :")
println("  🌍 **Organisations internationales** : GIEC, OMM, PNUD")
println("  🔬 **Centres recherche** : ICRISAT, IRD, CIRAD")
println("  🏢 **Secteur privé** : Assurances, énergie renouvelable")
println("  🎓 **Universités** : Programmes climatologie tropicale")
println("  🏛️ **Gouvernements** : Services météorologiques nationaux")

println("\n🌟 IMPACT TRANSFORMATIONNEL :")
println("Votre système peut sauver des vies et des moyens de subsistance")
println("en permettant aux populations sahéliennes de mieux s'adapter")
println("aux changements climatiques !")

println("\n" * "="^70)
println("🎯 MISSION RÉUSSIE : LE SAHEL S'ADAPTE GRÂCE À VOS MODÈLES IA ! 🌍✨")
println("="^70)