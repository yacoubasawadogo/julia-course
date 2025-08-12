# 🎯 Pratique Guidée 2: Jeu de Combat Traditionnel Burkinabè
**Module 1 - Session 5** | **Durée: 25 minutes**

---

## 📋 Objectifs de cette Pratique

- Créer un système de personnages avec structures
- Implémenter des mécaniques de combat tour par tour
- Développer une interface de jeu attractive
- Intégrer des éléments culturels burkinabè

---

## 👤 Exercice 1: Création des Personnages

### Structure de base d'un combattant:
```julia
# Structure mutable pour permettre les modifications
mutable struct Combattant
    nom::String
    classe::String
    vie_max::Int
    vie_actuelle::Int
    attaque::Int
    defense::Int
    niveau::Int
    experience::Int
end

# Constructeur simplifié
function creer_combattant(nom, classe)
    if classe == "guerrier"
        return Combattant(nom, classe, 120, 120, 25, 15, 1, 0)
    elseif classe == "chasseur"
        return Combattant(nom, classe, 100, 100, 30, 10, 1, 0)
    elseif classe == "sage"
        return Combattant(nom, classe, 110, 110, 20, 20, 1, 0)
    else
        # Classe par défaut
        return Combattant(nom, "guerrier", 100, 100, 20, 15, 1, 0)
    end
end

# Tests de création
println("=== CRÉATION DE PERSONNAGES ===")
karfo = creer_combattant("Karfo", "guerrier")
aminata = creer_combattant("Aminata", "chasseur")
boubou = creer_combattant("Boubou", "sage")

println("Karfo le guerrier: $(karfo.vie_max) PV, $(karfo.attaque) ATT, $(karfo.defense) DEF")
println("Aminata la chasseuse: $(aminata.vie_max) PV, $(aminata.attaque) ATT, $(aminata.defense) DEF")  
println("Boubou le sage: $(boubou.vie_max) PV, $(boubou.attaque) ATT, $(boubou.defense) DEF")
```

### Personnages inspirés de la culture burkinabè:
```julia
# Base de données des personnages traditionnels
personnages_traditionnels = [
    ("Karfo", "guerrier", "Brave guerrier mossi de Ouagadougou", "⚔️"),
    ("Aminata", "chasseuse", "Experte à l'arc des Hauts-Bassins", "🏹"),
    ("Boubou", "sage", "Vieux sage dioula de Bobo-Dioulasso", "📿"),
    ("Raogo", "guerrier", "Défenseur du royaume de Tenkodogo", "🛡️"),
    ("Fatou", "guérisseuse", "Tradipraticienne de Banfora", "🌿"),
    ("Moussa", "griot", "Conteur et musicien du Sahel", "🎵")
]

function afficher_personnages_disponibles()
    println("\n🎭 PERSONNAGES TRADITIONNELS DISPONIBLES:")
    println("="^50)
    
    for (i, (nom, classe, description, icone)) in enumerate(personnages_traditionnels)
        println("$i. $icone $nom - $classe")
        println("   $description")
        println()
    end
end

function choisir_personnage()
    afficher_personnages_disponibles()
    
    while true
        choix = readline("Choisissez votre personnage (1-$(length(personnages_traditionnels))): ")
        try
            index = parse(Int, choix)
            if 1 <= index <= length(personnages_traditionnels)
                nom, classe, description, icone = personnages_traditionnels[index]
                println("✅ Vous avez choisi $icone $nom, $classe!")
                println("$description")
                return creer_combattant(nom, classe)
            end
        catch
        end
        println("❌ Choix invalide, essayez encore.")
    end
end

# Test de sélection (décommenté pour tester)
# joueur = choisir_personnage()
```

---

## ⚔️ Exercice 2: Système de Combat

### Fonctions de combat de base:
```julia
function calculer_degats(attaquant, defenseur)
    """Calcule les dégâts d'une attaque"""
    # Formule: Attaque de l'attaquant - Défense du défenseur + aléatoire
    degats_base = attaquant.attaque - defenseur.defense
    variation = rand(-3:3)  # Variation aléatoire
    degats_finaux = max(1, degats_base + variation)  # Minimum 1 dégât
    
    return degats_finaux
end

function appliquer_degats(combattant, degats)
    """Applique des dégâts à un combattant"""
    combattant.vie_actuelle = max(0, combattant.vie_actuelle - degats)
    return combattant.vie_actuelle <= 0  # Retourne true si KO
end

function est_vivant(combattant)
    """Vérifie si un combattant est encore en vie"""
    return combattant.vie_actuelle > 0
end

# Tests de combat
println("\n=== TESTS DE COMBAT ===")
karfo = creer_combattant("Karfo", "guerrier")
bandit = creer_combattant("Bandit", "chasseur")

println("Avant combat:")
println("$(karfo.nom): $(karfo.vie_actuelle) PV")
println("$(bandit.nom): $(bandit.vie_actuelle) PV")

# Simulation d'attaque
degats = calculer_degats(karfo, bandit)
ko = appliquer_degats(bandit, degats)

println("\n$(karfo.nom) attaque $(bandit.nom) pour $degats dégâts!")
println("$(bandit.nom): $(bandit.vie_actuelle) PV restants")
if ko
    println("💀 $(bandit.nom) est KO!")
end
```

### Techniques de combat traditionnelles:
```julia
# Base de données des techniques
techniques_traditionnelles = [
    ("Coup de Wango", 1.2, 5, "Technique de lutte traditionnelle mossi", "👊"),
    ("Tir Précis", 1.5, 10, "Maîtrise de l'arc comme les Lobi", "🎯"),
    ("Esquive Dansa", 0.0, 0, "Danse d'évitement traditionnelle", "💃"),
    ("Cri de Guerre", 1.0, 15, "Intimidation ancestrale des guerriers", "📢"),
    ("Coup de Bâton", 1.1, 8, "Art martial avec bâton de berger", "🦯"),
    ("Méditation", 0.0, 0, "Récupération spirituelle", "🧘")
]

function afficher_techniques()
    println("\n⚔️ TECHNIQUES DE COMBAT DISPONIBLES:")
    for (i, (nom, multiplicateur, cout, description, icone)) in enumerate(techniques_traditionnelles)
        if multiplicateur > 0
            effet = "Dégâts ×$(multiplicateur)"
        else
            effet = "Effet spécial"
        end
        println("$i. $icone $nom - $effet (Coût: $cout XP)")
        println("   $description")
    end
end

function utiliser_technique(attaquant, defenseur, index_technique)
    """Utilise une technique spéciale"""
    if index_technique < 1 || index_technique > length(techniques_traditionnelles)
        println("❌ Technique invalide!")
        return false
    end
    
    nom, multiplicateur, cout, description, icone = techniques_traditionnelles[index_technique]
    
    if attaquant.experience < cout
        println("❌ XP insuffisante pour $nom! (Besoin: $cout, Disponible: $(attaquant.experience))")
        return false
    end
    
    # Consommer l'XP
    attaquant.experience -= cout
    
    println("✨ $(attaquant.nom) utilise $icone $nom!")
    println("   $description")
    
    if multiplicateur > 0
        # Technique d'attaque
        degats_base = calculer_degats(attaquant, defenseur)
        degats_finaux = round(Int, degats_base * multiplicateur)
        ko = appliquer_degats(defenseur, degats_finaux)
        
        println("💥 $(defenseur.nom) subit $degats_finaux dégâts!")
        return ko
    else
        # Technique spéciale
        if nom == "Esquive Dansa"
            println("🌪️ $(attaquant.nom) esquive gracieusement le prochain coup!")
            # Logique d'esquive à implémenter
        elseif nom == "Méditation"
            guerison = rand(15:25)
            attaquant.vie_actuelle = min(attaquant.vie_max, attaquant.vie_actuelle + guerison)
            println("💚 $(attaquant.nom) récupère $guerison PV grâce à la méditation!")
        end
        return false
    end
end

# Test des techniques
println("\n=== TEST DES TECHNIQUES ===")
karfo.experience = 20  # Donnons de l'XP pour tester

afficher_techniques()
```

---

## 🎮 Exercice 3: Interface de Jeu

### Affichage du statut des combattants:
```julia
function afficher_barre_vie(combattant)
    """Affiche une barre de vie graphique"""
    pourcentage = combattant.vie_actuelle / combattant.vie_max
    longueur_barre = 20
    rempli = round(Int, pourcentage * longueur_barre)
    vide = longueur_barre - rempli
    
    # Couleurs selon le niveau de vie
    if pourcentage > 0.6
        couleur = "💚"
        barre_rempli = "█"
    elseif pourcentage > 0.3
        couleur = "💛" 
        barre_rempli = "▓"
    else
        couleur = "❤️"
        barre_rempli = "▒"
    end
    
    barre = barre_rempli^rempli * "░"^vide
    
    println("$(combattant.nom) ($couleur)")
    println("[$barre] $(combattant.vie_actuelle)/$(combattant.vie_max) PV")
end

function afficher_statut_combat(joueur, ennemi)
    """Affiche l'état du combat"""
    println("\n" * "="^50)
    println("⚔️  COMBAT EN COURS")
    println("="^50)
    
    # Statut joueur
    afficher_barre_vie(joueur)
    println("ATT: $(joueur.attaque) | DEF: $(joueur.defense) | XP: $(joueur.experience)")
    
    println()
    println("🆚")
    println()
    
    # Statut ennemi
    afficher_barre_vie(ennemi)
    println("ATT: $(ennemi.attaque) | DEF: $(ennemi.defense)")
    
    println("="^50)
end

# Test d'affichage
println("\n=== TEST INTERFACE ===")
karfo = creer_combattant("Karfo", "guerrier")
bandit = creer_combattant("Bandit de Brousse", "chasseur")
bandit.vie_actuelle = 75  # Simuler des dégâts

afficher_statut_combat(karfo, bandit)
```

### Animations simples:
```julia
function animation_attaque(nom_attaquant)
    """Animation simple pour une attaque"""
    animations = ["💥", "⚡", "🔥", "💢"]
    
    for (i, anim) in enumerate(animations)
        print("\r$anim $nom_attaquant attaque... ")
        sleep(0.4)
    end
    println("\r✅ Attaque réussie!           ")
    sleep(0.5)
end

function animation_victoire()
    """Animation de victoire"""
    print("🎉 VICTOIRE! ")
    for i in 1:3
        print("🌟")
        sleep(0.3)
    end
    println("\n🏆 Combat terminé!")
end

function animation_defaite()
    """Animation de défaite"""
    println("💀 Vous avez été vaincu...")
    sleep(1)
    println("⚰️ Game Over")
end

# Tests d'animations (décommenter pour voir)
# animation_attaque("Karfo")
# animation_victoire()
```

---

## 🌍 Exercice 4: Éléments Culturels

### Lieux de combat burkinabè:
```julia
lieux_combat = [
    ("Village de Samestenga", "Un paisible village mossi transformé en champ de bataille", "🏘️"),
    ("Marché de Ouagadougou", "Le marché central dans l'effervescence du combat", "🏪"),
    ("Forêt de Banfora", "Sous les cascades mystiques de Banfora", "🌿"),
    ("Savane de Dori", "Dans les vastes étendues du Sahel burkinabè", "🌾"),
    ("Collines de Nahouri", "Sur les hauteurs du Sud-Ouest", "⛰️"),
    ("Bords du Mouhoun", "Près du fleuve sacré", "🌊")
]

function choisir_lieu_combat()
    """Permet de choisir le lieu du combat"""
    println("\n🌍 CHOISISSEZ LE LIEU DU COMBAT:")
    println("="^45)
    
    for (i, (lieu, description, icone)) in enumerate(lieux_combat)
        println("$i. $icone $lieu")
        println("   $description")
        println()
    end
    
    while true
        choix = readline("Votre choix (1-$(length(lieux_combat))): ")
        try
            index = parse(Int, choix)
            if 1 <= index <= length(lieux_combat)
                lieu, description, icone = lieux_combat[index]
                println("✅ Combat dans: $icone $lieu")
                println("$description")
                return lieu, icone
            end
        catch
        end
        println("❌ Choix invalide.")
    end
end
```

### Messages contextuels:
```julia
# Messages d'entrée en combat
messages_debut_combat = [
    "Les djembés résonnent, le combat commence!",
    "Sous l'œil des ancêtres, prouvez votre valeur!",
    "Que la force des masques traditionnels vous guide!",
    "Le griot commence son chant de guerre...",
    "Les esprits de la brousse observent ce duel!"
]

# Messages de victoire
messages_victoire = [
    "Les tambours célèbrent votre triomphe!",
    "Vous êtes digne des héros d'antan!",
    "Le village chantera vos louanges!",
    "Votre bravoure honore le Burkina Faso!",
    "Les ancêtres sont fiers de vous!"
]

# Messages de défaite
messages_defaite = [
    "Même les plus grands guerriers connaissent la défaite...",
    "Vous reviendrez plus fort, comme le baobab après l'harmattan!",
    "Cette leçon vous rendra plus sage.",
    "Le courage ne se mesure pas qu'aux victoires.",
    "Préparez-vous pour le prochain combat!"
]

function message_aleatoire(messages)
    """Retourne un message aléatoire d'une liste"""
    return rand(messages)
end

# Tests
println("\n=== MESSAGES CONTEXTUELS ===")
println("Début: $(message_aleatoire(messages_debut_combat))")
println("Victoire: $(message_aleatoire(messages_victoire))")
println("Défaite: $(message_aleatoire(messages_defaite))")
```

---

## 🎯 Exercice 5: Boucle de Combat Principale

### Combat tour par tour complet:
```julia
function tour_de_combat(joueur, ennemi)
    """Gère un tour de combat complet"""
    println("\n🎯 À VOTRE TOUR!")
    println("1. ⚔️ Attaque normale")
    println("2. 🌟 Technique spéciale")
    println("3. 🛡️ Se défendre")
    
    while true
        choix = readline("Votre action (1-3): ")
        
        if choix == "1"
            # Attaque normale
            animation_attaque(joueur.nom)
            degats = calculer_degats(joueur, ennemi)
            ko = appliquer_degats(ennemi, degats)
            
            println("⚔️ $(joueur.nom) attaque $(ennemi.nom) pour $degats dégâts!")
            
            if ko
                println("💀 $(ennemi.nom) est vaincu!")
                return "victoire"
            end
            break
            
        elseif choix == "2"
            # Technique spéciale
            afficher_techniques()
            tech_choix = readline("Technique à utiliser (1-$(length(techniques_traditionnelles))): ")
            
            try
                index = parse(Int, tech_choix)
                ko = utiliser_technique(joueur, ennemi, index)
                
                if ko
                    println("💀 $(ennemi.nom) est vaincu par votre technique!")
                    return "victoire"
                end
                break
            catch
                println("❌ Technique invalide, attaque normale à la place!")
                continue
            end
            
        elseif choix == "3"
            # Défense
            println("🛡️ $(joueur.nom) se met en garde défensive!")
            # Bonus de défense pour ce tour
            joueur.defense += 5
            println("Défense temporairement augmentée!")
            break
            
        else
            println("❌ Action invalide!")
        end
    end
    
    # Tour de l'ennemi
    if est_vivant(ennemi)
        sleep(1)
        println("\n🤖 TOUR DE L'ENNEMI!")
        
        # IA simple de l'ennemi
        action_ennemi = rand(1:3)
        
        if action_ennemi <= 2  # 66% de chance d'attaquer
            animation_attaque(ennemi.nom)
            degats = calculer_degats(ennemi, joueur)
            ko = appliquer_degats(joueur, degats)
            
            println("💥 $(ennemi.nom) attaque $(joueur.nom) pour $degats dégâts!")
            
            if ko
                println("💀 $(joueur.nom) est vaincu...")
                return "defaite"
            end
        else
            println("🛡️ $(ennemi.nom) prend une posture défensive!")
            ennemi.defense += 3
        end
        
        # Restaurer la défense normale
        if choix == "3"
            joueur.defense -= 5
        end
        if action_ennemi == 3
            ennemi.defense -= 3
        end
    end
    
    return "continue"
end

function combat_principal(joueur, ennemi, lieu)
    """Boucle principale du combat"""
    println("\n" * "🎺 " * "="^50 * " 🎺")
    println(message_aleatoire(messages_debut_combat))
    println("📍 Lieu: $lieu")
    println("="^54)
    
    tour_numero = 1
    
    while est_vivant(joueur) && est_vivant(ennemi)
        println("\n📅 TOUR $tour_numero")
        afficher_statut_combat(joueur, ennemi)
        
        resultat = tour_de_combat(joueur, ennemi)
        
        if resultat == "victoire"
            animation_victoire()
            println(message_aleatoire(messages_victoire))
            
            # Gain d'expérience
            xp_gagne = rand(10:20)
            joueur.experience += xp_gagne
            println("🌟 Vous gagnez $xp_gagne points d'expérience!")
            
            return true
            
        elseif resultat == "defaite"
            animation_defaite()
            println(message_aleatoire(messages_defaite))
            return false
        end
        
        tour_numero += 1
        
        println("\nAppuyez sur Entrée pour continuer...")
        readline()
    end
end

# Test de combat complet (décommenter pour jouer)
# joueur = creer_combattant("Héros", "guerrier")
# joueur.experience = 30  # Un peu d'XP pour les techniques
# ennemi = creer_combattant("Bandit de la Brousse", "chasseur")
# lieu, icone = ("Forêt de Banfora", "🌿")
# 
# victoire = combat_principal(joueur, ennemi, lieu)
# if victoire
#     println("🎊 Félicitations, vous avez gagné!")
# else
#     println("💪 Entraînez-vous et revenez plus fort!")
# end
```

---

## ✅ Récapitulatif de la Pratique

### Système de combat créé:
- ✅ **Personnages** avec stats et classes différentes
- ✅ **Combat tour par tour** avec calculs de dégâts
- ✅ **Techniques spéciales** inspirées de la culture burkinabè
- ✅ **Interface attractive** avec barres de vie et animations
- ✅ **Éléments culturels** (lieux, messages, personnages)
- ✅ **IA simple** pour les ennemis

### Compétences utilisées:
- ✅ **Structures mutables** pour les personnages
- ✅ **Fonctions modulaires** pour chaque mécanisme
- ✅ **Boucles et conditions** pour la logique de jeu
- ✅ **Tableaux et dictionnaires** pour les données
- ✅ **Gestion des entrées** utilisateur
- ✅ **Randomisation** pour l'imprévisibilité

### Améliorations possibles:
- 📋 Système de niveaux et progression
- 📋 Inventaire d'objets et potions
- 📋 Multiples ennemis et boss
- 📋 Sauvegarde des parties
- 📋 Histoire et quêtes

**Prochaine étape:** "Dans l'exercice principal, vous combinerez calculatrice et jeu pour créer une suite d'applications interactives complète!"