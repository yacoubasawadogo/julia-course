# 📚 Module 2 - Session 2: Multiple Dispatch et Méthodes
**Durée: 2 heures** | **Niveau: Intermédiaire**

---

## 🎯 Objectifs de la Session

À la fin de cette session, vous serez capable de:
- ✅ Comprendre le concept de multiple dispatch
- ✅ Créer des méthodes spécialisées pour différents types
- ✅ Utiliser l'héritage de types et les types abstraits
- ✅ Implémenter des interfaces cohérentes
- ✅ Optimiser les performances avec le dispatch

---

## 🔧 Le Multiple Dispatch: Concept Fondamental

### Qu'est-ce que le Multiple Dispatch?

Le **multiple dispatch** est une caractéristique unique de Julia qui permet de choisir quelle méthode exécuter basé sur les **types de tous les arguments**, pas seulement le premier.

```julia
# Contrairement à la POO classique où dispatch = obj.method(args)
# Julia utilise: method(obj, args) avec dispatch sur TOUS les arguments

# Exemple simple
function processeur(x::Int, y::Int)
    println("Addition de deux entiers: $(x + y)")
end

function processeur(x::Float64, y::Float64)
    println("Addition de deux flottants: $(x + y)")
end

function processeur(x::String, y::String)
    println("Concaténation: $x$y")
end

# Julia choisit automatiquement la bonne méthode
processeur(5, 3)           # → "Addition de deux entiers: 8"
processeur(5.0, 3.0)       # → "Addition de deux flottants: 8.0"
processeur("Bonjour ", "Ouaga")  # → "Concaténation: Bonjour Ouaga"
```

### Pourquoi Multiple Dispatch?

1. **Code plus naturel**: Les fonctions reflètent les opérations mathématiques
2. **Extensibilité**: Facile d'ajouter de nouveaux types et comportements
3. **Performance**: Dispatch compilé, pas d'overhead runtime
4. **Composition**: Combine naturellement différents packages

---

## 🏗️ Types Abstraits et Hiérarchie

### Création de Types Abstraits

```julia
# Types abstraits - définissent des interfaces
abstract type Vehicule end
abstract type Terrestre <: Vehicule end
abstract type Aerien <: Vehicule end

# Types concrets
struct Voiture <: Terrestre
    marque::String
    modele::String
    vitesse_max::Int
end

struct Moto <: Terrestre
    marque::String
    cylindree::Int
    vitesse_max::Int
end

struct Avion <: Aerien
    compagnie::String
    modele::String
    altitude_max::Int
end

struct Helicoptere <: Aerien
    type::String
    rayon_action::Int
end
```

### Méthodes Génériques avec Hiérarchie

```julia
# Méthode générale pour tous les véhicules
function demarrer(v::Vehicule)
    println("Le véhicule démarre...")
end

# Spécialisations pour les sous-types
function demarrer(v::Terrestre)
    println("$(typeof(v)) sur route: moteur en marche!")
end

function demarrer(v::Aerien)
    println("$(typeof(v)) prêt au décollage!")
end

# Encore plus spécifique
function demarrer(v::Voiture)
    println("🚗 $(v.marque) $(v.modele) démarre en douceur")
end

function demarrer(moto::Moto)
    println("🏍️ $(moto.marque) $(moto.cylindree)cc rugit!")
end

# Test de la hiérarchie
ma_voiture = Voiture("Toyota", "Corolla", 180)
ma_moto = Moto("Yamaha", 250, 140)
mon_avion = Avion("Air Burkina", "Boeing 737", 12000)

demarrer(ma_voiture)  # → Plus spécifique: Voiture
demarrer(ma_moto)     # → Plus spécifique: Moto  
demarrer(mon_avion)   # → Générique: Aerien
```

---

## 🎭 Exemples Contextuels Burkinabè

### Système Monétaire Multi-Devises

```julia
# Types abstraits pour les devises
abstract type Devise end
abstract type DeviseAfricaine <: Devise end
abstract type DeviseInternationale <: Devise end

# Devises concrètes
struct FCFA <: DeviseAfricaine
    montant::Float64
end

struct Euro <: DeviseInternationale
    montant::Float64
end

struct DollarUS <: DeviseInternationale
    montant::Float64
end

struct Livre <: DeviseInternationale
    montant::Float64
end

# Taux de change (base FCFA)
const TAUX_CHANGE = Dict(
    Euro => 656.0,
    DollarUS => 590.0,
    Livre => 750.0
)

# Multiple dispatch pour les conversions
function convertir(source::FCFA, ::Type{T}) where T <: DeviseInternationale
    taux = TAUX_CHANGE[T]
    return T(source.montant / taux)
end

function convertir(source::T, ::Type{FCFA}) where T <: DeviseInternationale
    taux = TAUX_CHANGE[T]
    return FCFA(source.montant * taux)
end

function convertir(source::T1, ::Type{T2}) where {T1 <: DeviseInternationale, T2 <: DeviseInternationale}
    # Conversion via FCFA
    fcfa_temp = convertir(source, FCFA)
    return convertir(fcfa_temp, T2)
end

# Opérations arithmétiques
function +(a::T, b::T) where T <: Devise
    return T(a.montant + b.montant)
end

function -(a::T, b::T) where T <: Devise
    return T(a.montant - b.montant)
end

# Comparaisons (toujours en FCFA)
function >(a::Devise, b::Devise)
    a_fcfa = isa(a, FCFA) ? a : convertir(a, FCFA)
    b_fcfa = isa(b, FCFA) ? b : convertir(b, FCFA)
    return a_fcfa.montant > b_fcfa.montant
end

# Affichage personnalisé
function Base.show(io::IO, fcfa::FCFA)
    print(io, "$(round(Int, fcfa.montant)) FCFA")
end

function Base.show(io::IO, euro::Euro)
    print(io, "$(round(euro.montant, digits=2)) EUR")
end

function Base.show(io::IO, dollar::DollarUS)
    print(io, "$(round(dollar.montant, digits=2)) USD")
end

# Tests du système
salaire_fcfa = FCFA(250000)
salaire_euro = convertir(salaire_fcfa, Euro)
salaire_usd = convertir(salaire_fcfa, DollarUS)

println("Salaire: $salaire_fcfa")
println("En euros: $salaire_euro") 
println("En dollars: $salaire_usd")

# Comparaisons
if salaire_euro > DollarUS(400)
    println("Salaire européen > 400 USD")
end
```

### Système de Transport Burkinabè

```julia
abstract type Transport end
abstract type TransportPublic <: Transport end
abstract type TransportPrive <: Transport end

# Transports publics
struct SOTRACO <: TransportPublic  # Bus urbains
    ligne::String
    capacite::Int
    tarif::Int  # FCFA
end

struct TCV <: TransportPublic  # Transport inter-villes
    destination::String
    distance_km::Int
    tarif_base::Int
end

# Transports privés
struct Taxi <: TransportPrive
    plaque::String
    tarif_km::Int
end

struct MotoCabane <: TransportPrive  # Moto-taxi
    zone::String
    tarif_course::Int
end

struct Zemidjani <: TransportPrive  # Taxi-vélo traditionnel
    quartier::String
    tarif_fixe::Int
end

# Multiple dispatch pour calculer les coûts
function calculer_tarif(transport::SOTRACO, distance_km::Float64)
    # Tarif fixe pour les bus urbains
    return transport.tarif
end

function calculer_tarif(transport::TCV, distance_km::Float64)
    # Tarif proportionnel à la distance
    return Int(round(transport.tarif_base * distance_km / 100))
end

function calculer_tarif(transport::Taxi, distance_km::Float64)
    # Tarif au kilomètre
    return Int(round(transport.tarif_km * distance_km))
end

function calculer_tarif(transport::MotoCabane, distance_km::Float64)
    # Tarif fixe par course courte
    return distance_km > 5 ? transport.tarif_course * 2 : transport.tarif_course
end

function calculer_tarif(transport::Zemidjani, distance_km::Float64)
    # Tarif fixe traditionnel
    return transport.tarif_fixe
end


##

struct Moyen_transport
    type::String
    
    # taxi-velo
    quartier::String
    tarif_fixe::Int

    #taxi-moto
    zone::String
    tarif_course::Int

    #sotraco
    ligne::String
    capacite::Int
    tarif::Int  # FCFA

    #tcv
    destination::String
    distance_km::Int
    tarif_base::Int
end


## calcul des tarifs

function calculer_tarif(transport: Moyen_transport)
   ## Si cest un taxi velo
   if transport.type == 'taxi-velo'
      if transport.quartier == 'tampouy'
        return x * y
      else
        return missing
      
   else if transport.type == 'sotraco'
      return transport.tarif
   else if transport.type == 'taxi-moto'
      return 
end



# Informations sur le transport
function info_transport(t::TransportPublic)
    println("🚌 Transport public - Réglementé par l'État")
end

function info_transport(t::TransportPrive)
    println("🚗 Transport privé - Tarifs négociables")
end

function info_transport(t::SOTRACO)
    println("🚌 SOTRACO Ligne $(t.ligne) - Capacité: $(t.capacite) passagers")
end

function info_transport(t::Zemidjani)
    println("🚲 Zemidjani traditionnel - Transport écologique du quartier $(t.quartier)")
end

# Tests du système
transports = [
    SOTRACO("A", 50, 200),
    TCV("Bobo-Dioulasso", 350, 2500),
    Taxi("BF-1234-AB", 300),
    MotoCabane("Ouaga 2000", 500),
    Zemidjani("Cissin", 250)
]

distance_test = 12.5  # km

for transport in transports
    cout = calculer_tarif(transport, distance_test)
    println("$(typeof(transport)): $(cout) FCFA pour $(distance_test) km")
    info_transport(transport)
    println()
end
```

---

## ⚡ Dispatch Avancé et Performance

### Paramètres de Type

```julia
# Types paramétrés pour optimisation
struct Produit{T<:Real}
    nom::String
    prix::T
    quantite::Int
end

# Dispatch spécialisé selon le type de prix
function calculer_total(produit::Produit{Int})
    # Optimisation pour les entiers (calcul exact)
    return produit.prix * produit.quantite
end

function calculer_total(produit::Produit{Float64})
    # Gestion des flottants avec arrondi
    return round(produit.prix * produit.quantite, digits=2)
end

## Rational numbers

function calculer_total(produit::Produit{Rational})
   return round(produit.prix * produit.quantite, digits=10)
end

function calculer_tva(produit::Produit{T}) where T<:Real
    # Méthode générique avec paramètre de type
    total = calculer_total(produit)
    return T(total * 0.18)  # TVA 18% au Burkina
end

# Tests
riz_entier = Produit{Int}("Riz local", 350, 10)
huile_float = Produit{Float64}("Huile", 1250.50, 3)

println("Total riz: $(calculer_total(riz_entier)) FCFA")
println("TVA riz: $(calculer_tva(riz_entier)) FCFA")
println("Total huile: $(calculer_total(huile_float)) FCFA")
println("TVA huile: $(calculer_tva(huile_float)) FCFA")

## Forme complexe avec des if elses

function calculer_total(x::Produit{T}) where T<:Real
   total = x.prix * x.quantite
   return isa(total, Float64) ? round(total, digits=2) : total 
end


```

### Union Types pour Flexibilité

```julia
# Types Union pour accepter plusieurs types
const PrixType = Union{Int, Float64, Nothing}

struct Article
    nom::String
    prix::PrixType
    disponible::Bool
end

function afficher_prix(nom::String, prix::PrixType)
   println("$(nom): $(prix) FCFA")
end

function afficher_prix(nom::String, ::Missing)
   println("$(nom): Prix non disponible")
end

function calculer_remise(prix::Int, pourcentage::Real)
    return Int(round(prix * (1 - pourcentage/100)))
end

function calculer_remise(prix::Float64, pourcentage::Real) 
    return round(prix * (1 - pourcentage/100), digits=2)
end

function calculer_remise(::Missing, pourcentage::Real)
    return missing
end

# Tests avec différents types
articles = [
    Article("Mil", 180, true),
    Article("Maïs", 175.50, true),
    Article("Fonio", missing, false)
]

function decrire_reduction(prix::Float64)
   println("  Avec remise 15%: $prix FCFA")
end

function decrire_reduction(::Missing)
   println(" Aucune remise possible")
end

for article in articles
    afficher_prix(article.nom, article.prix)
    prix_reduit = calculer_remise(article.prix, 15)
    decrire_reduction(prix_reduit)
end
```

---

## 🎨 Interfaces et Protocoles

### Définition d'Interfaces

```julia
# Interface pour les objets calculables
abstract type Calculable end

# Méthodes requises pour l'interface
function calculer_valeur(obj::Calculable)
    error("calculer_valeur doit être implémentée pour $(typeof(obj))")
end

function est_valide(obj::Calculable)
    error("est_valide doit être implémentée pour $(typeof(obj))")
end

# Implémentations concrètes
struct FactureElectricite <: Calculable
    consommation_kwh::Float64
    tarif_kwh::Float64
    frais_fixes::Float64
end

struct FactureEau <: Calculable
    consommation_m3::Float64
    tarif_m3::Float64
    abonnement::Float64
end

struct FactureTelephone <: Calculable
    minutes_utilisees::Int
    cout_minute::Float64
    forfait_mensuel::Float64
end

# Implémentation de l'interface
function calculer_valeur(facture::FactureElectricite)
    return facture.consommation_kwh * facture.tarif_kwh + facture.frais_fixes
end

function calculer_valeur(facture::FactureEau)
    return facture.consommation_m3 * facture.tarif_m3 + facture.abonnement
end

#function calculer_valeur(facture::FactureTelephone)
#    cout_communication = facture.minutes_utilisees * facture.cout_minute
#    return max(cout_communication, facture.forfait_mensuel)
#end

function est_valide(facture::FactureElectricite)
    return facture.consommation_kwh >= 0 && facture.tarif_kwh > 0
end

function est_valide(facture::FactureEau)
    return facture.consommation_m3 >= 0 && facture.tarif_m3 > 0
end

##function est_valide(facture::FactureTelephone)
#    return facture.minutes_utilisees >= 0 && facture.cout_minute >= 0
#end

# Fonction générique utilisant l'interface
function traiter_facture(facture::Calculable)
    if !est_valide(facture)
        println("❌ Facture invalide: $(typeof(facture))")
        return nothing
    end
    
    montant = calculer_valeur(facture)
    println("✅ $(typeof(facture)): $(round(Int, montant)) FCFA")
    return montant
end

# Tests
factures = [
    FactureElectricite(150.5, 85.0, 2500.0),  # SONABEL
    FactureEau(25.3, 180.0, 1500.0),          # ONEA
    FactureTelephone(420, 45.0, 5000.0)       # Orange/Moov
]

total_factures = 0
for facture in factures
    montant = traiter_facture(facture)
    if montant !== nothing
        global total_factures += montant
    end
end

println("\n💰 Total des factures: $(round(Int, total_factures)) FCFA")
```

---

## 🔄 Extensibilité et Packages

### Extension de Types Existants

```julia
# Extension des types de base avec nouvelles méthodes
import Base: +, -, *, ==

struct Coordonnee
    latitude::Float64
    longitude::Float64
    nom::String
end

# Surcharge des opérateurs
function +(c1::Coordonnee, c2::Coordonnee)
    # Point moyen entre deux coordonnées
    lat_moy = (c1.latitude + c2.latitude) / 2
    lon_moy = (c1.longitude + c2.longitude) / 2
    return Coordonnee(lat_moy, lon_moy, "Point moyen")
end

function -(c1::Coordonnee, c2::Coordonnee)
    # Distance approximative en km (formule simplifiée)
    dlat = c1.latitude - c2.latitude
    dlon = c1.longitude - c2.longitude
    return sqrt(dlat^2 + dlon^2) * 111  # 1° ≈ 111 km
end

function ==(c1::Coordonnee, c2::Coordonnee)
    return c1.latitude ≈ c2.latitude && c1.longitude ≈ c2.longitude
end

# Villes du Burkina Faso
ouagadougou = Coordonnee(12.3714, -1.5197, "Ouagadougou")
bobo = Coordonnee(11.1771, -4.2979, "Bobo-Dioulasso") 
koudougou = Coordonnee(12.2530, -2.3622, "Koudougou")

# Utilisation des opérateurs surchargés
point_moyen = ouagadougou + bobo
distance = ouagadougou - bobo

println("Point moyen entre Ouaga et Bobo: $(point_moyen.latitude), $(point_moyen.longitude)")
println("Distance Ouaga-Bobo: $(round(distance, digits=1)) km")
```

### Méthodes Dynamiques

```julia
# Génération dynamique de méthodes
abstract type Animal end

struct Chien <: Animal
    nom::String
    race::String
end

struct Chat <: Animal
    nom::String
    couleur::String
end

struct Poule <: Animal
    nom::String
    ponte_par_jour::Int
end

# Génération automatique de méthodes
const CRIS = Dict(
    Chien => "Ouaf!",
    Chat => "Miaou!",
    Poule => "Cot cot!"
)

const NOURRITURE = Dict(
    Chien => "croquettes",
    Chat => "poisson",
    Poule => "graines"
)

# Génération de méthodes pour chaque type d'animal
for T in [Chien, Chat, Poule]
    @eval function crier(animal::$T)
        println("$(animal.nom) fait: $($(CRIS[T]))")
    end
    
    @eval function nourrir(animal::$T)
        println("$(animal.nom) mange des $($(NOURRITURE[T]))")
    end
end

# Méthode spécialisée pour les poules
function pondre(poule::Poule)
    println("$(poule.nom) pond $(poule.ponte_par_jour) œuf(s)")
end

# Tests
animaux = [
    Chien("Rex", "Berger Allemand"),
    Chat("Minou", "gris"),
    Poule("Gertrude", 2)
]

for animal in animaux
    crier(animal)
    nourrir(animal)
    
    # Dispatch conditionnel
    if isa(animal, Poule)
        pondre(animal)
    end
    println()
end
```

---

## 🚀 Optimisation et Performance

### Profile du Dispatch

```julia
# Mesure des performances avec @time et @benchmark
using BenchmarkTools

abstract type Forme end

struct Cercle <: Forme
    rayon::Float64
end

struct Rectangle <: Forme  
    largeur::Float64
    hauteur::Float64
end

struct Triangle <: Forme
    base::Float64
    hauteur::Float64
end

# Calcul d'aire avec multiple dispatch
function aire(c::Cercle)
    return π * c.rayon^2
end

function aire(r::Rectangle)
    return r.largeur * r.hauteur
end

function aire(t::Triangle)
    return 0.5 * t.base * t.hauteur
end

# Version générique (moins efficace)
function aire_generique(forme::Forme)
    if isa(forme, Cercle)
        return π * forme.rayon^2
    elseif isa(forme, Rectangle)
        return forme.largeur * forme.hauteur  
    elseif isa(forme, Triangle)
        return 0.5 * forme.base * forme.hauteur
    end
end

# Tests de performance
formes = [
    Cercle(5.0),
    Rectangle(4.0, 6.0),
    Triangle(3.0, 8.0)
]

println("Performance multiple dispatch:")
@time for _ in 1:100000
    for forme in formes
        aire(forme)
    end
end

println("\nPerformance version générique:")
@time for _ in 1:100000
    for forme in formes
        aire_generique(forme)
    end
end

# Le multiple dispatch est généralement plus rapide!
```

### Stabilité de Type

```julia
# Importance de la stabilité de type pour les performances

# ❌ MAUVAIS - Type instable
function somme_instable(arr)
    total = 0  # Int
    for x in arr
        if x > 0
            total += x        # total reste Int
        else
            total += x * 0.1  # total devient Float64
        end
    end
    return total  # Type de retour imprévisible
end

# ✅ BON - Type stable  
function somme_stable(arr::Vector{T}) where T<:Number
    total = zero(T)  # Type cohérent avec l'entrée
    for x in arr
        if x > 0
            total += x
        else
            total += T(x * 0.1)  # Conversion explicite
        end
    end
    return total  # Type de retour prévisible
end

# Tests avec données burkinabè
temperatures = [32.5, 28.0, 35.2, -1.0, 40.1]  # Températures en °C

println("Test stabilité de type:")
@time result1 = somme_instable(temperatures)
@time result2 = somme_stable(temperatures)

println("Résultat instable: $result1 (type: $(typeof(result1)))")
println("Résultat stable: $result2 (type: $(typeof(result2)))")
```

---

## 🎯 Points Clés à Retenir

### Avantages du Multiple Dispatch

1. **Extensibilité**: Facile d'ajouter de nouveaux types et comportements
2. **Performance**: Dispatch résolu à la compilation
3. **Code naturel**: Syntaxe proche des mathématiques
4. **Composition**: Combinaison naturelle de packages

### Bonnes Pratiques

1. **Hiérarchie claire**: Types abstraits pour interfaces communes
2. **Stabilité de type**: Éviter les types qui changent
3. **Spécialisation progressive**: Du général au spécifique
4. **Documentation**: Clarifier les interfaces attendues

### Pièges à Éviter

1. **Ambiguïté**: Méthodes avec même signature
2. **Dispersion**: Trop de méthodes spécialisées  
3. **Type piracy**: Modification de types externes
4. **Instabilité**: Types qui changent dans les fonctions

---

## 🚀 Prochaines Étapes

Dans la prochaine session, nous explorerons:
- Gestion de fichiers et I/O
- Sérialisation et persistance des données
- Traitement de fichiers CSV et JSON
- Applications avec données réelles du Burkina Faso

---

## 📝 Notes pour l'Instructeur

### Démonstrations Recommandées:
1. Créer une hiérarchie de formes géométriques
2. Système de devises avec conversions automatiques
3. Benchmark dispatch vs conditions if/else
4. Extension de types Base avec nouveaux opérateurs

### Exercices Interactifs:
- Système de transport avec calculs de tarifs
- Gestion de factures multi-services  
- Calculateur de distances géographiques
- Simulateur économique multi-devises

### Timing Suggéré:
- **30 min**: Théorie et concepts fondamentaux
- **45 min**: Exemples contextuels (devises, transport)
- **15 min**: Pause
- **30 min**: Performance et optimisation
- **20 min**: Exercices pratiques et questions