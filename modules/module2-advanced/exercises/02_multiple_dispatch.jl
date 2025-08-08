# Exercice 2 : Répartition Multiple (Multiple Dispatch)
# Module 2 : Programmation Julia Avancée  
# Durée : 45 minutes

# 📚 AVANT DE COMMENCER
# Lisez le résumé d'apprentissage : resume_02_multiple_dispatch.md
# Découvrez pourquoi la répartition multiple est le "super-pouvoir" de Julia !

println("📚 Consultez le résumé : modules/module2-advanced/resume_02_multiple_dispatch.md")
println("Appuyez sur Entrée quand vous êtes prêt à explorer la magie de Julia...")
readline()

println("🎭 Répartition Multiple : La Magie de Julia")
println("="^50)

# Partie 1 : Bases de la Répartition Multiple
println("\n🎯 Partie 1 : Concepts Fondamentaux")

# Fonction simple avec différentes méthodes
function saluer(nom::String)
    return "Bonjour, $nom !"
end

function saluer(nombre::Integer)
    return "Salutations, numéro $nombre !"
end

function saluer(x::Float64)
    return "Salut, nombre flottant $(round(x, digits=2)) !"
end

function saluer(personne::String, langue::String)
    if langue == "français"
        return "Bonjour, $personne !"
    elseif langue == "anglais" 
        return "Hello, $personne!"
    elseif langue == "espagnol"
        return "Hola, $personne!"
    else
        return "Salut, $personne !"
    end
end

# Test des différentes méthodes
println("Tests de la fonction saluer :")
println(saluer("Alice"))
println(saluer(42))
println(saluer(3.14159))
println(saluer("Bob", "espagnol"))

# Inspection des méthodes
println("\nMéthodes disponibles pour 'saluer' :")
println(methods(saluer))

# Partie 2 : Répartition sur Types Abstraits et Concrets
println("\n🏗️ Partie 2 : Hiérarchie de Types et Spécialisation")

# Définir une hiérarchie de types
abstract type Véhicule end
abstract type VéhiculeTerrestre <: Véhicule end
abstract type VéhiculeAérien <: Véhicule end

struct Voiture <: VéhiculeTerrestre
    marque::String
    vitesse_max::Int
end

struct Vélo <: VéhiculeTerrestre
    type::String
    nb_vitesses::Int
end

struct Avion <: VéhiculeAérien
    compagnie::String
    altitude_max::Int
end

struct Hélicoptère <: VéhiculeAérien
    modèle::String
    nb_pales::Int
end

# Fonctions spécialisées par type
function déplacer(v::VéhiculeTerrestre)
    return "Je me déplace sur la route"
end

function déplacer(v::VéhiculeAérien)
    return "Je vole dans les airs"
end

function déplacer(v::Voiture)
    return "Je roule à $(v.vitesse_max) km/h avec ma $(v.marque)"
end

function déplacer(v::Avion)
    return "Je vole à $(v.altitude_max)m d'altitude avec $(v.compagnie)"
end

function entretenir(v::Véhicule)
    return "Entretien standard d'un véhicule"
end

function entretenir(v::VéhiculeTerrestre)
    return "Vérification des pneus et de la mécanique"
end

function entretenir(v::Voiture)
    return "Vidange, contrôle technique et lavage"
end

# Tests de la hiérarchie
println("Tests de la hiérarchie de véhicules :")
ma_voiture = Voiture("Toyota", 180)
mon_vélo = Vélo("VTT", 21)
mon_avion = Avion("Air France", 12000)
mon_hélico = Hélicoptère("Apache", 4)

véhicules = [ma_voiture, mon_vélo, mon_avion, mon_hélico]

for v in véhicules
    println("$(typeof(v)) : $(déplacer(v))")
    println("  Entretien : $(entretenir(v))")
end

# Partie 3 : Répartition Multiple Complexe
println("\n🔥 Partie 3 : Répartition Multiple Avancée")

# Opérations mathématiques sur différents types
function combiner(a::Number, b::Number)
    return a + b
end

function combiner(a::String, b::String)
    return a * " + " * b
end

function combiner(a::Vector, b::Vector)
    return vcat(a, b)
end

function combiner(a::Number, b::String)
    return string(a) * " et " * b
end

function combiner(a::String, b::Number)
    return a * " et " * string(b)
end

# Test de combinaisons
println("Tests de combinaisons :")
println("5 + 3 = ", combiner(5, 3))
println("\"Hello\" + \"World\" = ", combiner("Hello", "World"))
println("[1,2] + [3,4] = ", combiner([1,2], [3,4]))
println("42 + \"Julia\" = ", combiner(42, "Julia"))
println("\"Prix\" + 100 = ", combiner("Prix", 100))

# Partie 4 : Système de Combat avec Répartition Multiple
println("\n⚔️ Partie 4 : Système de Combat RPG")

# Types de personnages
abstract type Personnage end

struct Guerrier <: Personnage
    nom::String
    force::Int
    defense::Int
end

struct Mage <: Personnage
    nom::String
    magie::Int
    mana::Int
end

struct Voleur <: Personnage
    nom::String
    agilité::Int
    discrétion::Int
end

# Combat avec répartition multiple
function combattre(attaquant::Guerrier, défenseur::Guerrier)
    dégâts = max(1, attaquant.force - défenseur.defense)
    return "$(attaquant.nom) frappe $(défenseur.nom) avec son épée ! Dégâts : $dégâts"
end

function combattre(attaquant::Mage, défenseur::Personnage)
    dégâts = attaquant.magie + rand(1:10)
    return "$(attaquant.nom) lance un sort sur $(défenseur.nom) ! Dégâts magiques : $dégâts"
end

function combattre(attaquant::Voleur, défenseur::Personnage)
    if rand() < 0.3  # 30% de chance d'attaque critique
        dégâts = attaquant.agilité * 2
        return "$(attaquant.nom) attaque $(défenseur.nom) par surprise ! Critique : $dégâts"
    else
        dégâts = attaquant.agilité
        return "$(attaquant.nom) attaque $(défenseur.nom) furtivement. Dégâts : $dégâts"
    end
end

function combattre(attaquant::Personnage, défenseur::Mage)
    if défenseur.mana > 10
        return "$(défenseur.nom) se protège avec un bouclier magique ! Attaque bloquée."
    else
        return combattre(attaquant, défenseur)  # Appel récursif avec types plus génériques
    end
end

# Test du système de combat
println("Système de combat :")
samory = Guerrier("Samory", 15, 8)
nabonswendé = Mage("Nabonswendé", 20, 50)
yennenga = Voleur("Yennenga", 12, 15)

combattants = [samory, nabonswendé, yennenga]

println("Tour de combat :")
for i in 1:3
    attaquant = combattants[i]
    défenseur = combattants[mod1(i+1, 3)]
    println(combattre(attaquant, défenseur))
end

# Partie 5 : Opérateurs Personnalisés avec Répartition Multiple
println("\n🧮 Partie 5 : Opérateurs Personnalisés")

# Créer de nouveaux types numériques
struct ComplexePersonnalisé
    réel::Float64
    imaginaire::Float64
end

# Surcharger les opérateurs
import Base: +, -, *, /, show

function +(a::ComplexePersonnalisé, b::ComplexePersonnalisé)
    return ComplexePersonnalisé(a.réel + b.réel, a.imaginaire + b.imaginaire)
end

function *(a::ComplexePersonnalisé, b::ComplexePersonnalisé) 
    réel = a.réel * b.réel - a.imaginaire * b.imaginaire
    imaginaire = a.réel * b.imaginaire + a.imaginaire * b.réel
    return ComplexePersonnalisé(réel, imaginaire)
end

function show(io::IO, c::ComplexePersonnalisé)
    if c.imaginaire >= 0
        print(io, "$(c.réel) + $(c.imaginaire)i")
    else
        print(io, "$(c.réel) - $(abs(c.imaginaire))i")
    end
end

# Test des opérateurs personnalisés
println("Nombres complexes personnalisés :")
z1 = ComplexePersonnalisé(3.0, 4.0)
z2 = ComplexePersonnalisé(1.0, -2.0)

println("z1 = ", z1)
println("z2 = ", z2)
println("z1 + z2 = ", z1 + z2)
println("z1 * z2 = ", z1 * z2)

# Partie 6 : Analyseur de Performance des Méthodes
println("\n📊 Partie 6 : Analyse de Performance")

# Fonction avec spécialisation pour performance
function calculer_somme(arr::Vector{T}) where T <: Number
    total = zero(T)  # Utilise le bon type de zéro
    for x in arr
        total += x
    end
    return total
end

function calculer_somme_générique(arr)
    total = 0
    for x in arr
        total += x
    end
    return total
end

# Test de performance
println("Comparaison de performance :")
données_int = collect(1:100000)
données_float = collect(1.0:100000.0)

# Test fonction spécialisée
temps_spé_int = @elapsed calculer_somme(données_int)
temps_spé_float = @elapsed calculer_somme(données_float)

# Test fonction générique  
temps_gén_int = @elapsed calculer_somme_générique(données_int)
temps_gén_float = @elapsed calculer_somme_générique(données_float)

println("Int64 - Spécialisée: $(temps_spé_int*1000)ms, Générique: $(temps_gén_int*1000)ms")
println("Float64 - Spécialisée: $(temps_spé_float*1000)ms, Générique: $(temps_gén_float*1000)ms")

# Partie 7 : Défi Créatif - Calculatrice Polymorphe
println("\n🎨 Partie 7 : Défi - Calculatrice Polymorphe")

struct Fraction
    numérateur::Int
    dénominateur::Int
    
    function Fraction(n::Int, d::Int)
        if d == 0
            throw(DivideError())
        end
        # Simplification automatique
        g = gcd(abs(n), abs(d))
        new(div(n, g), div(d, g))
    end
end

# Opérations sur fractions
function +(a::Fraction, b::Fraction)
    return Fraction(a.numérateur * b.dénominateur + b.numérateur * a.dénominateur,
                   a.dénominateur * b.dénominateur)
end

function *(a::Fraction, b::Fraction)
    return Fraction(a.numérateur * b.numérateur, a.dénominateur * b.dénominateur)
end

function show(io::IO, f::Fraction)
    if f.dénominateur == 1
        print(io, f.numérateur)
    else
        print(io, "$(f.numérateur)/$(f.dénominateur)")
    end
end

# Calculatrice qui marche avec tous les types
function calculer(op::String, a, b)
    if op == "+"
        return a + b
    elseif op == "*"
        return a * b
    else
        error("Opération non supportée")
    end
end

# Test calculatrice polymorphe
println("Calculatrice polymorphe :")
f1 = Fraction(1, 2)
f2 = Fraction(1, 3)

println("$f1 + $f2 = ", calculer("+", f1, f2))
println("$f1 * $f2 = ", calculer("*", f1, f2))
println("5 + 3 = ", calculer("+", 5, 3))
println("2.5 * 4.0 = ", calculer("*", 2.5, 4.0))

# Partie 8 : Métaprogrammation et Génération de Méthodes
println("\n🔮 Partie 8 : Génération Automatique de Méthodes")

# Générer automatiquement des méthodes
for op in [:+, :*, :-, :/]
    @eval function $(Symbol("calculer_" * string(op)))(a::Number, b::Number)
        return $op(a, b)
    end
end

println("Méthodes générées automatiquement :")
println("calculer_+(10, 5) = ", calculer_+(10, 5))
println("calculer_*(3, 7) = ", calculer_*(3, 7))
println("calculer_-(15, 8) = ", calculer_-(15, 8))
println("calculer_/(20, 4) = ", calculer_/(20, 4))

# Bilan d'apprentissage
println("\n📈 BILAN D'APPRENTISSAGE")
println("="^60)
println("🎭 MAÎTRISE DE LA RÉPARTITION MULTIPLE !")
println("="^60)
println("✅ Compétences de niveau expert développées :")
println("  - Définition de méthodes multiples pour une même fonction")
println("  - Spécialisation sur hiérarchies de types complexes")
println("  - Systèmes polymorphes avec comportements adaptatifs")
println("  - Surcharge d'opérateurs avec types personnalisés")
println("  - Optimisation de performance par spécialisation")
println("  - Métaprogrammation pour génération de méthodes")
println("\n🚀 Vous maîtrisez maintenant le cœur de la puissance de Julia !")
println("Cette compétence vous distingue des autres langages de programmation.")
println("\n📆 PROCHAINE ÉTAPE : 03_package_creation.jl - Créer vos propres paquets !")
println("   (La répartition multiple sera essentielle pour vos paquets)")
println("   (Conseil : Expérimentez avec vos propres hiérarchies de types !)")