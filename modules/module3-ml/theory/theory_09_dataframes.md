# Session 9 : Manipulation de Données avec DataFrames.jl

## 🎯 Objectifs de la Session
- Maîtriser les opérations de base avec DataFrames.jl
- Importer et exporter des données dans différents formats
- Filtrer, trier et grouper des données
- Effectuer des jointures et des agrégations
- Nettoyer et transformer des jeux de données

## 📊 Introduction aux DataFrames

### Qu'est-ce qu'un DataFrame ?
Un DataFrame est une structure de données tabulaire (comme un tableau Excel) qui permet de :
- Stocker des données de types différents dans des colonnes
- Manipuler facilement de grandes quantités de données
- Effectuer des analyses statistiques complexes

### Installation et chargement
```julia
using Pkg
Pkg.add("DataFrames")
Pkg.add("CSV")
Pkg.add("XLSX")
Pkg.add("Statistics")

using DataFrames
using CSV
using XLSX
using Statistics
```

## 🏗️ Création de DataFrames

### Création manuelle
```julia
# Données sur la production agricole au Burkina Faso
df_production = DataFrame(
    region = ["Centre", "Nord", "Sud-Ouest", "Est", "Boucle du Mouhoun"],
    mil_tonnes = [45000, 38000, 52000, 41000, 48000],
    sorgho_tonnes = [35000, 42000, 28000, 39000, 44000],
    mais_tonnes = [28000, 25000, 35000, 30000, 32000],
    population = [2500000, 1800000, 950000, 1200000, 1650000]
)

println(df_production)
```

### À partir de dictionnaires
```julia
# Données climatiques de Ouagadougou
donnees_climat = Dict(
    "mois" => ["Jan", "Fév", "Mar", "Avr", "Mai", "Jun"],
    "temperature_moy" => [25.5, 28.2, 32.1, 34.8, 33.2, 29.8],
    "precipitation_mm" => [2, 5, 15, 45, 85, 120],
    "humidite_pct" => [25, 22, 28, 35, 55, 75]
)

df_climat = DataFrame(donnees_climat)
```

## 📥 Import et Export de Données

### Lecture de fichiers CSV
```julia
# Lecture d'un fichier de données agricoles
df_agricole = CSV.read("donnees_agriculture_bf.csv", DataFrame)

# Avec options spécifiques
df_agricole = CSV.read("donnees_agriculture_bf.csv", DataFrame,
    header=1,           # Première ligne comme en-têtes
    delim=';',          # Séparateur point-virgule
    decimal=',',        # Virgule pour les décimales
    encoding="utf-8"    # Encodage français
)
```

### Lecture de fichiers Excel
```julia
# Lecture d'un fichier Excel
df_recensement = DataFrame(XLSX.readtable("recensement_bf_2019.xlsx", "Feuil1"))

# Spécifier une plage de cellules
df_economie = DataFrame(XLSX.readtable("indicateurs_economiques.xlsx", "Données", "A1:E100"))
```

### Export de données
```julia
# Export vers CSV
CSV.write("production_cereales_2023.csv", df_production)

# Export vers Excel
XLSX.writetable("analyse_agricole.xlsx", 
    "Production" => df_production,
    "Climat" => df_climat
)
```

## 🔍 Exploration des Données

### Informations générales
```julia
# Dimensions du DataFrame
size(df_production)  # (nombre_lignes, nombre_colonnes)
nrow(df_production)  # Nombre de lignes
ncol(df_production)  # Nombre de colonnes

# Noms des colonnes
names(df_production)

# Types des colonnes
eltype.(eachcol(df_production))

# Aperçu des premières/dernières lignes
first(df_production, 3)  # 3 premières lignes
last(df_production, 2)   # 2 dernières lignes

# Résumé statistique
describe(df_production)
```

### Accès aux données
```julia
# Accès à une colonne
df_production.region
df_production[!, :region]
df_production[!, "region"]

# Accès à plusieurs colonnes
df_production[!, [:region, :mil_tonnes]]

# Accès à des lignes
df_production[1, :]      # Première ligne
df_production[1:3, :]    # Lignes 1 à 3
df_production[end, :]    # Dernière ligne

# Accès à une cellule spécifique
df_production[1, :region]  # Ligne 1, colonne region
```

## 🔧 Manipulation des Données

### Ajout de colonnes
```julia
# Calcul de la production totale par région
df_production.production_totale = df_production.mil_tonnes + 
                                 df_production.sorgho_tonnes + 
                                 df_production.mais_tonnes

# Production par habitant (kg/personne)
df_production.production_par_habitant = (df_production.production_totale * 1000) ./ 
                                       df_production.population

# Nouvelle colonne avec transform!
transform!(df_production, 
    [:mil_tonnes, :sorgho_tonnes] => (+) => :cereales_principales)
```

### Modification de colonnes
```julia
# Conversion d'unités (tonnes vers kg)
df_production.mil_kg = df_production.mil_tonnes .* 1000

# Remplacement de valeurs
replace!(df_production.region, "Centre" => "Région Centrale")

# Modification conditionnelle
df_production.categorie_production = ifelse.(
    df_production.production_totale .> 100000,
    "Forte production",
    "Production modérée"
)
```

### Suppression de colonnes et lignes
```julia
# Supprimer une colonne
select!(df_production, Not(:mil_kg))

# Supprimer plusieurs colonnes
select!(df_production, Not([:col1, :col2]))

# Supprimer des lignes (par index)
delete!(df_production, 2)  # Supprime la ligne 2

# Supprimer les lignes avec des valeurs manquantes
dropmissing!(df_production)
```

## 📊 Filtrage et Tri

### Filtrage des données
```julia
# Régions avec forte production de mil
regions_mil_fort = filter(row -> row.mil_tonnes > 40000, df_production)

# Utilisation de @subset (plus lisible)
using DataFramesMeta

# Régions du Nord avec production totale > 100000 tonnes
@subset(df_production, :region .== "Nord", :production_totale .> 100000)

# Filtrage multiple
@subset(df_production, 
    :mil_tonnes .> 35000, 
    :population .< 2000000)

# Filtrage avec conditions complexes
regions_equilibrees = @subset(df_production,
    (:mil_tonnes .+ :sorgho_tonnes) .> :mais_tonnes .* 2)
```

### Tri des données
```julia
# Tri par production de mil (croissant)
sort!(df_production, :mil_tonnes)

# Tri décroissant
sort!(df_production, :mil_tonnes, rev=true)

# Tri multiple
sort!(df_production, [:region, :mil_tonnes])

# Tri avec fonction personnalisée
sort!(df_production, :production_par_habitant, rev=true)
```

## 📈 Groupement et Agrégation

### Opérations de groupement
```julia
# Exemple avec plus de données (ajoutons des années)
df_multi_annees = DataFrame(
    region = repeat(["Centre", "Nord", "Sud-Ouest"], 3),
    annee = repeat([2021, 2022, 2023], inner=3),
    production = [45000, 38000, 52000, 47000, 40000, 54000, 49000, 42000, 56000],
    superficie_ha = [25000, 22000, 28000, 26000, 23000, 29000, 27000, 24000, 30000]
)

# Groupement par région
groupes_region = groupby(df_multi_annees, :region)

# Application d'une fonction à chaque groupe
combine(groupes_region, :production => mean => :production_moyenne)

# Agrégations multiples
stats_par_region = combine(groupes_region,
    :production => mean => :prod_moyenne,
    :production => maximum => :prod_max,
    :production => minimum => :prod_min,
    :superficie_ha => sum => :superficie_totale
)

# Groupement multiple
stats_region_annee = combine(
    groupby(df_multi_annees, [:region, :annee]),
    :production => sum => :production_totale,
    nrow => :nombre_observations
)
```

### Transform et select avec groupes
```julia
# Ajouter la moyenne du groupe à chaque ligne
transform!(groupby(df_multi_annees, :region),
    :production => mean => :moyenne_regionale)

# Calculer l'écart à la moyenne
transform!(groupby(df_multi_annees, :region),
    [:production, :moyenne_regionale] => 
    ((x, y) -> x .- y) => :ecart_moyenne)
```

## 🔗 Jointures de DataFrames

### Types de jointures
```julia
# DataFrame des coordonnées des régions
df_coordonnees = DataFrame(
    region = ["Centre", "Nord", "Sud-Ouest", "Est"],
    latitude = [12.3714, 13.5000, 11.1800, 11.7833],
    longitude = [-1.5197, -2.0000, -3.2000, 0.5333],
    chef_lieu = ["Ouagadougou", "Ouahigouya", "Gaoua", "Fada N'Gourma"]
)

# Jointure interne (inner join)
df_complet = innerjoin(df_production, df_coordonnees, on=:region)

# Jointure externe gauche (left join)
df_avec_coords = leftjoin(df_production, df_coordonnees, on=:region)

# Jointure complète (outer join)
df_union = outerjoin(df_production, df_coordonnees, on=:region)
```

### Jointures avec colonnes différentes
```julia
# Si les noms de colonnes diffèrent
df_population = DataFrame(
    nom_region = ["Centre", "Nord", "Sud-Ouest"],
    habitants = [2500000, 1800000, 950000],
    densite_km2 = [87, 45, 32]
)

# Jointure avec renommage
df_avec_pop = leftjoin(df_production, df_population, 
    on=:region => :nom_region)
```

## 🧹 Nettoyage des Données

### Gestion des valeurs manquantes
```julia
# Créer des données avec valeurs manquantes
df_avec_missing = DataFrame(
    region = ["Centre", "Nord", missing, "Sud-Ouest"],
    production = [45000, missing, 52000, 41000],
    qualite = ["Bonne", "Excellente", "Moyenne", missing]
)

# Identifier les valeurs manquantes
describe(df_avec_missing, :nmissing)

# Supprimer les lignes avec valeurs manquantes
df_propre = dropmissing(df_avec_missing)

# Supprimer seulement pour certaines colonnes
df_propre_region = dropmissing(df_avec_missing, :region)

# Remplacer les valeurs manquantes
df_avec_missing.production = coalesce.(df_avec_missing.production, 0)
```

### Déduplication
```julia
# Créer des données avec doublons
df_avec_doublons = DataFrame(
    region = ["Centre", "Nord", "Centre", "Sud-Ouest"],
    annee = [2022, 2022, 2022, 2022],
    production = [45000, 38000, 45000, 52000]
)

# Supprimer les doublons
df_unique = unique(df_avec_doublons)

# Supprimer les doublons sur certaines colonnes
df_unique_region = unique(df_avec_doublons, :region)
```

## 🎯 Exemples Pratiques Burkina Faso

### Analyse de la production céréalière
```julia
# Données réalistes pour le Burkina Faso
df_cereales_bf = DataFrame(
    province = ["Kadiogo", "Bam", "Poni", "Gourma", "Kossi", "Mouhoun"],
    region = ["Centre", "Nord", "Sud-Ouest", "Est", "Boucle du Mouhoun", "Boucle du Mouhoun"],
    mil_ha = [15000, 25000, 18000, 22000, 28000, 24000],
    sorgho_ha = [12000, 20000, 15000, 18000, 25000, 22000],
    mais_ha = [8000, 12000, 14000, 15000, 18000, 16000],
    rendement_mil = [0.8, 1.2, 1.1, 0.9, 1.3, 1.1],  # tonnes/ha
    rendement_sorgho = [0.9, 1.1, 1.0, 0.8, 1.2, 1.0],
    rendement_mais = [1.8, 2.1, 2.3, 1.9, 2.4, 2.2]
)

# Calcul de la production totale
transform!(df_cereales_bf,
    [:mil_ha, :rendement_mil] => (*, :production_mil),
    [:sorgho_ha, :rendement_sorgho] => (*) => :production_sorgho,
    [:mais_ha, :rendement_mais] => (*) => :production_mais
)

# Production totale par province
transform!(df_cereales_bf,
    [:production_mil, :production_sorgho, :production_mais] => 
    ((x,y,z) -> x .+ y .+ z) => :production_totale)

# Analyse par région
stats_regions = combine(groupby(df_cereales_bf, :region),
    :production_totale => sum => :production_regionale,
    :production_totale => mean => :production_moyenne,
    nrow => :nombre_provinces
)

println("📊 Production céréalière par région (tonnes) :")
println(stats_regions)
```

### Analyse des revenus agricoles
```julia
# Prix moyens FCFA/tonne en 2023
prix_fcfa = DataFrame(
    cereale = ["mil", "sorgho", "mais"],
    prix_tonne = [180000, 175000, 160000]  # FCFA
)

# Calcul des revenus par province
df_revenus = @chain df_cereales_bf begin
    select(:province, :region, :production_mil, :production_sorgho, :production_mais)
    @transform(
        :revenu_mil = :production_mil * 180000,
        :revenu_sorgho = :production_sorgho * 175000,
        :revenu_mais = :production_mais * 160000
    )
    @transform(:revenu_total = :revenu_mil + :revenu_sorgho + :revenu_mais)
    sort(:revenu_total, rev=true)
end

println("💰 Top 3 des provinces par revenus agricoles :")
println(first(df_revenus[!, [:province, :revenu_total]], 3))
```

## 🎓 Bonnes Pratiques

### Performance
```julia
# Utiliser ! pour les modifications en place
sort!(df, :colonne)  # Plus rapide que df = sort(df, :colonne)

# Préallouer les vecteurs quand possible
n = nrow(df)
nouveau_vecteur = Vector{Float64}(undef, n)

# Utiliser view() pour éviter les copies
vue_donnees = @view df[1:100, :]
```

### Code lisible
```julia
# Utiliser des noms de colonnes explicites
df_propre = @chain df_brut begin
    @select(:region, :production_2023 = :prod, :superficie = :sup)
    @filter(:production_2023 > 1000)
    @arrange(:production_2023)
end
```

### Validation des données
```julia
function valider_donnees_production(df::DataFrame)
    # Vérifier que toutes les productions sont positives
    @assert all(df.production .>= 0) "Production négative détectée"
    
    # Vérifier l'absence de valeurs manquantes critiques
    @assert !any(ismissing.(df.region)) "Régions manquantes détectées"
    
    println("✅ Données validées avec succès")
end
```

## 📚 Ressources Supplémentaires

### Packages complémentaires
- **DataFramesMeta.jl** : Syntaxe simplifiée pour la manipulation
- **Query.jl** : Requêtes LINQ-style
- **Pipe.jl** : Chaînage d'opérations
- **FreqTables.jl** : Tables de fréquences
- **StatsBase.jl** : Statistiques descriptives

### Formats de données supportés
- CSV, TSV (délimités)
- Excel (.xlsx, .xls)
- JSON, XML
- Feather, Parquet (formats binaires)
- Bases de données SQL

## 🏆 Points Clés à Retenir
1. **DataFrames.jl** est l'outil principal pour l'analyse de données en Julia
2. Les opérations peuvent être **chaînées** pour plus de lisibilité
3. Utilisez **groupby/combine** pour les analyses par groupes
4. Les **jointures** permettent de combiner plusieurs sources
5. Toujours **valider et nettoyer** les données avant l'analyse
6. Les **performances** sont importantes : utilisez `!` et `@view`

Dans la prochaine session, nous verrons comment visualiser ces données avec Plots.jl pour créer des graphiques informatifs sur nos analyses agricoles et économiques !