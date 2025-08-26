# Practice 10.1 : Visualisation des Données Climatiques du Burkina Faso

## 🎯 Objectif
Créer des visualisations complètes et interactives des données climatiques du Burkina Faso pour analyser les patterns météorologiques, la variabilité saisonnière et les tendances à long terme.

## 📋 Prérequis
```julia
using Plots
using DataFrames
using Statistics
using StatsPlots
using Dates
using DataFramesMeta

# Configuration du backend pour interactivité
plotlyjs()  # ou gr() pour la rapidité
```

## 🌡️ Création des Données Climatiques

### Étape 1: Dataset météorologique principal
```julia
# Données climatiques mensuelles moyennes pour différentes stations
df_climat = DataFrame(
    station = repeat(["Ouagadougou", "Bobo-Dioulasso", "Dori", "Gaoua", "Fada N'Gourma"], inner=12),
    mois = repeat(1:12, 5),
    mois_nom = repeat(["Jan", "Fév", "Mar", "Avr", "Mai", "Jun", 
                      "Jul", "Aoû", "Sep", "Oct", "Nov", "Déc"], 5),
    zone_climatique = repeat(["Soudano-Sahélienne", "Soudanienne", "Sahélienne", 
                             "Soudanienne", "Soudano-Sahélienne"], inner=12),
    latitude = repeat([12.37, 11.18, 14.03, 10.33, 12.06], inner=12),
    longitude = repeat([-1.52, -4.29, -0.03, -3.18, 0.37], inner=12),
    
    # Températures (°C) - patterns réalistes selon les zones
    temperature_min = [
        # Ouagadougou (Soudano-Sahélienne)
        16, 20, 24, 27, 27, 24, 22, 21, 22, 22, 18, 15,
        # Bobo-Dioulasso (Soudanienne) 
        18, 22, 25, 26, 25, 22, 21, 20, 21, 22, 20, 17,
        # Dori (Sahélienne)
        13, 17, 21, 25, 27, 25, 23, 22, 23, 21, 16, 12,
        # Gaoua (Soudanienne)
        19, 23, 26, 26, 24, 21, 20, 19, 20, 22, 21, 18,
        # Fada N'Gourma (Soudano-Sahélienne)
        15, 19, 23, 26, 26, 23, 21, 20, 21, 21, 17, 14
    ],
    
    temperature_max = [
        # Ouagadougou
        33, 36, 39, 41, 40, 37, 34, 33, 35, 38, 36, 33,
        # Bobo-Dioulasso
        32, 35, 37, 38, 36, 32, 30, 29, 31, 34, 33, 31,
        # Dori
        31, 35, 39, 42, 42, 39, 35, 33, 36, 38, 35, 31,
        # Gaoua
        31, 34, 36, 36, 33, 29, 27, 26, 28, 32, 32, 30,
        # Fada N'Gourma
        32, 35, 38, 40, 38, 35, 32, 31, 33, 36, 34, 32
    ],
    
    # Précipitations (mm) - très saisonnées
    precipitation = [
        # Ouagadougou
        0, 1, 4, 20, 74, 122, 180, 198, 142, 45, 1, 0,
        # Bobo-Dioulasso  
        2, 5, 15, 45, 95, 145, 210, 245, 185, 78, 8, 1,
        # Dori
        0, 0, 1, 8, 35, 75, 120, 145, 85, 15, 0, 0,
        # Gaoua
        5, 12, 28, 78, 135, 185, 245, 280, 220, 95, 15, 3,
        # Fada N'Gourma
        1, 2, 8, 25, 65, 110, 165, 185, 125, 35, 2, 0
    ],
    
    # Humidité relative (%)
    humidite = [
        # Ouagadougou
        25, 22, 28, 35, 55, 75, 85, 88, 78, 55, 35, 28,
        # Bobo-Dioulasso
        35, 32, 38, 45, 65, 80, 85, 88, 82, 68, 45, 38,
        # Dori
        15, 12, 18, 25, 45, 65, 75, 78, 68, 45, 25, 18,
        # Gaoua
        45, 42, 48, 55, 75, 85, 88, 90, 85, 75, 55, 48,
        # Fada N'Gourma
        28, 25, 31, 38, 58, 78, 82, 85, 75, 52, 32, 25
    ],
    
    # Vitesse du vent (km/h)
    vent_vitesse = [
        # Ouagadougou
        8, 10, 12, 8, 6, 5, 4, 4, 5, 6, 8, 9,
        # Bobo-Dioulasso
        6, 8, 10, 7, 5, 4, 3, 3, 4, 5, 7, 7,
        # Dori
        12, 15, 18, 12, 8, 6, 5, 5, 6, 8, 12, 14,
        # Gaoua
        5, 7, 9, 6, 4, 3, 2, 2, 3, 4, 6, 6,
        # Fada N'Gourma
        9, 11, 13, 9, 7, 5, 4, 4, 5, 7, 9, 10
    ]
)

println("🌡️ Dataset climatique créé avec $(nrow(df_climat)) observations")
println("📊 Stations incluses : $(unique(df_climat.station))")
```

**🎯 Défi 1 :** Explorez la structure du dataset et vérifiez la cohérence des données.

---

### Étape 2: Graphique des températures saisonnières
```julia
# Extraction des données de Ouagadougou
ouaga_data = @subset(df_climat, :station .== "Ouagadougou")

# Graphique des températures min/max
p_temp_ouaga = plot(ouaga_data.mois_nom, [ouaga_data.temperature_min ouaga_data.temperature_max],
    title="Températures Mensuelles - Ouagadougou",
    xlabel="Mois", ylabel="Température (°C)",
    label=["T° minimale" "T° maximale"],
    linewidth=3, marker=[:circle :square],
    color=[:blue :red],
    size=(700, 400),
    legend=:topright
)

# Ajout de zone d'ombre entre min et max
plot!(p_temp_ouaga, ouaga_data.mois_nom, ouaga_data.temperature_min,
      fillrange=ouaga_data.temperature_max, fillalpha=0.2, fillcolor=:gray,
      label="Amplitude thermique", linealpha=0)

display(p_temp_ouaga)
```

**🎯 Défi 2 :** Créez le même graphique pour Dori et comparez avec Ouagadougou.

---

### Étape 3: Visualisation des précipitations
```julia
# Graphique en barres des précipitations pour toutes les stations
@df df_climat groupedbar(:mois_nom, :precipitation,
    group=:station,
    title="Précipitations Mensuelles par Station",
    xlabel="Mois", ylabel="Précipitations (mm)",
    size=(900, 500),
    legend=:topright,
    color_palette=:tab10
)
```

**🎯 Défi 3 :** Quelle station reçoit le plus de pluie ? Pendant quels mois ?

---

### Étape 4: Comparaison des zones climatiques
```julia
# Calcul des moyennes par zone climatique
stats_zones = combine(groupby(df_climat, [:zone_climatique, :mois_nom]),
    :temperature_max => mean => :temp_max_moy,
    :precipitation => mean => :precip_moy,
    :humidite => mean => :humidite_moy
)

# Graphique des températures par zone
@df stats_zones plot(:mois_nom, :temp_max_moy,
    group=:zone_climatique,
    title="Température Maximale Moyenne par Zone Climatique",
    xlabel="Mois", ylabel="Température (°C)",
    linewidth=2, marker=:circle,
    size=(800, 400)
)
```

**🎯 Défi 4 :** Créez un graphique similaire pour les précipitations moyennes par zone.

---

### Étape 5: Analyse de la variabilité climatique
```julia
# Calcul de la variabilité (coefficient de variation) par mois
variabilite_temp = combine(groupby(df_climat, :mois_nom),
    :temperature_max => (x -> std(x)/mean(x)*100) => :cv_temp_max,
    :precipitation => (x -> std(x)/mean(x)*100) => :cv_precip
)

# Graphique de variabilité
p_var = plot(variabilite_temp.mois_nom, variabilite_temp.cv_temp_max,
    title="Variabilité Climatique Inter-stations",
    xlabel="Mois", ylabel="Coefficient de Variation (%)",
    label="Température max", linewidth=2, color=:red, marker=:circle)

plot!(p_var, variabilite_temp.mois_nom, variabilite_temp.cv_precip,
      label="Précipitations", linewidth=2, color=:blue, marker=:square,
      size=(700, 400))

display(p_var)
```

**🎯 Défi 5 :** Pendant quels mois observe-t-on la plus grande variabilité entre stations ?

---

### Étape 6: Diagramme climatique de Walter-Lieth
```julia
# Création d'un diagramme climatique (température et précipitations)
function diagramme_climatique(station_nom::String)
    data_station = @subset(df_climat, :station .== station_nom)
    
    # Graphique principal (température)
    p = plot(data_station.mois_nom, data_station.temperature_max,
        title="Diagramme Climatique - $station_nom",
        xlabel="Mois", ylabel="Température (°C)",
        label="Température", color=:red, linewidth=3,
        size=(800, 500))
    
    # Axe secondaire (précipitations)
    plot!(twinx(), data_station.mois_nom, data_station.precipitation,
          ylabel="Précipitations (mm)", label="Précipitations",
          color=:blue, linewidth=3, fillrange=0, fillalpha=0.3)
    
    return p
end

# Diagrammes pour 3 stations représentatives
p1 = diagramme_climatique("Ouagadougou")
p2 = diagramme_climatique("Dori")
p3 = diagramme_climatique("Gaoua")

plot(p1, p2, p3, layout=(3,1), size=(800, 900))
```

**🎯 Défi 6 :** Analysez les différences climatiques entre ces trois stations.

---

### Étape 7: Carte de chaleur climatique
```julia
# Création d'une matrice pour heatmap
stations_list = unique(df_climat.station)
mois_list = 1:12

# Matrice des températures maximales
temp_matrix = zeros(length(stations_list), 12)
for (i, station) in enumerate(stations_list)
    station_data = @subset(df_climat, :station .== station)
    temp_matrix[i, :] = station_data.temperature_max
end

# Heatmap des températures
heatmap(mois_list, stations_list, temp_matrix,
    title="Températures Maximales par Station et Mois",
    xlabel="Mois", ylabel="Station",
    color=:plasma,
    size=(700, 400))
```

**🎯 Défi 7 :** Créez une heatmap similaire pour les précipitations.

---

### Étape 8: Analyse des extrêmes climatiques
```julia
# Identification des extrêmes
extremes_climat = combine(groupby(df_climat, :station),
    :temperature_max => maximum => :temp_max_record,
    :temperature_min => minimum => :temp_min_record,
    :precipitation => maximum => :precip_max_mensuelle,
    :precipitation => sum => :precip_annuelle_totale
)

# Graphique des records de température
scatter(extremes_climat.temp_min_record, extremes_climat.temp_max_record,
    series_annotations=text.(extremes_climat.station, 8, :bottom),
    title="Records de Température par Station",
    xlabel="Température minimale record (°C)",
    ylabel="Température maximale record (°C)",
    markersize=8, color=:orange,
    size=(700, 500))

# Ajouter une ligne de régression simple
x_range = minimum(extremes_climat.temp_min_record):maximum(extremes_climat.temp_min_record)
plot!(x_range, x_range .+ 20, linestyle=:dash, color=:gray, label="Amplitude moyenne")
```

**🎯 Défi 8 :** Quelle station a l'amplitude thermique la plus importante ?

---

### Étape 9: Indice de confort climatique
```julia
# Calcul d'un indice de confort basé sur température et humidité
transform!(df_climat,
    [:temperature_max, :humidite] => 
    ((temp, hum) -> round.(temp .- (hum .- 50) .* 0.2, digits=1)) => :indice_confort
)

# Visualisation de l'indice de confort par station
@df df_climat plot(:mois_nom, :indice_confort,
    group=:station,
    title="Indice de Confort Climatique par Station",
    xlabel="Mois", ylabel="Indice de Confort",
    linewidth=2, size=(800, 500),
    legend=:bottomright
)

# Ligne de référence pour confort optimal
hline!([25], linestyle=:dash, color=:green, linewidth=2, label="Confort optimal")
```

**🎯 Défi 9 :** Quelle station offre le meilleur confort climatique en moyenne ?

---

### Étape 10: Projection saisonnière en radar
```julia
# Création d'un graphique radar pour une station
function graphique_radar_climat(station_nom::String)
    data_station = @subset(df_climat, :station .== station_nom)
    
    # Normalisation des données (0-100)
    temp_norm = (data_station.temperature_max .- minimum(data_station.temperature_max)) ./ 
                (maximum(data_station.temperature_max) - minimum(data_station.temperature_max)) .* 100
    
    precip_norm = (data_station.precipitation .- minimum(data_station.precipitation)) ./ 
                  (maximum(data_station.precipitation) - minimum(data_station.precipitation)) .* 100
    
    # Angles pour les mois (en radians)
    angles = 2π .* (0:11) ./ 12
    
    # Graphique radar
    plot(angles, temp_norm, proj=:polar,
         title="Profil Climatique Annuel - $station_nom",
         label="Température (norm.)", linewidth=2, color=:red)
    
    plot!(angles, precip_norm, proj=:polar,
          label="Précipitations (norm.)", linewidth=2, color=:blue)
    
    # Fermer le cercle
    plot!([angles; angles[1]], [temp_norm; temp_norm[1]], proj=:polar,
          linewidth=2, color=:red, alpha=0.7)
    plot!([angles; angles[1]], [precip_norm; precip_norm[1]], proj=:polar,
          linewidth=2, color=:blue, alpha=0.7)
end

# Affichage pour Ouagadougou
graphique_radar_climat("Ouagadougou")
```

**🎯 Défi 10 :** Créez des graphiques radar pour toutes les stations et comparez-les.

---

### Étape 11: Tendances et anomalies (simulation)
```julia
# Simulation de données historiques avec tendance au réchauffement
annees = 2000:2023
n_annees = length(annees)

# Simulation de l'évolution de la température moyenne annuelle
temp_ouaga_annuelle = 28.5 .+ 0.03 .* (annees .- 2000) .+ randn(n_annees) .* 0.5

# Graphique de tendance
plot(annees, temp_ouaga_annuelle,
    title="Évolution de la Température Moyenne - Ouagadougou (2000-2023)",
    xlabel="Année", ylabel="Température moyenne (°C)",
    linewidth=2, marker=:circle, color=:red,
    size=(800, 400))

# Ligne de tendance
z = polyfit(collect(annees), temp_ouaga_annuelle, 1)
trend_line = z[1] .* annees .+ z[2]
plot!(annees, trend_line, linestyle=:dash, color=:blue, linewidth=2,
      label="Tendance (+$(round(z[1]*10, digits=2))°C/décennie)")

# Bandes de confiance
upper_band = trend_line .+ 1.0
lower_band = trend_line .- 1.0
plot!(annees, upper_band, fillrange=lower_band, fillalpha=0.2, color=:gray,
      label="Intervalle confiance", linealpha=0)
```

**🎯 Défi 11 :** Calculez la tendance d'évolution des précipitations sur la même période.

---

### Étape 12: Dashboard climatique interactif
```julia
# Création d'un dashboard complet
function dashboard_climatique()
    # 1. Températures par zone
    p1 = @df stats_zones plot(:mois_nom, :temp_max_moy,
        group=:zone_climatique,
        title="Températures par Zone",
        ylabel="°C", linewidth=2)
    
    # 2. Précipitations totales par station
    precip_totales = combine(groupby(df_climat, :station),
        :precipitation => sum => :precip_annuelle)
    p2 = bar(precip_totales.station, precip_totales.precip_annuelle,
        title="Précipitations Annuelles",
        ylabel="mm", color=:lightblue, rotation=45)
    
    # 3. Amplitude thermique
    amplitudes = combine(groupby(df_climat, :station),
        [:temperature_max, :temperature_min] => 
        ((tmax, tmin) -> mean(tmax .- tmin)) => :amplitude_moyenne)
    p3 = scatter(amplitudes.station, amplitudes.amplitude_moyenne,
        title="Amplitude Thermique Moyenne",
        ylabel="°C", markersize=8, color=:orange)
    
    # 4. Saisonnalité des précipitations
    p4 = @df df_climat boxplot(:mois_nom, :precipitation,
        title="Variabilité Mensuelle des Précipitations",
        ylabel="mm", color=:green)
    
    # Assemblage
    plot(p1, p2, p3, p4, layout=(2,2), size=(1000, 700),
         suptitle="Dashboard Climatique - Burkina Faso")
end

dashboard_climatique()
```

**🎯 Défi 12 :** Ajoutez un 5ème graphique montrant l'évolution de l'humidité par station.

---

### Étape 13: Analyse des corrélations climatiques
```julia
# Matrice de corrélation entre variables climatiques
variables_climat = [:temperature_min, :temperature_max, :precipitation, :humidite, :vent_vitesse]
matrice_corr = cor(Matrix(df_climat[!, variables_climat]))

# Heatmap de corrélation
heatmap(variables_climat, variables_climat, matrice_corr,
    title="Corrélations entre Variables Climatiques",
    color=:RdYlBu, aspect_ratio=1,
    size=(600, 500))

# Ajouter les valeurs de corrélation
for i in 1:length(variables_climat)
    for j in 1:length(variables_climat)
        annotate!(i, j, text(round(matrice_corr[i,j], digits=2), 10, :white))
    end
end
```

**🎯 Défi 13 :** Quelles sont les 3 corrélations les plus fortes observées ?

---

### Étape 14: Classification climatique automatique
```julia
# Classification des mois selon le climat
function classifier_climat(temp_max, precipitation)
    if temp_max > 35 && precipitation < 50
        return "Chaud et sec"
    elseif temp_max > 30 && precipitation > 100
        return "Chaud et humide"
    elseif temp_max < 30 && precipitation > 100
        return "Frais et humide"
    else
        return "Tempéré"
    end
end

# Application de la classification
transform!(df_climat,
    [:temperature_max, :precipitation] => 
    ((temp, precip) -> classifier_climat.(temp, precip)) => :type_climat
)

# Visualisation de la classification
@df df_climat scatter(:temperature_max, :precipitation,
    group=:type_climat,
    title="Classification Climatique Automatique",
    xlabel="Température maximale (°C)",
    ylabel="Précipitations (mm)",
    markersize=6, alpha=0.7,
    size=(800, 600))
```

**🎯 Défi Final :** Analysez la répartition des types climatiques par station et par saison.

---

## 🎯 Exercices Supplémentaires

### Exercice A: Rose des vents
```julia
# Créez une rose des vents montrant la direction et vitesse du vent par saison
```

### Exercice B: Indices bioclimatiques
```julia
# Calculez et visualisez des indices comme l'évapotranspiration potentielle
```

### Exercice C: Comparaison avec normales climatiques
```julia
# Comparez les données actuelles avec des normales sur 30 ans
```

### Exercice D: Prévision saisonnière simple
```julia
# Utilisez les patterns historiques pour estimer les tendances futures
```

## 🏆 Points Clés Appris
- ✅ Visualisation multi-variables de données climatiques
- ✅ Graphiques temporels et saisonniers
- ✅ Cartes de chaleur et graphiques radar
- ✅ Comparaisons inter-stations et inter-zones
- ✅ Détection de tendances et d'anomalies
- ✅ Dashboard interactif intégré
- ✅ Classification automatique de patterns climatiques
- ✅ Corrélations entre variables environnementales

Ces visualisations climatiques nous préparent à la prochaine étape : analyser et visualiser les indicateurs économiques pour comprendre les liens entre climat et développement au Burkina Faso !