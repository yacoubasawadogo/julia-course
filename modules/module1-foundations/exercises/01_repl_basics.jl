# Exercice 1 : Bases du REPL
# Cours Interactif de Programmation Julia
# Durée : 15 minutes

# 📚 AVANT DE COMMENCER
# Lisez le résumé d'apprentissage : resume_01_repl_basics.md
# Ou demandez à votre instructeur de le présenter en classe !
# Ce résumé vous explique POURQUOI apprendre le REPL et comment cela s'applique en vrai.

println("📚 Consultez d'abord le résumé d'apprentissage dans resume_01_repl_basics.md")
println("Appuyez sur Entrée quand vous êtes prêt à commencer...")
readline()

println("Bienvenue aux Bases du REPL Julia !")
println("="^50)

# Défi 1 : Arithmétique de Base
println("\n🎯 Défi 1 : Arithmétique de Base")
println("Calculez ce qui suit dans le REPL :")
println("  a) 2 + 2")
println("  b) 10 * 5")
println("  c) 100 / 4")
println("  d) 2^10")
println("  e) sqrt(144)")

function check_arithmetic()
    println("\n✓ Vérification de votre compréhension...")
    print("Combien font 7 * 8 ? ")
    answer = readline()
    if parse(Int, answer) == 56
        println("Correct ! 🎉")
        return 1
    else
        println("Réessayez ! La réponse est 56")
        return 0
    end
end

# Défi 2 : Variables
println("\n🎯 Défi 2 : Variables")
println("Créez ces variables :")
println("  nom = \"Votre Nom\"")
println("  age = votre_age")
println("  pi_approx = 3.14159")
println("  est_etudiant = true")

function check_variables()
    println("\n✓ Pratiquons les variables...")
    print("Créez une variable 'x' égale à 42. Tapez la commande : ")
    answer = readline()
    if contains(answer, "x") && contains(answer, "42")
        println("Excellent travail ! 🎉")
        return 1
    else
        println("Indice : x = 42")
        return 0
    end
end

# Défi 3 : Utiliser ans
println("\n🎯 Défi 3 : La Variable 'ans'")
println("Julia stocke le dernier résultat dans 'ans'")
println("Essayez :")
println("  1) Tapez : 5 + 5")
println("  2) Tapez : ans * 2")
println("  3) Tapez : ans / 5")

function check_ans()
    println("\n✓ Comprendre 'ans'...")
    print("Si vous tapez '10 + 10' puis 'ans * 2', quel est le résultat ? ")
    answer = readline()
    if parse(Int, answer) == 40
        println("Parfait ! 🎉")
        return 1
    else
        println("La réponse est 40 (20 * 2)")
        return 0
    end
end

# Défi 4 : Système d'Aide
println("\n🎯 Défi 4 : Obtenir de l'Aide")
println("Dans le REPL, tapez '?' pour entrer en mode aide")
println("Essayez de chercher :")
println("  ?println")
println("  ?sqrt")
println("  ?typeof")

# Quiz Interactif
println("\n" * "="^50)
println("📝 QUIZ INTERACTIF")
println("="^50)

score = 0
score += check_arithmetic()
score += check_variables()
score += check_ans()

println("\n" * "="^50)
println("🏆 Votre Score : $score/3")
if score == 3
    println("Parfait ! Vous maîtrisez les bases du REPL ! 🌟")
elseif score >= 2
    println("Bon travail ! Pratiquez encore un peu pour la perfection.")
else
    println("Continuez à pratiquer ! Vous y arriverez.")
end

# Défis Bonus
println("\n🎁 DÉFIS BONUS")
println("1. Calculez le nombre d'or : (1 + sqrt(5))/2")
println("2. Créez une ligne pour calculer les intérêts composés")
println("3. Utilisez le REPL pour trouver le type de différentes valeurs")

println("\n💡 Conseil Pro : Utilisez les flèches ↑ et ↓ pour naviguer dans l'historique !")

# 📈 BILAN D'APPRENTISSAGE
println("\n" * "="^50)
println("📈 FÉLICITATIONS ! Vous avez terminé l'exercice REPL !")
println("="^50)
println("\n✅ Compétences développées :")
println("  - Maîtrise du REPL Julia pour l'expérimentation")
println("  - Calculs arithmétiques interactifs")
println("  - Gestion des variables et de 'ans'")
println("  - Utilisation du système d'aide (?)")  
println("\n🎆 Vous êtes maintenant prêt pour des défis plus complexes !")
println("\n📆 PROCHAINE ÉTAPE : Exercice 02_calculator.jl")
println("   (Conseil : Relisez resume_01_repl_basics.md pour consolider vos acquis)")
println("   (Pour instructeurs : Consultez resources/guide_pedagogique.md)")