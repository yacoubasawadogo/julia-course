"""
🎯 Système de Suivi de Progrès - Cours Julia Burkina Faso
=======================================================

Ce fichier implémente un système de suivi de progrès avec badges et gamification
pour motiver les étudiants tout au long du cours de 30 heures.
"""

using Dates
using JSON

# Structure pour suivre le progrès d'un étudiant
mutable struct ProgressEtudiant
    nom::String
    prenom::String
    ville::String
    sessions_completees::Vector{Int}
    exercices_reussis::Dict{String, Bool}
    badges_obtenus::Vector{String}
    score_total::Int
    derniere_connexion::DateTime
    temps_etudie::Int  # en minutes
end

# Constructor pour un nouvel étudiant
function ProgressEtudiant(nom::String, prenom::String, ville::String="Ouagadougou")
    ProgressEtudiant(
        nom, prenom, ville,
        Int[],
        Dict{String, Bool}(),
        String[],
        0,
        now(),
        0
    )
end

# Badges disponibles dans le cours
const BADGES_DISPONIBLES = Dict(
    "🌟" => "Premier Pas - Complété la session 1",
    "🧮" => "Calculateur - Maîtrise l'arithmétique Julia",
    "📊" => "Analyste de Données - Complété Module 1",
    "🏗️" => "Architecte - Maîtrise les structs et modules",
    "🎨" => "Visualiseur - Crée de beaux graphiques",
    "🤖" => "ML Engineer - Implémente du machine learning",
    "🎯" => "Expert Julia - Complété tous les modules",
    "⚡" => "Rapide - Termine un exercice en moins de 10 min",
    "🔥" => "Assidu - 5 sessions consécutives",
    "💎" => "Perfectionniste - 100% sur tous les exercices",
    "🌍" => "Champion Burkina - Utilise des exemples locaux"
)

# Fonction pour créer un nouvel étudiant
function creer_etudiant(nom::String, prenom::String, ville::String="Ouagadougou")
    etudiant = ProgressEtudiant(nom, prenom, ville)
    println("🎉 Bienvenue $prenom $nom de $ville!")
    println("📚 Vous commencez votre aventure Julia!")
    attribuer_badge!(etudiant, "🌟")
    return etudiant
end

# Fonction pour attribuer un badge
function attribuer_badge!(etudiant::ProgressEtudiant, badge::String)
    if badge ∉ etudiant.badges_obtenus
        push!(etudiant.badges_obtenus, badge)
        println("🏆 NOUVEAU BADGE: $badge - $(BADGES_DISPONIBLES[badge])")
        etudiant.score_total += 100
        return true
    end
    return false
end

# Fonction pour marquer une session comme complétée
function completer_session!(etudiant::ProgressEtudiant, numero_session::Int)
    if numero_session ∉ etudiant.sessions_completees
        push!(etudiant.sessions_completees, numero_session)
        etudiant.score_total += 50
        println("✅ Session $numero_session complétée! (+50 points)")
        
        # Attribution de badges selon les sessions
        if numero_session == 1
            attribuer_badge!(etudiant, "🌟")
        elseif numero_session == 5
            attribuer_badge!(etudiant, "📊")
        elseif numero_session == 8
            attribuer_badge!(etudiant, "🏗️")
        elseif numero_session == 10
            attribuer_badge!(etudiant, "🎨")
        elseif numero_session == 11
            attribuer_badge!(etudiant, "🤖")
            attribuer_badge!(etudiant, "🎯")
        end
        
        # Badge pour assiduité
        if length(etudiant.sessions_completees) >= 5
            sessions_consecutives = true
            sessions_triees = sort(etudiant.sessions_completees)
            for i in 1:min(5, length(sessions_triees)-1)
                if sessions_triees[i+1] - sessions_triees[i] > 1
                    sessions_consecutives = false
                    break
                end
            end
            if sessions_consecutives
                attribuer_badge!(etudiant, "🔥")
            end
        end
    end
end

# Fonction pour marquer un exercice comme réussi
function reussir_exercice!(etudiant::ProgressEtudiant, nom_exercice::String, temps_minutes::Int=0)
    etudiant.exercices_reussis[nom_exercice] = true
    etudiant.score_total += 25
    println("🎯 Exercice '$nom_exercice' réussi! (+25 points)")
    
    # Badge pour rapidité
    if temps_minutes > 0 && temps_minutes <= 10
        attribuer_badge!(etudiant, "⚡")
    end
    
    # Vérifier si tous les exercices sont complétés
    exercices_totaux = [
        "exercise_01_repl", "exercise_02_types", "exercise_03_functions", 
        "exercise_04_arrays", "exercise_05_projects", "exercise_06_structs",
        "exercise_07_io", "exercise_08_modules", "exercise_09_dataframes",
        "exercise_10_visualization", "exercise_11_ml"
    ]
    
    if all(ex in keys(etudiant.exercices_reussis) for ex in exercices_totaux)
        attribuer_badge!(etudiant, "💎")
    end
end

# Fonction pour afficher le progrès
function afficher_progres(etudiant::ProgressEtudiant)
    println("\n" * "="^60)
    println("📊 RAPPORT DE PROGRÈS - $(etudiant.prenom) $(etudiant.nom)")
    println("🏙️  Ville: $(etudiant.ville)")
    println("="^60)
    
    println("📈 Score Total: $(etudiant.score_total) points")
    println("✅ Sessions Complétées: $(length(etudiant.sessions_completees))/11")
    println("🎯 Exercices Réussis: $(length(etudiant.exercices_reussis))/11")
    println("⏱️  Temps d'Étude: $(etudiant.temps_etudie) minutes")
    
    # Progrès par module
    module1_sessions = count(s -> s <= 5, etudiant.sessions_completees)
    module2_sessions = count(s -> 6 <= s <= 8, etudiant.sessions_completees)
    module3_sessions = count(s -> 9 <= s <= 11, etudiant.sessions_completees)
    
    println("\n📚 PROGRÈS PAR MODULE:")
    println("   Module 1 (Fondations): $(module1_sessions)/5 sessions")
    println("   Module 2 (Avancé): $(module2_sessions)/3 sessions")
    println("   Module 3 (Data Science): $(module3_sessions)/3 sessions")
    
    # Badges obtenus
    println("\n🏆 BADGES OBTENUS ($(length(etudiant.badges_obtenus))/11):")
    for badge in etudiant.badges_obtenus
        println("   $badge $(BADGES_DISPONIBLES[badge])")
    end
    
    # Badges restants
    badges_restants = [b for b in keys(BADGES_DISPONIBLES) if b ∉ etudiant.badges_obtenus]
    if !isempty(badges_restants)
        println("\n🎯 BADGES À OBTENIR:")
        for badge in badges_restants[1:min(3, length(badges_restants))]
            println("   $badge $(BADGES_DISPONIBLES[badge])")
        end
        if length(badges_restants) > 3
            println("   ... et $(length(badges_restants) - 3) autres")
        end
    end
    
    # Encouragements
    pourcentage = round((length(etudiant.sessions_completees) / 11) * 100, digits=1)
    if pourcentage < 30
        println("\n💪 Courage $(etudiant.prenom)! Vous venez de commencer votre aventure Julia!")
    elseif pourcentage < 60
        println("\n🚀 Excellent progrès $(etudiant.prenom)! Vous maîtrisez de mieux en mieux Julia!")
    elseif pourcentage < 90
        println("\n⭐ Impressionnant $(etudiant.prenom)! Vous êtes presque un(e) expert(e) Julia!")
    else
        println("\n🎉 FÉLICITATIONS $(etudiant.prenom)! Vous êtes maintenant un(e) expert(e) Julia du Burkina Faso!")
    end
    
    println("="^60)
end

# Fonction pour sauvegarder le progrès
function sauvegarder_progres(etudiant::ProgressEtudiant, fichier::String="progres_$(etudiant.nom)_$(etudiant.prenom).json")
    donnees = Dict(
        "nom" => etudiant.nom,
        "prenom" => etudiant.prenom,
        "ville" => etudiant.ville,
        "sessions_completees" => etudiant.sessions_completees,
        "exercices_reussis" => etudiant.exercices_reussis,
        "badges_obtenus" => etudiant.badges_obtenus,
        "score_total" => etudiant.score_total,
        "derniere_connexion" => string(etudiant.derniere_connexion),
        "temps_etudie" => etudiant.temps_etudie
    )
    
    open(fichier, "w") do f
        JSON.print(f, donnees, 2)
    end
    println("💾 Progrès sauvegardé dans $fichier")
end

# Fonction pour charger le progrès
function charger_progres(fichier::String)
    if !isfile(fichier)
        error("Fichier de progrès non trouvé: $fichier")
    end
    
    donnees = JSON.parsefile(fichier)
    
    etudiant = ProgressEtudiant(
        donnees["nom"],
        donnees["prenom"],
        donnees["ville"],
        donnees["sessions_completees"],
        Dict{String, Bool}(donnees["exercices_reussis"]),
        donnees["badges_obtenus"],
        donnees["score_total"],
        DateTime(donnees["derniere_connexion"]),
        donnees["temps_etudie"]
    )
    
    println("📂 Progrès chargé pour $(etudiant.prenom) $(etudiant.nom)")
    return etudiant
end

# Fonction pour créer un classement de classe
function classement_classe(etudiants::Vector{ProgressEtudiant})
    if isempty(etudiants)
        println("Aucun étudiant dans la classe.")
        return
    end
    
    # Trier par score décroissant
    etudiants_tries = sort(etudiants, by = e -> e.score_total, rev = true)
    
    println("\n🏆 CLASSEMENT DE LA CLASSE")
    println("="^50)
    
    for (i, etudiant) in enumerate(etudiants_tries[1:min(10, length(etudiants_tries))])
        emoji_rang = i == 1 ? "🥇" : i == 2 ? "🥈" : i == 3 ? "🥉" : "🎯"
        sessions = length(etudiant.sessions_completees)
        badges = length(etudiant.badges_obtenus)
        
        println("$emoji_rang $i. $(etudiant.prenom) $(etudiant.nom) ($(etudiant.ville))")
        println("    Score: $(etudiant.score_total) pts | Sessions: $sessions/11 | Badges: $badges/11")
    end
    
    if length(etudiants_tries) > 10
        println("    ... et $(length(etudiants_tries) - 10) autres étudiants")
    end
    
    println("="^50)
end

# Exemple d'utilisation
function exemple_utilisation()
    println("🎓 Exemple d'utilisation du système de progrès")
    println("="^50)
    
    # Créer des étudiants exemples
    aminata = creer_etudiant("Ouédraogo", "Aminata", "Ouagadougou")
    ibrahim = creer_etudiant("Sawadogo", "Ibrahim", "Bobo-Dioulasso")
    fatou = creer_etudiant("Kaboré", "Fatou", "Koudougou")
    
    # Simuler du progrès
    completer_session!(aminata, 1)
    completer_session!(aminata, 2)
    reussir_exercice!(aminata, "exercise_01_repl", 8)
    
    completer_session!(ibrahim, 1)
    reussir_exercice!(ibrahim, "exercise_01_repl", 15)
    
    # Afficher les progrès
    afficher_progres(aminata)
    
    # Classement
    classement_classe([aminata, ibrahim, fatou])
end

# Décommenter pour voir l'exemple
# exemple_utilisation()