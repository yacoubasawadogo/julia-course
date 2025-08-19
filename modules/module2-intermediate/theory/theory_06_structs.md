# 📚 Session 6 : Les Structures (Structs) et Types Personnalisés

## 🎯 Objectifs d'apprentissage
À la fin de cette session, vous saurez :
- Créer des types de données personnalisés avec `struct`
- Distinguer entre structures mutables et immutables
- Utiliser les constructeurs pour initialiser vos structures
- Comprendre l'organisation des données complexes

## 🌟 Introduction : Organiser les données comme au marché de Ouagadougou

Imaginez que vous gérez un étal au Grand Marché de Ouagadougou. Vous vendez différents produits : tissus, légumes, artisanat. Comment organisez-vous vos informations ?

```julia
# Approche simple mais limitée
nom_produit = "Pagne Faso Dan Fani"
prix = 15000  # FCFA
quantite = 50
origine = "Ouagadougou"

# Mais si vous avez 100 produits différents ?
# Il vous faut une meilleure organisation !
```

## 🏗️ Qu'est-ce qu'une Structure (Struct) ?

Une **structure** est comme un conteneur qui regroupe plusieurs données liées. C'est votre façon de créer vos propres types de données !

### Structure de base (immutable)

```julia
struct Produit
    nom::String
    prix::Int
    quantite::Int
    origine::String
end

# Création d'un produit
pagne = Produit("Pagne Faso Dan Fani", 15000, 50, "Ouagadougou")

# Accès aux propriétés
println("Produit: $(pagne.nom)")
println("Prix: $(pagne.prix) FCFA")
println("Stock: $(pagne.quantite) unités")
println("Origine: $(pagne.origine)")
```

### 🔄 Structure mutable

```julia
mutable struct Inventaire
    nom::String
    prix::Int
    quantite::Int
    origine::String
end

# Maintenant on peut modifier !
legume = Inventaire("Tomates", 500, 100, "Koudougou")
println("Stock initial: $(legume.quantite)")

# Vente de 20 tomates
legume.quantite -= 20
println("Stock après vente: $(legume.quantite)")
```

## 🤔 Immutable vs Mutable : Quand utiliser quoi ?

### Structures Immutables (`struct`)
- ✅ **Utiliser pour** : Données qui ne changent pas (coordonnées GPS, dates, informations personnelles)
- ✅ **Avantages** : Plus rapides, sûres, prévisibles
- ❌ **Inconvénient** : Impossible de modifier après création

```julia
struct Position
    latitude::Float64
    longitude::Float64
    ville::String
end

ouaga = Position(12.3714, -1.5197, "Ouagadougou")
# ouaga.latitude = 12.0  # ❌ ERREUR ! Impossible de modifier
```

### Structures Mutables (`mutable struct`)
- ✅ **Utiliser pour** : Données qui évoluent (scores de jeu, inventaires, comptes bancaires)
- ✅ **Avantages** : Flexibles, modifiables
- ❌ **Inconvénient** : Légèrement plus lentes

```julia
mutable struct CompteBank
    nom::String
    solde::Int  # en FCFA
    numero::String
end

compte_amadou = CompteBank("Amadou Ouédraogo", 250000, "BF001234")
# Dépôt d'argent
compte_amadou.solde += 50000  # ✅ Ça marche !
```

## 🏗️ Constructeurs : Personnaliser la création

### Constructeur interne
```julia
struct Etudiant
    nom::String
    age::Int
    niveau::String
    
    # Constructeur avec validation
    function Etudiant(nom::String, age::Int, niveau::String)
        if age < 16
            error("L'âge minimum est 16 ans")
        end
        if !(niveau in ["Première", "Terminale", "Université"])
            error("Niveau non reconnu")
        end
        new(nom, age, niveau)
    end
end

# Utilisation
fatima = Etudiant("Fatima Sawadogo", 18, "Terminale")  # ✅ OK
# jeune = Etudiant("Ali", 15, "Première")  # ❌ Erreur !
```

### Constructeur externe
```julia
struct Joueur
    nom::String
    points::Int
    niveau::String
end

# Constructeur pour nouveau joueur
function Joueur(nom::String)
    Joueur(nom, 0, "Débutant")
end

# Utilisation
ibrahim = Joueur("Ibrahim Compaoré")  # Points = 0, Niveau = "Débutant"
aicha = Joueur("Aïcha Traoré", 1500, "Expert")  # Tous les paramètres
```

## 🎮 Exemple pratique : Système de jeu burkinabè

```julia
mutable struct Guerrier
    nom::String
    vie::Int
    force::Int
    defense::Int
    arme::String
    origine::String
end

# Constructeur pour guerriers traditionnels
function Guerrier(nom::String, origine::String)
    armes_traditionnelles = ["Lance", "Arc", "Épée", "Bouclier"]
    arme = rand(armes_traditionnelles)
    
    Guerrier(nom, 100, rand(10:20), rand(5:15), arme, origine)
end

# Création de guerriers
yennenga = Guerrier("Princesse Yennenga", "Tenkodogo")
samori = Guerrier("Samori Touré", "Bobo-Dioulasso")

println("⚔️  $(yennenga.nom) de $(yennenga.origine)")
println("💪 Force: $(yennenga.force), Défense: $(yennenga.defense)")
println("🗡️  Arme: $(yennenga.arme)")

# Fonction de combat
function attaquer!(attaquant::Guerrier, defenseur::Guerrier)
    degats = max(1, attaquant.force - defenseur.defense)
    defenseur.vie -= degats
    
    println("$(attaquant.nom) attaque $(defenseur.nom) avec $(attaquant.arme)!")
    println("💥 Dégâts: $(degats), Vie restante: $(defenseur.vie)")
end

# Combat !
attaquer!(yennenga, samori)
```

## 📊 Types avec paramètres

```julia
struct Point{T}
    x::T
    y::T
end

struct Person
    name::String
end

pp = Point(Person("Hamidou"), Person("Mahamadi"))
println(pp)

# Différents types de points
point_entier = Point(5, 10)        # Point{Int64}
point_decimal = Point(5.5, 10.2)   # Point{Float64}
point_texte = Point("A", "B")      # Point{String}

typeof(point_entier)   # Point{Int64}
typeof(point_decimal)  # Point{Float64}
```

## 🎯 Méthodes spécialisées

```julia
struct Monnaie
    montant::Float64
    devise::String
end

# Méthode d'affichage personnalisée
function Base.show(io::IO, m::Monnaie)
    if m.devise == "FCFA"
        print(io, "$(Int(m.montant)) FCFA")
    else
        print(io, "$(m.montant) $(m.devise)")
    end
end

# Opération d'addition
function Base.+(m1::Monnaie, m2::Monnaie)
    if m1.devise != m2.devise
        error("Impossible d'additionner des devises différentes")
    end
    Monnaie(m1.montant + m2.montant, m1.devise)
end

# Utilisation
salaire = Monnaie(150000.0, "FCFA")
bonus = Monnaie(25000.0, "FCFA")
total = salaire + bonus

println(salaire)  # 150000 FCFA
println(total)    # 175000 FCFA
```

## 🎪 Exercice rapide : Votre première structure

Créez une structure `Personne` avec :
- nom (String)
- age (Int)
- ville (String)

```julia
struct Personne
    # À vous de compléter !
end

# Testez avec :
moi = Personne("Votre nom", votre_age, "Votre ville")
println("Je suis $(moi.nom), j'ai $(moi.age) ans et je vis à $(moi.ville)")
```

## 📝 Points clés à retenir

1. **`struct`** = immutable (ne peut pas être modifié)
2. **`mutable struct`** = mutable (peut être modifié)
3. **Constructeurs** permettent de valider et personnaliser la création
4. **Types paramétrés** pour plus de flexibilité
5. **Méthodes personnalisées** pour améliorer l'utilisation

## 🚀 Dans la pratique suivante...

Nous allons créer des structures pour :
1. 🎮 Un système de jeu avec des joueurs
2. 📦 Un système d'inventaire pour un magasin
3. 📚 Un système de gestion d'étudiants

Prêt(e) à structurer vos données comme un(e) vrai(e) programmeur/programmeuse burkinabè ? 

🎯 **Code d'abord, théorie ensuite !** - Passons à la pratique !