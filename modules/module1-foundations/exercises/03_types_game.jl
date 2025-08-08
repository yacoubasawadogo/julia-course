# Exercice 3 : Jeu de Combat des Types Julia
# Cours Interactif de Programmation Julia
# Durée : 30 minutes

# 📚 AVANT DE COMMENCER
# Lisez le résumé d'apprentissage : resume_03_types_game.md
# Découvrez pourquoi maîtriser les types Julia est crucial pour la performance !

using Random

println("📚 Consultez d'abord le résumé d'apprentissage dans resume_03_types_game.md")
println("Appuyez sur Entrée quand vous êtes prêt à combattre...")
readline()

println("⚔️  ARÈNE DE COMBAT DES TYPES JULIA ⚔️")
println("="^50)
println("Maîtrisez le système de types de Julia à travers des combats !")
println()

# Introduction au Système de Types
println("📚 Hiérarchie des Types Julia :")
println("  Any (type supérieur)")
println("  ├── Number")
println("  │   ├── Real")
println("  │   │   ├── Integer")
println("  │   │   │   ├── Int64")
println("  │   │   │   └── Bool")
println("  │   │   └── AbstractFloat")
println("  │   │       └── Float64")
println("  │   └── Complex")
println("  └── String")
println()

# Partie 1 : Détective des Types
println("🔍 Partie 1 : Détective des Types")
println("-" * 30)

function jeu_detective_types()
    score = 0
    questions = [
        (42, Int64),
        (3.14, Float64),
        ("Bonjour", String),
        (true, Bool),
        ('A', Char),
        (2 + 3im, Complex{Int64}),
        ([1, 2, 3], Vector{Int64}),
        (1:10, UnitRange{Int64})
    ]
    
    println("Devinez le type de chaque valeur !")
    
    for (valeur, type_correct) in questions
        println("\nValeur : ", repr(valeur))
        print("Votre hypothèse (tapez le nom du type) : ")
        hypothese = readline()
        
        type_reel = typeof(valeur)
        if occursin(string(type_correct), hypothese) || occursin(hypothese, string(type_correct))
            println("✅ Correct ! C'est $(type_reel)")
            score += 1
        else
            println("❌ Faux ! C'est $(type_reel)")
        end
    end
    
    println("\n🏆 Score : $score/$(length(questions))")
    return score
end

# Partie 2 : Défi de Conversion de Types
println("\n🔄 Partie 2 : Arène de Conversion de Types")
println("-" * 30)

function defi_conversion()
    println("Convertissez les valeurs entre les types !")
    
    defis = [
        ("Convertir \"123\" en Int", "123", 123),
        ("Convertir 3.7 en Int", 3.7, 3),
        ("Convertir 65 en Char", 65, 'A'),
        ("Convertir true en Int", true, 1)
    ]
    
    score = 0
    for (desc, entree, attendu) in defis
        println("\n$desc")
        println("Entrée : ", repr(entree))
        print("Tapez votre code de conversion : ")
        code_utilisateur = readline()
        
        try
            # En pratique, vous évalueriez code_utilisateur de manière sécurisée
            println("Résultat attendu : ", repr(attendu))
            println("💡 Indice : Utilisez convert() ou les fonctions constructrices")
            score += 1
        catch
            println("Erreur dans la conversion !")
        end
    end
    
    return score
end

# Partie 3 : Jeu de Combat de Types - Héros du Burkina
println("\n⚔️ Partie 3 : Combat des Héros Burkinabè")
println("-" * 30)

mutable struct GuerrierType
    nom::String
    type::DataType
    pv::Int
    attaque::Int
    defense::Int
end

function creer_guerrier(type::DataType)
    guerriers = Dict(
        Int64 => GuerrierType("Samory le Guerrier", Int64, 100, 15, 10),
        Float64 => GuerrierType("Nabonswendé le Sage", Float64, 80, 20, 5),
        String => GuerrierType("Griot Traditionnel", String, 90, 12, 8),
        Bool => GuerrierType("Yennenga la Cavalière", Bool, 110, 10, 15),
        Complex => GuerrierType("Marabout Mystique", Complex, 70, 25, 3)
    )
    return get(guerriers, type, GuerrierType("Inconnu", Any, 50, 10, 5))
end

function efficacite_type(attaquant::DataType, defenseur::DataType)
    # Matrice d'efficacité des types
    if attaquant <: Number && defenseur == String
        return 1.5  # Les nombres sont forts contre les chaînes
    elseif attaquant == String && defenseur <: Number
        return 0.5  # Les chaînes sont faibles contre les nombres
    elseif attaquant == Bool && defenseur == Bool
        return 1.0  # Neutre
    else
        return 1.0
    end
end

function combattre!(attaquant::GuerrierType, defenseur::GuerrierType)
    efficacite = efficacite_type(attaquant.type, defenseur.type)
    degats = round(Int, attaquant.attaque * efficacite - defenseur.defense/2)
    degats = max(degats, 1)  # Minimum 1 dégât
    defenseur.pv -= degats
    
    println("$(attaquant.nom) attaque $(defenseur.nom) !")
    println("Efficacité : $(efficacite)x")
    println("Dégâts infligés : $degats")
    println("$(defenseur.nom) PV : $(defenseur.pv)")
end

function jeu_combat_types()
    println("\n🎮 LE COMBAT DE TYPES COMMENCE !")
    
    # Le joueur choisit son type
    println("\nChoisissez votre héros burkinabè :")
    println("1. Samory le Guerrier (Int64) - Résistant et équilibré")
    println("2. Nabonswendé le Sage (Float64) - Sagesse puissante, défense faible")
    println("3. Griot Traditionnel (String) - Maître des paroles, polyvalent")
    println("4. Yennenga la Cavalière (Bool) - Grande guerrière, défense élevée")
    println("5. Marabout Mystique (Complex) - Pouvoirs mystiques, fragile")
    
    print("Votre choix (1-5) : ")
    choix = parse(Int, readline())
    
    types = [Int64, Float64, String, Bool, Complex]
    type_joueur = types[choix]
    joueur = creer_guerrier(type_joueur)
    
    # Ennemi aléatoire
    type_ennemi = rand(types)
    ennemi = creer_guerrier(type_ennemi)
    
    println("\n⚔️ $(joueur.nom) VS $(ennemi.nom) ⚔️")
    
    tour = 1
    while joueur.pv > 0 && ennemi.pv > 0
        println("\n--- Tour $tour ---")
        
        # Le joueur attaque
        if joueur.pv > 0
            combattre!(joueur, ennemi)
        end
        
        # L'ennemi attaque
        if ennemi.pv > 0
            combattre!(ennemi, joueur)
        end
        
        tour += 1
        
        if tour > 20  # Empêcher les boucles infinies
            println("Combat trop long !")
            break
        end
    end
    
    if joueur.pv > 0
        println("\n🎉 VICTOIRE ! Vous avez gagné le combat de types !")
        return true
    else
        println("\n💀 DÉFAITE ! Étudiez les types et réessayez !")
        return false
    end
end

# Partie 4 : Création de Type Personnalisé
println("\n🏗️ Partie 4 : Créez Votre Animal Totem")
println("-" * 30)

struct AnimalTotem
    nom::String
    origine::String
    niveau_spirituel::Int
    force_vitale::Float64
    pouvoirs::Vector{String}
end

function creer_animal_totem()
    println("Créez votre propre animal totem burkinabè !")
    print("Nom de l'animal : ")
    nom = readline()
    print("Origine (Sahel/Savane/Forêt) : ")
    origine = readline()
    print("Niveau spirituel (1-100) : ")
    niveau = parse(Int, readline())
    force = niveau * 10.0
    
    pouvoirs = String[]
    println("Entrez 4 pouvoirs traditionnels (un par ligne) :")
    for i in 1:4
        print("Pouvoir $i : ")
        push!(pouvoirs, readline())
    end
    
    animal = AnimalTotem(nom, origine, niveau, force, pouvoirs)
    
    println("\n🐾 Votre Animal Totem :")
    println("Nom : $(animal.nom)")
    println("Origine : $(animal.origine)")
    println("Niveau spirituel : $(animal.niveau_spirituel)")
    println("Force vitale : $(animal.force_vitale)")
    println("Pouvoirs : $(join(animal.pouvoirs, ", "))")
    
    return animal
end

# Partie 5 : Défi de Performance des Types
println("\n⚡ Partie 5 : Performance des Types")
println("-" * 30)

function demo_performance()
    println("Voyez comment les déclarations de types affectent la performance !")
    
    # Fonction non typée
    function somme_non_typee(arr)
        total = 0
        for x in arr
            total += x
        end
        return total
    end
    
    # Fonction typée
    function somme_typee(arr::Vector{Int64})::Int64
        total::Int64 = 0
        for x in arr
            total += x
        end
        return total
    end
    
    tableau_test = collect(1:1000000)
    
    println("Test avec 1 million d'entiers...")
    
    # Chronométrer non typée
    t1 = @elapsed somme_non_typee(tableau_test)
    println("Temps fonction non typée : $(t1) secondes")
    
    # Chronométrer typée
    t2 = @elapsed somme_typee(tableau_test)
    println("Temps fonction typée : $(t2) secondes")
    
    acceleration = t1 / t2
    println("Accélération : $(round(acceleration, digits=2))x")
    
    if acceleration > 1
        println("🚀 Les annotations de types ont amélioré la performance !")
    end
end

# Boucle Principale du Jeu
println("\n" * "="^50)
println("🎮 MENU PRINCIPAL DU JEU")
println("="^50)

function jeu_principal()
    score_total = 0
    
    println("\n1️⃣ Démarrage Détective des Types...")
    score1 = jeu_detective_types()
    score_total += score1
    
    print("\nAppuyez sur Entrée pour continuer...")
    readline()
    
    println("\n2️⃣ Arène de Combat de Types...")
    if jeu_combat_types()
        score_total += 5
    end
    
    print("\nAppuyez sur Entrée pour continuer...")
    readline()
    
    println("\n3️⃣ Créez Votre Animal Totem...")
    creer_animal_totem()
    score_total += 3
    
    println("\n4️⃣ Démo de Performance...")
    demo_performance()
    
    println("\n" * "="^50)
    println("🏆 SCORE FINAL : $score_total")
    println("="^50)
    
    if score_total >= 10
        println("⭐ RANG MAÎTRE : Vous avez maîtrisé les types Julia !")
    elseif score_total >= 7
        println("🥈 RANG EXPERT : Excellente compréhension des types !")
    else
        println("🥉 RANG APPRENTI : Continuez à pratiquer !")
    end
end

# Exécuter le jeu
println("\n🚀 Prêt à jouer ? Tapez 'commencer' pour débuter !")
print("> ")
if readline() == "commencer"
    jeu_principal()
end

# 📈 BILAN D'APPRENTISSAGE
println("\n" * "="^50)
println("📈 FANTASTIQUE ! Vous avez maîtrisé les types Julia !")
println("="^50)
println("\n✅ Compétences de haut niveau développées :")
println("  - Navigation experte dans la hiérarchie des types Julia")
println("  - Diagnostic et conversion entre types différents")
println("  - Compréhension de l'impact performance des types")
println("  - Création de types personnalisés (struct)")
println("  - Bases de la répartition multiple")
println("\n⚡ Cette maîtrise des types vous distingue comme développeur Julia !")
println("\n📆 PROCHAINE ÉTAPE : Projet d'Aventure Textuelle")
println("   (Conseil : Relisez resume_03_types_game.md pour approfondir)")
println("   (Note : Les types que vous venez d'apprendre sont au cœur du projet !)")