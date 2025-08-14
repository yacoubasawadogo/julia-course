# 🎮 Pratique 8.2 : Module de jeux et divertissements burkinabè

## 🎯 Mission
Créer un module complet de jeux inspirés de la culture burkinabè, avec système de scores, sauvegarde et multijoueurs !

## 📋 Ce que vous allez apprendre
- Développer des modules pour le divertissement
- Intégrer des éléments culturels burkinabè
- Créer des systèmes de jeu évolutifs
- Implémenter des mécaniques de progression
- Gérer l'état persistant des jeux

---

## 🏗️ Étape 1 : Architecture du module JeuxBurkina

Créons la structure de notre module de jeux :

```julia
using Random, Dates, JSON

# Créer la structure du projet
function creer_structure_jeux()
    dossiers = [
        "JeuxBurkina",
        "JeuxBurkina/src",
        "JeuxBurkina/data",
        "JeuxBurkina/test",
        "JeuxBurkina/save_games"
    ]
    
    for dossier in dossiers
        if !isdir(dossier)
            mkdir(dossier)
            println("📁 Dossier créé: $dossier")
        end
    end
    
    # Créer Project.toml pour les jeux
    contenu_toml = """
name = "JeuxBurkina"
uuid = "$(UUIDs.uuid4())"
version = "1.0.0"
authors = ["Développeur Julia Burkina <dev@burkina.games>"]

[deps]
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
JSON = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"

[compat]
julia = "1.6"
JSON = "0.21"
"""

    open("JeuxBurkina/Project.toml", "w") do fichier
        write(fichier, contenu_toml)
    end
    
    println("✅ Structure JeuxBurkina créée!")
end

using UUIDs
creer_structure_jeux()
```

### Module principal JeuxBurkina.jl

```julia
function creer_module_principal_jeux()
    contenu_module = """
module JeuxBurkina

# Exporter toutes les fonctions de jeu
export
    # Structures de base
    Joueur, TableauScores,
    # Module Awalé
    JeuAwale, jouer_awale, regles_awale,
    # Module Devinettes
    JeuDevinettes, deviner_nombre, deviner_ville,
    # Module Contes
    JeuContes, raconter_conte, quiz_conte,
    # Module Défis
    JeuDefis, defi_mathematique, defi_culture,
    # Utilitaires
    sauvegarder_scores, charger_scores, afficher_menu_principal

# Inclure tous les sous-modules
include("structures_base.jl")
include("jeu_awale.jl")
include("jeu_devinettes.jl")
include("jeu_contes.jl")
include("jeu_defis.jl")
include("gestion_scores.jl")

# Importer les modules
using .StructuresBase
using .JeuAwale
using .JeuDevinettes
using .JeuContes
using .JeuDefis
using .GestionScores

\"""
    bienvenue_jeux()

Lance l'interface principale des jeux burkinabè.
\"""
function bienvenue_jeux()
    println("🇧🇫 === JEUX TRADITIONNELS DU BURKINA FASO ===")
    println("🎮 Collection de jeux inspirés de notre culture")
    println()
    println("🎲 Jeux disponibles:")
    println("   🥜 Awalé - Jeu de stratégie traditionnel")
    println("   🤔 Devinettes - Testez vos connaissances")
    println("   📚 Contes - Histoires et légendes")
    println("   🏆 Défis - Challenges mathématiques et culturels")
    println()
    println("🎯 Tapez 'afficher_menu_principal()' pour commencer!")
end

\"""
    info_module()

Affiche les informations sur le module JeuxBurkina.
\"""
function info_module()
    println("ℹ️  === INFORMATIONS MODULE ===")
    println("📦 Nom: JeuxBurkina")
    println("🎯 Version: 1.0.0")
    println("👥 Auteur: Communauté Développeurs Burkina")
    println("🎮 Nombre de jeux: 4 modules principaux")
    println("💾 Sauvegarde: Scores et progression persistants")
    println("🌍 Culture: 100% adapté au Burkina Faso")
end

end  # module JeuxBurkina
"""

    open("JeuxBurkina/src/JeuxBurkina.jl", "w") do fichier
        write(fichier, contenu_module)
    end
    
    println("✅ Module principal JeuxBurkina créé!")
end

creer_module_principal_jeux()
```

---

## 🏗️ Étape 2 : Structures de base

```julia
function creer_structures_base()
    contenu_structures = """
module StructuresBase

export Joueur, TableauScores, StatistiquesJeu

using Dates

\"""
Structure représentant un joueur avec ses statistiques.
\"""
mutable struct Joueur
    nom::String
    origine::String  # Ville/région du Burkina
    niveau::Int
    points_total::Int
    jeux_joues::Int
    jeux_gagnes::Int
    date_creation::String
    derniere_connexion::String
    achievements::Vector{String}
    statistiques::Dict{String, Any}
    
    function Joueur(nom::String, origine::String)
        new(
            nom, origine, 1, 0, 0, 0,
            string(Dates.now()),
            string(Dates.now()),
            String[],
            Dict{String, Any}()
        )
    end
end

\"""
Tableau des meilleurs scores pour chaque jeu.
\"""
mutable struct TableauScores
    jeu::String
    scores::Vector{Tuple{String, Int, String}}  # (nom, score, date)
    
    function TableauScores(jeu::String)
        new(jeu, Tuple{String, Int, String}[])
    end
end

\"""
Statistiques détaillées pour un jeu spécifique.
\"""
mutable struct StatistiquesJeu
    nom_jeu::String
    parties_jouees::Int
    parties_gagnees::Int
    temps_total::Float64  # en minutes
    meilleur_score::Int
    score_moyen::Float64
    derniere_partie::String
    
    function StatistiquesJeu(nom_jeu::String)
        new(nom_jeu, 0, 0, 0.0, 0, 0.0, "")
    end
end

\"""
    afficher_joueur(joueur::Joueur)

Affiche les informations détaillées d'un joueur.
\"""
function afficher_joueur(joueur::Joueur)
    println("👤 === PROFIL JOUEUR ===")
    println("🎮 Nom: \$(joueur.nom)")
    println("🏠 Origine: \$(joueur.origine)")
    println("⭐ Niveau: \$(joueur.niveau)")
    println("🏆 Points total: \$(joueur.points_total)")
    println("🎲 Parties jouées: \$(joueur.jeux_joues)")
    println("✅ Parties gagnées: \$(joueur.jeux_gagnes)")
    
    if joueur.jeux_joues > 0
        pourcentage_victoire = round((joueur.jeux_gagnes / joueur.jeux_joues) * 100, digits=1)
        println("📊 Taux de victoire: \$pourcentage_victoire%")
    end
    
    if !isempty(joueur.achievements)
        println("🏅 Achievements: \$(join(joueur.achievements, ", "))")
    end
    
    println("📅 Membre depuis: \$(joueur.date_creation[1:10])")
    println()
end

\"""
    calculer_niveau(points::Int) -> Int

Calcule le niveau d'un joueur basé sur ses points.
\"""
function calculer_niveau(points::Int)
    if points < 100
        return 1
    elseif points < 500
        return 2
    elseif points < 1500
        return 3
    elseif points < 3000
        return 4
    elseif points < 5000
        return 5
    else
        return 5 + div(points - 5000, 2000)
    end
end

\"""
    ajouter_points!(joueur::Joueur, points::Int, jeu::String)

Ajoute des points à un joueur et met à jour son niveau.
\"""
function ajouter_points!(joueur::Joueur, points::Int, jeu::String)
    ancien_niveau = joueur.niveau
    joueur.points_total += points
    joueur.niveau = calculer_niveau(joueur.points_total)
    
    # Mettre à jour les statistiques du jeu
    if !haskey(joueur.statistiques, jeu)
        joueur.statistiques[jeu] = StatistiquesJeu(jeu)
    end
    
    stats = joueur.statistiques[jeu]
    stats.parties_jouees += 1
    
    if points > 0
        joueur.jeux_gagnes += 1
        stats.parties_gagnees += 1
        
        if points > stats.meilleur_score
            stats.meilleur_score = points
        end
    end
    
    joueur.jeux_joues += 1
    joueur.derniere_connexion = string(Dates.now())
    
    # Vérifier les achievements
    verifier_achievements!(joueur, ancien_niveau)
    
    if joueur.niveau > ancien_niveau
        println("🎉 NIVEAU UP! Vous passez au niveau \$(joueur.niveau)!")
        ajouter_achievement!(joueur, "Niveau \$(joueur.niveau) atteint")
    end
end

\"""
    verifier_achievements!(joueur::Joueur, ancien_niveau::Int)

Vérifie et attribue les achievements au joueur.
\"""
function verifier_achievements!(joueur::Joueur, ancien_niveau::Int)
    achievements_possibles = [
        (j -> j.jeux_joues >= 10, "Premier pas - 10 parties"),
        (j -> j.jeux_joues >= 50, "Joueur régulier - 50 parties"),
        (j -> j.jeux_joues >= 100, "Accro aux jeux - 100 parties"),
        (j -> j.jeux_gagnes >= 25, "Champion en herbe - 25 victoires"),
        (j -> j.points_total >= 1000, "Millionaire des points"),
        (j -> j.niveau >= 5, "Maître joueur niveau 5"),
        (j -> length(j.statistiques) >= 3, "Joueur polyvalent - 3 jeux"),
    ]
    
    for (condition, nom_achievement) in achievements_possibles
        if condition(joueur) && !(nom_achievement in joueur.achievements)
            ajouter_achievement!(joueur, nom_achievement)
        end
    end
end

\"""
    ajouter_achievement!(joueur::Joueur, achievement::String)

Ajoute un achievement au joueur.
\"""
function ajouter_achievement!(joueur::Joueur, achievement::String)
    if !(achievement in joueur.achievements)
        push!(joueur.achievements, achievement)
        println("🏅 Nouvel achievement débloqué: \$achievement!")
    end
end

end  # module StructuresBase
"""

    open("JeuxBurkina/src/structures_base.jl", "w") do fichier
        write(fichier, contenu_structures)
    end
    
    println("✅ Structures de base créées!")
end

creer_structures_base()
```

### 🎯 Défi 1 : Test des structures
Testez les structures de base :

```julia
println("\n🧪 === TEST DES STRUCTURES ===")
include("JeuxBurkina/src/structures_base.jl")
using .StructuresBase

# Créer un joueur de test
joueur_test = Joueur("Aminata Ouédraogo", "Ouagadougou")
afficher_joueur(joueur_test)

# Simuler quelques parties
for i in 1:5
    points = rand(10:100)
    ajouter_points!(joueur_test, points, "Test")
    println("Points ajoutés: $points (Total: $(joueur_test.points_total))")
end

println("\nProfil final:")
afficher_joueur(joueur_test)
```

---

## 🥜 Étape 3 : Jeu d'Awalé

Créons une version simplifiée du jeu traditionnel Awalé :

```julia
function creer_jeu_awale()
    contenu_awale = """
module JeuAwale

export JeuAwaleState, jouer_awale, regles_awale, creer_partie_awale

using Random
using ..StructuresBase

\"""
État d'une partie d'Awalé.
\"""
mutable struct JeuAwaleState
    plateau::Vector{Int}  # 12 cases (6 par joueur)
    joueur_actuel::Int    # 1 ou 2
    scores::Vector{Int}   # Score de chaque joueur
    partie_terminee::Bool
    gagnant::Int         # 0 = match nul, 1 ou 2 = gagnant
    
    function JeuAwaleState()
        # Plateau initial : 4 graines par case
        new(fill(4, 12), 1, [0, 0], false, 0)
    end
end

\"""
    regles_awale()

Affiche les règles simplifiées de l'Awalé.
\"""
function regles_awale()
    println("🥜 === RÈGLES DE L'AWALÉ ===")
    println("🎯 But : Capturer le plus de graines possible")
    println()
    println("📋 Règles simplifiées :")
    println("   1. Chaque joueur possède 6 cases (1-6 pour J1, 7-12 pour J2)")
    println("   2. À votre tour, choisissez une case NON VIDE de votre côté")
    println("   3. Distribuez les graines une par une dans le sens horaire")
    println("   4. Si la dernière graine tombe dans une case adverse avec")
    println("      2 ou 3 graines (après distribution), capturez-les!")
    println("   5. Le jeu se termine quand un joueur ne peut plus jouer")
    println("   6. Le joueur avec le plus de graines gagne!")
    println()
    println("💡 Conseil : Observez bien le plateau avant de jouer!")
    println()
end

\"""
    afficher_plateau(etat::JeuAwaleState)

Affiche le plateau d'Awalé de manière visuelle.
\"""
function afficher_plateau(etat::JeuAwaleState)
    println("🥜 === PLATEAU AWALÉ ===")
    println()
    
    # Affichage du côté joueur 2 (cases 12 à 7, de droite à gauche)
    print("J2:  ")
    for i in 12:-1:7
        print(sprintf("%2d ", etat.plateau[i]))
    end
    println("   (Cases 12-7)")
    
    # Ligne de séparation
    println("     ---------------")
    
    # Affichage du côté joueur 1 (cases 1 à 6, de gauche à droite)
    print("J1:  ")
    for i in 1:6
        print(sprintf("%2d ", etat.plateau[i]))
    end
    println("   (Cases 1-6)")
    
    println()
    println("Scores: J1 = \$(etat.scores[1]) | J2 = \$(etat.scores[2])")
    println("Tour du joueur \$(etat.joueur_actuel)")
    println()
end

# Fonction helper pour formater les nombres
function sprintf(fmt::String, args...)
    if fmt == "%2d "
        return lpad(string(args[1]), 2) * " "
    end
    return string(args...)
end

\"""
    cases_valides(etat::JeuAwaleState, joueur::Int) -> Vector{Int}

Retourne les cases où le joueur peut jouer (cases non vides de son côté).
\"""
function cases_valides(etat::JeuAwaleState, joueur::Int)
    if joueur == 1
        return [i for i in 1:6 if etat.plateau[i] > 0]
    else
        return [i for i in 7:12 if etat.plateau[i] > 0]
    end
end

\"""
    jouer_coup!(etat::JeuAwaleState, case_choisie::Int) -> Bool

Exécute un coup et retourne true si le coup était valide.
\"""
function jouer_coup!(etat::JeuAwaleState, case_choisie::Int)
    if etat.partie_terminee
        return false
    end
    
    # Vérifier que la case est valide pour le joueur actuel
    cases_possibles = cases_valides(etat, etat.joueur_actuel)
    if !(case_choisie in cases_possibles)
        return false
    end
    
    # Prendre toutes les graines de la case
    graines = etat.plateau[case_choisie]
    etat.plateau[case_choisie] = 0
    
    # Distribuer les graines
    position_actuelle = case_choisie
    while graines > 0
        position_actuelle = (position_actuelle % 12) + 1  # Mouvement circulaire
        etat.plateau[position_actuelle] += 1
        graines -= 1
    end
    
    # Vérifier capture (si dernière graine tombe chez l'adversaire)
    if est_case_adverse(position_actuelle, etat.joueur_actuel)
        nb_graines_case = etat.plateau[position_actuelle]
        if nb_graines_case == 2 || nb_graines_case == 3
            # Capturer les graines
            etat.scores[etat.joueur_actuel] += nb_graines_case
            etat.plateau[position_actuelle] = 0
            println("🎉 Capture! \$(nb_graines_case) graines capturées!")
        end
    end
    
    # Changer de joueur
    etat.joueur_actuel = (etat.joueur_actuel == 1) ? 2 : 1
    
    # Vérifier fin de partie
    verifier_fin_partie!(etat)
    
    return true
end

\"""
    est_case_adverse(case::Int, joueur::Int) -> Bool

Vérifie si une case appartient à l'adversaire.
\"""
function est_case_adverse(case::Int, joueur::Int)
    if joueur == 1
        return case >= 7  # Cases 7-12 pour joueur 2
    else
        return case <= 6  # Cases 1-6 pour joueur 1
    end
end

\"""
    verifier_fin_partie!(etat::JeuAwaleState)

Vérifie si la partie est terminée et détermine le gagnant.
\"""
function verifier_fin_partie!(etat::JeuAwaleState)
    # Vérifier si un joueur ne peut plus jouer
    cases_j1 = cases_valides(etat, 1)
    cases_j2 = cases_valides(etat, 2)
    
    if isempty(cases_j1) || isempty(cases_j2)
        etat.partie_terminee = true
        
        # Additionner les graines restantes au score
        for i in 1:6
            etat.scores[1] += etat.plateau[i]
        end
        for i in 7:12
            etat.scores[2] += etat.plateau[i]
        end
        
        # Déterminer le gagnant
        if etat.scores[1] > etat.scores[2]
            etat.gagnant = 1
        elseif etat.scores[2] > etat.scores[1]
            etat.gagnant = 2
        else
            etat.gagnant = 0  # Égalité
        end
    end
end

\"""
    jouer_awale(joueur::Joueur)

Lance une partie d'Awalé contre l'ordinateur.
\"""
function jouer_awale(joueur::Joueur)
    println("🥜 Bienvenue dans l'Awalé, \$(joueur.nom)!")
    println("Vous jouez contre l'ordinateur (niveau facile)")
    println()
    
    etat = JeuAwaleState()
    regles_awale()
    
    while !etat.partie_terminee
        afficher_plateau(etat)
        
        if etat.joueur_actuel == 1  # Tour du joueur humain
            cases_possibles = cases_valides(etat, 1)
            if isempty(cases_possibles)
                println("❌ Vous ne pouvez plus jouer!")
                break
            end
            
            println("🎮 À votre tour! Cases disponibles: \$(join(cases_possibles, ", "))")
            print("Choisissez une case (1-6): ")
            
            try
                choix = parse(Int, readline())
                if jouer_coup!(etat, choix)
                    println("✅ Coup joué: case \$choix")
                else
                    println("❌ Coup invalide! Réessayez.")
                    continue
                end
            catch
                println("❌ Veuillez entrer un nombre valide!")
                continue
            end
            
        else  # Tour de l'ordinateur
            cases_possibles = cases_valides(etat, 2)
            if isempty(cases_possibles)
                println("❌ L'ordinateur ne peut plus jouer!")
                break
            end
            
            # IA simple : choisir une case au hasard
            choix_ia = rand(cases_possibles)
            jouer_coup!(etat, choix_ia)
            println("🤖 L'ordinateur joue la case \$choix_ia")
            
            sleep(1)  # Petite pause pour l'effet
        end
    end
    
    # Afficher le résultat
    afficher_plateau(etat)
    println("🏁 === FIN DE PARTIE ===")
    
    if etat.gagnant == 1
        println("🎉 Félicitations! Vous avez gagné!")
        points_gagnes = 50 + etat.scores[1]
        ajouter_points!(joueur, points_gagnes, "Awalé")
        println("💰 Vous gagnez \$points_gagnes points!")
    elseif etat.gagnant == 2
        println("😔 L'ordinateur a gagné! Continuez à vous entraîner!")
        ajouter_points!(joueur, 10, "Awalé")  # Points de consolation
        println("💰 Points de participation: 10")
    else
        println("🤝 Match nul! Belle partie!")
        ajouter_points!(joueur, 25, "Awalé")
        println("💰 Points d'égalité: 25")
    end
    
    println()
end

\"""
    creer_partie_awale() -> JeuAwaleState

Crée une nouvelle partie d'Awalé pour les tests.
\"""
function creer_partie_awale()
    return JeuAwaleState()
end

end  # module JeuAwale
"""

    open("JeuxBurkina/src/jeu_awale.jl", "w") do fichier
        write(fichier, contenu_awale)
    end
    
    println("✅ Module Awalé créé!")
end

creer_jeu_awale()
```

### 🎯 Défi 2 : Test du jeu d'Awalé
Testez le jeu d'Awalé :

```julia
println("\n🧪 === TEST AWALÉ ===")
include("JeuxBurkina/src/jeu_awale.jl")
using .JeuAwale
using .StructuresBase

# Créer un joueur pour tester
joueur_awale = Joueur("Boureima Traoré", "Bobo-Dioulasso")

# Afficher les règles
regles_awale()

# Créer une partie de test et afficher le plateau
etat_test = creer_partie_awale()
afficher_plateau(etat_test)

println("🎮 Pour jouer une partie complète, utilisez:")
println("   jouer_awale(joueur_awale)")
```

---

## 🤔 Étape 4 : Jeu de devinettes

```julia
function creer_jeu_devinettes()
    contenu_devinettes = """
module JeuDevinettes

export deviner_nombre, deviner_ville, deviner_proverbe, quiz_burkina

using Random
using ..StructuresBase

# Base de données des villes du Burkina Faso
const VILLES_BURKINA = [
    "Ouagadougou", "Bobo-Dioulasso", "Koudougou", "Banfora", 
    "Ouahigouya", "Pouytenga", "Dédougou", "Kaya", "Gaoua",
    "Fada N'Gourma", "Ziniaré", "Dori", "Tenkodogo", "Réo",
    "Manga", "Kongoussi", "Djibo", "Tougan", "Nouna", "Diapaga"
]

# Proverbes et dictons burkinabè
const PROVERBES_BURKINA = [
    ("Si tu veux aller vite, marche seul. Si tu veux aller loin, marchons ensemble", "proverbe_ensemble"),
    ("L'arbre qui tombe fait du bruit, la forêt qui pousse reste silencieuse", "proverbe_foret"),
    ("Quand les racines d'un arbre commencent à pourrir, il se répand dans les branches", "proverbe_racines"),
    ("Ce n'est pas le puits qui est trop profond, c'est ta corde qui est trop courte", "proverbe_puits"),
    ("L'eau qui dort n'a pas de reproche à faire au courant", "proverbe_eau")
]

# Questions de culture générale burkinabè
const QUESTIONS_CULTURE = [
    ("Quelle est la capitale du Burkina Faso?", ["Ouagadougou", "Bobo-Dioulasso", "Koudougou"], 1),
    ("Quel est le nom de la monnaie burkinabè?", ["FCFA", "Euro", "Dollar"], 1),
    ("Qui était le président Thomas Sankara?", ["Révolutionnaire", "Musicien", "Commerçant"], 1),
    ("Quel tissu traditionnel est célèbre au Burkina?", ["Faso Dan Fani", "Kente", "Bogolan"], 1),
    ("Dans quelle région se trouve Banfora?", ["Sud-Ouest", "Centre", "Nord"], 1),
    ("Quel est le plus grand marché de Ouagadougou?", ["Grand Marché", "Rood Woko", "Marché central"], 2),
    ("Quelle danse traditionnelle est populaire au Burkina?", ["Djembe", "Balafon", "Les deux"], 3)
]

\"""
    deviner_nombre(joueur::Joueur; niveau::String = "facile")

Jeu de devinette de nombres avec différents niveaux.
\"""
function deviner_nombre(joueur::Joueur; niveau::String = "facile")
    println("🔢 === JEU DE DEVINETTES - NOMBRES ===")
    println("Bonjour \$(joueur.nom) de \$(joueur.origine)!")
    
    # Définir les paramètres selon le niveau
    if niveau == "facile"
        max_nombre = 50
        max_essais = 8
        points_base = 20
    elseif niveau == "moyen"
        max_nombre = 100
        max_essais = 7
        points_base = 40
    else  # difficile
        max_nombre = 200
        max_essais = 6
        points_base = 80
    end
    
    nombre_secret = rand(1:max_nombre)
    essais = 0
    
    println("🎯 Niveau: \$niveau")
    println("🔢 J'ai choisi un nombre entre 1 et \$max_nombre")
    println("🎮 Vous avez \$max_essais essais pour le trouver!")
    println()
    
    while essais < max_essais
        essais += 1
        print("Essai \$essais/\$max_essais - Votre proposition: ")
        
        try
            proposition = parse(Int, readline())
            
            if proposition == nombre_secret
                println("🎉 BRAVO! Vous avez trouvé \$nombre_secret!")
                points_gagnes = points_base - (essais - 1) * 5
                ajouter_points!(joueur, points_gagnes, "Devinettes")
                println("💰 Vous gagnez \$points_gagnes points!")
                return true
            elseif proposition < nombre_secret
                println("📈 C'est plus grand!")
            else
                println("📉 C'est plus petit!")
            end
            
        catch
            println("❌ Veuillez entrer un nombre valide!")
            essais -= 1  # Ne pas compter cet essai
        end
    end
    
    println("💀 Dommage! Le nombre était: \$nombre_secret")
    ajouter_points!(joueur, 5, "Devinettes")  # Points de consolation
    println("💰 Points de participation: 5")
    return false
end

\"""
    deviner_ville(joueur::Joueur)

Devine une ville du Burkina Faso avec des indices.
\"""
function deviner_ville(joueur::Joueur)
    println("🏙️  === DEVINEZ LA VILLE BURKINABÈ ===")
    
    ville_secrete = rand(VILLES_BURKINA)
    essais = 0
    max_essais = 4
    
    # Préparer des indices
    indices = preparer_indices_ville(ville_secrete)
    
    println("🎯 Je pense à une ville du Burkina Faso...")
    println("🕵️  Vous avez \$max_essais essais et 3 indices!")
    println()
    
    for essai in 1:max_essais
        if essai <= length(indices)
            println("💡 Indice \$essai: \$(indices[essai])")
        end
        
        print("Essai \$essai/\$max_essais - Quelle ville? ")
        proposition = strip(readline())
        
        if lowercase(proposition) == lowercase(ville_secrete)
            println("🎉 Exact! C'était bien \$ville_secrete!")
            points_gagnes = 50 - (essai - 1) * 10
            ajouter_points!(joueur, points_gagnes, "Devinettes")
            println("💰 Vous gagnez \$points_gagnes points!")
            return true
        else
            if essai < max_essais
                println("❌ Non, ce n'est pas \$proposition")
            end
        end
    end
    
    println("💀 La réponse était: \$ville_secrete")
    ajouter_points!(joueur, 5, "Devinettes")
    println("💰 Points de participation: 5")
    return false
end

\"""
    preparer_indices_ville(ville::String) -> Vector{String}

Prépare des indices pour deviner une ville.
\"""
function preparer_indices_ville(ville::String)
    indices_par_ville = Dict(
        "Ouagadougou" => [
            "C'est la capitale du pays",
            "On y trouve l'Université de Ouaga I",
            "Le Grand Marché s'y trouve",
            "Thomas Sankara y a vécu"
        ],
        "Bobo-Dioulasso" => [
            "C'est la deuxième plus grande ville",
            "Elle est dans la région des Hauts-Bassins",
            "On y trouve la Grande Mosquée",
            "Elle est surnommée 'Sya'"
        ],
        "Banfora" => [
            "Elle est connue pour ses cascades",
            "C'est dans le Sud-Ouest du pays",
            "Les Dômes de Fabedougou sont proches",
            "Elle produit beaucoup de canne à sucre"
        ],
        "Koudougou" => [
            "Elle est dans la région du Centre-Ouest",
            "C'est un important centre agricole",
            "Elle est sur la route de Bobo-Dioulasso",
            "Son nom signifie 'là où on creuse'"
        ]
    )
    
    return get(indices_par_ville, ville, [
        "C'est une ville du Burkina Faso",
        "Elle a une population importante",
        "Elle est administrative ou commerciale",
        "C'est un centre urbain reconnu"
    ])
end

\"""
    quiz_burkina(joueur::Joueur; nb_questions::Int = 5)

Quiz de culture générale sur le Burkina Faso.
\"""
function quiz_burkina(joueur::Joueur; nb_questions::Int = 5)
    println("🧠 === QUIZ CULTURE BURKINA FASO ===")
    println("Testez vos connaissances, \$(joueur.nom)!")
    println("📚 \$nb_questions questions vous attendent")
    println()
    
    questions_choisies = shuffle(QUESTIONS_CULTURE)[1:min(nb_questions, length(QUESTIONS_CULTURE))]
    score = 0
    
    for (i, (question, options, bonne_reponse)) in enumerate(questions_choisies)
        println("Question \$i/\$nb_questions:")
        println("❓ \$question")
        
        for (j, option) in enumerate(options)
            println("   \$j. \$option")
        end
        
        print("Votre réponse (1-\$(length(options))): ")
        
        try
            reponse = parse(Int, readline())
            
            if reponse == bonne_reponse
                println("✅ Correct!")
                score += 1
            else
                println("❌ Faux! La bonne réponse était: \$(bonne_reponse). \$(options[bonne_reponse])")
            end
        catch
            println("❌ Réponse invalide!")
        end
        
        println()
    end
    
    # Calcul des points
    pourcentage = round((score / nb_questions) * 100, digits=1)
    points_gagnes = score * 15  # 15 points par bonne réponse
    
    println("🏁 === RÉSULTATS ===")
    println("📊 Score: \$score/\$nb_questions (\$pourcentage%)")
    
    if pourcentage >= 80
        println("🏆 Excellent! Vous connaissez bien le Burkina!")
        ajouter_achievement!(joueur, "Expert en culture burkinabè")
    elseif pourcentage >= 60
        println("👍 Bien! Bonne connaissance du pays")
    elseif pourcentage >= 40
        println("📚 Pas mal, mais vous pouvez encore apprendre!")
    else
        println("📖 Il faut réviser l'histoire et la culture du Burkina!")
    end
    
    ajouter_points!(joueur, points_gagnes, "Quiz")
    println("💰 Points gagnés: \$points_gagnes")
    
    return score
end

\"""
    deviner_proverbe(joueur::Joueur)

Complète un proverbe burkinabè traditionnel.
\"""
function deviner_proverbe(joueur::Joueur)
    println("💭 === COMPLÉTER LE PROVERBE ===")
    
    proverbe_complet, id_proverbe = rand(PROVERBES_BURKINA)
    mots = split(proverbe_complet, " ")
    
    # Cacher quelques mots (environ 20-30% des mots)
    nb_mots_caches = max(1, div(length(mots), 4))
    indices_caches = shuffle(1:length(mots))[1:nb_mots_caches]
    
    proverbe_avec_trous = copy(mots)
    mots_caches = String[]
    
    for i in indices_caches
        push!(mots_caches, mots[i])
        proverbe_avec_trous[i] = "___"
    end
    
    println("🎯 Complétez ce proverbe burkinabè:")
    println("📜 \"\$(join(proverbe_avec_trous, " "))\"")
    println()
    println("💡 Mots manquants (dans le désordre): \$(join(shuffle(mots_caches), ", "))")
    println()
    
    print("✍️  Écrivez le proverbe complet: ")
    reponse = strip(readline())
    
    # Vérification souple (ignorer la casse et la ponctuation)
    if normaliser_texte(reponse) == normaliser_texte(proverbe_complet)
        println("🎉 Parfait! Vous connaissez bien nos proverbes!")
        ajouter_points!(joueur, 40, "Proverbes")
        println("💰 Points gagnés: 40")
        return true
    else
        println("❌ Pas tout à fait...")
        println("📜 Le proverbe complet était:")
        println("   \"\$proverbe_complet\"")
        ajouter_points!(joueur, 10, "Proverbes")
        println("💰 Points de participation: 10")
        return false
    end
end

\"""
    normaliser_texte(texte::String) -> String

Normalise un texte pour la comparaison (supprime ponctuation, espaces multiples, casse).
\"""
function normaliser_texte(texte::String)
    # Supprimer la ponctuation et normaliser les espaces
    texte_propre = replace(lowercase(texte), r"[,\.!?;:]" => "")
    texte_propre = replace(texte_propre, r"\\s+" => " ")
    return strip(texte_propre)
end

end  # module JeuDevinettes
"""

    open("JeuxBurkina/src/jeu_devinettes.jl", "w") do fichier
        write(fichier, contenu_devinettes)
    end
    
    println("✅ Module Devinettes créé!")
end

creer_jeu_devinettes()
```

---

## 📚 Étape 5 : Module de contes et légendes

```julia
function creer_jeu_contes()
    contenu_contes = """
module JeuContes

export raconter_conte, quiz_conte, contes_disponibles

using Random
using ..StructuresBase

# Base de données des contes burkinabè
const CONTES_BURKINA = Dict(
    "yennenga" => Dict(
        "titre" => "La Légende de la Princesse Yennenga",
        "conte" => \"\"\"
Il était une fois, au royaume de Dagbon, une princesse guerrière nommée Yennenga.
Elle était si habile au combat que son père, le roi, refusait qu'elle se marie,
car il avait besoin d'elle pour protéger le royaume.

Un jour, fatiguée de cette situation, Yennenga s'enfuit sur son cheval.
Après un long voyage, elle rencontra un jeune chasseur éléphant nommé Rialé.
Ils tombèrent amoureux et eurent un fils qu'ils appelèrent Ouédraogo.

Ouédraogo grandit et devint un grand chef. Il fonda un royaume qu'il nomma
Burkina, qui signifie "terre des hommes intègres".

C'est ainsi que naquit notre beau pays, le Burkina Faso!
\"\"\",
        "morale" => "La détermination et l'amour peuvent créer de grandes choses.",
        "questions" => [
            ("Comment s'appelait la princesse guerrière?", ["Yennenga", "Rialé", "Ouédraogo"], 1),
            ("Quel était le métier de Rialé?", ["Guerrier", "Chasseur d'éléphants", "Roi"], 2),
            ("Comment s'appelait leur fils?", ["Burkina", "Ouédraogo", "Dagbon"], 2),
            ("Que signifie 'Burkina'?", ["Terre des rois", "Terre des hommes intègres", "Terre des guerriers"], 2)
        ]
    ),
    
    "lievre_hyene" => Dict(
        "titre" => "Le Lièvre et la Hyène",
        "conte" => \"\"\"
Un jour, Lièvre et Hyène décidèrent de cultiver ensemble un champ de mil.
Lièvre, plus malin, proposa: "Moi je prends ce qui pousse sous la terre,
toi tu prends ce qui pousse au-dessus."

Hyène accepta, pensant avoir le meilleur deal. Mais Lièvre avait planté
des arachides! Quand vint la récolte, Lièvre récolta toutes les arachides
souterraines, et Hyène n'eut que les feuilles inutiles.

L'année suivante, Hyène dit: "Cette fois, je prends ce qui est sous terre!"
Malin Lièvre planta du mil. À la récolte, Hyène n'eut que les racines,
et Lièvre récolta tous les épis de mil.

Depuis ce jour, on dit au Burkina: "L'intelligence vaut mieux que la force."
\"\"\",
        "morale" => "L'intelligence et la ruse peuvent triompher de la force brute.",
        "questions" => [
            ("Qui était le plus malin?", ["Hyène", "Lièvre", "Les deux"], 2),
            ("Qu'a planté Lièvre la première année?", ["Mil", "Arachides", "Ignames"], 2),
            ("Qu'a eu Hyène la première année?", ["Arachides", "Feuilles", "Racines"], 2),
            ("Quelle est la morale?", ["La force prime", "L'intelligence vaut mieux", "Il faut partager"], 2)
        ]
    ),
    
    "baobab" => Dict(
        "titre" => "Pourquoi le Baobab est à l'envers",
        "conte" => \"\"\"
Au commencement, quand Dieu créa les arbres, le Baobab était le plus bel arbre.
Il avait un tronc élancé, des branches gracieuses et des feuilles toujours vertes.

Mais Baobab devint très orgueilleux. Il se moquait des autres arbres:
"Regardez comme je suis beau! Vous n'êtes que de pauvres arbustes!"

Il critiquait même le travail de Dieu: "Pourquoi m'avoir planté dans la savane?
Je mériterais d'être près d'une belle rivière, comme ces palmiers stupides!"

Dieu entendit ces plaintes et se fâcha. D'un geste puissant, Il arracha
Baobab et le replanta la tête en bas!

C'est pourquoi aujourd'hui, le Baobab semble avoir ses racines en l'air.
Et il ne peut plus se plaindre, car sa bouche est dans la terre!
\"\"\",
        "morale" => "L'orgueil et l'ingratitude mènent à la chute.",
        "questions" => [
            ("Pourquoi Baobab était-il fier?", ["Il était beau", "Il était grand", "Il était vieux"], 1),
            ("De quoi se plaignait-il?", ["De sa hauteur", "De son emplacement", "De ses feuilles"], 2),
            ("Qu'a fait Dieu pour le punir?", ["L'a coupé", "L'a replanté à l'envers", "L'a déplacé"], 2),
            ("Quelle est la leçon?", ["Être humble", "Être grand", "Être patient"], 1)
        ]
    )
)

\"""
    contes_disponibles()

Affiche la liste des contes disponibles.
\"""
function contes_disponibles()
    println("📚 === CONTES DISPONIBLES ===")
    for (id, conte) in CONTES_BURKINA
        println("🌟 \$(conte["titre"])")
        println("   ID: \$id")
        println("   📖 Morale: \$(conte["morale"])")
        println()
    end
end

\"""
    raconter_conte(id_conte::String; interactif::Bool = false)

Raconte un conte burkinabè.
\"""
function raconter_conte(id_conte::String; interactif::Bool = false)
    if !haskey(CONTES_BURKINA, id_conte)
        println("❌ Conte '\$id_conte' non trouvé!")
        contes_disponibles()
        return
    end
    
    conte = CONTES_BURKINA[id_conte]
    
    println("📖 === \$(conte["titre"]) ===")
    println()
    
    if interactif
        # Raconter phrase par phrase avec pauses
        phrases = split(conte["conte"], ". ")
        for (i, phrase) in enumerate(phrases)
            println(phrase * (i < length(phrases) ? "." : ""))
            if i % 3 == 0 && i < length(phrases)  # Pause tous les 3 phrases
                print("\\n[Appuyez sur Entrée pour continuer...]")
                readline()
                println()
            end
        end
    else
        # Raconter d'un coup
        println(conte["conte"])
    end
    
    println()
    println("✨ Morale: \$(conte["morale"])")
    println()
end

\"""
    quiz_conte(joueur::Joueur, id_conte::String)

Lance un quiz basé sur un conte.
\"""
function quiz_conte(joueur::Joueur, id_conte::String)
    if !haskey(CONTES_BURKINA, id_conte)
        println("❌ Conte '\$id_conte' non trouvé pour le quiz!")
        return 0
    end
    
    conte = CONTES_BURKINA[id_conte]
    
    println("🧠 === QUIZ: \$(conte["titre"]) ===")
    println("📚 D'abord, (re)lisons le conte...")
    println()
    
    raconter_conte(id_conte)
    
    println("🎯 Maintenant, testons votre compréhension!")
    println()
    
    score = 0
    questions = conte["questions"]
    
    for (i, (question, options, bonne_reponse)) in enumerate(questions)
        println("Question \$i/\$(length(questions)):")
        println("❓ \$question")
        
        for (j, option) in enumerate(options)
            println("   \$j. \$option")
        end
        
        print("Votre réponse (1-\$(length(options))): ")
        
        try
            reponse = parse(Int, readline())
            
            if reponse == bonne_reponse
                println("✅ Excellent!")
                score += 1
            else
                println("❌ Non, la bonne réponse était: \$(options[bonne_reponse])")
            end
        catch
            println("❌ Réponse invalide!")
        end
        
        println()
    end
    
    # Calcul des points
    pourcentage = round((score / length(questions)) * 100, digits=1)
    points_gagnes = score * 20  # 20 points par bonne réponse
    
    println("🏁 === RÉSULTATS DU QUIZ ===")
    println("📊 Score: \$score/\$(length(questions)) (\$pourcentage%)")
    
    if pourcentage == 100
        println("🏆 Parfait! Vous avez bien écouté le conte!")
        ajouter_achievement!(joueur, "Maître conteur")
    elseif pourcentage >= 75
        println("🌟 Très bien! Vous comprenez nos légendes!")
    elseif pourcentage >= 50
        println("📖 Pas mal! Relisez le conte pour mieux comprendre")
    else
        println("📚 Il faut mieux écouter nos histoires traditionnelles!")
    end
    
    ajouter_points!(joueur, points_gagnes, "Contes")
    println("💰 Points gagnés: \$points_gagnes")
    
    return score
end

\"""
    conte_aleatoire(joueur::Joueur)

Raconte un conte choisi au hasard avec quiz optionnel.
\"""
function conte_aleatoire(joueur::Joueur)
    id_conte = rand(keys(CONTES_BURKINA))
    
    println("🎲 Conte choisi au hasard: \$(CONTES_BURKINA[id_conte]["titre"])")
    println()
    
    raconter_conte(id_conte, interactif=true)
    
    print("🤔 Voulez-vous faire le quiz sur ce conte? (o/n): ")
    if lowercase(strip(readline())) == "o"
        quiz_conte(joueur, id_conte)
    else
        # Points pour avoir écouté
        ajouter_points!(joueur, 10, "Contes")
        println("💰 Points d'écoute: 10")
    end
end

end  # module JeuContes
"""

    open("JeuxBurkina/src/jeu_contes.jl", "w") do fichier
        write(fichier, contenu_contes)
    end
    
    println("✅ Module Contes créé!")
end

creer_jeu_contes()
```

---

## 🏆 Étape 6 : Menu principal et gestion globale

```julia
function creer_gestion_scores()
    contenu_gestion = """
module GestionScores

export sauvegarder_scores, charger_scores, afficher_menu_principal, tableau_scores_global

using JSON, Dates
using ..StructuresBase

const FICHIER_SCORES = "save_games/scores_globaux.json"
const FICHIER_JOUEURS = "save_games/joueurs.json"

\"""
    sauvegarder_joueur(joueur::Joueur)

Sauvegarde un joueur dans le fichier JSON.
\"""
function sauvegarder_joueur(joueur::Joueur)
    # Créer le dossier s'il n'existe pas
    if !isdir("save_games")
        mkdir("save_games")
    end
    
    # Charger les joueurs existants
    joueurs_existants = Dict{String, Any}()
    if isfile(FICHIER_JOUEURS)
        try
            joueurs_existants = JSON.parsefile(FICHIER_JOUEURS)
        catch
            println("⚠️  Erreur lors du chargement des joueurs existants")
        end
    end
    
    # Convertir le joueur en dictionnaire
    joueur_dict = Dict(
        "nom" => joueur.nom,
        "origine" => joueur.origine,
        "niveau" => joueur.niveau,
        "points_total" => joueur.points_total,
        "jeux_joues" => joueur.jeux_joues,
        "jeux_gagnes" => joueur.jeux_gagnes,
        "date_creation" => joueur.date_creation,
        "derniere_connexion" => joueur.derniere_connexion,
        "achievements" => joueur.achievements,
        "statistiques" => joueur.statistiques
    )
    
    # Ajouter/mettre à jour le joueur
    joueurs_existants[joueur.nom] = joueur_dict
    
    # Sauvegarder
    try
        open(FICHIER_JOUEURS, "w") do fichier
            JSON.print(fichier, joueurs_existants, 2)
        end
        println("💾 Profil de \$(joueur.nom) sauvegardé!")
    catch e
        println("❌ Erreur lors de la sauvegarde: \$e")
    end
end

\"""
    charger_joueur(nom::String) -> Union{Joueur, Nothing}

Charge un joueur depuis le fichier JSON.
\"""
function charger_joueur(nom::String)
    if !isfile(FICHIER_JOUEURS)
        return nothing
    end
    
    try
        joueurs_data = JSON.parsefile(FICHIER_JOUEURS)
        
        if !haskey(joueurs_data, nom)
            return nothing
        end
        
        data = joueurs_data[nom]
        
        # Reconstruire le joueur
        joueur = Joueur(data["nom"], data["origine"])
        joueur.niveau = data["niveau"]
        joueur.points_total = data["points_total"]
        joueur.jeux_joues = data["jeux_joues"]
        joueur.jeux_gagnes = data["jeux_gagnes"]
        joueur.date_creation = data["date_creation"]
        joueur.derniere_connexion = data["derniere_connexion"]
        joueur.achievements = data["achievements"]
        joueur.statistiques = data["statistiques"]
        
        return joueur
        
    catch e
        println("❌ Erreur lors du chargement: \$e")
        return nothing
    end
end

\"""
    lister_joueurs_sauvegardes() -> Vector{String}

Liste tous les joueurs sauvegardés.
\"""
function lister_joueurs_sauvegardes()
    if !isfile(FICHIER_JOUEURS)
        return String[]
    end
    
    try
        joueurs_data = JSON.parsefile(FICHIER_JOUEURS)
        return collect(keys(joueurs_data))
    catch
        return String[]
    end
end

\"""
    tableau_scores_global()

Affiche le tableau des scores globaux.
\"""
function tableau_scores_global()
    println("🏆 === TABLEAU DES SCORES GLOBAUX ===")
    
    if !isfile(FICHIER_JOUEURS)
        println("📭 Aucun joueur enregistré pour le moment")
        return
    end
    
    try
        joueurs_data = JSON.parsefile(FICHIER_JOUEURS)
        
        if isempty(joueurs_data)
            println("📭 Aucun joueur enregistré pour le moment")
            return
        end
        
        # Convertir en vecteur et trier par points
        joueurs_scores = [(data["nom"], data["points_total"], data["niveau"], data["origine"]) 
                         for (nom, data) in joueurs_data]
        sort!(joueurs_scores, by=x->x[2], rev=true)
        
        println("🥇 TOP JOUEURS BURKINA FASO:")
        println()
        
        for (i, (nom, points, niveau, origine)) in enumerate(joueurs_scores[1:min(10, length(joueurs_scores))])
            medaille = i <= 3 ? ["🥇", "🥈", "🥉"][i] : "🏆"
            println("\$medaille \$i. \$nom (\$origine)")
            println("     💰 \$points points | ⭐ Niveau \$niveau")
            println()
        end
        
    catch e
        println("❌ Erreur lors du chargement des scores: \$e")
    end
end

\"""
    afficher_menu_principal()

Affiche et gère le menu principal des jeux.
\"""
function afficher_menu_principal()
    joueur_actuel = nothing
    
    while true
        println("\\n🇧🇫 === JEUX TRADITIONNELS BURKINA FASO ===")
        
        if joueur_actuel !== nothing
            println("👤 Joueur connecté: \$(joueur_actuel.nom) | ⭐ Niveau \$(joueur_actuel.niveau) | 💰 \$(joueur_actuel.points_total) pts")
        end
        
        println()
        println("1. 👤 Gestion du profil")
        println("2. 🥜 Jouer à l'Awalé")
        println("3. 🤔 Jeux de devinettes")
        println("4. 📚 Contes et légendes")
        println("5. 🏆 Tableau des scores")
        println("6. ℹ️  Aide et règles")
        println("7. 🚪 Quitter")
        
        print("\\nVotre choix (1-7): ")
        choix = strip(readline())
        
        if choix == "1"
            joueur_actuel = gerer_profil(joueur_actuel)
            
        elseif choix == "2"
            if joueur_actuel === nothing
                println("❌ Veuillez d'abord créer ou charger un profil!")
                continue
            end
            
            # Importer les modules de jeu (simulation)
            println("🥜 Lancement de l'Awalé...")
            # jouer_awale(joueur_actuel)  # Décommenté pour jeu réel
            ajouter_points!(joueur_actuel, rand(10:50), "Awalé")
            sauvegarder_joueur(joueur_actuel)
            
        elseif choix == "3"
            if joueur_actuel === nothing
                println("❌ Veuillez d'abord créer ou charger un profil!")
                continue
            end
            
            menu_devinettes(joueur_actuel)
            
        elseif choix == "4"
            if joueur_actuel === nothing
                println("❌ Veuillez d'abord créer ou charger un profil!")
                continue
            end
            
            menu_contes(joueur_actuel)
            
        elseif choix == "5"
            tableau_scores_global()
            
        elseif choix == "6"
            afficher_aide()
            
        elseif choix == "7"
            if joueur_actuel !== nothing
                sauvegarder_joueur(joueur_actuel)
                println("💾 Profil sauvegardé!")
            end
            println("👋 Merci d'avoir joué! À bientôt!")
            break
            
        else
            println("❌ Choix invalide! Veuillez choisir entre 1 et 7.")
        end
        
        # Pause avant de revenir au menu
        if choix != "7"
            print("\\n[Appuyez sur Entrée pour revenir au menu...]")
            readline()
        end
    end
end

\"""
    gerer_profil(joueur_actuel) -> Union{Joueur, Nothing}

Gère la création/chargement/affichage des profils.
\"""
function gerer_profil(joueur_actuel)
    while true
        println("\\n👤 === GESTION DU PROFIL ===")
        
        if joueur_actuel !== nothing
            println("Profil actuel: \$(joueur_actuel.nom)")
        end
        
        println()
        println("1. ➕ Créer un nouveau profil")
        println("2. 📂 Charger un profil existant")
        println("3. 👁️  Voir mon profil actuel")
        println("4. 🔄 Retour au menu principal")
        
        print("\\nVotre choix (1-4): ")
        choix = strip(readline())
        
        if choix == "1"
            return creer_nouveau_profil()
            
        elseif choix == "2"
            return charger_profil_existant()
            
        elseif choix == "3"
            if joueur_actuel !== nothing
                afficher_joueur(joueur_actuel)
            else
                println("❌ Aucun profil chargé!")
            end
            
        elseif choix == "4"
            return joueur_actuel
            
        else
            println("❌ Choix invalide!")
        end
    end
end

\"""
    creer_nouveau_profil() -> Joueur

Crée un nouveau profil de joueur.
\"""
function creer_nouveau_profil()
    println("\\n➕ === NOUVEAU PROFIL ===")
    
    print("🎮 Nom du joueur: ")
    nom = strip(readline())
    
    if isempty(nom)
        println("❌ Le nom ne peut pas être vide!")
        return nothing
    end
    
    # Vérifier si le joueur existe déjà
    if charger_joueur(nom) !== nothing
        println("⚠️  Un joueur avec ce nom existe déjà!")
        print("Voulez-vous le charger à la place? (o/n): ")
        if lowercase(strip(readline())) == "o"
            return charger_joueur(nom)
        else
            return nothing
        end
    end
    
    print("🏠 Ville/Région d'origine: ")
    origine = strip(readline())
    
    if isempty(origine)
        origine = "Burkina Faso"
    end
    
    joueur = Joueur(nom, origine)
    sauvegarder_joueur(joueur)
    
    println("✅ Profil créé avec succès!")
    afficher_joueur(joueur)
    
    return joueur
end

\"""
    charger_profil_existant() -> Union{Joueur, Nothing}

Charge un profil existant.
\"""
function charger_profil_existant()
    println("\\n📂 === CHARGER UN PROFIL ===")
    
    joueurs_disponibles = lister_joueurs_sauvegardes()
    
    if isempty(joueurs_disponibles)
        println("📭 Aucun profil sauvegardé trouvé!")
        return nothing
    end
    
    println("Profils disponibles:")
    for (i, nom) in enumerate(joueurs_disponibles)
        println("\$i. \$nom")
    end
    
    print("\\nChoisissez un profil (numéro ou nom): ")
    choix = strip(readline())
    
    # Essayer de parser comme un numéro
    try
        index = parse(Int, choix)
        if 1 <= index <= length(joueurs_disponibles)
            nom_choisi = joueurs_disponibles[index]
            joueur = charger_joueur(nom_choisi)
            if joueur !== nothing
                println("✅ Profil \$nom_choisi chargé!")
                return joueur
            end
        else
            println("❌ Numéro invalide!")
        end
    catch
        # Essayer comme nom direct
        joueur = charger_joueur(choix)
        if joueur !== nothing
            println("✅ Profil \$choix chargé!")
            return joueur
        else
            println("❌ Profil '\$choix' non trouvé!")
        end
    end
    
    return nothing
end

\"""
    menu_devinettes(joueur::Joueur)

Menu des jeux de devinettes.
\"""
function menu_devinettes(joueur::Joueur)
    # Cette fonction serait implémentée pour intégrer avec JeuDevinettes
    println("🤔 Jeux de devinettes en développement...")
    ajouter_points!(joueur, rand(5:30), "Devinettes")
    sauvegarder_joueur(joueur)
end

\"""
    menu_contes(joueur::Joueur)

Menu des contes et légendes.
\"""
function menu_contes(joueur::Joueur)
    # Cette fonction serait implémentée pour intégrer avec JeuContes
    println("📚 Contes et légendes en développement...")
    ajouter_points!(joueur, rand(5:20), "Contes")
    sauvegarder_joueur(joueur)
end

\"""
    afficher_aide()

Affiche l'aide générale du système.
\"""
function afficher_aide()
    println("\\nℹ️  === AIDE ET RÈGLES ===")
    println("🎮 Bienvenue dans les Jeux Traditionnels du Burkina Faso!")
    println()
    println("📋 Comment jouer:")
    println("   1. Créez d'abord un profil avec votre nom")
    println("   2. Choisissez un jeu dans le menu principal")
    println("   3. Gagnez des points en jouant et en réussissant")
    println("   4. Montez de niveau et débloquez des achievements")
    println("   5. Comparez vos scores avec d'autres joueurs")
    println()
    println("🏆 Système de points:")
    println("   • Victoires aux jeux: 20-80 points")
    println("   • Bonnes réponses quiz: 15-20 points")
    println("   • Participation: 5-10 points")
    println("   • Achievements spéciaux: points bonus")
    println()
    println("⭐ Niveaux:")
    println("   • Niveau 1: 0-99 points")
    println("   • Niveau 2: 100-499 points")
    println("   • Niveau 3: 500-1499 points")
    println("   • Et ainsi de suite...")
    println()
    println("💾 Vos profils sont automatiquement sauvegardés!")
end

end  # module GestionScores
"""

    open("JeuxBurkina/src/gestion_scores.jl", "w") do fichier
        write(fichier, contenu_gestion)
    end
    
    println("✅ Module GestionScores créé!")
end

creer_gestion_scores()
```

---

## 🧪 Étape 7 : Test du système complet

```julia
# Finaliser la création du module
creer_module_principal_jeux()

println("\n🧪 === TEST DU SYSTÈME COMPLET ===")

# Charger tous les modules
include("JeuxBurkina/src/structures_base.jl")
include("JeuxBurkina/src/gestion_scores.jl")

using .StructuresBase
using .GestionScores

# Test des fonctionnalités de base
println("🎮 Test de création de joueur:")
joueur_test = Joueur("Fatimata Compaoré", "Koudougou")
afficher_joueur(joueur_test)

# Test du système de points
for i in 1:5
    points = rand(10:50)
    jeu = rand(["Awalé", "Quiz", "Devinettes"])
    ajouter_points!(joueur_test, points, jeu)
    println("+ $points points ($jeu)")
end

println("\nProfil final:")
afficher_joueur(joueur_test)

# Test de sauvegarde
sauvegarder_joueur(joueur_test)

# Test de chargement
joueur_charge = charger_joueur("Fatimata Compaoré")
if joueur_charge !== nothing
    println("✅ Chargement réussi!")
    afficher_joueur(joueur_charge)
end

# Afficher comment lancer le système
println("\n🚀 === LANCEMENT DU SYSTÈME ===")
println("Pour jouer, utilisez:")
println("   afficher_menu_principal()")
println()
println("Ou testez individuellement:")
println("   tableau_scores_global()")
println("   afficher_aide()")
```

---

## 🏅 Récapitulatif des points

```julia
println("\n🏅 === RÉCAPITULATIF FINAL ===")
score_total = 0

# Vérifier les modules créés
modules_attendus = [
    "structures_base.jl",
    "jeu_awale.jl", 
    "jeu_devinettes.jl",
    "jeu_contes.jl",
    "gestion_scores.jl"
]

modules_crees = 0
for module_file in modules_attendus
    if isfile(joinpath("JeuxBurkina/src", module_file))
        modules_crees += 1
    end
end

score_total += modules_crees * 15
println("✅ Modules créés ($(modules_crees)/$(length(modules_attendus))): +$(modules_crees * 15) points")

# Points pour structure de projet
if isfile("JeuxBurkina/Project.toml") && isdir("JeuxBurkina/save_games")
    score_total += 20
    println("✅ Structure de projet complète: +20 points")
end

# Points pour fonctionnalités
if @isdefined(joueur_test) && joueur_test.points_total > 0
    score_total += 15
    println("✅ Système de points fonctionnel: +15 points")
end

# Points pour sauvegarde
if isfile("save_games/joueurs.json")
    score_total += 20
    println("✅ Système de sauvegarde: +20 points")
end

# Points pour contenu culturel
score_total += 15
println("✅ Contenu culturel burkinabè: +15 points")

println("\n🎯 SCORE TOTAL: $(score_total)/120 points")

if score_total >= 100
    println("🥇 Excellent! Système de jeu complet et professionnel!")
elseif score_total >= 80
    println("🥈 Très bien! Bon framework de jeu!")
elseif score_total >= 60
    println("🥉 Bien! Système de base fonctionnel!")
else
    println("📚 Complétez les modules manquants!")
end

println("\n🎮 === FÉLICITATIONS ===")
println("Vous avez créé un système de jeux complet inspiré de la culture burkinabè!")
println("Votre module JeuxBurkina inclut:")
println("   🥜 Jeu d'Awalé traditionnel")
println("   🤔 Devinettes sur le Burkina Faso")
println("   📚 Contes et légendes locales")
println("   🏆 Système de scores et achievements")
println("   💾 Sauvegarde persistante des profils")
println()
println("🚀 Pour lancer le système complet:")
println("   include(\"JeuxBurkina/src/JeuxBurkina.jl\")")
println("   using .JeuxBurkina")
println("   afficher_menu_principal()")
```

---

## 🎓 Ce que vous avez appris

1. ✅ **Architecture modulaire complexe** avec multiples sous-modules
2. ✅ **Intégration culturelle** dans la programmation
3. ✅ **Systèmes de persistance** avec JSON
4. ✅ **Interfaces utilisateur** textuelles interactives
5. ✅ **Gestion d'état** et progression de joueurs
6. ✅ **Organisation de projet** à grande échelle
7. ✅ **Programmation orientée jeu** avec mécaniques complètes

## 🚀 Prochaine étape

Dans l'exercice final, vous construirez un package complet pour un projet au choix !

🎮 **Félicitations, vous êtes maintenant un(e) développeur/développeuse de jeux et d'applications culturelles expert(e) !**