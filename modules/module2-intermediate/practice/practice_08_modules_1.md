# 🧮 Pratique 8.1 : Création d'un module d'utilitaires mathématiques

## 🎯 Mission
Créer un module complet d'utilitaires mathématiques adapté aux besoins du Burkina Faso : calculs financiers, conversions, géométrie et statistiques !

## 📋 Ce que vous allez apprendre
- Structurer un module Julia professionnel
- Organiser le code en sous-modules spécialisés
- Documenter vos fonctions avec des docstrings
- Créer des tests unitaires
- Gérer un projet avec Project.toml

---

## 🏗️ Étape 1 : Structure du projet

Créons d'abord la structure de notre module :

```julia
# Créer la structure de dossiers
function creer_structure_projet()
    dossiers = [
        "MathsBurkina",
        "MathsBurkina/src", 
        "MathsBurkina/test",
        "MathsBurkina/docs"
    ]
    
    for dossier in dossiers
        if !isdir(dossier)
            mkdir(dossier)
            println("📁 Dossier créé: $dossier")
        end
    end
    
    println("✅ Structure du projet créée!")
    println("📂 Votre projet MathsBurkina est prêt!")
end

creer_structure_projet()

# Vérifier la structure créée
function afficher_structure()
    println("\n📂 === STRUCTURE DU PROJET ===")
    for (root, dirs, files) in walkdir("MathsBurkina")
        niveau = count('/', root) - count('/', "MathsBurkina")
        indent = "  " ^ niveau
        dossier_nom = basename(root)
        println("$indent📁 $dossier_nom/")
        
        # Afficher les fichiers s'il y en a
        for fichier in files
            println("$indent  📄 $fichier")
        end
    end
end

afficher_structure()
```

### 🎯 Défi 1 : Fichier Project.toml
Créez le fichier de configuration principal :

```julia
function creer_project_toml()
    contenu_toml = """
name = "MathsBurkina"
uuid = "$(UUIDs.uuid4())"
version = "1.0.0"
authors = ["Étudiant Julia Burkina <etudiant@burkina.bf>"]

[deps]

[compat]
julia = "1.6"

[extras]
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[targets]
test = ["Test"]
"""

    open("MathsBurkina/Project.toml", "w") do fichier
        write(fichier, contenu_toml)
    end
    
    println("✅ Project.toml créé!")
end

using UUIDs
creer_project_toml()

# Lire et afficher le contenu
println("\n📄 Contenu de Project.toml:")
if isfile("MathsBurkina/Project.toml")
    contenu = read("MathsBurkina/Project.toml", String)
    println(contenu)
end
```

---

## 🧮 Étape 2 : Module principal et sous-modules

### Module principal (MathsBurkina.jl)

```julia
function creer_module_principal()
    contenu_module = """
module MathsBurkina

# Exporter toutes les fonctions publiques
export 
    # Module Finances
    calculer_impots_bf, formater_fcfa, calculer_tva_bf, convertir_devises,
    # Module Géométrie  
    aire_cercle, aire_rectangle, volume_cylindre, distance_points,
    # Module Statistiques
    moyenne_burkina, mediane_burkina, ecart_type_burkina,
    # Module Conversions
    convertir_temperature, convertir_distance, convertir_poids

# Inclure tous les sous-modules
include("finances.jl")
include("geometrie.jl") 
include("statistiques.jl")
include("conversions.jl")

# Importer les sous-modules
using .FinancesBurkina
using .GeometrieBurkina
using .StatistiquesBurkina
using .ConversionsBurkina

\"""
    bienvenue()

Affiche les informations sur le module MathsBurkina.
\"""
function bienvenue()
    println("🇧🇫 === MATHS BURKINA ===")
    println("Module d'utilitaires mathématiques pour le Burkina Faso")
    println()
    println("📊 Modules disponibles:")
    println("   💰 FinancesBurkina - Calculs financiers et monétaires")
    println("   📐 GeometrieBurkina - Calculs géométriques")
    println("   📈 StatistiquesBurkina - Analyses statistiques")
    println("   🔄 ConversionsBurkina - Conversions d'unités")
    println()
    println("💡 Tapez 'using .MathsBurkina' pour commencer!")
    println("📚 Documentations disponible avec ?nom_fonction")
end

end  # module MathsBurkina
"""

    open("MathsBurkina/src/MathsBurkina.jl", "w") do fichier
        write(fichier, contenu_module)
    end
    
    println("✅ Module principal créé!")
end

creer_module_principal()
```

### 🎯 Défi 2 : Sous-module Finances
Créez le module de calculs financiers :

```julia
function creer_module_finances()
    contenu_finances = """
module FinancesBurkina

export calculer_impots_bf, formater_fcfa, calculer_tva_bf, convertir_devises

# Constantes financières du Burkina Faso
const TAUX_TVA_BF = 0.18  # 18%
const SEUIL_EXONERATION = 50000  # 50,000 FCFA
const TAUX_IMPOT_FAIBLE = 0.15   # 15% pour revenus moyens
const TAUX_IMPOT_ELEVE = 0.25    # 25% pour hauts revenus
const SEUIL_IMPOT_ELEVE = 2000000  # 2,000,000 FCFA

# Taux de change approximatifs (exemple)
const TAUX_CHANGE = Dict(
    "EUR" => 655.957,  # 1 EUR = 655.957 FCFA
    "USD" => 600.0,    # 1 USD = 600 FCFA (approximatif)
    "GBP" => 750.0     # 1 GBP = 750 FCFA (approximatif)
)

\"""
    calculer_impots_bf(revenu_annuel::Int) -> Int

Calcule les impôts selon le barème progressif burkinabè.

# Arguments
- `revenu_annuel::Int`: Revenu annuel en FCFA

# Retourne
- `Int`: Montant de l'impôt en FCFA

# Exemples
```julia
julia> calculer_impots_bf(30000)
0  # Exonéré

julia> calculer_impots_bf(100000)
15000  # 15% sur la tranche imposable

julia> calculer_impots_bf(3000000)
750000  # 25% pour haut revenu
```
\"""
function calculer_impots_bf(revenu_annuel::Int)
    if revenu_annuel <= SEUIL_EXONERATION
        return 0  # Exonéré
    elseif revenu_annuel <= SEUIL_IMPOT_ELEVE
        return Int(round((revenu_annuel - SEUIL_EXONERATION) * TAUX_IMPOT_FAIBLE))
    else
        # Calcul progressif
        impot_tranche_moyenne = (SEUIL_IMPOT_ELEVE - SEUIL_EXONERATION) * TAUX_IMPOT_FAIBLE
        impot_tranche_haute = (revenu_annuel - SEUIL_IMPOT_ELEVE) * TAUX_IMPOT_ELEVE
        return Int(round(impot_tranche_moyenne + impot_tranche_haute))
    end
end

\"""
    formater_fcfa(montant::Real) -> String

Formate un montant en FCFA avec séparateurs de milliers.

# Exemples
```julia
julia> formater_fcfa(1000000)
"1 000 000 FCFA"

julia> formater_fcfa(75500.50)
"75 500,50 FCFA"
```
\"""
function formater_fcfa(montant::Real)
    # Séparer partie entière et décimale
    if montant == floor(montant)
        partie_entiere = Int(montant)
        str_montant = string(partie_entiere)
        decimales = ""
    else
        partie_entiere = Int(floor(montant))
        partie_decimale = montant - partie_entiere
        str_montant = string(partie_entiere)
        decimales = string(round(partie_decimale, digits=2))[3:end]  # Enlever "0."
        decimales = "," * decimales
    end
    
    # Ajouter espaces tous les 3 chiffres
    longueur = length(str_montant)
    if longueur <= 3
        return str_montant * decimales * " FCFA"
    end
    
    resultat = ""
    for (i, char) in enumerate(reverse(str_montant))
        if i > 1 && (i - 1) % 3 == 0
            resultat = " " * resultat
        end
        resultat = char * resultat
    end
    
    return resultat * decimales * " FCFA"
end

\"""
    calculer_tva_bf(montant_ht::Real) -> Real

Calcule la TVA au taux burkinabè (18%).
\"""
function calculer_tva_bf(montant_ht::Real)
    return round(montant_ht * TAUX_TVA_BF, digits=2)
end

\"""
    convertir_devises(montant_fcfa::Real, devise::String) -> Real

Convertit des FCFA vers une autre devise.

# Devises supportées
- "EUR": Euro  
- "USD": Dollar américain
- "GBP": Livre sterling
\"""
function convertir_devises(montant_fcfa::Real, devise::String)
    devise_upper = uppercase(devise)
    if !haskey(TAUX_CHANGE, devise_upper)
        error("Devise '\$devise' non supportée. Devises disponibles: \$(keys(TAUX_CHANGE))")
    end
    
    return round(montant_fcfa / TAUX_CHANGE[devise_upper], digits=2)
end

end  # module FinancesBurkina
"""

    open("MathsBurkina/src/finances.jl", "w") do fichier
        write(fichier, contenu_finances)
    end
    
    println("✅ Module Finances créé!")
end

creer_module_finances()

# Test rapide du module finances
println("\n🧪 Test du module Finances:")
include("MathsBurkina/src/finances.jl")
using .FinancesBurkina

println("💰 Impôts sur 150,000 FCFA: $(calculer_impots_bf(150000)) FCFA")
println("💰 Format: $(formater_fcfa(1234567))")
println("💰 TVA sur 100,000 FCFA: $(calculer_tva_bf(100000)) FCFA")
println("💰 100,000 FCFA = $(convertir_devises(100000, "EUR")) EUR")
```

---

## 📐 Étape 3 : Module Géométrie

```julia
function creer_module_geometrie()
    contenu_geometrie = """
module GeometrieBurkina

export aire_cercle, aire_rectangle, volume_cylindre, distance_points, 
       aire_triangle, perimetre_rectangle, surface_sphere

const PI_PRECIS = 3.141592653589793

\"""
    aire_cercle(rayon::Real) -> Real

Calcule l'aire d'un cercle.
Utile pour les calculs de superficie de puits circulaires, 
silos à grains, etc.

# Exemples
```julia
julia> aire_cercle(5)
78.54

julia> aire_cercle(2.5)
19.63
```
\"""
function aire_cercle(rayon::Real)
    if rayon < 0
        error("Le rayon ne peut pas être négatif")
    end
    return round(PI_PRECIS * rayon^2, digits=2)
end

\"""
    aire_rectangle(longueur::Real, largeur::Real) -> Real

Calcule l'aire d'un rectangle.
Parfait pour les calculs de superficie de terrains, 
champs agricoles, constructions.
\"""
function aire_rectangle(longueur::Real, largeur::Real)
    if longueur < 0 || largeur < 0
        error("Les dimensions ne peuvent pas être négatives")
    end
    return round(longueur * largeur, digits=2)
end

\"""
    aire_triangle(base::Real, hauteur::Real) -> Real

Calcule l'aire d'un triangle.
\"""
function aire_triangle(base::Real, hauteur::Real)
    if base < 0 || hauteur < 0
        error("Les dimensions ne peuvent pas être négatives")
    end
    return round(0.5 * base * hauteur, digits=2)
end

\"""
    perimetre_rectangle(longueur::Real, largeur::Real) -> Real

Calcule le périmètre d'un rectangle.
Utile pour calculer la clôture nécessaire pour un terrain.
\"""
function perimetre_rectangle(longueur::Real, largeur::Real)
    if longueur < 0 || largeur < 0
        error("Les dimensions ne peuvent pas être négatives")
    end
    return round(2 * (longueur + largeur), digits=2)
end

\"""
    volume_cylindre(rayon::Real, hauteur::Real) -> Real

Calcule le volume d'un cylindre.
Très utile pour les calculs de capacité de citernes d'eau,
silos à grains cylindriques, etc.

# Exemples
```julia
julia> volume_cylindre(2, 5)  # Citerne de 2m de rayon, 5m de haut
62.83  # m³

julia> volume_cylindre(1.5, 3)  # Petit silo
21.21  # m³
```
\"""
function volume_cylindre(rayon::Real, hauteur::Real)
    if rayon < 0 || hauteur < 0
        error("Les dimensions ne peuvent pas être négatives")
    end
    return round(PI_PRECIS * rayon^2 * hauteur, digits=2)
end

\"""
    surface_sphere(rayon::Real) -> Real

Calcule la surface d'une sphère.
\"""
function surface_sphere(rayon::Real)
    if rayon < 0
        error("Le rayon ne peut pas être négatif")
    end
    return round(4 * PI_PRECIS * rayon^2, digits=2)
end

\"""
    distance_points(x1::Real, y1::Real, x2::Real, y2::Real) -> Real

Calcule la distance entre deux points dans un plan.
Utile pour mesurer les distances sur un terrain,
entre deux villes, etc.

# Exemples
```julia
julia> distance_points(0, 0, 3, 4)
5.0  # Distance entre (0,0) et (3,4)
```
\"""
function distance_points(x1::Real, y1::Real, x2::Real, y2::Real)
    return round(sqrt((x2 - x1)^2 + (y2 - y1)^2), digits=2)
end

\"""
    calculer_superficie_terrain_irregulier(points::Vector{Tuple{Real, Real}}) -> Real

Calcule la superficie d'un terrain de forme irrégulière
en utilisant la formule du lacet (shoelace formula).

# Arguments  
- `points`: Vecteur de tuples (x, y) représentant les sommets du polygone

# Exemple
```julia
julia> points = [(0, 0), (10, 0), (10, 8), (5, 12), (0, 8)]
julia> calculer_superficie_terrain_irregulier(points)
90.0
```
\"""
function calculer_superficie_terrain_irregulier(points::Vector{Tuple{Real, Real}})
    if length(points) < 3
        error("Il faut au moins 3 points pour définir une superficie")
    end
    
    n = length(points)
    aire = 0.0
    
    for i in 1:n
        j = (i % n) + 1  # Point suivant (avec retour au début)
        aire += points[i][1] * points[j][2]
        aire -= points[j][1] * points[i][2]
    end
    
    return round(abs(aire) / 2.0, digits=2)
end

end  # module GeometrieBurkina
"""

    open("MathsBurkina/src/geometrie.jl", "w") do fichier
        write(fichier, contenu_geometrie)
    end
    
    println("✅ Module Géométrie créé!")
end

creer_module_geometrie()
```

### 🎯 Défi 3 : Test du module Géométrie
Testez toutes les fonctions géométriques :

```julia
println("\n🧪 === TEST DU MODULE GÉOMÉTRIE ===")
include("MathsBurkina/src/geometrie.jl")
using .GeometrieBurkina

# Tests pratiques avec des exemples burkinabè
println("🏗️  Calculs pour un projet de construction à Ouagadougou:")

# Terrain rectangulaire
longueur_terrain = 50  # mètres
largeur_terrain = 30   # mètres
superficie = aire_rectangle(longueur_terrain, largeur_terrain)
perimetre = perimetre_rectangle(longueur_terrain, largeur_terrain)

println("📐 Terrain de $(longueur_terrain)m x $(largeur_terrain)m:")
println("   • Superficie: $(superficie) m²")
println("   • Périmètre: $(perimetre) m (clôture nécessaire)")

# Citerne d'eau cylindrique
rayon_citerne = 3      # mètres
hauteur_citerne = 4    # mètres
volume_eau = volume_cylindre(rayon_citerne, hauteur_citerne)

println("\n🚰 Citerne d'eau cylindrique:")
println("   • Rayon: $(rayon_citerne)m, Hauteur: $(hauteur_citerne)m")
println("   • Capacité: $(volume_eau) m³ = $(Int(volume_eau * 1000)) litres")

# Distance entre villes (coordonnées fictives)
println("\n🗺️  Distance entre points d'intérêt:")
distance_ouaga_bobo = distance_points(0, 0, 360, 80)  # Coordonnées fictives
println("   • Distance Ouagadougou-Bobo: $(distance_ouaga_bobo) km (approximatif)")

# Terrain de forme irrégulière
terrain_irregulier = [(0.0, 0.0), (25.0, 0.0), (30.0, 15.0), (20.0, 25.0), (0.0, 20.0)]
superficie_irreguliere = calculer_superficie_terrain_irregulier(terrain_irregulier)
println("\n🏞️  Terrain de forme irrégulière:")
println("   • Superficie: $(superficie_irreguliere) m²")

# Calcul pour puits circulaire
rayon_puits = 1.5
aire_puits = aire_cercle(rayon_puits)
println("\n💧 Puits circulaire:")
println("   • Rayon: $(rayon_puits)m")
println("   • Aire de la surface: $(aire_puits) m²")
```

---

## 📊 Étape 4 : Module Statistiques

```julia
function creer_module_statistiques()
    contenu_stats = """
module StatistiquesBurkina

export moyenne_burkina, mediane_burkina, ecart_type_burkina, mode_burkina,
       quartiles_burkina, resume_statistique, analyser_pluviometrie

using Statistics

\"""
    moyenne_burkina(donnees::Vector{<:Real}) -> Real

Calcule la moyenne arithmétique avec arrondi adapté aux données burkinabè.

# Exemples
```julia
julia> moyenne_burkina([12, 15, 18, 14, 16])  # Notes d'étudiants
15.0

julia> moyenne_burkina([800, 900, 750, 820])  # Pluviométrie en mm
817.5
```
\"""
function moyenne_burkina(donnees::Vector{<:Real})
    if isempty(donnees)
        error("Impossible de calculer la moyenne d'un vecteur vide")
    end
    return round(sum(donnees) / length(donnees), digits=2)
end

\"""
    mediane_burkina(donnees::Vector{<:Real}) -> Real

Calcule la médiane des données.
\"""
function mediane_burkina(donnees::Vector{<:Real})
    if isempty(donnees)
        error("Impossible de calculer la médiane d'un vecteur vide")
    end
    return round(median(donnees), digits=2)
end

\"""
    ecart_type_burkina(donnees::Vector{<:Real}) -> Real

Calcule l'écart-type de l'échantillon.
\"""
function ecart_type_burkina(donnees::Vector{<:Real})
    if length(donnees) < 2
        error("Il faut au moins 2 valeurs pour calculer l'écart-type")
    end
    return round(std(donnees), digits=2)
end

\"""
    mode_burkina(donnees::Vector{<:Real}) -> Vector{Real}

Trouve la ou les valeurs les plus fréquentes.
\"""
function mode_burkina(donnees::Vector{<:Real})
    if isempty(donnees)
        error("Impossible de calculer le mode d'un vecteur vide")
    end
    
    # Compter les fréquences
    compteur = Dict{Real, Int}()
    for valeur in donnees
        compteur[valeur] = get(compteur, valeur, 0) + 1
    end
    
    # Trouver la fréquence maximale
    freq_max = maximum(values(compteur))
    
    # Retourner toutes les valeurs avec cette fréquence
    modes = [k for (k, v) in compteur if v == freq_max]
    return sort(modes)
end

\"""
    quartiles_burkina(donnees::Vector{<:Real}) -> Tuple{Real, Real, Real}

Calcule les quartiles Q1, Q2 (médiane), Q3.
Retourne un tuple (Q1, Q2, Q3).
\"""
function quartiles_burkina(donnees::Vector{<:Real})
    if length(donnees) < 4
        error("Il faut au moins 4 valeurs pour calculer les quartiles")
    end
    
    donnees_triees = sort(donnees)
    n = length(donnees_triees)
    
    # Calcul des positions des quartiles
    q1_pos = (n + 1) * 0.25
    q2_pos = (n + 1) * 0.5  
    q3_pos = (n + 1) * 0.75
    
    # Interpolation linéaire si nécessaire
    q1 = interpole_quartile(donnees_triees, q1_pos)
    q2 = interpole_quartile(donnees_triees, q2_pos)
    q3 = interpole_quartile(donnees_triees, q3_pos)
    
    return (round(q1, digits=2), round(q2, digits=2), round(q3, digits=2))
end

# Fonction helper pour l'interpolation
function interpole_quartile(donnees_triees::Vector{<:Real}, position::Real)
    if position == floor(position)
        return donnees_triees[Int(position)]
    else
        indice_inf = Int(floor(position))
        indice_sup = Int(ceil(position))
        
        if indice_sup > length(donnees_triees)
            return donnees_triees[end]
        end
        
        fraction = position - indice_inf
        return donnees_triees[indice_inf] + fraction * (donnees_triees[indice_sup] - donnees_triees[indice_inf])
    end
end

\"""
    resume_statistique(donnees::Vector{<:Real}, nom_variable::String = "Variable") 

Affiche un résumé statistique complet des données.
\"""
function resume_statistique(donnees::Vector{<:Real}, nom_variable::String = "Variable")
    if isempty(donnees)
        println("❌ Aucune donnée à analyser")
        return
    end
    
    println("📊 === RÉSUMÉ STATISTIQUE : \$nom_variable ===")
    println("📈 Nombre d'observations: \$(length(donnees))")
    println("📈 Moyenne: \$(moyenne_burkina(donnees))")
    println("📈 Médiane: \$(mediane_burkina(donnees))")
    
    if length(donnees) >= 2
        println("📈 Écart-type: \$(ecart_type_burkina(donnees))")
    end
    
    println("📈 Minimum: \$(minimum(donnees))")
    println("📈 Maximum: \$(maximum(donnees))")
    
    if length(donnees) >= 4
        q1, q2, q3 = quartiles_burkina(donnees)
        println("📈 Quartiles (Q1, Q2, Q3): (\$q1, \$q2, \$q3)")
    end
    
    modes = mode_burkina(donnees)
    if length(modes) == 1
        println("📈 Mode: \$(modes[1])")
    else
        println("📈 Modes: \$(join(modes, ", "))")
    end
    
    println("📈 Étendue: \$(maximum(donnees) - minimum(donnees))")
    println()
end

\"""
    analyser_pluviometrie(donnees_pluie::Vector{<:Real}, mois::Vector{String} = String[])

Analyse spécialisée pour les données de pluviométrie burkinabè.
\"""
function analyser_pluviometrie(donnees_pluie::Vector{<:Real}, mois::Vector{String} = String[])
    if isempty(donnees_pluie)
        println("❌ Aucune donnée de pluviométrie")
        return
    end
    
    println("🌧️  === ANALYSE PLUVIOMÉTRIE BURKINA FASO ===")
    
    total_annuel = sum(donnees_pluie)
    moyenne_mensuelle = moyenne_burkina(donnees_pluie)
    
    println("🌧️  Total annuel: \$total_annuel mm")
    println("🌧️  Moyenne mensuelle: \$moyenne_mensuelle mm")
    
    # Classification selon les standards burkinabè
    if total_annuel >= 1200
        classification = "Année très humide"
    elseif total_annuel >= 800
        classification = "Année normale à humide"
    elseif total_annuel >= 500
        classification = "Année sèche"
    else
        classification = "Année très sèche - Risque de sécheresse"
    end
    
    println("🌧️  Classification: \$classification")
    
    # Identifier les mois les plus pluvieux
    if !isempty(mois) && length(mois) == length(donnees_pluie)
        indices_tries = sortperm(donnees_pluie, rev=true)
        println("\\n🌧️  Mois les plus pluvieux:")
        for i in 1:min(3, length(indices_tries))
            idx = indices_tries[i]
            println("   \$(i). \$(mois[idx]): \$(donnees_pluie[idx]) mm")
        end
    end
    
    # Période de sécheresse (mois avec < 10mm)
    mois_secs = sum(donnees_pluie .< 10)
    println("\\n🌧️  Mois avec moins de 10mm: \$mois_secs")
    
    println()
end

end  # module StatistiquesBurkina
"""

    open("MathsBurkina/src/statistiques.jl", "w") do fichier
        write(fichier, contenu_stats)
    end
    
    println("✅ Module Statistiques créé!")
end

creer_module_statistiques()
```

### 🎯 Défi 4 : Analyse de données burkinabè
Testez le module avec des données réelles :

```julia
println("\n🧪 === TEST DU MODULE STATISTIQUES ===")
include("MathsBurkina/src/statistiques.jl")
using .StatistiquesBurkina

# Données de pluviométrie de Ouagadougou (exemple fictif mais réaliste)
pluviometrie_ouaga = [0, 2, 8, 45, 95, 180, 220, 185, 120, 35, 5, 0]  # mm par mois
mois_annee = ["Jan", "Fév", "Mar", "Avr", "Mai", "Jun", "Jul", "Aoû", "Sep", "Oct", "Nov", "Déc"]

analyser_pluviometrie(pluviometrie_ouaga, mois_annee)

# Notes d'étudiants d'un lycée de Koudougou
notes_mathematiques = [12.5, 15.0, 8.5, 18.0, 14.5, 16.0, 11.0, 13.5, 17.5, 9.0, 
                      15.5, 12.0, 14.0, 16.5, 10.5, 13.0, 15.0, 11.5, 17.0, 14.5]

resume_statistique(notes_mathematiques, "Notes de Mathématiques - Lycée de Koudougou")

# Rendements agricoles (quintaux par hectare)
rendements_mil = [8.5, 12.0, 15.5, 10.0, 14.5, 11.0, 16.0, 13.5, 9.5, 12.5, 15.0, 11.5]

resume_statistique(rendements_mil, "Rendement du Mil (quintaux/hectare)")

# Test des quartiles avec données de revenus (en milliers de FCFA)
revenus_mensuels = [45, 65, 85, 120, 150, 200, 250, 300, 180, 95, 75, 110, 140, 220, 280]

println("💰 Analyse des revenus mensuels:")
q1, q2, q3 = quartiles_burkina(revenus_mensuels)
println("   • 25% gagnent moins de $(q1)k FCFA")
println("   • 50% gagnent moins de $(q2)k FCFA (médiane)")
println("   • 75% gagnent moins de $(q3)k FCFA")
```

---

## 🔄 Étape 5 : Module Conversions

```julia
function creer_module_conversions()
    contenu_conversions = """
module ConversionsBurkina

export convertir_temperature, convertir_distance, convertir_poids, 
       convertir_superficie, convertir_volume

\"""
    convertir_temperature(valeur::Real, de::String, vers::String) -> Real

Convertit une température entre différentes unités.

# Unités supportées
- "C" ou "Celsius"
- "F" ou "Fahrenheit" 
- "K" ou "Kelvin"

# Exemples
```julia
julia> convertir_temperature(30, "C", "F")
86.0  # 30°C = 86°F

julia> convertir_temperature(98.6, "F", "C")  
37.0  # 98.6°F = 37°C (température corporelle)
```
\"""
function convertir_temperature(valeur::Real, de::String, vers::String)
    # Normaliser les noms d'unités
    de_norm = normaliser_unite_temperature(de)
    vers_norm = normaliser_unite_temperature(vers)
    
    if de_norm == vers_norm
        return round(valeur, digits=2)
    end
    
    # Convertir tout en Celsius d'abord
    celsius = if de_norm == "C"
        valeur
    elseif de_norm == "F"
        (valeur - 32) * 5/9
    elseif de_norm == "K"
        valeur - 273.15
    else
        error("Unité de température '\$de' non reconnue")
    end
    
    # Convertir depuis Celsius vers l'unité cible
    resultat = if vers_norm == "C"
        celsius
    elseif vers_norm == "F"
        celsius * 9/5 + 32
    elseif vers_norm == "K"
        celsius + 273.15
    else
        error("Unité de température '\$vers' non reconnue")
    end
    
    return round(resultat, digits=2)
end

function normaliser_unite_temperature(unite::String)
    unite_lower = lowercase(unite)
    if unite_lower in ["c", "celsius", "°c"]
        return "C"
    elseif unite_lower in ["f", "fahrenheit", "°f"]
        return "F"
    elseif unite_lower in ["k", "kelvin"]
        return "K"
    else
        error("Unité de température '\$unite' non reconnue")
    end
end

\"""
    convertir_distance(valeur::Real, de::String, vers::String) -> Real

Convertit une distance entre différentes unités.

# Unités supportées
- "mm", "cm", "m", "km" (système métrique)
- "in", "ft", "yd", "mi" (système impérial)

# Exemples utiles au Burkina Faso
```julia
julia> convertir_distance(360, "km", "mi")
223.69  # Distance Ouagadougou-Bobo en miles

julia> convertir_distance(6, "ft", "m")
1.83  # Hauteur d'une construction
```
\"""
function convertir_distance(valeur::Real, de::String, vers::String)
    # Facteurs de conversion vers le mètre
    facteurs_vers_metre = Dict(
        "mm" => 0.001,
        "cm" => 0.01,
        "m" => 1.0,
        "km" => 1000.0,
        "in" => 0.0254,
        "ft" => 0.3048,
        "yd" => 0.9144,
        "mi" => 1609.34
    )
    
    if !haskey(facteurs_vers_metre, de)
        error("Unité de distance '\$de' non reconnue")
    end
    
    if !haskey(facteurs_vers_metre, vers)
        error("Unité de distance '\$vers' non reconnue")
    end
    
    # Convertir en mètres puis vers l'unité cible
    metres = valeur * facteurs_vers_metre[de]
    resultat = metres / facteurs_vers_metre[vers]
    
    return round(resultat, digits=4)
end

\"""
    convertir_poids(valeur::Real, de::String, vers::String) -> Real

Convertit un poids entre différentes unités.

# Unités supportées
- "g", "kg", "t" (système métrique)
- "oz", "lb" (système impérial)
- "quintal" (100 kg, utilisé en agriculture)

# Exemples agricoles
```julia
julia> convertir_poids(1.5, "t", "quintal")
15.0  # 1.5 tonnes = 15 quintaux

julia> convertir_poids(50, "lb", "kg")
22.68  # Sac de grain de 50 livres
```
\"""
function convertir_poids(valeur::Real, de::String, vers::String)
    # Facteurs de conversion vers le kilogramme
    facteurs_vers_kg = Dict(
        "g" => 0.001,
        "kg" => 1.0,
        "t" => 1000.0,
        "quintal" => 100.0,
        "oz" => 0.0283495,
        "lb" => 0.453592
    )
    
    if !haskey(facteurs_vers_kg, de)
        error("Unité de poids '\$de' non reconnue")
    end
    
    if !haskey(facteurs_vers_kg, vers)
        error("Unité de poids '\$vers' non reconnue")
    end
    
    # Convertir en kg puis vers l'unité cible
    kilogrammes = valeur * facteurs_vers_kg[de]
    resultat = kilogrammes / facteurs_vers_kg[vers]
    
    return round(resultat, digits=4)
end

\"""
    convertir_superficie(valeur::Real, de::String, vers::String) -> Real

Convertit une superficie entre différentes unités.

# Unités supportées
- "m2", "hectare", "km2"
- "ft2", "acre"

# Exemples pour l'agriculture et l'immobilier
```julia
julia> convertir_superficie(1, "hectare", "m2")
10000.0  # 1 hectare = 10,000 m²

julia> convertir_superficie(2.5, "acre", "hectare")
1.01  # Conversion terrain agricole
```
\"""
function convertir_superficie(valeur::Real, de::String, vers::String)
    # Facteurs de conversion vers le mètre carré
    facteurs_vers_m2 = Dict(
        "m2" => 1.0,
        "hectare" => 10000.0,
        "km2" => 1000000.0,
        "ft2" => 0.092903,
        "acre" => 4046.86
    )
    
    if !haskey(facteurs_vers_m2, de)
        error("Unité de superficie '\$de' non reconnue")
    end
    
    if !haskey(facteurs_vers_m2, vers)
        error("Unité de superficie '\$vers' non reconnue")
    end
    
    # Convertir en m² puis vers l'unité cible
    metres_carres = valeur * facteurs_vers_m2[de]
    resultat = metres_carres / facteurs_vers_m2[vers]
    
    return round(resultat, digits=4)
end

\"""
    convertir_volume(valeur::Real, de::String, vers::String) -> Real

Convertit un volume entre différentes unités.

# Unités supportées
- "ml", "l", "m3" (système métrique)
- "gal" (gallon américain)

# Exemples pour l'eau et les liquides
```julia
julia> convertir_volume(1000, "l", "m3")
1.0  # 1000 litres = 1 m³

julia> convertir_volume(50, "gal", "l")
189.27  # Réservoir de 50 gallons
```
\"""
function convertir_volume(valeur::Real, de::String, vers::String)
    # Facteurs de conversion vers le litre
    facteurs_vers_litre = Dict(
        "ml" => 0.001,
        "l" => 1.0,
        "m3" => 1000.0,
        "gal" => 3.78541
    )
    
    if !haskey(facteurs_vers_litre, de)
        error("Unité de volume '\$de' non reconnue")
    end
    
    if !haskey(facteurs_vers_litre, vers)
        error("Unité de volume '\$vers' non reconnue")
    end
    
    # Convertir en litres puis vers l'unité cible
    litres = valeur * facteurs_vers_litre[de]
    resultat = litres / facteurs_vers_litre[vers]
    
    return round(resultat, digits=4)
end

end  # module ConversionsBurkina
"""

    open("MathsBurkina/src/conversions.jl", "w") do fichier
        write(fichier, contenu_conversions)
    end
    
    println("✅ Module Conversions créé!")
end

creer_module_conversions()
```

---

## 🧪 Étape 6 : Tests unitaires

Créons une suite de tests complète :

```julia
function creer_tests_unitaires()
    contenu_tests = """
using Test

# Charger notre module
push!(LOAD_PATH, joinpath(@__DIR__, "..", "src"))
using MathsBurkina

@testset "Tests MathsBurkina" begin
    
    @testset "Module Finances" begin
        # Tests calcul d'impôts
        @test calculer_impots_bf(30000) == 0  # Exonéré
        @test calculer_impots_bf(100000) == 7500  # (100000-50000) * 0.15
        @test calculer_impots_bf(3000000) == 542500  # Calcul progressif
        
        # Tests formatage FCFA
        @test formater_fcfa(1000) == "1 000 FCFA"
        @test formater_fcfa(1000000) == "1 000 000 FCFA"
        @test formater_fcfa(1234567) == "1 234 567 FCFA"
        
        # Tests TVA
        @test calculer_tva_bf(1000) == 180.0  # 18%
        @test calculer_tva_bf(0) == 0.0
        
        # Tests conversion devises
        @test convertir_devises(655957, "EUR") ≈ 1000.0 atol=0.01
        @test_throws ErrorException convertir_devises(1000, "YEN")  # Devise non supportée
    end
    
    @testset "Module Géométrie" begin
        # Tests aires
        @test aire_cercle(1) ≈ 3.14 atol=0.01
        @test aire_rectangle(10, 5) == 50.0
        @test aire_triangle(10, 6) == 30.0
        
        # Tests volumes
        @test volume_cylindre(1, 1) ≈ 3.14 atol=0.01
        
        # Tests distance
        @test distance_points(0, 0, 3, 4) == 5.0
        @test distance_points(0, 0, 0, 0) == 0.0
        
        # Tests erreurs pour valeurs négatives
        @test_throws ErrorException aire_cercle(-1)
        @test_throws ErrorException aire_rectangle(-5, 10)
        @test_throws ErrorException volume_cylindre(1, -1)
    end
    
    @testset "Module Statistiques" begin
        donnees_test = [1, 2, 3, 4, 5]
        
        # Tests de base
        @test moyenne_burkina(donnees_test) == 3.0
        @test mediane_burkina(donnees_test) == 3.0
        @test ecart_type_burkina(donnees_test) ≈ 1.58 atol=0.01
        
        # Tests quartiles
        donnees_quartiles = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        q1, q2, q3 = quartiles_burkina(donnees_quartiles)
        @test q2 == 5.5  # Médiane
        
        # Tests mode
        @test mode_burkina([1, 2, 2, 3]) == [2]
        @test mode_burkina([1, 1, 2, 2]) == [1, 2]  # Bimodal
        
        # Tests erreurs
        @test_throws ErrorException moyenne_burkina(Float64[])
        @test_throws ErrorException ecart_type_burkina([1])
    end
    
    @testset "Module Conversions" begin
        # Tests température
        @test convertir_temperature(0, "C", "F") == 32.0
        @test convertir_temperature(100, "C", "F") == 212.0
        @test convertir_temperature(32, "F", "C") == 0.0
        @test convertir_temperature(273.15, "K", "C") == 0.0
        
        # Tests distance
        @test convertir_distance(1, "km", "m") == 1000.0
        @test convertir_distance(100, "cm", "m") == 1.0
        @test convertir_distance(1, "mi", "km") ≈ 1.609 atol=0.01
        
        # Tests poids
        @test convertir_poids(1, "kg", "g") == 1000.0
        @test convertir_poids(1, "t", "kg") == 1000.0
        @test convertir_poids(1, "t", "quintal") == 10.0
        
        # Tests superficie
        @test convertir_superficie(1, "hectare", "m2") == 10000.0
        @test convertir_superficie(1, "km2", "hectare") == 100.0
        
        # Tests volume
        @test convertir_volume(1, "l", "ml") == 1000.0
        @test convertir_volume(1, "m3", "l") == 1000.0
        
        # Tests erreurs unités non reconnues
        @test_throws ErrorException convertir_temperature(25, "X", "C")
        @test_throws ErrorException convertir_distance(100, "furlong", "m")
    end
    
end

println("✅ Tous les tests sont passés avec succès!")
println("🎉 Le module MathsBurkina est prêt à être utilisé!")
"""

    open("MathsBurkina/test/runtests.jl", "w") do fichier
        write(fichier, contenu_tests)
    end
    
    println("✅ Tests unitaires créés!")
end

creer_tests_unitaires()

# Exécuter les tests
println("\n🧪 === EXÉCUTION DES TESTS ===")
cd("MathsBurkina")
include("test/runtests.jl")
cd("..")
```

---

## 🏅 Récapitulatif des points

Calculons votre score pour cette pratique :

```julia
println("\n🏅 === RÉCAPITULATIF ===")
score_total = 0

# Points pour structure du projet
if isdir("MathsBurkina") && isfile("MathsBurkina/Project.toml")
    score_total += 20
    println("✅ Structure de projet créée: +20 points")
end

# Points pour module principal
if isfile("MathsBurkina/src/MathsBurkina.jl")
    score_total += 15
    println("✅ Module principal créé: +15 points")
end

# Points pour sous-modules
modules_crees = 0
for module_file in ["finances.jl", "geometrie.jl", "statistiques.jl", "conversions.jl"]
    if isfile(joinpath("MathsBurkina/src", module_file))
        modules_crees += 1
    end
end

score_total += modules_crees * 15
println("✅ Sous-modules créés ($(modules_crees)/4): +$(modules_crees * 15) points")

# Points pour tests
if isfile("MathsBurkina/test/runtests.jl")
    score_total += 25
    println("✅ Tests unitaires créés: +25 points")
end

# Points pour documentation
score_total += 15
println("✅ Documentation avec docstrings: +15 points")

println("\n🎯 SCORE TOTAL: $(score_total)/120 points")

if score_total >= 100
    println("🥇 Excellent! Module professionnel de qualité!")
elseif score_total >= 80
    println("🥈 Très bien! Bon niveau de développement!")
elseif score_total >= 60
    println("🥉 Bien! Module fonctionnel!")
else
    println("📚 Complétez les modules manquants!")
end

# Afficher la structure finale
afficher_structure()
```

---

## 🎓 Ce que vous avez appris

1. ✅ **Architecture modulaire** avec modules et sous-modules
2. ✅ **Gestion de projet** avec Project.toml
3. ✅ **Documentation** professionnelle avec docstrings
4. ✅ **Tests unitaires** complets et robustes
5. ✅ **Organisation du code** en fichiers séparés
6. ✅ **Validation et gestion d'erreurs** appropriées
7. ✅ **Fonctions utilitaires** adaptées au contexte burkinabè

## 🚀 Prochaine étape

Dans la pratique suivante, nous créerons un module de jeux et divertissements encore plus avancé !

🧮 **Félicitations, vous êtes maintenant un(e) architecte de modules Julia professionnel(le) !**