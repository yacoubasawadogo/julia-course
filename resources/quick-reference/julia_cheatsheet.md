# Aide-Mémoire Référence Rapide Julia

## Syntaxe de Base

### Variables et Types
```julia
x = 42              # Entier
y = 3.14            # Flottant
nom = "Julia"       # Chaîne
flag = true         # Booléen
nothing             # Valeur nulle
```

### Vérification de Types
```julia
typeof(x)           # Obtenir le type
isa(x, Int)         # Vérifier le type
convert(Float64, x) # Convertir le type
Int(3.14)          # Conversion par constructeur
```

## Structures de Données

### Tableaux
```julia
arr = [1, 2, 3]              # Vecteur
matrice = [1 2 3; 4 5 6]     # Matrice
arr[1]                       # Indexation (base 1 !)
arr[end]                     # Dernier élément
push!(arr, 4)                # Ajouter un élément
pop!(arr)                    # Supprimer le dernier
```

### Opérations sur Tableaux
```julia
arr .+ 2            # Addition élément par élément
arr .* arr          # Multiplication élément par élément
sum(arr)            # Somme de tous les éléments
maximum(arr)        # Trouver le maximum
length(arr)         # Longueur du tableau
size(matrice)       # Dimensions de la matrice
```

### Dictionnaires
```julia
dict = Dict("a" => 1, "b" => 2)
dict["c"] = 3       # Ajouter/mettre à jour
delete!(dict, "a")  # Supprimer une clé
haskey(dict, "b")   # Vérifier si la clé existe
keys(dict)          # Obtenir toutes les clés
values(dict)        # Obtenir toutes les valeurs
```

## Fonctions

### Fonctions de Base
```julia
# Forme standard
function ajouter(x, y)
    return x + y
end

# Forme courte
multiplier(x, y) = x * y

# Fonction anonyme
carre = x -> x^2

# Arguments optionnels
function saluer(nom="Monde")
    println("Bonjour, $nom !")
end

# Arguments par mots-clés
function tracer(x; couleur="bleu", largeur=1)
    # ...
end
```

### Répartition Multiple
```julia
traiter(x::Int) = x * 2
traiter(x::String) = uppercase(x)
traiter(x::Vector) = sum(x)
```

## Flux de Contrôle

### Conditionnels
```julia
if x > 0
    println("Positif")
elseif x < 0
    println("Négatif")
else
    println("Zéro")
end

# Opérateur ternaire
resultat = x > 0 ? "positif" : "non-positif"

# Évaluation en court-circuit
x > 0 && println("Positif")
x < 0 || println("Non-négatif")
```

### Boucles
```julia
# Boucle for
for i in 1:10
    println(i)
end

# Boucle while
while x < 10
    x += 1
end

# Énumération
for (index, valeur) in enumerate(arr)
    println("$index: $valeur")
end

# Break et continue
for i in 1:10
    i == 5 && continue
    i == 8 && break
    println(i)
end
```

### Compréhensions
```julia
carres = [x^2 for x in 1:10]
pairs = [x for x in 1:100 if x % 2 == 0]
matrice = [i * j for i in 1:3, j in 1:3]
```

## Chaînes

### Opérations sur Chaînes
```julia
str = "Bonjour, Julia !"
length(str)              # Longueur de la chaîne
uppercase(str)           # Convertir en majuscules
lowercase(str)           # Convertir en minuscules
replace(str, "Julia" => "Monde")  # Remplacer
split("a,b,c", ",")      # Diviser la chaîne
join(["a", "b", "c"], "-")  # Joindre les chaînes
```

### Interpolation de Chaînes
```julia
nom = "Julia"
age = 10
message = "Bonjour, $nom ! Vous avez $age ans."
resultat = "2 + 2 = $(2 + 2)"
```

## E/S de Fichiers

### Lecture de Fichiers
```julia
# Lire tout le fichier
contenu = read("fichier.txt", String)

# Lire les lignes
lignes = readlines("fichier.txt")

# Lire avec open
open("fichier.txt", "r") do fichier
    for ligne in eachline(fichier)
        println(ligne)
    end
end
```

### Écriture de Fichiers
```julia
# Écrire une chaîne
write("sortie.txt", "Bonjour, Monde !")

# Écrire avec open
open("sortie.txt", "w") do fichier
    write(fichier, "Ligne 1\n")
    write(fichier, "Ligne 2\n")
end
```

## Gestion d'Erreurs

### Try-Catch
```julia
try
    operation_risquee()
catch e
    println("Erreur : ", e)
finally
    nettoyage()
end

# Lancer une erreur
error("Quelque chose s'est mal passé !")

# Assert
@assert x > 0 "x doit être positif"
```

## Types et Structures

### Types Personnalisés
```julia
# Structure immuable
struct Point
    x::Float64
    y::Float64
end

# Structure mutable
mutable struct Compteur
    count::Int
end

# Constructeur
Point(1.0, 2.0)

# Types paramétriques
struct Conteneur{T}
    valeur::T
end
```

## Macros Utiles

```julia
@time expression         # Chronométrer l'exécution
@elapsed expression      # Retourner le temps d'exécution
@show variable          # Afficher le nom et la valeur de la variable
@assert condition       # Assert condition
@doc function          # Afficher la documentation
```

## Gestion des Paquets

```julia
using Pkg

Pkg.add("NomPaquet")        # Installer un paquet
Pkg.remove("NomPaquet")     # Supprimer un paquet
Pkg.update()                # Mettre à jour les paquets
Pkg.status()                # Afficher les paquets installés

using NomPaquet             # Charger un paquet
import NomPaquet: func      # Importer une fonction spécifique
```

## Conseils de Performance

1. **Stabilité des Types** : Assurez-vous que les fonctions retournent des types cohérents
2. **Éviter les Variables Globales** : Utilisez des variables locales ou des globales const
3. **Préallouer les Tableaux** : Ne pas faire croître les tableaux dans les boucles
4. **Utiliser les Vues** : `@view arr[1:10]` au lieu de `arr[1:10]`
5. **Vectoriser les Opérations** : Utiliser la syntaxe point `.+`, `.*`
6. **Annotations de Types** : Ajouter quand nécessaire pour la clarté/performance

## Motifs Courants

### Map, Filter, Reduce
```julia
map(x -> x^2, [1, 2, 3])           # [1, 4, 9]
filter(x -> x > 2, [1, 2, 3, 4])   # [3, 4]
reduce(+, [1, 2, 3, 4])            # 10
```

### Diffusion
```julia
arr = [1, 2, 3]
arr .+ 1                   # [2, 3, 4]
sin.(arr)                  # Appliquer à chaque élément
f.(x, y)                   # Application élément par élément
```

### Opérateur Pipe
```julia
resultat = donnees |>
    x -> filter(iseven, x) |>
    x -> map(sqrt, x) |>
    sum
```

## Conseils REPL

- `;` - Mode shell
- `?` - Mode aide
- `]` - Mode paquet
- `↑/↓` - Navigation historique
- `Tab` - Autocomplétion
- `Ctrl+C` - Interrompre l'exécution
- `Ctrl+D` - Quitter le REPL

## Exemples Rapides

### Fibonacci
```julia
fib(n) = n ≤ 1 ? n : fib(n-1) + fib(n-2)
```

### Vérification de Nombre Premier
```julia
estpremier(n) = n > 1 && all(n % i != 0 for i in 2:isqrt(n))
```

### Tri Rapide
```julia
trirapide(arr) = length(arr) ≤ 1 ? arr :
    [trirapide(filter(<(arr[1]), arr[2:end]));
     arr[1];
     trirapide(filter(≥(arr[1]), arr[2:end]))]
```

---

Rappel : Julia utilise l'**indexation base 1** et est **colonne-majeur** !