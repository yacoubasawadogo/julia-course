# 🎯 Pratique Guidée 2: Dispatch Avancé et Performance
**Module 2 - Session 2** | **Durée: 25 minutes**

---

## 📋 Objectifs de cette Pratique

- Maîtriser les types paramétrés et Union types
- Optimiser les performances avec le dispatch
- Étendre les types existants avec de nouvelles méthodes
- Créer des interfaces robustes et extensibles

---

## ⚡ Exercice 1: Types Paramétrés pour l'Optimisation

### Types génériques avec paramètres:
```julia
# Type paramétré pour optimiser selon le type de données
struct Produit{T<:Real}
    nom::String
    prix::T
    quantite::Int
    taux_tva::Float64
end

# Constructeur avec TVA burkinabè par défaut
function Produit(nom::String, prix::T, quantite::Int) where T<:Real
    return Produit{T}(nom, prix, quantite, 0.18)  # 18% TVA au Burkina
end

# Multiple dispatch spécialisé selon le type de prix
function prix_unitaire_ttc(p::Produit{Int})
    # Optimisation pour entiers - calcul exact
    prix_ttc = p.prix + Int(round(p.prix * p.taux_tva))
    return prix_ttc
end

function prix_unitaire_ttc(p::Produit{Float64})
    # Gestion précise des flottants
    prix_ttc = p.prix * (1 + p.taux_tva)
    return round(prix_ttc, digits=2)
end

function total_commande(p::Produit{T}) where T<:Real
    # Méthode générique avec préservation du type
    prix_ttc = prix_unitaire_ttc(p)
    return T(prix_ttc * p.quantite)
end

# Tests avec différents types de prix
println("=== PRODUITS AVEC TYPES PARAMÉTRÉS ===")

# Prix entiers (marchés locaux)
riz_local = Produit("Riz du Sourou", 350, 25)
mil_rouge = Produit("Mil rouge", 180, 40)

# Prix avec décimales (produits manufacturés)
huile_raffinee = Produit("Huile végétale", 1250.75, 8)
savon_marseille = Produit("Savon", 275.50, 12)

produits = [riz_local, mil_rouge, huile_raffinee, savon_marseille]

for produit in produits
    prix_ttc = prix_unitaire_ttc(produit)
    total = total_commande(produit)
    
    println("$(produit.nom):")
    println("  Prix HT: $(produit.prix) FCFA")
    println("  Prix TTC: $prix_ttc FCFA")
    println("  Total commande: $total FCFA")
    println("  Type de prix: $(typeof(produit.prix))")
    println()
end
```

### Challenge interactif:
> **À vous:** "Créez un type paramétré `Stock{T}` pour gérer différents types de quantités (Int pour unités, Float64 pour kg/litres)"

```julia
# Solution attendue:
struct Stock{T<:Real}
    produit::String
    quantite::T
    unite::String
    seuil_alerte::T
end

function verifier_stock(stock::Stock{Int})
    if stock.quantite <= stock.seuil_alerte
        println("⚠️ Stock faible: $(stock.produit) ($(stock.quantite) $(stock.unite))")
    else
        println("✅ Stock OK: $(stock.produit) ($(stock.quantite) $(stock.unite))")
    end
end

function verifier_stock(stock::Stock{Float64})
    if stock.quantite <= stock.seuil_alerte
        println("⚠️ Stock faible: $(stock.produit) ($(stock.quantite) $(stock.unite))")
    else
        println("✅ Stock OK: $(stock.produit) ($(round(stock.quantite, digits=1)) $(stock.unite))")
    end
end

# Tests
stocks = [
    Stock("Téléphones", 5, "unités", 10),           # Int
    Stock("Essence", 45.7, "litres", 50.0)          # Float64
]

for stock in stocks
    verifier_stock(stock)
end
```

---

## 🔄 Exercice 2: Union Types et Gestion Flexible

### Types Union pour flexibilité:
```julia
# Union pour gérer différents types de données
const PrixFlexible = Union{Int, Float64, Missing, String}

struct ArticleMarche
    nom::String
    prix::PrixFlexible
    disponible::Bool
    vendeur::String
end

# Multiple dispatch pour gérer chaque cas
function afficher_prix(article::ArticleMarche, prix::Int)
    println("$(article.nom): $(prix) FCFA (prix fixe)")
end

function afficher_prix(article::ArticleMarche, prix::Float64)
    println("$(article.nom): $(round(prix, digits=2)) FCFA (prix précis)")
end

function afficher_prix(article::ArticleMarche, ::Missing)
    println("$(article.nom): Prix à négocier avec $(article.vendeur)")
end

function afficher_prix(article::ArticleMarche, prix::String)
    println("$(article.nom): $prix (prix spécial)")
end

# Fonction principale avec dispatch sur le type du prix
function afficher_article(article::ArticleMarche)
    status = article.disponible ? "✅ Disponible" : "❌ Rupture"
    println("$status - Vendeur: $(article.vendeur)")
    afficher_prix(article, article.prix)
end

# Calcul de remise avec gestion des types
function appliquer_remise(prix::Int, remise_pct::Real)
    return Int(round(prix * (1 - remise_pct/100)))
end

function appliquer_remise(prix::Float64, remise_pct::Real)
    return round(prix * (1 - remise_pct/100), digits=2)
end

function appliquer_remise(::Missing, remise_pct::Real)
    return missing
end

function appliquer_remise(prix::String, remise_pct::Real)
    return "$prix (remise non applicable)"
end

# Tests du système
println("=== MARCHÉ DE OUAGADOUGOU - PRIX FLEXIBLES ===")

articles_marche = [
    ArticleMarche("Tomates", 800, true, "Fatou"),
    ArticleMarche("Oignons", 425.50, true, "Seydou"),
    ArticleMarche("Arachides", missing, true, "Mamadou"),
    ArticleMarche("Mangues", "3 pour 500 FCFA", true, "Aminata"),
    ArticleMarche("Mil", 180, false, "Ibrahim")
]

for article in articles_marche
    afficher_article(article)
    
    # Appliquer une remise de 10% si possible
    if article.disponible
        nouveau_prix = appliquer_remise(article.prix, 10)
        if nouveau_prix != article.prix
            println("  Avec remise 10%: $nouveau_prix")
        end
    end
    println()
end
```

---

## 🎨 Exercice 3: Extension de Types Existants

### Surcharge d'opérateurs pour types personnalisés:
```julia
import Base: +, -, *, /, <, >, ==, show

# Type pour coordonnées GPS burkinabè
struct Coordonnee
    latitude::Float64
    longitude::Float64
    nom::String
end

# Extension des opérateurs mathématiques
function +(c1::Coordonnee, c2::Coordonnee)
    # Point moyen géographique
    lat_moy = (c1.latitude + c2.latitude) / 2
    lon_moy = (c1.longitude + c2.longitude) / 2
    return Coordonnee(lat_moy, lon_moy, "Point moyen $(c1.nom)-$(c2.nom)")
end

function -(c1::Coordonnee, c2::Coordonnee)
    # Distance approximative en kilomètres (formule simplifiée)
    dlat = c1.latitude - c2.latitude
    dlon = c1.longitude - c2.longitude
    # 1 degré ≈ 111 km à l'équateur
    distance = sqrt(dlat^2 + dlon^2) * 111.0
    return round(distance, digits=1)
end

function *(coord::Coordonnee, facteur::Real)
    # Déplacement proportionnel (pour simulation)
    return Coordonnee(
        coord.latitude * facteur,
        coord.longitude * facteur,
        "$(coord.nom) x$facteur"
    )
end

# Comparaisons basées sur la latitude (Nord-Sud)
function >(c1::Coordonnee, c2::Coordonnee)
    return c1.latitude > c2.latitude
end

function <(c1::Coordonnee, c2::Coordonnee)
    return c1.latitude < c2.latitude
end

function ==(c1::Coordonnee, c2::Coordonnee)
    return abs(c1.latitude - c2.latitude) < 0.001 && 
           abs(c1.longitude - c2.longitude) < 0.001
end

# Affichage personnalisé
function Base.show(io::IO, coord::Coordonnee)
    print(io, "$(coord.nom) ($(coord.latitude)°N, $(coord.longitude)°E)")
end

# Villes importantes du Burkina Faso
ouagadougou = Coordonnee(12.3714, -1.5197, "Ouagadougou")
bobo = Coordonnee(11.1771, -4.2979, "Bobo-Dioulasso")
koudougou = Coordonnee(12.2530, -2.3622, "Koudougou")
banfora = Coordonnee(10.6331, -4.7618, "Banfora")

println("=== SYSTÈME GPS BURKINABÈ ===")
println("Villes principales:")
villes = [ouagadougou, bobo, koudougou, banfora]
for ville in villes
    println("  $ville")
end

# Tests des opérateurs
println("\nCalculs géographiques:")
centre_pays = ouagadougou + bobo
distance_ouaga_bobo = ouagadougou - bobo

println("Centre approximatif du pays: $centre_pays")
println("Distance Ouaga-Bobo: $(distance_ouaga_bobo) km")

# Tri par latitude (Nord vers Sud)
villes_triees = sort(villes, rev=true)  # Plus au nord en premier
println("\nVilles du Nord au Sud:")
for ville in villes_triees
    println("  $ville")
end
```

---

## 🏗️ Exercice 4: Interfaces Avancées et Extensibilité

### Interface pour objets mesurables:
```julia
# Interface abstraite pour les mesures
abstract type Mesurable end

# Méthodes requises par l'interface
function mesurer(obj::Mesurable)
    error("mesurer doit être implémentée pour $(typeof(obj))")
end

function unite_mesure(obj::Mesurable)
    error("unite_mesure doit être implémentée pour $(typeof(obj))")
end

function est_valide(obj::Mesurable)
    error("est_valide doit être implémentée pour $(typeof(obj))")
end

# Implémentations concrètes
struct ChampAgricole <: Mesurable
    proprietaire::String
    culture::String
    longueur_m::Float64
    largeur_m::Float64
end

struct ReservoirEau <: Mesurable
    localisation::String
    rayon_m::Float64
    profondeur_m::Float64
    niveau_actuel::Float64  # Pourcentage de remplissage
end

struct ParcelleCommerciale <: Mesurable
    adresse::String
    surface_m2::Float64
    prix_m2::Int
    zone::String
end

# Implémentation de l'interface pour ChampAgricole
function mesurer(champ::ChampAgricole)
    return champ.longueur_m * champ.largeur_m / 10000  # Conversion en hectares
end

function unite_mesure(::ChampAgricole)
    return "hectares"
end

function est_valide(champ::ChampAgricole)
    return champ.longueur_m > 0 && champ.largeur_m > 0
end

# Implémentation de l'interface pour ReservoirEau
function mesurer(reservoir::ReservoirEau)
    volume_total = π * reservoir.rayon_m^2 * reservoir.profondeur_m
    return volume_total * reservoir.niveau_actuel / 100  # Volume d'eau actuel
end

function unite_mesure(::ReservoirEau)
    return "m³"
end

function est_valide(reservoir::ReservoirEau)
    return reservoir.rayon_m > 0 && reservoir.profondeur_m > 0 && 
           0 <= reservoir.niveau_actuel <= 100
end

# Implémentation de l'interface pour ParcelleCommerciale
function mesurer(parcelle::ParcelleCommerciale)
    return parcelle.surface_m2 * parcelle.prix_m2
end

function unite_mesure(::ParcelleCommerciale)
    return "FCFA"
end

function est_valide(parcelle::ParcelleCommerciale)
    return parcelle.surface_m2 > 0 && parcelle.prix_m2 > 0
end

# Fonctions génériques utilisant l'interface
function rapport_mesure(obj::Mesurable)
    if !est_valide(obj)
        println("❌ Objet invalide: $(typeof(obj))")
        return
    end
    
    valeur = mesurer(obj)
    unite = unite_mesure(obj)
    nom_type = string(typeof(obj))
    
    println("📊 $nom_type:")
    println("   Mesure: $(round(valeur, digits=2)) $unite")
    
    # Informations spécialisées
    if isa(obj, ChampAgricole)
        rendement_estime = valeur * 1500  # kg/hectare moyen pour céréales
        println("   Culture: $(obj.culture)")
        println("   Propriétaire: $(obj.proprietaire)")
        println("   Production estimée: $(round(Int, rendement_estime)) kg")
    elseif isa(obj, ReservoirEau)
        println("   Localisation: $(obj.localisation)")
        println("   Niveau: $(obj.niveau_actuel)%")
    elseif isa(obj, ParcelleCommerciale)
        println("   Zone: $(obj.zone)")
        println("   Prix/m²: $(obj.prix_m2) FCFA")
        println("   Surface: $(obj.surface_m2) m²")
    end
    println()
end

function comparer_mesures(obj1::Mesurable, obj2::Mesurable)
    val1 = mesurer(obj1)
    val2 = mesurer(obj2)
    unit1 = unite_mesure(obj1)
    unit2 = unite_mesure(obj2)
    
    if unit1 == unit2
        if val1 > val2
            println("🏆 $(typeof(obj1)) > $(typeof(obj2)) ($val1 vs $val2 $unit1)")
        elseif val1 < val2
            println("🏆 $(typeof(obj2)) > $(typeof(obj1)) ($val2 vs $val1 $unit1)")
        else
            println("🤝 Égalité: $(typeof(obj1)) = $(typeof(obj2)) ($val1 $unit1)")
        end
    else
        println("⚠️ Impossible de comparer: unités différentes ($unit1 vs $unit2)")
    end
end

# Tests du système
println("=== SYSTÈME DE MESURES BURKINABÈ ===")

mesurables = [
    ChampAgricole("Mamadou Traoré", "Mil", 200.0, 150.0, ),
    ReservoirEau("Barrage de Bagré", 1000.0, 25.0, 75.0),
    ParcelleCommerciale("Avenue Kwame Nkrumah", 500.0, 25000, "Centre commercial")
]

println("Rapports individuels:")
for obj in mesurables
    rapport_mesure(obj)
end

println("Comparaisons:")
# Comparaison des champs (même unité)
champ1 = ChampAgricole("Ibrahim", "Sorgho", 180.0, 120.0)
champ2 = ChampAgricole("Fatou", "Maïs", 150.0, 160.0)
comparer_mesures(champ1, champ2)

# Comparaison impossible (unités différentes)
comparer_mesures(mesurables[1], mesurables[3])
```

---

## 🚀 Exercice 5: Performance et Optimisation

### Benchmark de performance avec dispatch:
```julia
using BenchmarkTools

# Comparaison multiple dispatch vs conditions if/else
abstract type Forme end

struct Cercle <: Forme
    rayon::Float64
end

struct Rectangle <: Forme
    longueur::Float64
    largeur::Float64
end

struct Triangle <: Forme
    base::Float64
    hauteur::Float64
end

# Version multiple dispatch (rapide)
function aire_dispatch(c::Cercle)
    return π * c.rayon^2
end

function aire_dispatch(r::Rectangle)
    return r.longueur * r.largeur
end

function aire_dispatch(t::Triangle)
    return 0.5 * t.base * t.hauteur
end

# Version conditionnelle (plus lente)
function aire_conditionnelle(forme::Forme)
    if isa(forme, Cercle)
        return π * forme.rayon^2
    elseif isa(forme, Rectangle)
        return forme.longueur * forme.largeur
    elseif isa(forme, Triangle)
        return 0.5 * forme.base * forme.hauteur
    else
        error("Forme non reconnue")
    end
end

# Création d'un ensemble de formes pour les tests
formes_test = [
    Cercle(5.0),
    Rectangle(4.0, 6.0),
    Triangle(3.0, 8.0),
    Cercle(2.5),
    Rectangle(10.0, 3.0),
    Triangle(6.0, 4.0)
]

println("=== COMPARAISON DE PERFORMANCE ===")
println("Calcul d'aire avec $(length(formes_test)) formes")

# Test multiple dispatch
println("\n⚡ Multiple dispatch:")
@time for _ in 1:100000
    for forme in formes_test
        aire_dispatch(forme)
    end
end

# Test conditionnel
println("\n🐌 Version conditionnelle:")
@time for _ in 1:100000
    for forme in formes_test
        aire_conditionnelle(forme)
    end
end

# Vérification que les résultats sont identiques
println("\n✅ Vérification des résultats:")
for forme in formes_test
    aire1 = aire_dispatch(forme)
    aire2 = aire_conditionnelle(forme)
    println("$(typeof(forme)): dispatch=$(round(aire1, digits=2)), conditionnel=$(round(aire2, digits=2))")
end
```

### Optimisation avec stabilité de type:
```julia
# Exemple de stabilité de type importante pour les performances
println("\n=== STABILITÉ DE TYPE ===")

# ❌ Version instable (type change pendant l'exécution)
function calcul_instable(donnees::Vector)
    resultat = 0  # Int
    for valeur in donnees
        if valeur > 100
            resultat += valeur        # reste Int
        else
            resultat += valeur * 0.5  # devient Float64
        end
    end
    return resultat  # Type imprévisible
end

# ✅ Version stable (type cohérent)
function calcul_stable(donnees::Vector{T}) where T<:Number
    resultat = zero(T)  # Type cohérent avec l'entrée
    for valeur in donnees
        if valeur > 100
            resultat += valeur
        else
            resultat += T(valeur * 0.5)  # Conversion explicite
        end
    end
    return resultat  # Type prévisible
end

# Tests avec données réalistes (prix en FCFA)
prix_produits = [150.0, 85.0, 1200.0, 45.0, 850.0, 75.0, 2500.0]

println("Données: $prix_produits")
println("\n⏱️ Performance fonction instable:")
@time for _ in 1:100000
    calcul_instable(prix_produits)
end

println("\n⚡ Performance fonction stable:")
@time for _ in 1:100000
    calcul_stable(prix_produits)
end

resultat1 = calcul_instable(prix_produits)
resultat2 = calcul_stable(prix_produits)
println("\nRésultats:")
println("Instable: $resultat1 (type: $(typeof(resultat1)))")
println("Stable: $resultat2 (type: $(typeof(resultat2)))")
```

---

## ✅ Récapitulatif de la Pratique Avancée

### Techniques maîtrisées:
- ✅ **Types paramétrés** - Optimisation selon le type de données
- ✅ **Union types** - Flexibilité dans la gestion des types
- ✅ **Extension d'opérateurs** - Surcharge naturelle des opérations
- ✅ **Interfaces robustes** - Contrats et extensibilité
- ✅ **Optimisation performance** - Dispatch vs conditions

### Applications burkinabè avancées:
- ✅ **Gestion de stock** avec types optimisés
- ✅ **Marché flexible** avec prix variables
- ✅ **Système GPS** avec opérateurs géographiques
- ✅ **Mesures agricoles** avec interface commune
- ✅ **Calculs optimisés** avec stabilité de type

### Performance et bonnes pratiques:
- ✅ **Dispatch compilé** - Plus rapide que les conditions
- ✅ **Stabilité de type** - Cohérence pour l'optimisation
- ✅ **Spécialisation progressive** - Du général au spécifique
- ✅ **Extension naturelle** - Ajout de comportements sans modification

### Points clés pour l'optimisation:
- ✅ Multiple dispatch = performance native
- ✅ Types stables = compilateur optimise mieux
- ✅ Spécialisation = comportement précis
- ✅ Interface = extensibilité maintenue

**Prochaine étape:** "Dans l'exercice principal, vous créerez un système complet de gestion commerciale utilisant toutes ces techniques avancées!"