# Exercice 9 : Projet d'Analyse Complète - Développement Socio-économique du Burkina Faso

## 🎯 Mission
Vous êtes analyste de données au Ministère de l'Économie et des Finances du Burkina Faso. Votre mission est de produire une analyse complète du développement socio-économique du pays pour appuyer les décisions de politique publique du Plan National de Développement Économique et Social (PNDES).

## 📋 Prérequis
```julia
using DataFrames
using CSV
using Statistics
using DataFramesMeta
using StatsBase
using Dates
```

## 🗂️ Datasets à Créer et Analyser

Vous devrez travailler avec 4 datasets interconnectés que vous créerez puis analyserez.

### Dataset 1: Données Économiques Régionales
```julia
# Créez ce dataset avec les données économiques par région
df_economie = DataFrame(
    region = ["Centre", "Hauts-Bassins", "Nord", "Est", "Boucle du Mouhoun", 
              "Centre-Est", "Sud-Ouest", "Sahel", "Centre-Nord", "Plateau Central",
              "Centre-Ouest", "Centre-Sud", "Cascades"],
    pib_milliards_fcfa = [2845.7, 1567.3, 987.2, 756.8, 1234.5, 
                         892.1, 634.9, 445.2, 678.3, 567.8,
                         723.4, 498.7, 423.1],
    secteur_primaire_pct = [15.2, 35.8, 65.3, 58.7, 72.1,
                           45.9, 68.4, 78.5, 69.2, 52.3,
                           61.7, 67.8, 71.2],
    secteur_secondaire_pct = [45.8, 28.7, 12.4, 15.8, 10.3,
                             18.9, 13.7, 8.2, 11.5, 19.7,
                             14.8, 12.1, 11.9],
    secteur_tertiaire_pct = [39.0, 35.5, 22.3, 25.5, 17.6,
                            35.2, 17.9, 13.3, 19.3, 28.0,
                            23.5, 20.1, 16.9],
    emploi_formel_milliers = [456.7, 234.8, 123.4, 98.7, 145.6,
                             167.8, 87.9, 45.6, 89.3, 134.5,
                             112.3, 76.8, 67.2],
    emploi_informel_milliers = [1234.5, 987.6, 876.5, 654.3, 765.4,
                               543.2, 432.1, 567.8, 678.9, 456.7,
                               567.8, 456.7, 345.6],
    revenus_moyens_fcfa = [2456000, 1876000, 987000, 1234000, 1345000,
                          1567000, 1123000, 876000, 1087000, 1456000,
                          1234000, 1098000, 1176000],
    taux_pauvrete_pct = [25.4, 38.7, 52.8, 48.3, 45.9,
                        41.2, 49.7, 58.4, 51.2, 43.6,
                        47.1, 50.3, 46.8],
    investissements_publics_milliards = [234.5, 145.6, 87.3, 67.8, 98.7,
                                        123.4, 76.5, 45.6, 67.8, 89.4,
                                        98.7, 65.4, 54.3]
)
```

### Dataset 2: Données d'Infrastructure et Services
```julia
# Dataset infrastructure et services publics
df_infrastructure = DataFrame(
    region = ["Centre", "Hauts-Bassins", "Nord", "Est", "Boucle du Mouhoun", 
              "Centre-Est", "Sud-Ouest", "Sahel", "Centre-Nord", "Plateau Central",
              "Centre-Ouest", "Centre-Sud", "Cascades"],
    routes_bitumees_km = [1245, 867, 456, 567, 678,
                         543, 432, 234, 345, 456,
                         567, 398, 345],
    routes_terre_km = [2345, 3456, 4567, 3789, 4123,
                      2987, 3654, 4876, 4321, 3456,
                      3789, 3987, 2876],
    hopitaux_regionaux = [8, 4, 2, 2, 3, 2, 2, 1, 2, 2, 2, 2, 1],
    centres_sante = [145, 98, 76, 65, 87, 67, 54, 43, 56, 67, 76, 54, 45],
    ecoles_primaires = [1245, 987, 765, 654, 789, 567, 456, 378, 467, 567, 645, 456, 378],
    ecoles_secondaires = [234, 178, 123, 98, 134, 87, 76, 54, 67, 89, 98, 67, 56],
    universites = [3, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0],
    banques_agences = [78, 45, 23, 18, 28, 19, 15, 8, 12, 16, 21, 13, 11],
    marches_publics = [89, 67, 45, 34, 52, 38, 29, 23, 31, 41, 46, 32, 27],
    acces_internet_pct = [78.4, 56.7, 23.4, 28.9, 34.5,
                         45.6, 32.1, 15.7, 26.8, 41.2,
                         38.9, 29.7, 31.5]
)
```

### Dataset 3: Données Agricoles et Environnementales
```julia
# Dataset agriculture et environnement
df_agri_env = DataFrame(
    region = ["Centre", "Hauts-Bassins", "Nord", "Est", "Boucle du Mouhoun", 
              "Centre-Est", "Sud-Ouest", "Sahel", "Centre-Nord", "Plateau Central",
              "Centre-Ouest", "Centre-Sud", "Cascades"],
    superficie_agricole_ha = [234567, 456789, 567890, 789012, 890123,
                             345678, 456789, 678901, 567890, 234567,
                             345678, 456789, 234567],
    production_cereales_tonnes = [145678, 234567, 198765, 176543, 287654,
                                 165432, 154321, 123456, 187654, 143210,
                                 176543, 154321, 132109],
    production_coton_tonnes = [12345, 45678, 8765, 6543, 23456,
                              9876, 7654, 3456, 5432, 4321,
                              6789, 5432, 3210],
    betail_bovins = [234567, 345678, 567890, 456789, 678901,
                    234567, 345678, 456789, 567890, 234567,
                    345678, 234567, 123456],
    forets_ha = [45678, 89012, 34567, 123456, 156789,
                67890, 234567, 12345, 78901, 89012,
                123456, 156789, 189012],
    aires_protegees_ha = [12345, 23456, 8901, 34567, 45678,
                         15678, 67890, 5678, 23456, 34567,
                         45678, 56789, 78901],
    acces_eau_agricole_pct = [67.8, 78.9, 45.6, 56.7, 72.3,
                             61.4, 58.9, 34.5, 48.7, 59.8,
                             64.5, 55.3, 69.7],
    degradation_sols_pct = [23.4, 18.7, 45.6, 38.9, 29.7,
                           34.5, 31.2, 52.3, 41.8, 28.9,
                           32.6, 37.4, 25.8],
    projets_environnement = [12, 8, 5, 6, 9, 7, 6, 4, 5, 8, 7, 6, 5]
)
```

### Dataset 4: Données Démographiques et Sociales
```julia
# Dataset démographie et social (utilisez les données des practices précédentes et enrichissez)
df_demo_social = DataFrame(
    region = ["Centre", "Hauts-Bassins", "Nord", "Est", "Boucle du Mouhoun", 
              "Centre-Est", "Sud-Ouest", "Sahel", "Centre-Nord", "Plateau Central",
              "Centre-Ouest", "Centre-Sud", "Cascades"],
    population_totale = [3285893, 1924812, 1567845, 1678923, 1987654,
                        1456789, 945123, 1234567, 1345678, 987654,
                        1123456, 876543, 567890],
    population_urbaine_pct = [73.5, 45.0, 23.4, 28.9, 34.5,
                             38.7, 32.1, 18.7, 25.6, 41.2,
                             35.8, 29.7, 53.4],
    taux_natalite = [42.3, 45.7, 48.9, 47.2, 46.8,
                    44.5, 47.8, 50.2, 49.1, 43.7,
                    46.2, 48.5, 44.9],
    taux_mortalite_infantile = [45.6, 52.8, 68.9, 61.3, 58.7,
                               49.8, 62.4, 72.5, 65.8, 47.3,
                               54.9, 63.7, 48.2],
    esperance_vie = [62.3, 59.8, 55.4, 57.2, 58.1,
                    60.5, 56.9, 53.7, 56.3, 61.8,
                    58.7, 55.8, 60.2],
    taux_alphabetisation = [78.4, 52.7, 28.9, 35.6, 41.3,
                           48.7, 34.5, 22.1, 31.8, 56.9,
                           43.2, 29.7, 49.8],
    acces_eau_potable_pct = [89.7, 67.8, 45.6, 52.3, 58.9,
                            61.4, 49.8, 34.5, 47.2, 72.6,
                            56.7, 43.9, 68.4],
    acces_sante_km = [2.3, 4.7, 8.9, 7.2, 6.5,
                     5.8, 7.8, 12.4, 9.1, 4.2,
                     6.7, 8.3, 5.1],
    scolarisation_primaire_pct = [94.5, 78.9, 56.7, 64.3, 71.2,
                                 73.8, 62.1, 48.9, 59.7, 81.4,
                                 68.5, 57.3, 76.8]
)
```

## 📊 Missions d'Analyse

### Mission 1: Diagnostic Économique Régional (25 points)

**A. Analyse de la Structure Économique**
1. Calculez le PIB par habitant pour chaque région
2. Identifiez les régions les plus industrialisées (fort % secteur secondaire)
3. Analysez la corrélation entre PIB et taux de pauvreté
4. Créez un classement des régions par performance économique globale

**B. Analyse de l'Emploi**
1. Calculez le taux d'emploi formel par région (emploi formel/population active estimée à 45% de la population)
2. Identifiez les régions avec le plus fort potentiel de formalisation de l'économie
3. Analysez la relation entre investissements publics et création d'emplois formels

```julia
# Votre code ici
# Exemple de démarrage :
transform!(df_economie, [:pib_milliards_fcfa, :population_totale] => 
    ((pib, pop) -> (pib .* 1_000_000_000) ./ pop) => :pib_par_habitant)
```

### Mission 2: Analyse des Infrastructures et Services (25 points)

**A. Évaluation de la Connectivité**
1. Calculez un indice de connectivité routière (routes bitumées/superficie approximative)
2. Analysez l'accès aux services financiers (banques par 100k habitants)
3. Évaluez la couverture sanitaire (population par centre de santé)

**B. Fracture Numérique**
1. Identifiez les régions en retard sur l'accès à Internet
2. Analysez la corrélation entre accès Internet et PIB par habitant
3. Estimez les besoins en infrastructure numérique

```julia
# Joignez les datasets et créez vos analyses
df_complet = leftjoin(df_economie, df_infrastructure, on=:region)
df_complet = leftjoin(df_complet, df_demo_social, on=:region)
```

### Mission 3: Sécurité Alimentaire et Durabilité (25 points)

**A. Productivité Agricole**
1. Calculez la productivité céréalière (tonnes/hectare) par région
2. Analysez la dépendance à l'agriculture de chaque région
3. Identifiez les régions vulnérables à l'insécurité alimentaire

**B. Durabilité Environnementale**
1. Calculez un indice de pression environnementale (dégradation sols + déforestation)
2. Analysez la couverture forestière par habitant
3. Évaluez l'efficacité des projets environnementaux

```julia
# Intégrez les données agricoles
df_complet = leftjoin(df_complet, df_agri_env, on=:region)

# Calculez la productivité
transform!(df_complet, [:production_cereales_tonnes, :superficie_agricole_ha] => 
    (/) => :productivite_cereales)
```

### Mission 4: Développement Humain et Social (25 points)

**A. Indice de Développement Humain Régional**
1. Créez un IDH simplifié basé sur : espérance de vie, alphabétisation, PIB/hab
2. Normalisez chaque indicateur (min-max scaling)
3. Calculez la moyenne géométrique des 3 dimensions

**B. Inégalités Régionales**
1. Analysez les écarts entre régions pour chaque indicateur
2. Identifiez les régions laissées pour compte
3. Proposez une typologie des régions (leader, émergente, fragile, critique)

```julia
# Fonction de normalisation
function normaliser_minmax(x)
    return (x .- minimum(x)) ./ (maximum(x) - minimum(x))
end

# Calcul IDH simplifié
transform!(df_complet,
    :esperance_vie => normaliser_minmax => :esp_vie_norm,
    :taux_alphabetisation => normaliser_minmax => :alpha_norm,
    :pib_par_habitant => normaliser_minmax => :pib_norm
)
```

## 🎯 Livrables Attendus

### 1. Tableau de Bord Exécutif
Créez un DataFrame résumé avec les indicateurs clés pour chaque région :
```julia
tableau_bord = @select(df_final, 
    :region,
    :pib_par_habitant,
    :taux_pauvrete_pct,
    :idh_regional,
    :productivite_cereales,
    :acces_eau_potable_pct,
    :taux_alphabetisation,
    :classement_general
)
```

### 2. Analyse des Corrélations
Identifiez les 5 corrélations les plus fortes entre indicateurs économiques et sociaux.

### 3. Régions Prioritaires
Identifiez et justifiez 3 régions prioritaires pour chaque type d'intervention :
- Développement économique
- Infrastructures sociales  
- Agriculture et environnement
- Réduction de la pauvreté

### 4. Scénarios de Développement
Pour chaque région, définissez :
- **Forces** (3 points forts)
- **Faiblesses** (3 défis principaux)  
- **Opportunités** (2 leviers de croissance)
- **Recommandations** (3 actions prioritaires)

## 🏆 Critères d'Évaluation

### Excellence Technique (40%)
- Maîtrise des fonctions DataFrames.jl
- Qualité du code (lisibilité, efficacité)
- Gestion appropriée des jointures et transformations
- Calculs statistiques corrects

### Qualité de l'Analyse (35%)
- Pertinence des indicateurs créés
- Profondeur des insights
- Cohérence de l'interprétation
- Identification des enjeux clés

### Recommandations Politiques (25%)
- Faisabilité des propositions
- Adaptation au contexte burkinabè
- Priorisation justifiée
- Vision stratégique

## 💡 Conseils pour Réussir

### Bonnes Pratiques Techniques
```julia
# Utilisez des noms de variables explicites
df_avec_indicateurs = @chain df_base begin
    @transform(:nouvelle_variable = calcul)
    @filter(condition)
    sort(:variable_tri, rev=true)
end

# Validez vos données
@assert all(df.variable .>= 0) "Valeurs négatives détectées"

# Documentez vos calculs
# Calcul de l'IDH : moyenne géométrique normalisée
```

### Stratégie d'Analyse
1. **Explorez** d'abord chaque dataset individuellement
2. **Joignez** progressivement les données
3. **Validez** la cohérence après chaque jointure
4. **Créez** des indicateurs composites graduellement
5. **Interprétez** les résultats dans le contexte local

### Contextualisation Burkina Faso
- Considérez la géographie (Sahel vs Sud plus humide)
- Intégrez les enjeux sécuritaires dans certaines régions
- Tenez compte des spécificités culturelles
- Référencez le PNDES et les ODD

## 🎓 Bonus (5 points supplémentaires)

Créez une fonction qui automatise le calcul d'un "Score de Vulnérabilité Régionale" combinant :
- Insécurité alimentaire
- Pauvreté
- Accès limité aux services
- Dégradation environnementale

```julia
function score_vulnerabilite(df::DataFrame)
    # Votre algorithme ici
    # Retourne un DataFrame avec le score par région
end
```

Bonne chance pour cette analyse complète ! Votre travail contribuera à éclairer les décisions pour le développement équitable du Burkina Faso 🇧🇫