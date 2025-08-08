#!/usr/bin/env julia

"""
Script de Navigation Interactive - Cours Julia Burkina Faso
============================================================

Usage: 
    julia navigate.jl
    # ou dans le REPL Julia :
    include("navigate.jl")
    navigate()
"""

using Pkg

# Structure du cours
const COURSE_STRUCTURE = Dict(
    "Module 1: Fondamentaux" => Dict(
        "path" => "modules/module1-foundations/",
        "exercises" => [
            ("01_repl_basics.jl", "REPL Interactif", "20 min"),
            ("02_calculator.jl", "Calculatrice Avancée", "30 min"),
            ("03_types_game.jl", "Combat des Héros Burkinabè", "30 min")
        ],
        "projects" => [
            ("text_adventure.jl", "🏛️ Palais de Moro-Naba", "2h")
        ],
        "badge" => "Naaba Programmeur"
    ),
    "Module 2: Avancé" => Dict(
        "path" => "modules/module2-advanced/",
        "exercises" => [
            ("01_data_structures.jl", "Structures de Données", "45 min"),
            ("02_multiple_dispatch.jl", "Répartition Multiple", "45 min")
        ],
        "projects" => [
            ("physics_simulator.jl", "🌌 Simulateur Physique", "3h")
        ],
        "badge" => "Ingénieur Systèmes Dynamiques"
    ),
    "Module 3: Machine Learning" => Dict(
        "path" => "modules/module3-ml/",
        "exercises" => [
            ("01_mlj_basics.jl", "MLJ Fondamentaux", "60 min"),
            ("02_dataframes.jl", "DataFrames Avancé", "60 min"),
            ("03_visualization.jl", "Visualisation", "45 min"),
            ("04_advanced_ml.jl", "ML Avancé", "75 min"),
            ("05_python_bridge.jl", "Bridge Python", "45 min")
        ],
        "projects" => [
            ("agricultural_predictor.jl", "🌾 Prédicteur Agricole", "4h"),
            ("climate_analysis.jl", "🌡️ Analyse Climatique", "3h")
        ],
        "badge" => "Data Scientist Julia Expert"
    )
)

# Fonctions utilitaires
function clear_screen()
    if Sys.iswindows()
        run(`cmd /c cls`)
    else
        run(`clear`)
    end
end

function print_header()
    println("🇧🇫" * "="^60 * "🇧🇫")
    println("📚 NAVIGATEUR COURS JULIA INTERACTIF - BURKINA FASO")
    println("🇧🇫" * "="^60 * "🇧🇫")
    println()
end

function print_colored(text, color=:normal)
    colors = Dict(
        :red => "\e[31m",
        :green => "\e[32m", 
        :yellow => "\e[33m",
        :blue => "\e[34m",
        :magenta => "\e[35m",
        :cyan => "\e[36m",
        :bold => "\e[1m",
        :normal => "\e[0m"
    )
    print(get(colors, color, colors[:normal]), text, colors[:normal])
end

function show_main_menu()
    clear_screen()
    print_header()
    
    println("🎯 Choisissez votre destination :")
    println()
    
    modules = collect(keys(COURSE_STRUCTURE))
    
    for (i, module_name) in enumerate(modules)
        badge = COURSE_STRUCTURE[module_name]["badge"]
        print_colored("$i. ", :cyan)
        print_colored(module_name, :bold)
        println(" → Badge: \"$badge\"")
    end
    
    println()
    print_colored("4. ", :cyan)
    print_colored("📋 Voir INDEX.md complet", :yellow)
    println()
    
    print_colored("5. ", :cyan)
    print_colored("🎓 Guide pour enseignants", :magenta)
    println()
    
    print_colored("6. ", :cyan)
    print_colored("❓ Aide et support", :blue)
    println()
    
    print_colored("0. ", :red)
    print_colored("Quitter", :red)
    println()
    println()
    
    print("Votre choix (0-6) : ")
    return readline()
end

function show_module_detail(module_name)
    clear_screen()
    print_header()
    
    module_data = COURSE_STRUCTURE[module_name]
    badge = module_data["badge"]
    
    print_colored("📚 $module_name\n", :bold)
    print_colored("🎖️ Badge à débloquer: \"$badge\"\n\n", :yellow)
    
    # Exercices
    println("💻 EXERCICES :")
    for (i, (file, name, duration)) in enumerate(module_data["exercises"])
        path = module_data["path"] * "exercises/" * file
        status = isfile(path) ? "✅" : "❌"
        println("  $i. $status $name ($duration)")
        println("     📁 $path")
    end
    
    println()
    
    # Projets
    println("🚀 PROJETS :")
    for (i, (file, name, duration)) in enumerate(module_data["projects"])
        path = module_data["path"] * "projects/" * file
        status = isfile(path) ? "✅" : "❌"  
        println("  $(i+10). $status $name ($duration)")
        println("     📁 $path")
    end
    
    println()
    println("📖 RÉSUMÉS D'APPRENTISSAGE :")
    resume_dir = module_data["path"]
    if isdir(resume_dir)
        for file in readdir(resume_dir)
            if startswith(file, "resume_") && endswith(file, ".md")
                println("  📄 $file")
            end
        end
    end
    
    println()
    print_colored("Choisissez un exercice/projet (numéro) ou 'b' pour retour : ", :cyan)
    return readline()
end

function run_exercise(file_path)
    if !isfile(file_path)
        print_colored("❌ Fichier non trouvé : $file_path\n", :red)
        return
    end
    
    clear_screen()
    print_header()
    
    print_colored("🚀 Lancement de : $file_path\n\n", :green)
    
    println("Options :")
    println("1. Ouvrir dans l'éditeur (recommandé)")
    println("2. Exécuter directement")
    println("3. Voir le contenu")
    println("4. Retour")
    
    print("Votre choix (1-4) : ")
    choice = readline()
    
    if choice == "1"
        try
            if Sys.iswindows()
                run(`cmd /c start $file_path`)
            elseif Sys.isapple()
                run(`open $file_path`)
            else
                # Linux - essayer différents éditeurs
                editors = ["code", "gedit", "nano", "vim"]
                for editor in editors
                    try
                        run(`which $editor`)
                        run(`$editor $file_path`)
                        break
                    catch
                        continue
                    end
                end
            end
        catch e
            println("❌ Impossible d'ouvrir l'éditeur : $e")
            println("Veuillez ouvrir manuellement : $file_path")
        end
        
    elseif choice == "2"
        println("⚠️ Attention : certains exercices sont interactifs.")
        print("Continuer ? (o/n) : ")
        if lowercase(readline()) == "o"
            try
                include(file_path)
            catch e
                print_colored("❌ Erreur d'exécution : $e\n", :red)
            end
        end
        
    elseif choice == "3"
        try
            content = read(file_path, String)
            lines = split(content, '\n')
            println("\n📄 Contenu (50 premières lignes) :")
            println("-" * "="^60 * "-")
            for (i, line) in enumerate(lines[1:min(50, length(lines))])
                println("$i: $line")
            end
            if length(lines) > 50
                println("... ($(length(lines) - 50) lignes supplémentaires)")
            end
        catch e
            print_colored("❌ Impossible de lire le fichier : $e\n", :red)
        end
    end
    
    println("\nAppuyez sur Entrée pour continuer...")
    readline()
end

function show_help()
    clear_screen()
    print_header()
    
    println("🆘 AIDE ET SUPPORT")
    println("="^40)
    println()
    
    println("📋 NAVIGATION :")
    println("  • INDEX.md - Guide complet de navigation")
    println("  • README.md - Introduction générale")
    println("  • Chaque module a son PARCOURS.md")
    println()
    
    println("🛠️ PROBLÈMES TECHNIQUES :")
    println("  • Julia pas installé ? → https://julialang.org/downloads/")
    println("  • Erreur de paquets ? → Pkg.update() dans Julia")
    println("  • Fichier manquant ? → Vérifier le chemin")
    println()
    
    println("🎓 POUR LES ENSEIGNANTS :")
    println("  • resources/guide_pedagogique.md")
    println("  • resources/quick-reference/julia_cheatsheet.md")
    println()
    
    println("💬 SUPPORT COMMUNAUTÉ :")
    println("  • GitHub Issues pour bugs techniques")
    println("  • Julia Discourse pour questions Julia générales")
    println("  • Documentation officielle Julia")
    println()
    
    println("🇧🇫 SPÉCIFICITÉS BURKINA FASO :")
    println("  • Exemples adaptés à l'économie locale (FCFA)")
    println("  • Références culturelles (Moro-Naba, héros historiques)")
    println("  • Projets agriculture et climat sahélien")
    println()
    
    print("Appuyez sur Entrée pour continuer...")
    readline()
end

function show_teacher_guide()
    clear_screen()
    print_header()
    
    println("🎓 GUIDE ENSEIGNANT - COURS JULIA BF")
    println("="^40)
    println()
    
    println("📚 RESSOURCES DISPONIBLES :")
    guide_path = "resources/guide_pedagogique.md"
    cheat_path = "resources/quick-reference/julia_cheatsheet.md"
    
    if isfile(guide_path)
        println("  ✅ Guide Pédagogique : $guide_path")
    else
        println("  ❌ Guide Pédagogique manquant")
    end
    
    if isfile(cheat_path)
        println("  ✅ Antisèche Julia : $cheat_path") 
    else
        println("  ❌ Antisèche Julia manquante")
    end
    
    println()
    println("⏱️ DURÉES ESTIMÉES :")
    total_time = 0
    for (module_name, data) in COURSE_STRUCTURE
        module_time = 0
        for (_, _, duration) in data["exercises"]
            time_min = parse(Int, match(r"(\d+)", duration).captures[1])
            module_time += time_min
        end
        for (_, _, duration) in data["projects"] 
            if occursin("h", duration)
                time_hours = parse(Int, match(r"(\d+)", duration).captures[1])
                module_time += time_hours * 60
            end
        end
        total_time += module_time
        println("  📖 $module_name : $(div(module_time, 60))h$(module_time % 60)min")
    end
    
    println("  🎯 TOTAL COURS : $(div(total_time, 60))h$(total_time % 60)min")
    
    println()
    println("🎯 MÉTHODOLOGIE :")
    println("  • 80% pratique, 20% théorie")
    println("  • Chaque exercice précédé d'un résumé (5 min)")
    println("  • Progression gamifiée avec badges")
    println("  • Projets contextualisés Burkina Faso")
    
    println()
    println("📊 ÉVALUATION :")
    println("  • Exercices auto-gradés")
    println("  • Projets avec critères objectifs")
    println("  • Portfolio final avec 3 projets majeurs")
    
    print("\nAppuyez sur Entrée pour continuer...")
    readline()
end

function navigate()
    """Fonction principale de navigation"""
    
    while true
        choice = show_main_menu()
        
        if choice == "0"
            clear_screen()
            print_colored("👋 Au revoir ! Bon apprentissage Julia au Burkina Faso ! 🇧🇫\n", :green)
            break
            
        elseif choice in ["1", "2", "3"]
            module_names = collect(keys(COURSE_STRUCTURE))
            module_idx = parse(Int, choice)
            module_name = module_names[module_idx]
            
            while true
                sub_choice = show_module_detail(module_name)
                
                if lowercase(sub_choice) == "b"
                    break
                end
                
                # Parser le choix
                try
                    choice_num = parse(Int, sub_choice)
                    module_data = COURSE_STRUCTURE[module_name]
                    
                    if choice_num <= length(module_data["exercises"])
                        # Exercice
                        file, _, _ = module_data["exercises"][choice_num]
                        file_path = module_data["path"] * "exercises/" * file
                        run_exercise(file_path)
                        
                    elseif choice_num >= 11 && choice_num <= 10 + length(module_data["projects"])
                        # Projet  
                        project_idx = choice_num - 10
                        file, _, _ = module_data["projects"][project_idx]
                        file_path = module_data["path"] * "projects/" * file
                        run_exercise(file_path)
                    end
                    
                catch e
                    println("❌ Choix invalide")
                    readline()
                end
            end
            
        elseif choice == "4"
            # Ouvrir INDEX.md
            index_path = "INDEX.md"
            if isfile(index_path)
                run_exercise(index_path)
            else
                print_colored("❌ INDEX.md non trouvé\n", :red)
                readline()
            end
            
        elseif choice == "5" 
            show_teacher_guide()
            
        elseif choice == "6"
            show_help()
            
        else
            print_colored("❌ Choix invalide. Veuillez choisir entre 0-6.\n", :red)
            readline()
        end
    end
end

# Auto-exécution si script lancé directement
if abspath(PROGRAM_FILE) == @__FILE__
    navigate()
end

println("✨ Navigateur Julia chargé ! Tapez navigate() pour commencer.")