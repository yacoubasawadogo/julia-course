# Exercice 2 : Construire une Calculatrice
# Cours Interactif de Programmation Julia
# Durée : 30 minutes

# 📚 AVANT DE COMMENCER
# Lisez le résumé d'apprentissage : resume_02_calculator.md
# Découvrez pourquoi construire une calculatrice vous prépare au développement d'applications réelles !

println("📚 Consultez d'abord le résumé d'apprentissage dans resume_02_calculator.md")
println("Appuyez sur Entrée quand vous êtes prêt à commencer...")
readline()

println("🧮 Construisez Votre Propre Calculatrice !")
println("="^50)

# Partie 1 : Fonctions de Calculatrice de Base
println("\n📚 Partie 1 : Opérations de Base")
println("Implémentez ces fonctions :")

# Code de départ
function additionner(a, b)
    # TODO : Implémenter l'addition
end

function soustraire(a, b)
    # TODO : Implémenter la soustraction 
end

function multiplier(a, b)
    # TODO : Implémenter la multiplication 
end

function diviser(a, b)
    # TODO : Ajouter la gestion d'erreur pour la division par zéro 
end

# Testez vos fonctions
println("\n🧪 Test des Opérations de Base :")
println("additionner(5, 3) = ", additionner(5, 3))
println("soustraire(10, 4) = ", soustraire(10, 4))
println("multiplier(6, 7) = ", multiplier(6, 7))
println("diviser(20, 4) = ", diviser(20, 4))
println("diviser(10, 0) = ", diviser(10, 0))

# Partie 2 : Opérations Avancées
println("\n📚 Partie 2 : Opérations Avancées")
println("Ajoutez ces fonctions à votre calculatrice :")

function puissance(base, exposant)
    # TODO : Implémenter la fonction puissance 
end

function racine_carree(n)
    # TODO : Gérer les nombres négatifs
    if n < 0
        println("Erreur : Impossible de calculer la racine carrée d'un nombre négatif !")
        return nothing
    end
    return sqrt(n)
end

function factorielle(n)
    # TODO : Implémenter la factorielle 
end

# Test des opérations avancées
println("\n🧪 Test des Opérations Avancées :")
println("puissance(2, 10) = ", puissance(2, 10))
println("racine_carree(144) = ", racine_carree(144))
println("factorielle(5) = ", factorielle(5))

# Partie 3 : Calculatrice Interactive
println("\n📚 Partie 3 : Calculatrice Interactive")
println("Créez une calculatrice interactive qui prend l'entrée utilisateur")

function calculatrice_interactive()
    println("\n🖩 Calculatrice Interactive Démarrée !")
    println("Commandes : +, -, *, /, ^, sqrt, fact, quitter")

    while true
        print("\nEntrez l'opération (ou 'quitter') : ")
        operation = readline()

        if operation == "quitter"
            println("Calculatrice fermée. Au revoir ! 👋")
            break
        end

        if operation in ["sqrt", "fact"]
            print("Entrez le nombre : ")
            num = parse(Float64, readline())

            if operation == "sqrt"
                resultat = racine_carree(num)
            elseif operation == "fact"
                resultat = factorielle(Int(num))
            end
        else
            print("Entrez le premier nombre : ")
            num1 = parse(Float64, readline())
            print("Entrez le deuxième nombre : ")
            num2 = parse(Float64, readline())

            if operation == "+"
                resultat = additionner(num1, num2)
            elseif operation == "-"
                resultat = soustraire(num1, num2)
            elseif operation == "*"
                resultat = multiplier(num1, num2)
            elseif operation == "/"
                resultat = diviser(num1, num2)
            elseif operation == "^"
                resultat = puissance(num1, num2)
            else
                println("Opération inconnue !")
                continue
            end
        end

        if resultat !== nothing
            println("Résultat : $resultat")
        end
    end
end

# Partie 4 : Calculatrice avec Mémoire
println("\n📚 Partie 4 : Calculatrice avec Mémoire")

mutable struct MemoireCalculatrice
    valeur::Float64
    historique::Vector{String}
end

function creer_calculatrice()
    return MemoireCalculatrice(0.0, String[])
end

function memoire_ajouter!(calc::MemoireCalculatrice, valeur)
    calc.valeur += valeur
    push!(calc.historique, "Ajouté $valeur, Mémoire : $(calc.valeur)")
end

function memoire_effacer!(calc::MemoireCalculatrice)
    calc.valeur = 0.0
    push!(calc.historique, "Mémoire effacée")
end

function afficher_historique(calc::MemoireCalculatrice)
    println("\n📜 Historique de la Calculatrice :")
    for (i, entree) in enumerate(calc.historique)
        println("  $i. $entree")
    end
end

# Test de la calculatrice mémoire
calc = creer_calculatrice()
memoire_ajouter!(calc, 100)
memoire_ajouter!(calc, 50)
println("Valeur actuelle en mémoire : ", calc.valeur)
afficher_historique(calc)

# Section Défis
println("\n🏆 DÉFIS")
println("="^50)
println("1. Ajoutez des fonctions trigonométriques (sin, cos, tan)")
println("2. Implémentez les calculs de pourcentage")
println("3. Ajoutez la conversion d'unités (mètres vers pieds, etc.)")
println("4. Créez une calculatrice graphique avec Plots.jl")
println("5. Ajoutez le support des nombres complexes")

# Exécutez la calculatrice interactive
println("\n🚀 Prêt à essayer la calculatrice interactive ?")
print("Tapez 'oui' pour commencer : ")
if readline() == "oui"
    calculatrice_interactive()
end

# 📈 BILAN D'APPRENTISSAGE
println("\n" * "="^50)
println("📈 EXCELLENT ! Vous avez construit votre calculatrice complète !")
println("="^50)
println("\n✅ Compétences maîtrisées :")
println("  - Architecture modulaire avec fonctions spécialisées")
println("  - Gestion d'erreurs robuste (division par zéro, etc.)")
println("  - Interfaces utilisateur conversationnelles")
println("  - Structures de données mutables (mémoire + historique)")
println("  - Parsing et validation d'entrées utilisateur")
println("\n🏗️ Vous savez maintenant construire des applications interactives complètes !")
println("\n📆 PROCHAINE ÉTAPE : 03_types_game.jl - Combat de Types Julia")
println("   (Conseil : Relisez resume_02_calculator.md pour consolider)")
println("   (Bonus : Tentez les défis d'extension ci-dessus !)")