# 📚 Module 1 - Session 2: Variables et Types en Julia
**Durée: 2 heures** | **Niveau: Débutant**

---

## 🎯 Objectifs de la Session

À la fin de cette session, vous serez capable de:
- ✅ Comprendre le système de types de Julia
- ✅ Créer et manipuler différents types de variables
- ✅ Effectuer des conversions de types
- ✅ Utiliser les structures de contrôle de base
- ✅ Comprendre la hiérarchie des types

---

## 🔍 Le Système de Types de Julia

### Pourquoi les Types sont Importants?

1. **Performance**: Julia optimise le code selon les types
2. **Sécurité**: Évite les erreurs à l'exécution
3. **Clarté**: Rend le code plus lisible
4. **Dispatch Multiple**: Permet des fonctions spécialisées

### Hiérarchie des Types

```
Any
├── Number
│   ├── Real
│   │   ├── Integer
│   │   │   ├── Signed (Int8, Int16, Int32, Int64)
│   │   │   └── Unsigned (UInt8, UInt16, UInt32, UInt64)
│   │   └── AbstractFloat (Float16, Float32, Float64)
│   └── Complex
├── AbstractString
│   └── String
├── AbstractChar
│   └── Char
└── Bool
```

---

## 📊 Types Numériques

### Entiers (Integer)

```julia
# Entiers signés
petit_nombre::Int8 = 127        # -128 à 127
nombre_normal::Int64 = 1000000  # Par défaut sur 64-bit
grand_nombre = 9_223_372_036_854_775_807  # Maximum Int64

# Entiers non-signés
age::UInt8 = 25                 # 0 à 255
population::UInt32 = 3_000_000  # Toujours positif
```

### Nombres à Virgule Flottante

```julia
# Différentes précisions
prix_simple::Float32 = 15.99f0   # f0 pour Float32
prix_precis::Float64 = 15.99     # Par défaut
pi_approx = 3.141592653589793

# Nombres spéciaux
infini = Inf
moins_infini = -Inf
pas_un_nombre = NaN
```

### Nombres Complexes

```julia
# Notation complexe
z1 = 3 + 4im
z2 = complex(3, 4)  # Équivalent

# Opérations
module_z = abs(z1)      # 5.0
angle_z = angle(z1)     # 0.9273...
conjugue = conj(z1)     # 3 - 4im
```

### Nombres Rationnels

```julia
# Fractions exactes
fraction = 3//4         # Trois quarts
somme = 1//2 + 1//3     # 5//6
decimal = float(3//4)   # 0.75
```

---

## 📝 Types Texte

### Caractères (Char)

```julia
# Un seul caractère
lettre = 'A'
chiffre = '5'
symbole = '€'
emoji = '🇧🇫'

# Opérations sur caractères
suivant = 'A' + 1       # 'B'
code_ascii = Int('A')   # 65
majuscule = uppercase('a')  # 'A'
```

### Chaînes de Caractères (String)

```julia
# Création de chaînes
nom = "Ouagadougou"
phrase = "Capitale du Burkina Faso"
multiligne = """
    Première ligne
    Deuxième ligne
    Troisième ligne
"""

# Interpolation
ville = "Bobo-Dioulasso"
habitants = 903_887
message = "La ville de $ville compte $habitants habitants"

# Échappement
guillemets = "Il a dit \"Bonjour\""
chemin = "C:\\Users\\Documents"
```

### Opérations sur les Chaînes

```julia
# Concaténation
prenom = "Thomas"
nom = "Sankara"
nom_complet = prenom * " " * nom

# Méthodes utiles
longueur = length("Burkina")     # 7
maj = uppercase("faso")          # "FASO"
min = lowercase("BURKINA")       # "burkina"
contient = occursin("Burk", "Burkina")  # true

# Découpage
texte = "Burkina-Faso"
parties = split(texte, "-")      # ["Burkina", "Faso"]
premier_car = first(texte)       # 'B'
derniers = last(texte, 4)        # "Faso"
```

---

## ✅ Type Booléen

### Valeurs et Opérations

```julia
# Valeurs booléennes
vrai = true
faux = false

# Opérateurs logiques
et = true && false      # false
ou = true || false      # true
non = !true             # false

# Comparaisons
egal = 5 == 5           # true
different = 5 != 3      # true
plus_grand = 10 > 5     # true
plus_petit_egal = 3 <= 3  # true
```

### Évaluation Court-Circuit

```julia
# && s'arrête au premier false
x = 5
y = 0
resultat = (y != 0) && (x/y > 2)  # false, sans erreur

# || s'arrête au premier true
condition = true || fonction_couteuse()  # true, fonction non appelée
```

---

## 🔄 Conversions de Types

### Conversions Explicites

```julia
# Nombres vers autres nombres
entier = Int(3.7)           # 3 (troncature)
flottant = Float64(42)      # 42.0
rationnel = Rational(0.75)  # 3//4

# Chaînes vers nombres
nombre = parse(Int, "123")       # 123
decimal = parse(Float64, "3.14") # 3.14

# Nombres vers chaînes
texte = string(42)          # "42"
format = string(3.14159)    # "3.14159"
```

### Vérification de Types

```julia
# Vérifier le type
typeof(42)              # Int64
typeof(3.14)            # Float64
typeof("Julia")         # String

# Tester l'appartenance
isa(42, Int)            # true
isa(42, Number)         # true
isa("Julia", String)    # true

# Sous-type
Int <: Number           # true
Float64 <: Real         # true
String <: Any           # true
```

---

## 🌍 Applications Pratiques

### Exemple 1: Gestion d'un Compte Bancaire

```julia
# Types appropriés pour l'argent
solde_initial = 150_000.00  # Float64 pour les centimes
depot = 25_000
retrait = 10_500.50

# Calculs
nouveau_solde = solde_initial + depot - retrait
est_positif = nouveau_solde > 0

# Affichage formaté
println("Solde: $(round(nouveau_solde, digits=2)) FCFA")
println("Compte actif: $est_positif")
```

### Exemple 2: Données Météorologiques

```julia
# Structure de données météo
ville = "Ouagadougou"
temperature_celsius = 35.5
humidite_pourcent = 65
pluie_mm = 0.0
ensoleille = true

# Conversions
temperature_fahrenheit = temperature_celsius * 9/5 + 32
categorie = temperature_celsius > 30 ? "Chaud" : "Modéré"

println("Météo à $ville:")
println("- Température: $temperature_celsius°C ($(round(temperature_fahrenheit, digits=1))°F)")
println("- Conditions: $categorie")
```

---

## 🎮 Structures de Contrôle

### Instructions If-Else

```julia
age = 18

if age < 18
    println("Mineur")
elseif age == 18
    println("Tout juste majeur!")
else
    println("Majeur")
end

# Opérateur ternaire
statut = age >= 18 ? "Majeur" : "Mineur"
```

### Boucles For

```julia
# Itération simple
for i in 1:5
    println("Itération $i")
end

# Parcourir une chaîne
for lettre in "Burkina"
    println(lettre)
end

# Avec pas
for nombre in 0:10:100
    print("$nombre ")
end
```

### Boucles While

```julia
compteur = 0
while compteur < 5
    println("Compteur: $compteur")
    compteur += 1
end

# Avec condition de sortie
x = 100
while true
    x = x ÷ 2
    println(x)
    x < 10 && break
end
```

---

## 💡 Bonnes Pratiques

### Nommage des Variables

```julia
# ✅ BON
age_utilisateur = 25
prix_total_fcfa = 15000
est_valide = true
NOM_CONSTANTE = 100

# ❌ MAUVAIS
a = 25              # Pas descriptif
prixTotal = 15000   # CamelCase non recommandé
x = true            # Ambigu
```

### Annotations de Type (Optionnelles)

```julia
# Quand les utiliser
function calculer_tva(prix::Float64, taux::Float64)::Float64
    return prix * taux
end

# Pour la documentation
population::Int64 = 21_000_000  # Population du Burkina Faso
```

---

## 🎯 Points Clés à Retenir

1. **Julia est dynamiquement typé** mais fortement typé
2. **Les types améliorent la performance** quand bien utilisés
3. **La conversion explicite** évite les erreurs
4. **La hiérarchie des types** permet la généricité
5. **Les structures de contrôle** sont expressives et flexibles

---

## 🚀 Prochaines Étapes

Dans la prochaine session, nous approfondirons:
- Les fonctions et leurs signatures
- Les méthodes et le dispatch multiple
- Les fonctions anonymes et closures
- La gestion des erreurs

---

## 📝 Notes pour l'Instructeur

### Démonstrations Live:
1. Montrer la hiérarchie avec `supertype()` et `subtypes()`
2. Démontrer l'impact des types sur la performance
3. Montrer les erreurs de conversion communes
4. Explorer les types avec `typeof()` et `isa()`

### Exercices Suggérés:
- Créer un système de gestion d'inventaire avec types appropriés
- Implémenter un convertisseur de devises FCFA/Euro/Dollar
- Créer un validateur de données avec vérification de types

### Points d'Attention:
- Les étudiants confondent souvent `=` (affectation) et `==` (comparaison)
- La division `/` retourne toujours un Float64, même entre entiers
- Les chaînes sont immuables en Julia