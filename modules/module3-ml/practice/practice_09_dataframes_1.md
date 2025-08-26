# Practice 9.1 : Analyse des Données de Production Agricole du Burkina Faso

## 🎯 Objectif
Analyser les données de production agricole réelles du Burkina Faso pour comprendre les tendances de production céréalière par région et identifier les opportunités d'amélioration.

## 📋 Prérequis
```julia
using DataFrames
using CSV
using Statistics
using DataFramesMeta
```

## 📊 Jeu de Données : Production Céréalière 2020-2023

Nous allons créer et analyser un jeu de données basé sur les statistiques agricoles réelles du Burkina Faso.

### Étape 1: Création du dataset de base
```julia
# Données de production céréalière par région (en tonnes)
df_production = DataFrame(
    annee = repeat(2020:2023, 13),
    region = repeat([
        "Cascades", "Centre", "Centre-Est", "Centre-Nord", "Centre-Ouest",
        "Centre-Sud", "Est", "Hauts-Bassins", "Nord", "Plateau Central",
        "Sahel", "Sud-Ouest", "Boucle du Mouhoun"
    ], inner=4),
    mil_tonnes = [
        # 2020-2023 pour chaque région
        15240, 16100, 14980, 15680,  # Cascades
        45670, 48200, 44100, 46300,  # Centre
        52340, 54800, 51200, 53100,  # Centre-Est
        38420, 40100, 37800, 39200,  # Centre-Nord
        41230, 43500, 40800, 42100,  # Centre-Ouest
        28340, 29800, 27900, 28900,  # Centre-Sud
        55680, 58200, 56100, 57400,  # Est
        62450, 65100, 63200, 64300,  # Hauts-Bassins
        72340, 75800, 73500, 74600,  # Nord
        35420, 37200, 36100, 36800,  # Plateau Central
        25680, 26900, 25200, 26100,  # Sahel
        48920, 51200, 49800, 50500,  # Sud-Ouest
        68540, 71200, 69800, 70300   # Boucle du Mouhoun
    ],
    sorgho_tonnes = [
        12180, 12800, 11900, 12400,  # Cascades
        38540, 40200, 37800, 39100,  # Centre
        44230, 46100, 43500, 44800,  # Centre-Est
        32340, 33800, 31900, 32900,  # Centre-Nord
        35120, 36700, 34800, 35600,  # Centre-Ouest
        22450, 23600, 22100, 22800,  # Centre-Sud
        48920, 51200, 49100, 50100,  # Est
        55340, 57800, 54900, 56200,  # Hauts-Bassins
        63420, 66200, 64100, 65100,  # Nord
        28340, 29600, 28000, 28800,  # Plateau Central
        20120, 21100, 19800, 20500,  # Sahel
        42340, 44200, 41800, 43100,  # Sud-Ouest
        58920, 61500, 59200, 60200   # Boucle du Mouhoun
    ],
    mais_tonnes = [
        8920, 9400, 8700, 9100,      # Cascades
        25340, 26800, 24900, 25900,  # Centre
        28420, 29900, 27800, 28600,  # Centre-Est
        18230, 19200, 17800, 18500,  # Centre-Nord
        22140, 23300, 21600, 22400,  # Centre-Ouest
        15680, 16500, 15200, 15800,  # Centre-Sud
        31240, 32800, 30900, 31700,  # Est
        38920, 40800, 38100, 39400,  # Hauts-Bassins
        35420, 37200, 34800, 36100,  # Nord
        18920, 19800, 18400, 19200,  # Plateau Central
        12340, 12900, 12000, 12600,  # Sahel
        28450, 29800, 27900, 28700,  # Sud-Ouest
        42340, 44200, 41500, 42800   # Boucle du Mouhoun
    ]
)

println("🌾 Dataset créé avec $(nrow(df_production)) observations")
println("📊 Aperçu des données :")
println(first(df_production, 5))
```

**🎯 Défi 1 :** Exécutez le code ci-dessus et vérifiez la structure des données.

---

### Étape 2: Exploration initiale des données
```julia
# Informations générales sur le dataset
println("📏 Dimensions du dataset : $(size(df_production))")
println("📋 Colonnes : $(names(df_production))")
println()

# Statistiques descriptives
println("📊 Statistiques descriptives :")
describe(df_production)
```

**🎯 Défi 2 :** Quelles sont les valeurs minimales et maximales de production pour chaque céréale ?

---

### Étape 3: Calculs de production totale
```julia
# Ajout de la production totale par observation
transform!(df_production,
    [:mil_tonnes, :sorgho_tonnes, :mais_tonnes] => 
    ((m, s, ma) -> m .+ s .+ ma) => :production_totale
)

# Ajout de la part de chaque céréale
transform!(df_production,
    [:mil_tonnes, :production_totale] => 
    ((mil, tot) -> round.((mil ./ tot) .* 100, digits=1)) => :part_mil_pct,
    [:sorgho_tonnes, :production_totale] => 
    ((sorgho, tot) -> round.((sorgho ./ tot) .* 100, digits=1)) => :part_sorgho_pct,
    [:mais_tonnes, :production_totale] => 
    ((mais, tot) -> round.((mais ./ tot) .* 100, digits=1)) => :part_mais_pct
)

println("🔢 Nouvelles colonnes ajoutées :")
println(names(df_production))
```

**🎯 Défi 3 :** Affichez les 3 premières lignes avec toutes les nouvelles colonnes.

---

### Étape 4: Analyse par région
```julia
# Production moyenne par région sur la période 2020-2023
stats_regions = combine(groupby(df_production, :region),
    :production_totale => mean => :prod_moyenne,
    :production_totale => std => :prod_ecart_type,
    :production_totale => minimum => :prod_min,
    :production_totale => maximum => :prod_max,
    :mil_tonnes => mean => :mil_moyen,
    :sorgho_tonnes => mean => :sorgho_moyen,
    :mais_tonnes => mean => :mais_moyen
)

# Tri par production moyenne décroissante
sort!(stats_regions, :prod_moyenne, rev=true)

println("🏆 TOP 5 des régions par production moyenne :")
println(first(stats_regions[!, [:region, :prod_moyenne]], 5))
```

**🎯 Défi 4 :** Identifiez les 3 régions avec la plus forte variabilité (écart-type) de production.

---

### Étape 5: Évolution temporelle
```julia
# Évolution de la production par année
evolution_annuelle = combine(groupby(df_production, :annee),
    :production_totale => sum => :production_nationale,
    :mil_tonnes => sum => :mil_national,
    :sorgho_tonnes => sum => :sorgho_national,
    :mais_tonnes => sum => :mais_national
)

# Calcul du taux de croissance année par année
evolution_annuelle.croissance_pct = [missing; 
    round.((evolution_annuelle.production_nationale[2:end] .- 
            evolution_annuelle.production_nationale[1:end-1]) ./ 
            evolution_annuelle.production_nationale[1:end-1] .* 100, digits=2)]

println("📈 Évolution de la production nationale :")
println(evolution_annuelle)
```

**🎯 Défi 5 :** Calculez la croissance moyenne annuelle de production sur la période.

---

### Étape 6: Analyse des spécialisations régionales
```julia
# Identification de la céréale dominante par région
specialisations = @chain df_production begin
    groupby(:region)
    combine(
        :mil_tonnes => mean => :mil_moy,
        :sorgho_tonnes => mean => :sorgho_moy,
        :mais_tonnes => mean => :mais_moy
    )
    @transform(
        :cereale_dominante = ifelse.(:mil_moy .> :sorgho_moy .&& :mil_moy .> :mais_moy, "Mil",
                            ifelse.(:sorgho_moy .> :mais_moy, "Sorgho", "Maïs")),
        :production_dominante = max.(:mil_moy, :sorgho_moy, :mais_moy),
        :indice_specialisation = round.(max.(:mil_moy, :sorgho_moy, :mais_moy) ./ 
                                       (:mil_moy .+ :sorgho_moy .+ :mais_moy) .* 100, digits=1)
    )
    sort(:indice_specialisation, rev=true)
end

println("🎯 Spécialisations régionales :")
println(specialisations[!, [:region, :cereale_dominante, :indice_specialisation]])
```

**🎯 Défi 6 :** Quelles sont les 3 régions les plus spécialisées ? Quelle est leur céréale de prédilection ?

---

### Étape 7: Analyse des performances par zone climatique
```julia
# Classification des régions par zone climatique (basée sur la géographie du Burkina Faso)
zones_climatiques = DataFrame(
    region = ["Sahel", "Nord", "Centre-Nord", "Plateau Central", "Centre", 
              "Centre-Est", "Centre-Ouest", "Centre-Sud", "Est", "Boucle du Mouhoun",
              "Hauts-Bassins", "Sud-Ouest", "Cascades"],
    zone_climat = ["Sahélienne", "Sahélienne", "Sahélienne", "Soudano-Sahélienne", 
                   "Soudano-Sahélienne", "Soudano-Sahélienne", "Soudano-Sahélienne",
                   "Soudano-Sahélienne", "Soudano-Sahélienne", "Soudanienne",
                   "Soudanienne", "Soudanienne", "Soudanienne"]
)

# Jointure avec les données de production
df_avec_climat = leftjoin(df_production, zones_climatiques, on=:region)

# Analyse par zone climatique
stats_zones = combine(groupby(df_avec_climat, :zone_climat),
    :production_totale => mean => :prod_moyenne,
    :mil_tonnes => mean => :mil_moyen,
    :sorgho_tonnes => mean => :sorgho_moyen,
    :mais_tonnes => mean => :mais_moyen,
    nrow => :nb_observations
)

println("🌍 Production moyenne par zone climatique :")
println(stats_zones)
```

**🎯 Défi 7 :** Quelle zone climatique a la meilleure productivité ? Analysez les différences entre zones.

---

### Étape 8: Identification des outliers
```julia
# Calcul des quartiles et détection des valeurs aberrantes
function detecter_outliers(df::DataFrame, colonne::Symbol)
    Q1 = quantile(df[!, colonne], 0.25)
    Q3 = quantile(df[!, colonne], 0.75)
    IQR = Q3 - Q1
    limite_basse = Q1 - 1.5 * IQR
    limite_haute = Q3 + 1.5 * IQR
    
    outliers = @subset(df, 
        $colonne .< limite_basse .|| $colonne .> limite_haute)
    
    return outliers[!, [:region, :annee, colonne]]
end

println("🔍 Détection des outliers pour la production totale :")
outliers_production = detecter_outliers(df_production, :production_totale)
println(outliers_production)

# Analyse des outliers pour chaque céréale
for cereale in [:mil_tonnes, :sorgho_tonnes, :mais_tonnes]
    outliers = detecter_outliers(df_production, cereale)
    if nrow(outliers) > 0
        println("\n📊 Outliers pour $cereale :")
        println(outliers)
    end
end
```

**🎯 Défi 8 :** Analysez les outliers détectés. Sont-ils dus à des conditions exceptionnelles ou à des erreurs de données ?

---

### Étape 9: Comparaison de performances 2020 vs 2023
```julia
# Comparaison première vs dernière année
comparaison_annees = @chain df_production begin
    @subset(:annee .== 2020 .|| :annee .== 2023)
    @select(:region, :annee, :production_totale)
    unstack(:annee, :production_totale)
    @rename(:1 => :prod_2020, :2 => :prod_2023)
    @transform(
        :evolution_tonnes = :prod_2023 .- :prod_2020,
        :evolution_pct = round.((:prod_2023 .- :prod_2020) ./ :prod_2020 .* 100, digits=2)
    )
    sort(:evolution_pct, rev=true)
end

println("📊 Évolution 2020-2023 par région :")
println(comparaison_annees)

# Régions en croissance vs décroissance
regions_croissance = @subset(comparaison_annees, :evolution_pct .> 0)
regions_decroissance = @subset(comparaison_annees, :evolution_pct .< 0)

println("\n✅ Régions en croissance : $(nrow(regions_croissance))")
println("❌ Régions en décroissance : $(nrow(regions_decroissance))")
```

**🎯 Défi 9 :** Calculez la croissance moyenne nationale entre 2020 et 2023.

---

### Étape 10: Synthèse et recommandations
```julia
# Calcul d'indicateurs de synthèse
println("=" ^ 60)
println("📋 SYNTHÈSE DE L'ANALYSE")
println("=" ^ 60)

# Production totale nationale
prod_nationale_2023 = sum(@subset(df_production, :annee .== 2023).production_totale)
println("🌾 Production nationale 2023 : $(round(prod_nationale_2023/1000, digits=0)) milliers de tonnes")

# Région la plus performante
meilleure_region = first(stats_regions.region)
println("🏆 Région la plus productive : $meilleure_region")

# Céréale dominante nationalement
total_cereales_2023 = combine(@subset(df_production, :annee .== 2023),
    :mil_tonnes => sum,
    :sorgho_tonnes => sum,
    :mais_tonnes => sum
)
println("🥇 Répartition nationale 2023 :")
println("   - Mil : $(round(total_cereales_2023.mil_tonnes_sum[1]/1000, digits=0))k tonnes")
println("   - Sorgho : $(round(total_cereales_2023.sorgho_tonnes_sum[1]/1000, digits=0))k tonnes") 
println("   - Maïs : $(round(total_cereales_2023.mais_tonnes_sum[1]/1000, digits=0))k tonnes")

# Régions à potentiel d'amélioration
regions_potentiel = last(stats_regions[!, [:region, :prod_moyenne]], 3)
println("⚡ Régions à fort potentiel d'amélioration :")
for i in 1:nrow(regions_potentiel)
    println("   - $(regions_potentiel.region[i])")
end
```

**🎯 Défi Final :** Rédigez 3 recommandations concrètes pour améliorer la production agricole au Burkina Faso basées sur votre analyse.

---

## 🎯 Exercices Supplémentaires

### Exercice A: Analyse de la variabilité climatique
```julia
# Créez un coefficient de variation pour mesurer la stabilité de production
# CV = (écart-type / moyenne) * 100
```

### Exercice B: Projection simple
```julia
# En supposant une croissance linéaire, estimez la production 2024 pour chaque région
```

### Exercice C: Analyse de corrélation
```julia
# Analysez s'il y a une corrélation entre la production de différentes céréales
using Statistics
```

## 🏆 Points Clés Appris
- ✅ Création et manipulation de datasets réalistes
- ✅ Calculs d'agrégations et de pourcentages  
- ✅ Analyse temporelle et détection de tendances
- ✅ Groupements et comparaisons multi-niveaux
- ✅ Détection d'anomalies dans les données
- ✅ Jointures pour enrichir l'analyse
- ✅ Synthèse d'insights actionables

Dans la prochaine pratique, nous analyserons des données démographiques pour comprendre la distribution de la population et ses caractéristiques socio-économiques !