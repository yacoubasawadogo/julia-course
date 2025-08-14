# 🎮 Pratique 7.2 : Sauvegarde d'état de jeu avec JSON

## 🎯 Mission
Créer un système complet de sauvegarde/chargement pour un jeu d'aventure burkinabè avec persistance des données en JSON !

## 📋 Ce que vous allez apprendre
- Sauvegarder des structures complexes en JSON
- Charger et restaurer l'état d'un jeu
- Gérer plusieurs slots de sauvegarde
- Créer un système de backup automatique
- Traiter les erreurs de corruption de fichiers

---

## 🏗️ Étape 1 : Structures du jeu d'aventure

Créons un jeu d'aventure se déroulant au Burkina Faso avec des lieux emblématiques :

```julia
using JSON, Dates

# Structure pour les objets du jeu
struct ObjetJeu
    nom::String
    description::String
    valeur::Int
    type::String  # "arme", "bouclier", "consommable", "trésor"
end

# Structure pour les compétences
mutable struct Competences
    force::Int
    agilite::Int
    intelligence::Int
    charisme::Int
    
    Competences() = new(10, 10, 10, 10)  # Valeurs par défaut
end

# Structure pour la position dans le monde
struct Position
    region::String
    ville::String
    lieu::String
    x::Int
    y::Int
end

# Structure principale du joueur
mutable struct JoueurAventure
    nom::String
    niveau::Int
    experience::Int
    points_vie::Int
    points_vie_max::Int
    energie::Int
    energie_max::Int
    competences::Competences
    inventaire::Vector{ObjetJeu}
    argent::Int  # en FCFA
    position::Position
    quetes_terminees::Vector{String}
    achievements::Vector{String}
    temps_jeu::Float64  # en heures
    derniere_sauvegarde::String
    
    function JoueurAventure(nom::String)
        # Position de départ : Ouagadougou
        position_depart = Position("Centre", "Ouagadougou", "Place de la Nation", 0, 0)
        
        new(
            nom, 1, 0, 100, 100, 50, 50,
            Competences(),
            ObjetJeu[],
            10000,  # 10,000 FCFA de départ
            position_depart,
            String[],
            String[],
            0.0,
            string(Dates.now())
        )
    end
end

# Objets de départ
objets_disponibles = [
    ObjetJeu("Gourde d'eau", "Gourde traditionnelle en calebasse", 500, "consommable"),
    ObjetJeu("Canne de marche", "Bâton sculpté par un artisan mossi", 1500, "arme"),
    ObjetJeu("Amulette de protection", "Amulette bénie par les anciens", 3000, "trésor"),
    ObjetJeu("Pagne Faso Dan Fani", "Tissu traditionnel burkinabè", 8000, "trésor"),
    ObjetJeu("Calebasse de karité", "Beurre de karité dans une calebasse", 2000, "consommable"),
    ObjetJeu("Masque traditionnel", "Masque de danse rituelle", 12000, "trésor"),
    ObjetJeu("Arc traditionnel", "Arc de chasse peul", 5000, "arme"),
    ObjetJeu("Sandales en cuir", "Sandales fabriquées à Banfora", 3500, "trésor")
]

# Créer un joueur exemple
println("🎮 === CRÉATION DU PERSONNAGE ===")
print("Entrez le nom de votre héros burkinabè: ")
nom_hero = readline()
if isempty(nom_hero)
    nom_hero = "Tiéméogo le Brave"
end

hero = JoueurAventure(nom_hero)

# Donner quelques objets de départ
objets_depart = rand(objets_disponibles, 3)
for objet in objets_depart
    push!(hero.inventaire, objet)
end

println("✅ Personnage créé: $(hero.nom)")
println("🏠 Position de départ: $(hero.position.lieu), $(hero.position.ville)")
println("🎒 Objets de départ: $(length(hero.inventaire)) objets")
```

### 🎯 Défi 1 : Développement du personnage
Faites évoluer votre personnage avec quelques actions :

```julia
println("\n🎯 DÉFI 1 : Développement du personnage")

function afficher_statut_joueur(joueur::JoueurAventure)
    println("\n👤 === STATUT DE $(joueur.nom) ===")
    println("🏆 Niveau: $(joueur.niveau) | XP: $(joueur.experience)")
    println("❤️  Vie: $(joueur.points_vie)/$(joueur.points_vie_max)")
    println("⚡ Énergie: $(joueur.energie)/$(joueur.energie_max)")
    println("💰 Argent: $(joueur.argent) FCFA")
    println("📍 Position: $(joueur.position.lieu), $(joueur.position.ville)")
    println("⏱️  Temps de jeu: $(round(joueur.temps_jeu, digits=1)) heures")
    
    println("\n💪 Compétences:")
    println("   • Force: $(joueur.competences.force)")
    println("   • Agilité: $(joueur.competences.agilite)")
    println("   • Intelligence: $(joueur.competences.intelligence)")
    println("   • Charisme: $(joueur.competences.charisme)")
    
    println("\n🎒 Inventaire ($(length(joueur.inventaire)) objets):")
    if isempty(joueur.inventaire)
        println("   Inventaire vide")
    else
        for (i, objet) in enumerate(joueur.inventaire)
            println("   $i. $(objet.nom) - $(objet.valeur) FCFA")
        end
    end
    
    if !isempty(joueur.quetes_terminees)
        println("\n✅ Quêtes terminées: $(join(joueur.quetes_terminees, ", "))")
    end
    
    if !isempty(joueur.achievements)
        println("\n🏅 Achievements: $(join(joueur.achievements, ", "))")
    end
end

# Simulation d'évolution
function simuler_aventure!(joueur::JoueurAventure)
    println("🗺️  Simulation d'une aventure...")
    
    # Gagner de l'expérience
    xp_gagne = rand(100:500)
    joueur.experience += xp_gagne
    println("✨ +$(xp_gagne) XP gagné!")
    
    # Vérifier montée de niveau
    if joueur.experience >= joueur.niveau * 1000
        joueur.niveau += 1
        joueur.points_vie_max += 20
        joueur.points_vie = joueur.points_vie_max
        joueur.energie_max += 10
        joueur.energie = joueur.energie_max
        
        # Améliorer une compétence aléatoire
        competences_list = [
            (:force, "Force"),
            (:agilite, "Agilité"), 
            (:intelligence, "Intelligence"),
            (:charisme, "Charisme")
        ]
        
        comp_field, comp_nom = rand(competences_list)
        setfield!(joueur.competences, comp_field, getfield(joueur.competences, comp_field) + rand(1:3))
        
        println("🎉 NIVEAU UP! Niveau $(joueur.niveau) atteint!")
        println("💪 $comp_nom amélioré!")
        
        push!(joueur.achievements, "Niveau $(joueur.niveau) atteint")
    end
    
    # Changer de position
    lieux_burkina = [
        ("Centre", "Koudougou", "Marché central"),
        ("Hauts-Bassins", "Bobo-Dioulasso", "Grande Mosquée"),
        ("Sud-Ouest", "Banfora", "Cascades de Karfiguéla"),
        ("Sahel", "Dori", "Marché aux animaux"),
        ("Nord", "Ouahigouya", "Palais du Naaba"),
        ("Est", "Fada N'Gourma", "Réserve de Pama")
    ]
    
    nouvelle_region, nouvelle_ville, nouveau_lieu = rand(lieux_burkina)
    joueur.position = Position(nouvelle_region, nouvelle_ville, nouveau_lieu, rand(-10:10), rand(-10:10))
    println("🏃 Voyage vers $(nouveau_lieu), $(nouvelle_ville)")
    
    # Ajouter une quête
    quetes_possibles = [
        "Aide aux commerçants de $(nouvelle_ville)",
        "Protection du village contre les bandits",
        "Livraison de message important",
        "Recherche d'objet traditionnel perdu",
        "Escorte de caravane commerciale"
    ]
    
    nouvelle_quete = rand(quetes_possibles)
    if !(nouvelle_quete in joueur.quetes_terminees)
        push!(joueur.quetes_terminees, nouvelle_quete)
        println("✅ Quête terminée: $nouvelle_quete")
        
        # Récompense
        recompense = rand(1000:5000)
        joueur.argent += recompense
        println("💰 +$(recompense) FCFA de récompense!")
    end
    
    # Chance de trouver un objet
    if rand() < 0.3  # 30% de chance
        nouvel_objet = rand(objets_disponibles)
        push!(joueur.inventaire, nouvel_objet)
        println("🎁 Objet trouvé: $(nouvel_objet.nom)!")
    end
    
    # Temps de jeu
    joueur.temps_jeu += rand(0.5:0.1:2.0)
    
    # Mettre à jour la dernière activité
    joueur.derniere_sauvegarde = string(Dates.now())
end

# Lancer quelques aventures
for i in 1:3
    println("\n--- Aventure $i ---")
    simuler_aventure!(hero)
    sleep(0.5)  # Petite pause pour l'effet
end

afficher_statut_joueur(hero)
```

---

## 💾 Étape 2 : Système de sauvegarde JSON

Créons un système robuste pour sauvegarder notre jeu :

```julia
# Fonction pour convertir un joueur en dictionnaire JSON
function joueur_vers_dict(joueur::JoueurAventure)
    return Dict(
        "nom" => joueur.nom,
        "niveau" => joueur.niveau,
        "experience" => joueur.experience,
        "points_vie" => joueur.points_vie,
        "points_vie_max" => joueur.points_vie_max,
        "energie" => joueur.energie,
        "energie_max" => joueur.energie_max,
        "competences" => Dict(
            "force" => joueur.competences.force,
            "agilite" => joueur.competences.agilite,
            "intelligence" => joueur.competences.intelligence,
            "charisme" => joueur.competences.charisme
        ),
        "inventaire" => [
            Dict(
                "nom" => obj.nom,
                "description" => obj.description,
                "valeur" => obj.valeur,
                "type" => obj.type
            ) for obj in joueur.inventaire
        ],
        "argent" => joueur.argent,
        "position" => Dict(
            "region" => joueur.position.region,
            "ville" => joueur.position.ville,
            "lieu" => joueur.position.lieu,
            "x" => joueur.position.x,
            "y" => joueur.position.y
        ),
        "quetes_terminees" => joueur.quetes_terminees,
        "achievements" => joueur.achievements,
        "temps_jeu" => joueur.temps_jeu,
        "derniere_sauvegarde" => joueur.derniere_sauvegarde,
        "version_sauvegarde" => "1.0",
        "date_creation" => string(Dates.now())
    )
end

# Fonction pour restaurer un joueur depuis un dictionnaire
function dict_vers_joueur(data::Dict)
    # Vérifier la version de sauvegarde
    if !haskey(data, "version_sauvegarde")
        @warn "Sauvegarde ancienne détectée - tentative de récupération"
    end
    
    # Créer les compétences
    comp_data = data["competences"]
    competences = Competences()
    competences.force = comp_data["force"]
    competences.agilite = comp_data["agilite"]
    competences.intelligence = comp_data["intelligence"]
    competences.charisme = comp_data["charisme"]
    
    # Créer l'inventaire
    inventaire = ObjetJeu[]
    for obj_data in data["inventaire"]
        objet = ObjetJeu(
            obj_data["nom"],
            obj_data["description"],
            obj_data["valeur"],
            obj_data["type"]
        )
        push!(inventaire, objet)
    end
    
    # Créer la position
    pos_data = data["position"]
    position = Position(
        pos_data["region"],
        pos_data["ville"],
        pos_data["lieu"],
        pos_data["x"],
        pos_data["y"]
    )
    
    # Créer le joueur
    joueur = JoueurAventure(data["nom"])
    joueur.niveau = data["niveau"]
    joueur.experience = data["experience"]
    joueur.points_vie = data["points_vie"]
    joueur.points_vie_max = data["points_vie_max"]
    joueur.energie = data["energie"]
    joueur.energie_max = data["energie_max"]
    joueur.competences = competences
    joueur.inventaire = inventaire
    joueur.argent = data["argent"]
    joueur.position = position
    joueur.quetes_terminees = data["quetes_terminees"]
    joueur.achievements = data["achievements"]
    joueur.temps_jeu = data["temps_jeu"]
    joueur.derniere_sauvegarde = data["derniere_sauvegarde"]
    
    return joueur
end

# Fonction principale de sauvegarde
function sauvegarder_jeu(joueur::JoueurAventure, slot::Int = 1)
    # Créer le dossier de sauvegardes s'il n'existe pas
    if !isdir("sauvegardes")
        mkdir("sauvegardes")
        println("📁 Dossier 'sauvegardes' créé")
    end
    
    nom_fichier = "sauvegardes/slot_$(slot)_$(replace(joueur.nom, " " => "_")).json"
    
    try
        # Mettre à jour la date de sauvegarde
        joueur.derniere_sauvegarde = string(Dates.now())
        
        # Convertir en dictionnaire et sauvegarder
        data = joueur_vers_dict(joueur)
        
        open(nom_fichier, "w") do fichier
            JSON.print(fichier, data, 2)  # Indentation de 2 pour lisibilité
        end
        
        println("💾 Jeu sauvegardé dans le slot $slot!")
        println("📄 Fichier: $nom_fichier")
        return true
        
    catch e
        println("❌ Erreur lors de la sauvegarde: $e")
        return false
    end
end

# Fonction de chargement
function charger_jeu(slot::Int)
    nom_fichier = "sauvegardes/slot_$(slot)_*.json"
    
    # Chercher les fichiers correspondants
    fichiers_slot = filter(f -> occursin("slot_$(slot)_", f), readdir("sauvegardes"))
    
    if isempty(fichiers_slot)
        println("❌ Aucune sauvegarde trouvée pour le slot $slot")
        return nothing
    end
    
    fichier_complet = joinpath("sauvegardes", fichiers_slot[1])
    
    try
        data = JSON.parsefile(fichier_complet)
        joueur = dict_vers_joueur(data)
        
        println("📂 Jeu chargé depuis le slot $slot!")
        println("👤 Personnage: $(joueur.nom)")
        println("📅 Dernière sauvegarde: $(joueur.derniere_sauvegarde)")
        
        return joueur
        
    catch e
        println("❌ Erreur lors du chargement: $e")
        println("💡 Le fichier de sauvegarde est peut-être corrompu")
        return nothing
    end
end

# Test du système de sauvegarde
println("\n💾 === TEST DE SAUVEGARDE ===")
succes = sauvegarder_jeu(hero, 1)

if succes
    println("✅ Sauvegarde réussie!")
    
    # Test du chargement
    println("\n📂 === TEST DE CHARGEMENT ===")
    joueur_charge = charger_jeu(1)
    
    if joueur_charge !== nothing
        println("✅ Chargement réussi!")
        afficher_statut_joueur(joueur_charge)
    end
end
```

### 🎯 Défi 2 : Gestion multiple de slots
Créez un système pour gérer plusieurs sauvegardes :

```julia
println("\n🎯 DÉFI 2 : Gestion de multiples slots")

function lister_sauvegardes()
    if !isdir("sauvegardes")
        println("📁 Aucun dossier de sauvegardes trouvé")
        return
    end
    
    fichiers = readdir("sauvegardes")
    sauvegardes = filter(f -> endswith(f, ".json"), fichiers)
    
    if isempty(sauvegardes)
        println("📂 Aucune sauvegarde trouvée")
        return
    end
    
    println("💾 === SAUVEGARDES DISPONIBLES ===")
    
    for fichier in sauvegardes
        try
            chemin_complet = joinpath("sauvegardes", fichier)
            data = JSON.parsefile(chemin_complet)
            
            # Extraire le numéro de slot du nom de fichier
            slot_match = match(r"slot_(\d+)_", fichier)
            slot = slot_match !== nothing ? slot_match.captures[1] : "?"
            
            # Informations de la sauvegarde
            nom = get(data, "nom", "Inconnu")
            niveau = get(data, "niveau", 0)
            temps_jeu = get(data, "temps_jeu", 0.0)
            derniere_save = get(data, "derniere_sauvegarde", "Inconnue")
            
            # Extraire juste la date (sans l'heure précise)
            try
                date_obj = DateTime(derniere_save[1:19])
                date_formatee = Dates.format(date_obj, "dd/mm/yyyy HH:MM")
            catch
                date_formatee = "Format invalide"
            end
            
            println("🎮 Slot $slot: $nom (Niveau $niveau)")
            println("   ⏱️  Temps de jeu: $(round(temps_jeu, digits=1))h")
            println("   📅 Dernière sauvegarde: $date_formatee")
            println()
            
        catch e
            println("⚠️  Fichier corrompu: $fichier")
        end
    end
end

function menu_sauvegarde(joueur::JoueurAventure)
    while true
        println("\n💾 === MENU DE SAUVEGARDE ===")
        println("1. 💾 Sauvegarder dans un slot")
        println("2. 📂 Charger depuis un slot")
        println("3. 📋 Lister toutes les sauvegardes")
        println("4. 🗑️  Supprimer une sauvegarde")
        println("5. 🔄 Retour au jeu")
        
        print("Votre choix (1-5): ")
        choix = readline()
        
        if choix == "1"
            print("Numéro de slot (1-10): ")
            try
                slot = parse(Int, readline())
                if 1 <= slot <= 10
                    if sauvegarder_jeu(joueur, slot)
                        println("✅ Sauvegarde réussie dans le slot $slot!")
                    end
                else
                    println("❌ Slot invalide! Utilisez 1-10")
                end
            catch
                println("❌ Numéro invalide!")
            end
            
        elseif choix == "2"
            lister_sauvegardes()
            print("Slot à charger: ")
            try
                slot = parse(Int, readline())
                joueur_charge = charger_jeu(slot)
                if joueur_charge !== nothing
                    println("🎮 Voulez-vous remplacer votre partie actuelle? (o/n)")
                    if lowercase(readline()) == "o"
                        # Dans un vrai jeu, on remplacerait les données
                        println("🔄 Partie chargée! (Simulation)")
                        afficher_statut_joueur(joueur_charge)
                    end
                end
            catch
                println("❌ Numéro invalide!")
            end
            
        elseif choix == "3"
            lister_sauvegardes()
            
        elseif choix == "4"
            lister_sauvegardes()
            print("Slot à supprimer: ")
            try
                slot = parse(Int, readline())
                # Chercher le fichier correspondant
                fichiers = readdir("sauvegardes")
                fichier_a_supprimer = ""
                
                for fichier in fichiers
                    if occursin("slot_$(slot)_", fichier)
                        fichier_a_supprimer = fichier
                        break
                    end
                end
                
                if !isempty(fichier_a_supprimer)
                    print("Confirmer la suppression du slot $slot? (o/n): ")
                    if lowercase(readline()) == "o"
                        rm(joinpath("sauvegardes", fichier_a_supprimer))
                        println("🗑️  Sauvegarde supprimée!")
                    end
                else
                    println("❌ Slot non trouvé!")
                end
            catch
                println("❌ Erreur lors de la suppression!")
            end
            
        elseif choix == "5"
            break
            
        else
            println("❌ Choix invalide!")
        end
    end
end

# Créer quelques sauvegardes de test
println("🎮 Création de sauvegardes de test...")

# Modifier le héros pour la diversité
hero_variations = [
    (hero, 1),
]

# Créer des variations du héros pour différents slots
for i in 2:3
    hero_copy = JoueurAventure("$(hero.nom) - Version $i")
    hero_copy.niveau = i + 1
    hero_copy.experience = i * 1200
    hero_copy.temps_jeu = i * 2.5
    
    # Ajouter quelques objets aléatoires
    for _ in 1:rand(1:4)
        push!(hero_copy.inventaire, rand(objets_disponibles))
    end
    
    sauvegarder_jeu(hero_copy, i)
    push!(hero_variations, (hero_copy, i))
end

# Afficher les sauvegardes créées
lister_sauvegardes()

# Lancer le menu
menu_sauvegarde(hero)
```

---

## 🔧 Étape 3 : Système de backup automatique

Ajoutons un système de sauvegarde automatique et de récupération d'urgence :

```julia
function creer_backup_automatique(joueur::JoueurAventure)
    # Créer un dossier de backup
    if !isdir("backups")
        mkdir("backups")
    end
    
    # Nom du fichier avec timestamp
    timestamp = Dates.format(Dates.now(), "yyyy-mm-dd_HH-MM-SS")
    nom_backup = "backups/auto_backup_$(timestamp).json"
    
    try
        data = joueur_vers_dict(joueur)
        data["type_sauvegarde"] = "backup_automatique"
        data["timestamp"] = timestamp
        
        open(nom_backup, "w") do fichier
            JSON.print(fichier, data, 2)
        end
        
        println("🔄 Backup automatique créé: $nom_backup")
        
        # Nettoyer les anciens backups (garder seulement les 5 derniers)
        nettoyer_anciens_backups()
        
        return true
    catch e
        println("⚠️  Erreur lors du backup automatique: $e")
        return false
    end
end

function nettoyer_anciens_backups()
    if !isdir("backups")
        return
    end
    
    fichiers_backup = filter(f -> startswith(f, "auto_backup_") && endswith(f, ".json"), readdir("backups"))
    
    if length(fichiers_backup) > 5
        # Trier par date de modification (plus récent en premier)
        fichiers_avec_dates = []
        for fichier in fichiers_backup
            chemin = joinpath("backups", fichier)
            date_modif = stat(chemin).mtime
            push!(fichiers_avec_dates, (fichier, date_modif))
        end
        
        sort!(fichiers_avec_dates, by=x->x[2], rev=true)
        
        # Supprimer les anciens (garder seulement les 5 premiers)
        for (fichier, _) in fichiers_avec_dates[6:end]
            rm(joinpath("backups", fichier))
            println("🗑️  Ancien backup supprimé: $fichier")
        end
    end
end

function lister_backups()
    if !isdir("backups")
        println("📁 Aucun dossier de backups trouvé")
        return
    end
    
    fichiers = filter(f -> endswith(f, ".json"), readdir("backups"))
    
    if isempty(fichiers)
        println("📂 Aucun backup trouvé")
        return
    end
    
    println("🔄 === BACKUPS AUTOMATIQUES ===")
    
    for fichier in sort(fichiers, rev=true)  # Plus récent en premier
        try
            chemin_complet = joinpath("backups", fichier)
            data = JSON.parsefile(chemin_complet)
            
            nom = get(data, "nom", "Inconnu")
            niveau = get(data, "niveau", 0)
            timestamp = get(data, "timestamp", "Inconnu")
            
            # Formatter le timestamp
            try
                date_obj = DateTime(timestamp, "yyyy-mm-dd_HH-MM-SS")
                date_formatee = Dates.format(date_obj, "dd/mm/yyyy à HH:MM:SS")
            catch
                date_formatee = timestamp
            end
            
            println("💾 $nom (Niveau $niveau)")
            println("   📅 Backup du: $date_formatee")
            println("   📄 Fichier: $fichier")
            println()
            
        catch e
            println("⚠️  Backup corrompu: $fichier")
        end
    end
end

function restaurer_depuis_backup()
    lister_backups()
    
    if !isdir("backups")
        return nothing
    end
    
    fichiers = filter(f -> endswith(f, ".json"), readdir("backups"))
    if isempty(fichiers)
        return nothing
    end
    
    print("Nom du fichier de backup à restaurer (sans extension): ")
    nom_fichier = readline()
    
    fichier_complet = nom_fichier * ".json"
    if fichier_complet in fichiers
        try
            chemin = joinpath("backups", fichier_complet)
            data = JSON.parsefile(chemin)
            joueur_restaure = dict_vers_joueur(data)
            
            println("✅ Backup restauré avec succès!")
            println("👤 Personnage: $(joueur_restaure.nom)")
            
            return joueur_restaure
        catch e
            println("❌ Erreur lors de la restauration: $e")
            return nothing
        end
    else
        println("❌ Fichier de backup non trouvé!")
        return nothing
    end
end

# Test du système de backup
println("\n🔄 === TEST DU SYSTÈME DE BACKUP ===")

# Simuler quelques aventures pour créer des changements
for i in 1:2
    simuler_aventure!(hero)
    creer_backup_automatique(hero)
    sleep(1)  # Attendre 1 seconde pour différencier les timestamps
end

# Lister les backups créés
lister_backups()

# Test de restauration
println("\n📋 Test de restauration d'un backup:")
# restaurer_depuis_backup()  # Décommenté pour test interactif
```

---

## 🛡️ Étape 4 : Vérification d'intégrité et récupération

Ajoutons des fonctions de vérification pour s'assurer que nos fichiers sont corrects :

```julia
function verifier_integrite_sauvegarde(nom_fichier::String)
    println("🔍 Vérification de l'intégrité: $nom_fichier")
    
    if !isfile(nom_fichier)
        println("❌ Fichier non trouvé!")
        return false
    end
    
    try
        data = JSON.parsefile(nom_fichier)
        
        # Vérifications essentielles
        champs_requis = ["nom", "niveau", "experience", "competences", "position", "inventaire"]
        champs_manquants = []
        
        for champ in champs_requis
            if !haskey(data, champ)
                push!(champs_manquants, champ)
            end
        end
        
        if !isempty(champs_manquants)
            println("❌ Champs manquants: $(join(champs_manquants, ", "))")
            return false
        end
        
        # Vérifications de cohérence
        if data["niveau"] < 1 || data["niveau"] > 100
            println("⚠️  Niveau suspect: $(data["niveau"])")
        end
        
        if data["experience"] < 0
            println("⚠️  Expérience négative: $(data["experience"])")
        end
        
        if !isa(data["inventaire"], Vector)
            println("❌ Format d'inventaire invalide")
            return false
        end
        
        # Vérifier la structure des compétences
        comp = data["competences"]
        if !isa(comp, Dict) || !haskey(comp, "force") || !haskey(comp, "agilite")
            println("❌ Structure de compétences invalide")
            return false
        end
        
        println("✅ Intégrité vérifiée - Fichier valide!")
        return true
        
    catch e
        println("❌ Erreur lors de la vérification: $e")
        return false
    end
end

function reparer_sauvegarde_corrompue(nom_fichier::String)
    println("🔧 Tentative de réparation: $nom_fichier")
    
    if !isfile(nom_fichier)
        println("❌ Fichier non trouvé!")
        return false
    end
    
    try
        # Tenter de lire le fichier brut
        contenu_brut = read(nom_fichier, String)
        
        # Vérifier si c'est un JSON tronqué
        if !endswith(strip(contenu_brut), "}")
            println("🔧 Fichier tronqué détecté - tentative de réparation...")
            
            # Ajouter une fermeture d'accolade si nécessaire
            contenu_repare = strip(contenu_brut) * "\n}"
            
            # Créer un fichier de sauvegarde
            nom_backup_reparation = nom_fichier * ".backup"
            write(nom_backup_reparation, contenu_brut)
            
            # Écrire le fichier réparé
            write(nom_fichier, contenu_repare)
            
            println("🔧 Réparation tentée - backup créé: $nom_backup_reparation")
            
            # Vérifier si la réparation a fonctionné
            return verifier_integrite_sauvegarde(nom_fichier)
        end
        
        println("❌ Type de corruption non pris en charge")
        return false
        
    catch e
        println("❌ Impossible de réparer: $e")
        return false
    end
end

function diagnostiquer_dossier_sauvegardes()
    println("\n🏥 === DIAGNOSTIC DU SYSTÈME DE SAUVEGARDE ===")
    
    # Vérifier les dossiers
    dossiers = ["sauvegardes", "backups"]
    for dossier in dossiers
        if isdir(dossier)
            println("✅ Dossier '$dossier' présent")
            
            fichiers = filter(f -> endswith(f, ".json"), readdir(dossier))
            println("   📄 $(length(fichiers)) fichier(s) JSON trouvé(s)")
            
            # Vérifier chaque fichier
            fichiers_valides = 0
            fichiers_corrompus = 0
            
            for fichier in fichiers
                chemin_complet = joinpath(dossier, fichier)
                if verifier_integrite_sauvegarde(chemin_complet)
                    fichiers_valides += 1
                else
                    fichiers_corrompus += 1
                    println("⚠️  Fichier problématique: $fichier")
                end
            end
            
            println("   ✅ Fichiers valides: $fichiers_valides")
            println("   ❌ Fichiers corrompus: $fichiers_corrompus")
            
        else
            println("❌ Dossier '$dossier' manquant")
            println("💡 Créez-le en sauvegardant votre jeu")
        end
        println()
    end
    
    # Recommandations
    println("💡 === RECOMMANDATIONS ===")
    println("• Sauvegardez régulièrement dans différents slots")
    println("• Les backups automatiques se créent toutes les heures")
    println("• Vérifiez l'intégrité avant les longs voyages")
    println("• Gardez toujours une sauvegarde de secours")
end

# Test du système de diagnostic
diagnostiquer_dossier_sauvegardes()

# Vérifier nos sauvegardes existantes
if isdir("sauvegardes")
    fichiers = filter(f -> endswith(f, ".json"), readdir("sauvegardes"))
    for fichier in fichiers[1:min(2, length(fichiers))]  # Tester seulement les 2 premiers
        verifier_integrite_sauvegarde(joinpath("sauvegardes", fichier))
    end
end
```

---

## 🏅 Récapitulatif des points

Calculons votre score pour cette pratique :

```julia
println("\n🏅 === RÉCAPITULATIF ===")
score_total = 0

# Points pour création du personnage
if @isdefined(hero) && !isempty(hero.nom)
    score_total += 15
    println("✅ Personnage créé: +15 points")
end

# Points pour évolution du personnage  
if hero.niveau > 1 || hero.experience > 0
    score_total += 20
    println("✅ Personnage développé: +20 points")
end

# Points pour système de sauvegarde
if isdir("sauvegardes")
    score_total += 25
    println("✅ Système de sauvegarde créé: +25 points")
end

# Points pour gestion de multiples slots
fichiers_saves = isdir("sauvegardes") ? length(filter(f -> endswith(f, ".json"), readdir("sauvegardes"))) : 0
if fichiers_saves >= 2
    score_total += 20
    println("✅ Multiples sauvegardes ($(fichiers_saves) fichiers): +20 points")
end

# Points pour système de backup
if isdir("backups")
    score_total += 20
    println("✅ Système de backup automatique: +20 points")
end

# Points pour vérification d'intégrité
score_total += 20
println("✅ Système de vérification d'intégrité: +20 points")

println("\n🎯 SCORE TOTAL: $(score_total)/120 points")

if score_total >= 100
    println("🥇 Excellent! Maître des sauvegardes JSON!")
elseif score_total >= 80
    println("🥈 Très bien! Bon système de persistance!")
elseif score_total >= 60
    println("🥉 Bien! Système fonctionnel!")
else
    println("📚 Révisez et améliorez le système!")
end
```

---

## 🎓 Ce que vous avez appris

1. ✅ **Sérialisation JSON** de structures complexes
2. ✅ **Désérialisation** et reconstruction d'objets
3. ✅ **Gestion de multiples slots** de sauvegarde
4. ✅ **Système de backup automatique** avec rotation
5. ✅ **Vérification d'intégrité** des fichiers
6. ✅ **Récupération d'erreur** et réparation de fichiers corrompus
7. ✅ **Interface utilisateur** pour la gestion des sauvegardes

## 🚀 Prochaine étape

Dans l'exercice suivant, nous créerons un gestionnaire de contacts complet avec persistance !

🎮 **Félicitations, vous maîtrisez maintenant la persistance de données comme un(e) vrai(e) développeur/développeuse de jeux burkinabè !**