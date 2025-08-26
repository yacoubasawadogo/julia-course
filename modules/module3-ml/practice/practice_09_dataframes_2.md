# Practice 9.2 : Analyse des Données Démographiques du Burkina Faso

## 🎯 Objectif
Analyser les données démographiques et socio-économiques du Burkina Faso pour comprendre la répartition de la population, l'accès aux services et identifier les défis de développement.

## 📋 Prérequis
```julia
using DataFrames
using CSV
using Statistics
using DataFramesMeta
using StatsBase
```

## 📊 Jeu de Données : Recensement et Indicateurs Sociaux

Nous allons travailler avec des données inspirées du recensement général de la population et de l'habitation (RGPH) du Burkina Faso.

### Étape 1: Création du dataset démographique principal
```julia
# Données démographiques par province (basées sur RGPH 2019)
df_demographie = DataFrame(
    province = [
        "Bam", "Banwa", "Bazèga", "Bougouriba", "Boulgou", "Boulkiemdé",
        "Comoé", "Ganzourgou", "Gnagna", "Gourma", "Houet", "Ioba",
        "Kadiogo", "Kénédougou", "Komondjari", "Kompienga", "Kossi",
        "Koulpélogo", "Kouritenga", "Kourwéogo", "Léraba", "Loroum",
        "Mouhoun", "Nahouri", "Namentenga", "Noumbiel", "Oubritenga",
        "Oudalan", "Passoré", "Poni", "Sanmatenga", "Séno", "Sissili",
        "Soum", "Sourou", "Tapoa", "Tuy", "Yagha", "Yatenga", "Ziro",
        "Zondoma", "Zoundwéogo", "Balé", "Nayala", "Komandjari"
    ],
    region = [
        "Nord", "Boucle du Mouhoun", "Centre-Sud", "Sud-Ouest", "Centre-Est", "Centre-Ouest",
        "Cascades", "Plateau Central", "Est", "Est", "Hauts-Bassins", "Sud-Ouest",
        "Centre", "Hauts-Bassins", "Est", "Est", "Boucle du Mouhoun",
        "Centre-Est", "Centre-Est", "Plateau Central", "Cascades", "Nord",
        "Boucle du Mouhoun", "Centre-Sud", "Centre-Nord", "Sud-Ouest", "Plateau Central",
        "Sahel", "Centre-Nord", "Sud-Ouest", "Centre-Nord", "Sahel", "Centre-Sud",
        "Sahel", "Boucle du Mouhoun", "Est", "Hauts-Bassins", "Sahel", "Nord", "Centre-Sud",
        "Nord", "Centre-Sud", "Boucle du Mouhoun", "Boucle du Mouhoun", "Est"
    ],
    population_totale = [
        350287, 345749, 320845, 145264, 737718, 701949,
        667031, 424352, 582513, 459382, 1924812, 298031,
        3285893, 550274, 147717, 150323, 463543,
        545037, 550274, 198785, 284098, 183159,
        463543, 269345, 398917, 106955, 430986,
        198425, 410932, 309575, 744151, 574915, 284098,
        598734, 256450, 198125, 294982, 324567, 745345, 298124,
        256871, 313547, 284573, 245183, 98743
    ],
    population_urbaine = [
        87572, 76308, 96254, 43579, 147544, 175487,
        300166, 127305, 116503, 91876, 865164, 59606,
        2415420, 220110, 29543, 30065, 92709,
        109007, 110055, 39757, 56820, 36632,
        92709, 53869, 79783, 21391, 86197,
        39685, 82186, 61915, 148830, 114983, 56820,
        119747, 51290, 39625, 58996, 64913, 149069, 59625,
        51374, 62709, 56915, 49037, 19749
    ],
    menages = [
        56789, 58745, 54637, 24789, 126845, 119834,
        113678, 72456, 99456, 78345, 328456, 50789,
        561234, 93789, 25234, 25687, 79123,
        92876, 93876, 33876, 48456, 31234,
        79123, 45876, 68123, 18234, 73456,
        33876, 70123, 52789, 127834, 98123, 48456,
        102345, 43789, 33789, 50234, 55456, 127345, 50876,
        43789, 53456, 48567, 41789, 16834
    ],
    taille_moyenne_menage = round.(rand(45) .* 2 .+ 4.5, digits=1),  # Entre 4.5 et 6.5 personnes/ménage
    age_median = round.(rand(45) .* 5 .+ 15),  # Entre 15 et 20 ans
    taux_alphabetisation = round.(rand(45) .* 40 .+ 30, digits=1),  # Entre 30% et 70%
    acces_eau_potable_pct = round.(rand(45) .* 50 .+ 40, digits=1),  # Entre 40% et 90%
    acces_electricite_pct = round.(rand(45) .* 60 .+ 10, digits=1),  # Entre 10% et 70%
    centres_sante = round.(Int, rand(45) .* 15 .+ 5),  # Entre 5 et 20 centres
    ecoles_primaires = round.(Int, rand(45) .* 80 .+ 20),  # Entre 20 et 100 écoles
    distance_capitale_km = [
        # Distances approximatives de Ouagadougou en km
        120, 285, 60, 320, 180, 75,
        420, 90, 280, 250, 365, 380,
        0, 385, 310, 290, 215,
        140, 150, 50, 445, 150,
        230, 140, 180, 450, 45,
        295, 125, 350, 110, 235, 160,
        275, 190, 285, 385, 220, 185, 165,
        160, 85, 275, 265, 325
    ]
)

println("👥 Dataset démographique créé avec $(nrow(df_demographie)) provinces")
println("📊 Aperçu des données :")
println(first(df_demographie, 3))
```

**🎯 Défi 1 :** Explorez la structure du dataset et identifiez les types de variables.

---

### Étape 2: Calculs d'indicateurs démographiques
```julia
# Calcul d'indicateurs clés
transform!(df_demographie,
    # Taux d'urbanisation
    [:population_urbaine, :population_totale] => 
    ((urb, tot) -> round.((urb ./ tot) .* 100, digits=1)) => :taux_urbanisation_pct,
    
    # Population rurale
    [:population_totale, :population_urbaine] => 
    ((-) => :population_rurale),
    
    # Densité approximative (population/km² - données fictives pour l'exercice)
    :population_totale => (x -> round.(x ./ (rand(length(x)) .* 8000 .+ 2000), digits=1)) => :densite_km2,
    
    # Ratio centres de santé pour 10000 habitants
    [:centres_sante, :population_totale] => 
    ((cs, pop) -> round.((cs ./ pop) .* 10000, digits=2)) => :centres_pour_10k_hab,
    
    # Ratio écoles pour 1000 enfants (estimation 25% de la population)
    [:ecoles_primaires, :population_totale] => 
    ((ec, pop) -> round.((ec ./ (pop * 0.25)) .* 1000, digits=2)) => :ecoles_pour_1k_enfants
)

println("🔢 Nouveaux indicateurs calculés :")
println(names(df_demographie)[end-5:end])
```

**🎯 Défi 2 :** Affichez les statistiques descriptives des nouveaux indicateurs.

---

### Étape 3: Analyse de la répartition de la population
```julia
# Répartition de la population par région
repartition_regionale = combine(groupby(df_demographie, :region),
    :population_totale => sum => :population_totale,
    :population_urbaine => sum => :population_urbaine,
    :population_rurale => sum => :population_rurale,
    nrow => :nombre_provinces
)

# Calcul des pourcentages
total_national = sum(repartition_regionale.population_totale)
transform!(repartition_regionale,
    :population_totale => (x -> round.((x ./ total_national) .* 100, digits=1)) => :pourcentage_national,
    [:population_urbaine, :population_totale] => 
    ((urb, tot) -> round.((urb ./ tot) .* 100, digits=1)) => :taux_urbanisation
)

# Tri par population décroissante
sort!(repartition_regionale, :population_totale, rev=true)

println("👥 Répartition de la population par région :")
println(repartition_regionale[!, [:region, :population_totale, :pourcentage_national, :taux_urbanisation]])
```

**🎯 Défi 3 :** Identifiez les 3 régions les plus peuplées et leur contribution au total national.

---

### Étape 4: Analyse de l'accès aux services de base
```julia
# Classification des provinces selon l'accès aux services
df_services = @chain df_demographie begin
    @select(:province, :region, :population_totale, :acces_eau_potable_pct, 
            :acces_electricite_pct, :taux_alphabetisation, :centres_pour_10k_hab)
    @transform(
        :score_acces_eau = ifelse.(:acces_eau_potable_pct .>= 70, "Bon", 
                          ifelse.(:acces_eau_potable_pct .>= 50, "Moyen", "Faible")),
        :score_electricite = ifelse.(:acces_electricite_pct .>= 50, "Bon",
                            ifelse.(:acces_electricite_pct .>= 25, "Moyen", "Faible")),
        :score_alphabetisation = ifelse.(:taux_alphabetisation .>= 60, "Bon",
                                ifelse.(:taux_alphabetisation .>= 40, "Moyen", "Faible")),
        :score_sante = ifelse.(:centres_pour_10k_hab .>= 1.5, "Bon",
                      ifelse.(:centres_pour_10k_hab .>= 1.0, "Moyen", "Faible"))
    )
end

# Analyse par région des scores d'accès
scores_regionaux = @chain df_services begin
    groupby(:region)
    combine(
        :acces_eau_potable_pct => mean => :eau_moyenne,
        :acces_electricite_pct => mean => :electricite_moyenne,
        :taux_alphabetisation => mean => :alphabetisation_moyenne,
        :centres_pour_10k_hab => mean => :sante_moyenne
    )
    @transform(
        :score_global = round.((:eau_moyenne .+ :electricite_moyenne .+ :alphabetisation_moyenne) ./ 3, digits=1)
    )
    sort(:score_global, rev=true)
end

println("🏥 Scores d'accès aux services par région :")
println(scores_regionaux)
```

**🎯 Défi 4 :** Identifiez les régions prioritaires pour l'amélioration de l'accès aux services.

---

### Étape 5: Analyse de l'urbanisation
```julia
# Analyse des patterns d'urbanisation
analyse_urbanisation = @chain df_demographie begin
    @select(:province, :region, :population_totale, :taux_urbanisation_pct, :distance_capitale_km)
    @transform(
        :categorie_distance = ifelse.(:distance_capitale_km .<= 100, "Proche (<100km)",
                             ifelse.(:distance_capitale_km .<= 200, "Moyenne (100-200km)", "Éloignée (>200km)")),
        :taille_province = ifelse.(:population_totale .>= 500000, "Grande",
                          ifelse.(:population_totale .>= 200000, "Moyenne", "Petite"))
    )
end

# Corrélation entre distance de la capitale et urbanisation
stats_distance = combine(groupby(analyse_urbanisation, :categorie_distance),
    :taux_urbanisation_pct => mean => :urbanisation_moyenne,
    :population_totale => mean => :population_moyenne,
    nrow => :nombre_provinces
)

println("🏙️ Urbanisation selon la distance de la capitale :")
println(stats_distance)

# Analyse par taille de province
stats_taille = combine(groupby(analyse_urbanisation, :taille_province),
    :taux_urbanisation_pct => mean => :urbanisation_moyenne,
    :distance_capitale_km => mean => :distance_moyenne,
    nrow => :nombre_provinces
)

println("\n📏 Urbanisation selon la taille des provinces :")
println(stats_taille)
```

**🎯 Défi 5 :** Y a-t-il une corrélation entre la proximité de la capitale et le taux d'urbanisation ?

---

### Étape 6: Analyse des inégalités d'accès
```julia
# Calcul d'indices d'inégalité (coefficient de variation)
function calculer_cv(x)
    return round((std(x) / mean(x)) * 100, digits=2)
end

inequalites = combine(groupby(df_demographie, :region),
    :acces_eau_potable_pct => calculer_cv => :cv_eau,
    :acces_electricite_pct => calculer_cv => :cv_electricite,
    :taux_alphabetisation => calculer_cv => :cv_alphabetisation,
    :densite_km2 => calculer_cv => :cv_densite
)

# Identification des régions avec fortes inégalités
@transform!(inequalites,
    :inegalite_moyenne = (:cv_eau .+ :cv_electricite .+ :cv_alphabetisation) ./ 3
)

sort!(inequalites, :inegalite_moyenne, rev=true)

println("📊 Inégalités d'accès aux services par région (CV%) :")
println(inequalites[!, [:region, :cv_eau, :cv_electricite, :cv_alphabetisation, :inegalite_moyenne]])
```

**🎯 Défi 6 :** Quelles régions présentent les plus fortes inégalités internes ?

---

### Étape 7: Analyse des besoins en infrastructures
```julia
# Estimation des besoins en infrastructures
df_besoins = @chain df_demographie begin
    @select(:province, :region, :population_totale, :acces_eau_potable_pct, 
            :acces_electricite_pct, :centres_sante, :ecoles_primaires)
    @transform(
        # Population sans accès aux services
        :pop_sans_eau = round.(Int, :population_totale .* (100 .- :acces_eau_potable_pct) ./ 100),
        :pop_sans_electricite = round.(Int, :population_totale .* (100 .- :acces_electricite_pct) ./ 100),
        
        # Estimation des besoins (normes OMS/UNESCO)
        :centres_sante_necessaires = round.(Int, :population_totale ./ 10000),  # 1 centre pour 10k hab
        :ecoles_necessaires = round.(Int, (:population_totale .* 0.25) ./ 500),  # 1 école pour 500 enfants
        
        # Déficits
        :deficit_centres = max.(0, :centres_sante_necessaires .- :centres_sante),
        :deficit_ecoles = max.(0, :ecoles_necessaires .- :ecoles_primaires)
    )
end

# Synthèse des besoins par région
besoins_regionaux = combine(groupby(df_besoins, :region),
    :pop_sans_eau => sum => :pop_totale_sans_eau,
    :pop_sans_electricite => sum => :pop_totale_sans_electricite,
    :deficit_centres => sum => :deficit_centres_total,
    :deficit_ecoles => sum => :deficit_ecoles_total
)

sort!(besoins_regionaux, :pop_totale_sans_eau, rev=true)

println("🏗️ Besoins en infrastructures par région :")
println(besoins_regionaux)
```

**🎯 Défi 7 :** Calculez le coût estimé pour combler les déficits si un centre de santé coûte 500 millions FCFA et une école 200 millions FCFA.

---

### Étape 8: Profilage des provinces
```julia
# Création de profils de développement
df_profils = @chain df_demographie begin
    @select(:province, :region, :population_totale, :taux_urbanisation_pct,
            :taux_alphabetisation, :acces_eau_potable_pct, :acces_electricite_pct,
            :densite_km2, :distance_capitale_km)
    @transform(
        # Score composite de développement (moyenne pondérée)
        :score_developpement = round.(
            (:taux_alphabetisation .* 0.3 .+ 
             :acces_eau_potable_pct .* 0.25 .+ 
             :acces_electricite_pct .* 0.25 .+ 
             :taux_urbanisation_pct .* 0.2), digits=1),
        
        # Classification selon le score
        :niveau_developpement = ifelse.(:score_developpement .>= 60, "Élevé",
                               ifelse.(:score_developpement .>= 40, "Moyen", "Faible")),
        
        # Potentiel basé sur la taille et la proximité
        :potentiel = ifelse.(:population_totale .>= 300000 .&& :distance_capitale_km .<= 150, "Fort",
                    ifelse.(:population_totale .>= 150000 .|| :distance_capitale_km .<= 100, "Moyen", "Faible"))
    )
end

# Matrice développement vs potentiel
matrice_dev = combine(groupby(df_profils, [:niveau_developpement, :potentiel]),
    nrow => :nombre_provinces,
    :population_totale => sum => :population_totale
)

println("🎯 Matrice développement vs potentiel :")
println(matrice_dev)

# Top et bottom provinces
top_provinces = @chain df_profils begin
    sort(:score_developpement, rev=true)
    first(5)
    @select(:province, :region, :score_developpement, :niveau_developpement)
end

bottom_provinces = @chain df_profils begin
    sort(:score_developpement)
    first(5)
    @select(:province, :region, :score_developpement, :niveau_developpement)
end

println("\n🏆 Top 5 provinces par score de développement :")
println(top_provinces)

println("\n⚠️ 5 provinces nécessitant le plus d'attention :")
println(bottom_provinces)
```

**🎯 Défi 8 :** Créez une stratégie de développement basée sur la matrice développement vs potentiel.

---

### Étape 9: Analyse des migrations internes (simulation)
```julia
# Simulation des flux migratoires basée sur l'attractivité des provinces
df_migration = @chain df_profils begin
    @select(:province, :region, :population_totale, :score_developpement, 
            :taux_urbanisation_pct, :distance_capitale_km)
    @transform(
        # Indice d'attractivité (facteurs économiques simulés)
        :attractivite = round.(
            (:score_developpement .* 0.4 .+ 
             :taux_urbanisation_pct .* 0.3 .+ 
             (100 .- :distance_capitale_km ./ 5) .* 0.3), digits=1),
        
        # Estimation du solde migratoire (entrées - sorties)
        :solde_migratoire_estime = round.(
            (:attractivite .- 50) .* :population_totale ./ 1000, digits=0),
        
        # Projection de population 2030 (avec migration)
        :projection_2030 = round.(Int, 
            :population_totale .* (1 + 0.025)^7 .+ :solde_migratoire_estime .* 7)
    )
end

# Provinces gagnantes et perdantes
provinces_gagnantes = @subset(df_migration, :solde_migratoire_estime .> 0)
provinces_perdantes = @subset(df_migration, :solde_migratoire_estime .< 0)

println("📈 Provinces attractives (solde migratoire positif) : $(nrow(provinces_gagnantes))")
println("📉 Provinces en exode (solde migratoire négatif) : $(nrow(provinces_perdantes))")

# Impact par région
impact_regional = combine(groupby(df_migration, :region),
    :solde_migratoire_estime => sum => :solde_regional,
    :population_totale => sum => :pop_actuelle,
    :projection_2030 => sum => :pop_projetee_2030
)

@transform!(impact_regional,
    :croissance_pct = round.((:pop_projetee_2030 .- :pop_actuelle) ./ :pop_actuelle .* 100, digits=1)
)

sort!(impact_regional, :solde_regional, rev=true)

println("\n🗺️ Impact migratoire par région :")
println(impact_regional[!, [:region, :solde_regional, :croissance_pct]])
```

**🎯 Défi 9 :** Quelles politiques pourraient rééquilibrer les flux migratoires ?

---

### Étape 10: Rapport de synthèse démographique
```julia
println("=" ^ 70)
println("📋 RAPPORT DE SYNTHÈSE DÉMOGRAPHIQUE - BURKINA FASO")
println("=" ^ 70)

# Statistiques nationales
pop_totale = sum(df_demographie.population_totale)
pop_urbaine = sum(df_demographie.population_urbaine)
taux_urb_national = round((pop_urbaine / pop_totale) * 100, digits=1)

println("👥 DÉMOGRAPHIE NATIONALE")
println("   Population totale : $(round(pop_totale/1_000_000, digits=1)) millions d'habitants")
println("   Population urbaine : $(round(pop_urbaine/1_000_000, digits=1)) millions ($(taux_urb_national)%)")
println("   Nombre de régions : $(length(unique(df_demographie.region)))")
println("   Nombre de provinces : $(nrow(df_demographie))")

# Indicateurs moyens
println("\n📊 INDICATEURS MOYENS NATIONAUX")
indicateurs_moyens = combine(df_demographie,
    :taux_alphabetisation => mean,
    :acces_eau_potable_pct => mean,
    :acces_electricite_pct => mean,
    :centres_pour_10k_hab => mean
)

println("   Taux d'alphabétisation : $(round(indicateurs_moyens.taux_alphabetisation_mean[1], digits=1))%")
println("   Accès eau potable : $(round(indicateurs_moyens.acces_eau_potable_pct_mean[1], digits=1))%")
println("   Accès électricité : $(round(indicateurs_moyens.acces_electricite_pct_mean[1], digits=1))%")
println("   Centres de santé : $(round(indicateurs_moyens.centres_pour_10k_hab_mean[1], digits=2))/10k hab")

# Défis prioritaires
println("\n⚠️ DÉFIS PRIORITAIRES IDENTIFIÉS")
pop_sans_eau = sum(df_besoins.pop_sans_eau)
pop_sans_elec = sum(df_besoins.pop_sans_electricite)
deficit_centres_total = sum(df_besoins.deficit_centres)
deficit_ecoles_total = sum(df_besoins.deficit_ecoles)

println("   $(round(pop_sans_eau/1_000_000, digits=1)) millions sans accès à l'eau potable")
println("   $(round(pop_sans_elec/1_000_000, digits=1)) millions sans électricité")
println("   Déficit de $deficit_centres_total centres de santé")
println("   Déficit de $deficit_ecoles_total écoles primaires")

# Régions prioritaires
regions_prioritaires = first(sort(scores_regionaux, :score_global), 3)
println("\n🎯 RÉGIONS PRIORITAIRES POUR LE DÉVELOPPEMENT")
for i in 1:nrow(regions_prioritaires)
    println("   $(i). $(regions_prioritaires.region[i]) (score: $(regions_prioritaires.score_global[i]))")
end

println("\n" * "=" ^ 70)
```

**🎯 Défi Final :** Rédigez 5 recommandations politiques concrètes basées sur cette analyse démographique.

---

## 🎯 Exercices Supplémentaires

### Exercice A: Analyse genre (simulation)
```julia
# Simulez des données de répartition homme/femme et analysez les différences d'accès aux services
```

### Exercice B: Pyramide des âges
```julia
# Créez des groupes d'âge et analysez la structure démographique
```

### Exercice C: Corrélation infrastructure-développement
```julia
# Analysez la corrélation entre le nombre d'infrastructures et les indicateurs de développement
using Statistics
```

### Exercice D: Planification territoriale
```julia
# Créez un modèle de prioritisation des investissements par province
```

## 🏆 Points Clés Appris
- ✅ Analyse de données démographiques complexes
- ✅ Calcul d'indicateurs socio-économiques
- ✅ Classification et segmentation de territoires
- ✅ Analyse des inégalités spatiales
- ✅ Estimation des besoins en infrastructures
- ✅ Simulation de flux migratoires
- ✅ Synthèse d'insights pour les politiques publiques
- ✅ Jointures et enrichissement de données

Cette analyse nous prépare parfaitement pour la suite : visualiser ces données démographiques avec des cartes et graphiques pour mieux communiquer nos insights !