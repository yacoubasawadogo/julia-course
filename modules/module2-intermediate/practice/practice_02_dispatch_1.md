# 🎯 Pratique Guidée 1: Multiple Dispatch - Fondations
**Module 2 - Session 2** | **Durée: 25 minutes**

---

## 📋 Objectifs de cette Pratique

- Comprendre le concept de multiple dispatch
- Créer des méthodes spécialisées par types
- Utiliser la hiérarchie de types abstraits
- Implémenter des interfaces cohérentes

---

## 🔧 Exercice 1: Multiple Dispatch de Base

### Étape 1 - Comprendre le dispatch simple:
```julia
# Même nom de fonction, comportements différents selon les types
function saluer(nom::String)
    return "Bonjour $nom!"
end

function saluer(age::Int)
    if age < 18
        return "Salut jeune de $age ans!"
    else
        return "Bonjour, vous avez $age ans."
    end
end

function saluer(actif::Bool)
    return actif ? "Bienvenue, utilisateur actif!" : "Compte inactif"
end

# Julia choisit automatiquement la bonne méthode
println(saluer("Aminata"))        # → Version String
println(saluer(25))               # → Version Int  
println(saluer(true))             # → Version Bool
```

### Challenge interactif:
> **À vous:** "Ajoutez une méthode `saluer(prix::Float64)` qui formate les prix en FCFA"

```julia
# Solution attendue:
function saluer(prix::Float64)
    return "Prix: $(round(Int, prix)) FCFA"
end

println(saluer(1250.75))  # → "Prix: 1251 FCFA"
```

### Étape 2 - Dispatch avec plusieurs arguments:
```julia
# Multiple dispatch sur PLUSIEURS arguments
function calculer(x::Int, y::Int)
    println("Addition d'entiers: $(x + y)")
end

function calculer(x::Float64, y::Float64)
    println("Addition de flottants: $(round(x + y, digits=2))")
end

function calculer(x::String, y::String)
    println("Concaténation: $x$y")
end

function calculer(x::Int, y::Float64)
    println("Entier + Flottant: $(x + y)")
end

function calculer(x::Float64, y::Int)
    println("Flottant + Entier: $(x + y)")
end

# Tests
calculer(5, 3)           # Int, Int
calculer(5.5, 3.2)       # Float64, Float64
calculer("Ouaga", "2000") # String, String
calculer(10, 5.5)        # Int, Float64
calculer(7.2, 4)         # Float64, Int
```

---

## 🏗️ Exercice 2: Types Abstraits et Hiérarchie

### Création d'une hiérarchie de types:
```julia
# Types abstraits - définissent des catégories
abstract type Personne end
abstract type Etudiant <: Personne end
abstract type Travailleur <: Personne end

# Types concrets
struct EtudiantLycee <: Etudiant
    nom::String
    classe::String
    moyenne::Float64
end

struct EtudiantUniversite <: Etudiant
    nom::String
    filiere::String
    niveau::Int
    moyenne::Float64
end

struct Fonctionnaire <: Travailleur
    nom::String
    ministere::String
    echelon::Int
    salaire::Int
end

struct Commercant <: Travailleur
    nom::String
    activite::String
    chiffre_affaires::Int
end
```

### Multiple dispatch avec hiérarchie:
```julia
# Méthode générale pour toutes les Personnes
function presenter(p::Personne)
    println("👋 Je suis $(p.nom)")
end

# Spécialisations pour les sous-types
function presenter(e::Etudiant)
    println("📚 Étudiant: $(e.nom)")
end

function presenter(t::Travailleur)
    println("💼 Travailleur: $(t.nom)")
end

# Encore plus spécifique
function presenter(e::EtudiantLycee)
    mention = e.moyenne >= 14 ? "Très bien" : e.moyenne >= 12 ? "Bien" : "Passable"
    println("🎓 Lycéen: $(e.nom), classe $(e.classe), $(mention) ($(e.moyenne)/20)")
end

function presenter(e::EtudiantUniversite)
    println("🏫 Universitaire: $(e.nom), $(e.filiere) niveau $(e.niveau)")
end

function presenter(f::Fonctionnaire)
    println("🏛️ Fonctionnaire: $(f.nom), $(f.ministere), échelon $(f.echelon)")
end

function presenter(c::Commercant)
    println("🏪 Commerçant: $(c.nom), $(c.activite)")
end

# Création de personnes
personnes = [
    EtudiantLycee("Aminata", "Terminale D", 15.5),
    EtudiantUniversite("Paul", "Informatique", 3, 13.2),
    Fonctionnaire("Marie", "Éducation Nationale", 7, 150000),
    Commercant("Seydou", "Vente de céréales", 2500000)
]

# Test du dispatch - Julia choisit automatiquement la méthode la plus spécifique
for personne in personnes
    presenter(personne)
end
```

---

## 💰 Exercice 3: Système de Devises Burkinabè

### Structure monétaire hiérarchique:
```julia
abstract type Monnaie end
abstract type MonnaieAfricaine <: Monnaie end
abstract type MonnaieInternationale <: Monnaie end

# Devises concrètes
struct FCFA <: MonnaieAfricaine
    valeur::Float64
end

struct Euro <: MonnaieInternationale
    valeur::Float64
end

struct Dollar <: MonnaieInternationale
    valeur::Float64
end

# Taux de change (base FCFA)
const TAUX = Dict(
    Euro => 656.0,
    Dollar => 590.0
)

# Multiple dispatch pour les conversions
function vers_fcfa(monnaie::FCFA)
    return monnaie  # Déjà en FCFA
end

function vers_fcfa(monnaie::Euro)
    return FCFA(monnaie.valeur * TAUX[Euro])
end

function vers_fcfa(monnaie::Dollar)
    return FCFA(monnaie.valeur * TAUX[Dollar])
end

# Conversion depuis FCFA
function convertir(fcfa::FCFA, ::Type{Euro})
    return Euro(fcfa.valeur / TAUX[Euro])
end

function convertir(fcfa::FCFA, ::Type{Dollar})
    return Dollar(fcfa.valeur / TAUX[Dollar])
end

# Affichage personnalisé
function Base.show(io::IO, fcfa::FCFA)
    print(io, "$(round(Int, fcfa.valeur)) FCFA")
end

function Base.show(io::IO, euro::Euro)
    print(io, "$(round(euro.valeur, digits=2)) EUR")
end

function Base.show(io::IO, dollar::Dollar)
    print(io, "$(round(dollar.valeur, digits=2)) USD")
end

# Tests du système
println("=== SYSTÈME MONÉTAIRE BURKINABÈ ===")

salaire = FCFA(300000)
prix_voiture_eur = Euro(15000)
budget_voyage_usd = Dollar(1200)

println("Salaire: $salaire")
println("Prix voiture: $prix_voiture_eur")
println("Budget voyage: $budget_voyage_usd")

# Conversions automatiques
println("\nConversions vers FCFA:")
voiture_fcfa = vers_fcfa(prix_voiture_eur)
voyage_fcfa = vers_fcfa(budget_voyage_usd)

println("Voiture: $voiture_fcfa")
println("Voyage: $voyage_fcfa")

# Conversions depuis FCFA
println("\nConversions depuis FCFA:")
salaire_eur = convertir(salaire, Euro)
salaire_usd = convertir(salaire, Dollar)

println("Salaire en euros: $salaire_eur")
println("Salaire en dollars: $salaire_usd")
```

---

## 🚌 Exercice 4: Transport Burkinabè avec Dispatch

### Hiérarchie de transports:
```julia
abstract type Transport end
abstract type TransportUrbain <: Transport end
abstract type TransportInterurbain <: Transport end

# Transports urbains
struct Bus <: TransportUrbain
    ligne::String
    tarif_fixe::Int
end

struct TaxiVille <: TransportUrbain
    zone::String
    tarif_km::Int
end

struct Zemidjan <: TransportUrbain  # Moto-taxi
    quartier::String
    tarif_course::Int
end

# Transports interurbains
struct TCV <: TransportInterurbain  # Transport public
    destination::String
    tarif_base::Int
    distance_km::Float64
end

struct TaxisBrousse <: TransportInterurbain
    destination::String
    tarif_negocie::Int
end

# Multiple dispatch pour calculer les tarifs
function calculer_tarif(bus::Bus, distance::Float64)
    # Tarif fixe pour les bus urbains
    return bus.tarif_fixe
end

function calculer_tarif(taxi::TaxiVille, distance::Float64)
    # Calcul au kilomètre
    return Int(round(taxi.tarif_km * distance))
end

function calculer_tarif(moto::Zemidjan, distance::Float64)
    # Tarif par course (max 2 courses pour longues distances)
    return distance > 8 ? moto.tarif_course * 2 : moto.tarif_course
end

function calculer_tarif(tcv::TCV, distance::Float64)
    # Tarif proportionnel pour transport inter-villes
    return Int(round(tcv.tarif_base * distance / 100))
end

function calculer_tarif(brousse::TaxisBrousse, distance::Float64)
    # Tarif négocié fixe
    return brousse.tarif_negocie
end

# Informations sur le confort
function niveau_confort(::TransportUrbain)
    return "Confort urbain standard"
end

function niveau_confort(::Bus)
    return "Bon confort, climatisé"
end

function niveau_confort(::Zemidjan)
    return "Transport rapide mais exposition aux éléments"
end

function niveau_confort(::TransportInterurbain)
    return "Confort longue distance"
end

function niveau_confort(::TaxisBrousse)
    return "Confort variable selon négociation"
end

# Tests du système
println("=== TRANSPORT AU BURKINA FASO ===")

transports = [
    Bus("Ligne A", 200),
    TaxiVille("Centre-ville", 250),
    Zemidjan("Cissin", 300),
    TCV("Bobo-Dioulasso", 2000, 350.0),
    TaxisBrousse("Kaya", 1500)
]

distance_test = 15.0  # km

println("Calcul des tarifs pour $distance_test km:")
println("-" * 50)

for transport in transports
    tarif = calculer_tarif(transport, distance_test)
    confort = niveau_confort(transport)
    
    println("$(typeof(transport)): $(tarif) FCFA")
    println("  $confort")
    println()
end
```

---

## 🎨 Exercice 5: Interface et Polymorphisme

### Interface pour objets calculables:
```julia
# Interface abstraite
abstract type Facture end

# Méthodes requises (interface)
function montant_total(f::Facture)
    error("montant_total doit être implémentée pour $(typeof(f))")
end

function est_payee(f::Facture)
    error("est_payee doit être implémentée pour $(typeof(f))")
end

# Types concrets implémentant l'interface
struct FactureElectricite <: Facture
    consommation_kwh::Float64
    tarif_kwh::Float64
    abonnement::Float64
    payee::Bool
end

struct FactureEau <: Facture
    consommation_m3::Float64
    tarif_m3::Float64
    frais_fixes::Float64
    payee::Bool
end

struct FactureTelephone <: Facture
    minutes::Int
    tarif_minute::Float64
    forfait::Float64
    payee::Bool
end

# Implémentation de l'interface pour chaque type
function montant_total(f::FactureElectricite)
    return f.consommation_kwh * f.tarif_kwh + f.abonnement
end

function montant_total(f::FactureEau)
    return f.consommation_m3 * f.tarif_m3 + f.frais_fixes
end

function montant_total(f::FactureTelephone)
    cout_appels = f.minutes * f.tarif_minute
    return max(cout_appels, f.forfait)  # Au moins le forfait minimum
end

function est_payee(f::Facture)
    return f.payee
end

# Fonctions génériques utilisant l'interface
function afficher_facture(facture::Facture)
    type_facture = replace(string(typeof(facture)), "Facture" => "")
    montant = montant_total(facture)
    statut = est_payee(facture) ? "✅ PAYÉE" : "❌ IMPAYÉE"
    
    println("📋 $type_facture: $(round(Int, montant)) FCFA - $statut")
end

function total_impaye(factures::Vector{<:Facture})
    total = 0.0
    for facture in factures
        if !est_payee(facture)
            total += montant_total(facture)
        end
    end
    return total
end

# Tests du système
println("=== GESTION DES FACTURES MÉNAGÈRES ===")

factures_mensuelles = [
    FactureElectricite(185.5, 85.0, 2500.0, true),   # SONABEL - Payée
    FactureEau(22.3, 150.0, 1200.0, false),          # ONEA - Impayée
    FactureTelephone(450, 35.0, 4500.0, false)       # Orange - Impayée
]

println("Détail des factures:")
for facture in factures_mensuelles
    afficher_facture(facture)
end

total_du = total_impaye(factures_mensuelles)
println("\n💰 Total impayé: $(round(Int, total_du)) FCFA")
```

---

## ✅ Récapitulatif de la Pratique

### Concepts maîtrisés:
- ✅ **Multiple dispatch de base** - Une fonction, plusieurs méthodes
- ✅ **Types abstraits** - Hiérarchies et interfaces
- ✅ **Spécialisation progressive** - Du général au spécifique
- ✅ **Polymorphisme** - Même interface, comportements différents
- ✅ **Dispatch automatique** - Julia choisit la bonne méthode

### Applications contextuelles:
- ✅ **Système monétaire** avec conversions automatiques
- ✅ **Transport burkinabè** avec calculs de tarifs
- ✅ **Gestion de factures** avec interface commune
- ✅ **Hiérarchie de personnes** avec présentations spécialisées

### Avantages observés:
- ✅ **Code naturel** - Syntaxe proche du langage mathématique
- ✅ **Extensibilité** - Facile d'ajouter de nouveaux types
- ✅ **Performance** - Dispatch résolu à la compilation
- ✅ **Maintenance** - Séparation claire des responsabilités

### Patterns utiles mémorisés:
- ✅ `function nom(arg::Type)` pour spécialiser par type
- ✅ `abstract type Parent end` pour créer des interfaces
- ✅ `struct Enfant <: Parent` pour l'héritage
- ✅ `Base.show(io::IO, obj::Type)` pour l'affichage personnalisé

**Prochaine étape:** "Dans la deuxième pratique, nous approfondirons les techniques avancées de dispatch et l'optimisation des performances!"