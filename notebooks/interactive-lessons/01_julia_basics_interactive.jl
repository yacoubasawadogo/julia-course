# Carnet Interactif des Bases de Julia
# Ceci est un carnet Pluto.jl pour l'apprentissage interactif
#
# 📚 RÉSUMÉ D'APPRENTISSAGE : Consultez resume_carnet_interactif.md
# Ce résumé explique comment maximiser votre apprentissage avec Pluto.jl

### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ Cell 1: Welcome
md"""
# 🎯 Bases Interactives de Julia

Bienvenue dans votre première leçon Julia interactive ! Ce carnet vous enseignera les fondamentaux de Julia à travers la pratique.

## Comment utiliser ce carnet :
1. Cliquez sur n'importe quelle cellule pour l'éditer
2. Appuyez sur Shift+Entrée pour exécuter une cellule
3. Expérimentez avec le code !
4. Complétez les exercices
"""

# ╔═╡ Cell 2: Variables and Types
md"""
## 📚 Leçon 1 : Variables et Types

Julia est typé dynamiquement mais vous pouvez spécifier les types pour la performance.
"""

# Essayez de changer ces valeurs !
mon_entier = 42
mon_flottant = 3.14159
ma_chaine = "Bonjour, Julia !"
mon_booleen = true

# Vérifier leurs types
println("Type entier : ", typeof(mon_entier))
println("Type flottant : ", typeof(mon_flottant))
println("Type chaîne : ", typeof(ma_chaine))
println("Type booléen : ", typeof(mon_booleen))

# ╔═╡ Cell 3: Exercise 1
md"""
### 🏋️ Exercice 1 : Créez Vos Variables

Créez des variables pour :
1. Votre âge (entier)
2. Votre taille en mètres (flottant)
3. Votre nom (chaîne)
4. Si vous aimez programmer (booléen)
"""

# Votre code ici :
age = 0  # Changez ceci !
taille = 0.0  # Changez ceci !
nom = ""  # Changez ceci !
aime_programmer = false  # Changez ceci !

# Validation
if age > 0 && taille > 0 && nom != "" && aime_programmer
    md"✅ Excellent travail ! Vous avez créé toutes les variables correctement !"
else
    md"⚠️ Assurez-vous de définir toutes les variables avec des valeurs appropriées"
end

# ╔═╡ Cell 4: Arrays and Operations
md"""
## 📚 Leçon 2 : Tableaux et Opérations

Les tableaux de Julia sont puissants et rapides !
"""

# Créer des tableaux
nombres = [1, 2, 3, 4, 5]
carres = nombres .^ 2  # Mise au carré élément par élément
pairs = nombres[nombres .% 2 .== 0]  # Filtrer les nombres pairs

println("Original : ", nombres)
println("Carrés : ", carres)
println("Nombres pairs : ", pairs)

# ╔═╡ Cell 5: Exercise 2
md"""
### 🏋️ Exercice 2 : Manipulation de Tableaux

Créez un tableau des 10 premiers nombres de Fibonacci
"""

# Votre code ici :
function fibonacci(n)
    if n <= 2
        return ones(Int, n)
    end
    fib = zeros(Int, n)
    fib[1] = fib[2] = 1
    for i in 3:n
        fib[i] = fib[i-1] + fib[i-2]
    end
    return fib
end

nombres_fib = fibonacci(10)

# Validation
attendu = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]
if nombres_fib == attendu
    md"✅ Parfait ! Votre séquence de Fibonacci est correcte !"
else
    md"⚠️ Pas tout à fait. Les 10 premiers nombres de Fibonacci sont : $attendu"
end

# ╔═╡ Cell 6: Functions
md"""
## 📚 Leçon 3 : Fonctions

Les fonctions Julia sont concises et puissantes !
"""

# Plusieurs façons de définir des fonctions
# Forme standard
function saluer(nom)
    return "Bonjour, $nom !"
end

# Forme courte
carre(x) = x^2

# Fonction anonyme
cube = x -> x^3

println(saluer("Julia"))
println("5 au carré = ", carre(5))
println("3 au cube = ", cube(3))

# ╔═╡ Cell 7: Exercise 3
md"""
### 🏋️ Exercice 3 : Créer des Fonctions

Créez trois fonctions :
1. `celsius_vers_fahrenheit(c)` - Convertir Celsius en Fahrenheit
2. `est_premier(n)` - Vérifier si un nombre est premier
3. `factorielle(n)` - Calculer la factorielle
"""

# Votre code ici :
celsius_vers_fahrenheit(c) = c * 9/5 + 32

function est_premier(n)
    n <= 1 && return false
    for i in 2:isqrt(n)
        n % i == 0 && return false
    end
    return true
end

function factorial(n)
    n < 0 && error("Negative factorial")
    n <= 1 && return 1
    return n * factorial(n-1)
end

# Tests
test_results = [
    celsius_to_fahrenheit(0) ≈ 32,
    celsius_to_fahrenheit(100) ≈ 212,
    is_prime(17) == true,
    is_prime(20) == false,
    factorial(5) == 120
]

if all(test_results)
    md"✅ Excellent! All functions work correctly!"
else
    md"⚠️ Some functions need fixing. Check your implementations."
end

# ╔═╡ Cell 8: Control Flow
md"""
## 📚 Lesson 4: Control Flow

Master if-else, loops, and comprehensions!
"""

# If-else example
function grade_message(score)
    if score >= 90
        return "A - Excellent!"
    elseif score >= 80
        return "B - Good job!"
    elseif score >= 70
        return "C - Satisfactory"
    else
        return "Need improvement"
    end
end

# For loop
println("Counting:")
for i in 1:5
    println("  $i")
end

# While loop
countdown = 3
while countdown > 0
    println("T-$countdown...")
    global countdown -= 1
end
println("Liftoff! 🚀")

# Comprehension
squares = [x^2 for x in 1:5]
println("Squares: ", squares)

# ╔═╡ Cell 9: Exercise 4
md"""
### 🏋️ Exercise 4: FizzBuzz Challenge

Implement FizzBuzz for numbers 1 to 20:
- Print "Fizz" for multiples of 3
- Print "Buzz" for multiples of 5
- Print "FizzBuzz" for multiples of both
- Print the number otherwise
"""

# Your code here:
function fizzbuzz(n)
    result = []
    for i in 1:n
        if i % 15 == 0
            push!(result, "FizzBuzz")
        elseif i % 3 == 0
            push!(result, "Fizz")
        elseif i % 5 == 0
            push!(result, "Buzz")
        else
            push!(result, string(i))
        end
    end
    return result
end

fb_result = fizzbuzz(15)

# Validation
expected_fb = ["1", "2", "Fizz", "4", "Buzz", "Fizz", "7", "8", "Fizz", "Buzz", "11", "Fizz", "13", "14", "FizzBuzz"]
if fb_result == expected_fb
    md"✅ Perfect FizzBuzz implementation!"
else
    md"⚠️ Check your FizzBuzz logic"
end

# ╔═╡ Cell 10: Data Structures
md"""
## 📚 Lesson 5: Data Structures

Dictionaries and custom types!
"""

# Dictionary
student = Dict(
    "name" => "Alice",
    "age" => 22,
    "grades" => [95, 87, 92]
)

println("Student: ", student["name"])
println("Average grade: ", sum(student["grades"]) / length(student["grades"]))

# Custom type
struct Point
    x::Float64
    y::Float64
end

p = Point(3.0, 4.0)
distance = sqrt(p.x^2 + p.y^2)
println("Distance from origin: ", distance)

# ╔═╡ Cell 11: Final Challenge
md"""
## 🏆 Final Challenge: Mini Calculator

Create a calculator that can:
1. Add two numbers
2. Subtract two numbers
3. Multiply two numbers
4. Divide two numbers (handle division by zero!)
5. Calculate power
"""

# Your code here:
struct Calculator end

function calculate(op::String, a::Number, b::Number)
    if op == "+"
        return a + b
    elseif op == "-"
        return a - b
    elseif op == "*"
        return a * b
    elseif op == "/"
        b == 0 ? error("Division by zero!") : return a / b
    elseif op == "^"
        return a ^ b
    else
        error("Unknown operation: $op")
    end
end

# Test the calculator
test_cases = [
    calculate("+", 5, 3) == 8,
    calculate("-", 10, 4) == 6,
    calculate("*", 6, 7) == 42,
    calculate("/", 20, 4) == 5,
    calculate("^", 2, 10) == 1024
]

if all(test_cases)
    md"""
    # 🎉 Congratulations!
    
    You've completed the Julia Basics Interactive Lesson!
    
    ## What you learned:
    ✅ Variables and types
    ✅ Arrays and operations
    ✅ Functions
    ✅ Control flow
    ✅ Data structures
    
    ## Next steps:
    1. Try modifying the exercises
    2. Create your own challenges
    3. Move on to Module 2!
    
    Happy coding! 🚀
    """
else
    md"⚠️ Calculator needs some fixes"
end

# ╔═╡ Cell Order:
# ╟─Cell 1
# ╟─Cell 2
# ╟─Cell 3
# ╟─Cell 4
# ╟─Cell 5
# ╟─Cell 6
# ╟─Cell 7
# ╟─Cell 8
# ╟─Cell 9
# ╟─Cell 10
# ╟─Cell 11