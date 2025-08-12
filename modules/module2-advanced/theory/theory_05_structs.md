# 📚 Module 2 - Session 1: Structures et Types Personnalisés
**Durée: 2 heures** | **Niveau: Intermédiaire**

---

## 🎯 Objectifs de la Session

À la fin de cette session, vous serez capable de:
- ✅ Créer des structures personnalisées (struct)
- ✅ Comprendre la différence entre mutable et immutable
- ✅ Implémenter des constructeurs personnalisés
- ✅ Utiliser des types paramétriques
- ✅ Créer des hiérarchies de types abstraits

---

## 🏗️ Introduction aux Structures

### Pourquoi Utiliser des Structures?

1. **Organisation**: Regrouper des données liées
2. **Réutilisabilité**: Créer des modèles de données
3. **Type Safety**: Validation automatique des types
4. **Performance**: Structures optimisées par Julia
5. **Abstraction**: Modéliser des concepts du monde réel

---

## 📦 Structures Immutables

### Définition de Base

```julia
# Structure simple pour un point 2D
struct Point2D
    x::Float64
    y::Float64
end

# Création d'instances
origine = Point2D(0.0, 0.0)
point_a = Point2D(3.5, 7.2)

# Accès aux champs
println("x = $(point_a.x), y = $(point_a.y)")
```

### Exemple: Personne Burkinabè

```julia
struct PersonneBF
    nom::String
    prenom::String
    age::Int
    ville::String
    profession::String
end

# Création
citoyen = PersonneBF(
    "Ouédraogo",
    "Aminata",
    28,
    "Ouagadougou",
    "Ingénieure"
)

# Utilisation
println("$(citoyen.prenom) $(citoyen.nom) de $(citoyen.ville)")
```

### Structures avec Valeurs Par Défaut

```julia
# Constructeur externe avec défauts
struct Produit
    nom::String
    prix_fcfa::Float64
    quantite::Int
end

# Constructeur avec valeurs par défaut
Produit(nom::String) = Produit(nom, 0.0, 0)
Produit(nom::String, prix::Float64) = Produit(nom, prix, 1)

# Utilisation
riz = Produit("Riz", 25000.0, 50)
mil = Produit("Mil", 15000.0)  # quantite = 1 par défaut
sorgho = Produit("Sorgho")     # prix = 0.0, quantite = 0
```

---

## 🔄 Structures Mutables

### Quand Utiliser Mutable?

```julia
# Structure mutable pour données changeantes
mutable struct CompteBancaire
    titulaire::String
    solde::Float64
    devise::String
end

# Création et modification
compte = CompteBancaire("Kabore Jean", 150000.0, "FCFA")
println("Solde initial: $(compte.solde) $(compte.devise)")

# Modification possible avec mutable
compte.solde += 25000
println("Nouveau solde: $(compte.solde) $(compte.devise)")

# Fonction de retrait
function retirer!(compte::CompteBancaire, montant::Float64)
    if montant <= compte.solde
        compte.solde -= montant
        return true
    else
        println("Solde insuffisant!")
        return false
    end
end
```

### Comparaison Mutable vs Immutable

```julia
# Immutable - Plus rapide, plus sûr
struct PointFixe
    x::Float64
    y::Float64
end

# Mutable - Flexible mais plus lent
mutable struct PointMobile
    x::Float64
    y::Float64
end

# Performance
point_fixe = PointFixe(1.0, 2.0)
# point_fixe.x = 3.0  # ERREUR! Immutable

point_mobile = PointMobile(1.0, 2.0)
point_mobile.x = 3.0  # OK, mutable
```

---

## 🎨 Constructeurs Personnalisés

### Constructeur Interne

```julia
struct Temperature
    celsius::Float64
    
    # Constructeur interne avec validation
    function Temperature(celsius::Float64)
        if celsius < -273.15
            error("Température impossible: en dessous du zéro absolu!")
        end
        new(celsius)
    end
end

# Constructeurs additionnels
Temperature(fahrenheit::Float64, ::Val{:F}) = 
    Temperature((fahrenheit - 32) * 5/9)
Temperature(kelvin::Float64, ::Val{:K}) = 
    Temperature(kelvin - 273.15)

# Utilisation
temp1 = Temperature(25.0)              # 25°C
temp2 = Temperature(77.0, Val(:F))     # 77°F → 25°C
temp3 = Temperature(298.15, Val(:K))   # 298.15K → 25°C
```

### Exemple: Coordonnées GPS

```julia
struct CoordGPS
    latitude::Float64
    longitude::Float64
    nom_lieu::String
    
    function CoordGPS(lat::Float64, lon::Float64, nom::String="")
        # Validation des coordonnées
        if abs(lat) > 90
            error("Latitude invalide: doit être entre -90 et 90")
        end
        if abs(lon) > 180
            error("Longitude invalide: doit être entre -180 et 180")
        end
        new(lat, lon, nom)
    end
end

# Lieux importants du Burkina Faso
ouaga = CoordGPS(12.3714, -1.5197, "Ouagadougou")
bobo = CoordGPS(11.1771, -4.2979, "Bobo-Dioulasso")
```

---

## 🔗 Types Paramétriques

### Structures Génériques

```julia
# Structure paramétrique
struct Conteneur{T}
    valeur::T
    capacite_max::Int
end

# Utilisation avec différents types
conteneur_int = Conteneur{Int}(42, 100)
conteneur_string = Conteneur{String}("Burkina", 50)
conteneur_float = Conteneur{Float64}(3.14, 10)

# Type déduit automatiquement
conteneur_auto = Conteneur(true, 1)  # Conteneur{Bool}
```

### Exemple: Paire Générique

```julia
struct Paire{T,S}
    premier::T
    second::S
end

# Différentes combinaisons
coord = Paire(12.3, -1.5)           # Paire{Float64,Float64}
ville = Paire("Ouaga", 2_800_000)   # Paire{String,Int}
info = Paire(:temperature, 35.5)     # Paire{Symbol,Float64}

# Fonction générique
function echanger(p::Paire{T,S}) where {T,S}
    return Paire{S,T}(p.second, p.premier)
end
```

---

## 🎭 Types Abstraits

### Hiérarchie de Types

```julia
# Type abstrait de base
abstract type Vehicule end

# Sous-types abstraits
abstract type VehiculeTerrestre <: Vehicule end
abstract type VehiculeAerien <: Vehicule end

# Types concrets
struct Moto <: VehiculeTerrestre
    marque::String
    cylindree::Int
    proprietaire::String
end

struct Velo <: VehiculeTerrestre
    type::String  # VTT, Route, etc.
    vitesses::Int
end

struct Avion <: VehiculeAerien
    modele::String
    capacite_passagers::Int
end

# Fonction polymorphe
function decrire(v::Vehicule)
    println("C'est un véhicule de type $(typeof(v))")
end

# Spécialisation
function vitesse_max(m::Moto)
    return m.cylindree > 125 ? 120 : 80  # km/h
end

function vitesse_max(v::Velo)
    return 30  # km/h
end
```

---

## 🌍 Application Pratique: Gestion Agricole

```julia
# Système de gestion de parcelles agricoles
abstract type Culture end

struct Cereale <: Culture
    nom::String
    surface_hectares::Float64
    rendement_kg_ha::Float64
    prix_kg_fcfa::Float64
end

struct Legume <: Culture
    nom::String
    surface_hectares::Float64
    production_tonnes::Float64
    prix_tonne_fcfa::Float64
end

mutable struct Exploitation
    nom::String
    proprietaire::String
    cultures::Vector{Culture}
    superficie_totale::Float64
end

# Fonctions de calcul
function valeur_production(c::Cereale)
    production_kg = c.surface_hectares * c.rendement_kg_ha
    return production_kg * c.prix_kg_fcfa
end

function valeur_production(l::Legume)
    return l.production_tonnes * l.prix_tonne_fcfa
end

function valeur_totale(e::Exploitation)
    return sum(valeur_production(c) for c in e.cultures)
end

# Utilisation
mais = Cereale("Maïs", 2.5, 1800, 200)
tomates = Legume("Tomates", 0.5, 15, 400_000)

ferme = Exploitation(
    "Ferme Moderne",
    "Sawadogo Paul",
    [mais, tomates],
    3.0
)

println("Valeur totale de production: $(valeur_totale(ferme)) FCFA")
```

---

## 💡 Bonnes Pratiques

### Conception de Structures

```julia
# ✅ BON - Structures cohérentes et simples
struct Etudiant
    matricule::String
    nom::String
    prenom::String
    niveau::Int
    moyenne::Float64
end

# ❌ MAUVAIS - Trop de responsabilités
struct EtudiantComplet
    # Données personnelles
    nom::String
    prenom::String
    # Données académiques
    notes::Vector{Float64}
    # Données financières
    frais_scolarite::Float64
    paiements::Vector{Float64}
    # Mieux vaut séparer en plusieurs structures
end
```

### Immutabilité par Défaut

```julia
# Préférer immutable sauf si modification nécessaire
struct Configuration
    serveur::String
    port::Int
    timeout::Int
end

# Mutable seulement si vraiment nécessaire
mutable struct SessionUtilisateur
    id::String
    derniere_activite::Float64
    compteur_requetes::Int
end
```

---

## 🎯 Points Clés à Retenir

1. **Immutable par défaut** - Plus rapide et plus sûr
2. **Mutable si nécessaire** - Pour les données changeantes
3. **Constructeurs validants** - Garantir l'intégrité
4. **Types paramétriques** - Pour la réutilisabilité
5. **Hiérarchie abstraite** - Pour l'organisation

---

## 🚀 Prochaines Étapes

Dans la prochaine session:
- Multiple dispatch avancé
- Surcharge d'opérateurs
- Traits et interfaces
- Métaprogrammation de base

---

## 📝 Notes pour l'Instructeur

### Démonstrations Live:
1. Créer une structure `Entreprise` avec les étudiants
2. Montrer la différence de performance mutable/immutable
3. Implémenter un système de gestion de stock
4. Explorer avec `fieldnames()`, `fieldtypes()`

### Exercices Pratiques:
- Modéliser un système bancaire complet
- Créer une hiérarchie d'animaux de ferme
- Implémenter un carnet d'adresses

### Points d'Attention:
- Les étudiants oublient souvent le mot-clé `mutable`
- La différence entre `=` et `==` pour les structures
- L'importance des types abstraits pour l'organisation