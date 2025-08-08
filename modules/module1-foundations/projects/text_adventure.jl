# Projet 1 : Jeu d'Aventure Textuel
# Construire un jeu d'aventure interactif basé sur du texte
# Temps estimé : 2 heures

# 🏰 PROJET CAPSTONE - AVANT DE COMMENCER
# OBLIGATOIRE : Lisez le résumé d'apprentissage : resume_projet_aventure.md
# Ce projet intègre TOUT ce que vous avez appris ! Le résumé vous guide.
# 
# Prérequis : Exercices 1, 2, 3 complétés avec succès
# Ce projet teste votre maîtrise complète des fondamentaux Julia

println("🏛️ PROJET CAPSTONE : Le Palais de Moro-Naba")
println("📚 Consultez OBLIGATOIREMENT le résumé dans resume_projet_aventure.md")
println("Ce projet intègre tous les concepts vus dans les exercices précédents.")
print("\nAvez-vous lu le résumé d'apprentissage ? (oui/non) : ")

if lowercase(readline()) != "oui"
    println("⚠️  ARRÊT : Veuillez d'abord lire resume_projet_aventure.md")
    println("Ce résumé vous explique l'architecture et les défis de ce projet complexe.")
    exit()
end

using Random

# Structure d'État du Jeu
mutable struct EtatJeu
    nom_joueur::String
    salle_actuelle::String
    inventaire::Vector{String}
    sante::Int
    score::Int
    jeu_fini::Bool
end

# Descriptions des salles du Palais de Moro-Naba
const SALLES = Dict(
    "entree" => (
        description="Vous vous tenez à l'entrée du palais du Moro-Naba. Les murs en banco rouge s'élèvent majestueusement devant vous.",
        exits=Dict("nord" => "cour_honneur", "est" => "jardin_cola"),
        items=["tison"],
        puzzle=nothing
    ),
    "cour_honneur" => (
        description="La grande cour d'honneur où se tenaient les cérémonies royales. Des piliers sculptés bordent la cour.",
        exits=Dict("sud" => "entree", "nord" => "salle_trone", "ouest" => "case_palabres", "est" => "forge"),
        items=["grigri"],
        puzzle="devinette_mossi"
    ),
    "jardin_cola" => (
        description="Un jardin planté de kolatiers et de karités. L'ombre fraîche contraste avec l'ardeur du soleil.",
        exits=Dict("ouest" => "entree"),
        items=["rose", "pelle"],
        puzzle=nothing
    ),
    "case_palabres" => (
        description="La case des palabres où les anciens tenaient conseil. Les murs portent encore l'écho des sagesses passées.",
        exits=Dict("est" => "cour_honneur"),
        items=["manuscrit", "amulette"],
        puzzle="proverbe"
    ),
    "forge" => (
        description="L'ancienne forge royale où étaient façonnées les armes des guerriers mossi. Les outils attendent encore.",
        exits=Dict("ouest" => "cour_honneur"),
        items=["lance", "bracelet_bronze"],
        puzzle=nothing
    ),
    "salle_trone" => (
        description="La salle du Naaba ! Le trône ancestral du Moro-Naba se dresse fièrement au centre.",
        exits=Dict("sud" => "cour_honneur", "haut" => "terrasse"),
        items=["sceptre_royal"],
        puzzle="epreuve_sagesse"
    ),
    "terrasse" => (
        description="La terrasse au sommet du palais ! Vous dominez Ouagadougou et pouvez voir les collines au loin.",
        exits=Dict("bas" => "salle_trone"),
        items=["tresor_mossi"],
        puzzle="ceremonie_finale"
    )
)

# Énigmes
function resoudre_enigme(type_enigme::String, jeu::EtatJeu)
    if type_enigme == "devinette_mossi"
        println("\n🧩 Un ancien dit : 'Je marche devant toi le jour, mais disparait quand le soleil se couche. Qui suis-je ?'")
        print("Votre réponse : ")
        reponse = lowercase(readline())
        if occursin("ombre", reponse)
            println("✅ Correct ! L'ancien vous sourit et le passage s'ouvre.")
            return true
        else
            println("❌ L'ancien secoue la tête. Réfléchissez encore...")
            jeu.sante -= 10
            return false
        end
        
    elseif type_enigme == "proverbe"
        println("\n🧩 Complétez ce proverbe mossi : 'L'arbre qui tombe fait plus de bruit...'")
        println("Indice : C'est une leçon de sagesse sur la discrétion")
        print("Votre réponse : ")
        reponse = lowercase(readline())
        if occursin("forêt", reponse) || occursin("qui grandit", reponse)
            println("✅ Sage réponse ! L'ancien vous bénit.")
            jeu.score += 20
            return true
        else
            println("❌ Continuez à réfléchir sur la sagesse des anciens.")
            return false
        end
        
    elseif type_enigme == "epreuve_sagesse"
        if "grigri" in jeu.inventaire
            println("✨ Votre grigri brille ! Les esprits ancestraux vous acceptent.")
            return true
        else
            println("🚪 L'accès au trône nécessite la protection des ancêtres. Il vous faut un grigri.")
            return false
        end
        
    elseif type_enigme == "ceremonie_finale"
        println("\n🏆 CÉRÉMONIE FINALE DU MORO-NABA !")
        println("Nommez les couleurs du drapeau du Burkina Faso :")
        println("Indice : Rouge du courage, vert de l'espoir, et l'étoile d'or au centre")
        print("Votre réponse : ")
        reponse = lowercase(replace(readline(), " " => ""))
        if (occursin("rouge", reponse) && occursin("vert", reponse)) && 
           (occursin("jaune", reponse) || occursin("or", reponse) || occursin("étoile", reponse))
            println("🎉 HONNEUR AU FASO ! Vous êtes digne du trésor ancestral !")
            jeu.score += 100
            jeu.jeu_fini = true
            return true
        else
            println("❌ Respectez d'abord les symboles de votre patrie.")
            return false
        end
    end
    
    return false
end

# Game Commands
function show_help()
    println("\n📜 Commandes Disponibles :")
    println("  regarder - Examiner votre environnement")
    println("  aller [direction] - Se déplacer (nord, sud, est, ouest, haut, bas)")
    println("  prendre [objet] - Ramasser un objet")
    println("  inventaire - Vérifier votre inventaire")
    println("  utiliser [objet] - Utiliser un objet de votre inventaire")
    println("  score - Vérifier votre score")
    println("  sante - Vérifier votre santé")
    println("  aide - Afficher ce message d'aide")
    println("  quit - Exit the game")
end

function look(game::GameState)
    room = ROOMS[game.current_room]
    println("\n📍 Location: $(uppercase(game.current_room))")
    println(room.description)
    
    if !isempty(room.items)
        println("\n🎁 You see: $(join(room.items, ", "))")
    end
    
    println("\n🚪 Exits: $(join(keys(room.exits), ", "))")
end

function go(direction::String, game::GameState)
    room = ROOMS[game.current_room]
    
    if haskey(room.exits, direction)
        next_room = room.exits[direction]
        
        # Check if there's a puzzle blocking the way
        if room.puzzle !== nothing && direction == "north" && game.current_room == "hall"
            if !solve_puzzle(room.puzzle, game)
                return
            end
        elseif game.current_room == "throne" && direction == "up"
            if !solve_puzzle(room.puzzle, game)
                return
            end
        end
        
        game.current_room = next_room
        game.score += 5
        println("\n➡️ You move $direction to the $next_room.")
        look(game)
    else
        println("❌ You can't go that way!")
    end
end

function take_item(item::String, game::GameState)
    room = ROOMS[game.current_room]
    
    if item in room.items
        push!(game.inventory, item)
        filter!(x -> x != item, room.items)
        game.score += 10
        println("✅ You picked up the $item!")
        
        # Special item effects
        if item == "torch"
            println("💡 The torch lights up dark areas!")
        elseif item == "map"
            println("🗺️ The map reveals the castle layout!")
            println("\n[Castle Map]")
            println("    [Tower]")
            println("       |")
            println("   [Throne]")
            println("       |")
            println("[Library]-[Hall]-[Armory]")
            println("       |")
            println("  [Entrance]-[Garden]")
        end
    else
        println("❌ There's no $item here.")
    end
end

function use_item(item::String, game::GameState)
    if item in game.inventory
        if item == "torch" && game.current_room == "library"
            println("🔦 The torch reveals hidden text on the wall!")
            game.score += 15
        elseif item == "sword" && game.current_room == "throne"
            println("⚔️ You raise the sword triumphantly!")
            game.score += 20
        elseif item == "rose"
            println("🌹 The rose's beauty fills you with determination!")
            game.health = min(100, game.health + 20)
        else
            println("💭 Nothing happens.")
        end
    else
        println("❌ You don't have a $item.")
    end
end

function show_inventory(game::GameState)
    if isempty(game.inventory)
        println("🎒 Your inventory is empty.")
    else
        println("🎒 Inventory: $(join(game.inventory, ", "))")
    end
end

function show_status(game::GameState)
    println("\n" * "="^40)
    println("Player: $(game.player_name)")
    println("❤️ Health: $(game.health)/100")
    println("⭐ Score: $(game.score)")
    println("📍 Location: $(uppercase(game.current_room))")
    println("="^40)
end

# Main Game Loop
function play_game()
    println("\n" * "="^50)
    println("🏰 WELCOME TO CASTLE JULIA 🏰")
    println("="^50)
    println("\nA text adventure game to practice Julia programming")
    
    print("\nEnter your name, brave adventurer: ")
    player_name = readline()
    
    game = GameState(
        player_name,
        "entrance",
        String[],
        100,
        0,
        false
    )
    
    println("\nWelcome, $player_name!")
    println("Type 'help' for available commands.")
    look(game)
    
    # Game loop
    while !game.game_over && game.health > 0
        print("\n> ")
        input = lowercase(strip(readline()))
        parts = split(input)
        
        if isempty(parts)
            continue
        end
        
        command = parts[1]
        
        if command == "quit"
            println("Thanks for playing! Final score: $(game.score)")
            break
            
        elseif command == "help"
            show_help()
            
        elseif command == "look"
            look(game)
            
        elseif command == "go" && length(parts) >= 2
            go(parts[2], game)
            
        elseif command == "take" && length(parts) >= 2
            take_item(join(parts[2:end], " "), game)
            
        elseif command == "use" && length(parts) >= 2
            use_item(join(parts[2:end], " "), game)
            
        elseif command == "inventory"
            show_inventory(game)
            
        elseif command == "score"
            println("⭐ Score: $(game.score)")
            
        elseif command == "health"
            println("❤️ Health: $(game.health)/100")
            
        elseif command == "status"
            show_status(game)
            
        else
            println("❓ Unknown command. Type 'help' for commands.")
        end
        
        # Random events
        if rand() < 0.1
            events = [
                "You hear strange whispers in the walls...",
                "A cold breeze sends shivers down your spine.",
                "You notice shadows moving in the corner of your eye.",
                "The castle seems to shift and groan around you."
            ]
            println("\n👻 $(rand(events))")
        end
        
        # Check win condition
        if "treasure" in game.inventory
            game.game_over = true
            println("\n" * "="^50)
            println("🏆 CONGRATULATIONS! 🏆")
            println("You've found the legendary treasure!")
            println("Final Score: $(game.score)")
            println("="^50)
        end
        
        # Check lose condition
        if game.health <= 0
            println("\n💀 GAME OVER 💀")
            println("Your adventure ends here...")
            println("Final Score: $(game.score)")
            break
        end
    end
end

# Démarrer le jeu
println("Prêt à commencer votre aventure ? Tapez 'oui' pour démarrer !")
print("> ")
if readline() == "oui"
    play_game()
    
    # 📈 BILAN D'APPRENTISSAGE - PROJET CAPSTONE
    println("\n" * "="^60)
    println("🏆 PROJET CAPSTONE TERMINÉ - CHÂTEAU JULIA 🏆")
    println("="^60)
    println("\n✅ MAÎTRISE COMPLÈTE DES FONDAMENTAUX JULIA :")
    println("  🏗️ Architecture d'application complète (400+ lignes)")
    println("  🎯 Intégration harmonieuse : types + fonctions + structures")
    println("  🎮 Systèmes complexes : état, logique, interface utilisateur")
    println("  🧩 Résolution d'énigmes éducatives Julia-themed")
    println("  🔄 Debugging et maintenance de codebase moyenne")
    
    println("\n🌟 BADGE DÉBLOQUÉ : 'Maître Aventurier Julia'")
    println("Vous avez prouvé votre capacité à créer des applications Julia complètes !")
    
    println("\n🚀 PRÊT POUR LE MODULE 2 - PROGRAMMATION AVANCÉE")
    println("Votre maîtrise des fondamentaux vous permet maintenant d'aborder :")
    println("  - Structures de données complexes")
    println("  - Optimisation de performance")
    println("  - Répartition multiple avancée")
    println("  - Développement de paquets")
    
    println("\n📚 RESSOURCES DE CONSOLIDATION :")
    println("  - Relisez resume_projet_aventure.md pour approfondir")
    println("  - Tentez les extensions suggérées dans le résumé")
    println("  - Consultez resources/guide_pedagogique.md (instructeurs)")
    println("="^60)
else
    println("Revenez quand vous serez prêt pour l'aventure !")
end