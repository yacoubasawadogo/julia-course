# 📚 Module 1 - Session 5: Projets Pratiques
**Durée: 2 heures** | **Niveau: Débutant+**

---

## 🎯 Objectifs de la Session

À la fin de cette session, vous serez capable de:
- ✅ Concevoir et implémenter un projet complet
- ✅ Organiser le code en fonctions modulaires
- ✅ Gérer les entrées utilisateur et la validation
- ✅ Créer des interfaces textuelles interactives
- ✅ Appliquer tous les concepts vus précédemment

---

## 🧮 Projet 1: Calculatrice Avancée Burkinabè

### Fonctionnalités à Implémenter

La calculatrice sera spécialement adaptée au contexte burkinabè:

```julia
# Fonctionnalités de base
- Addition, soustraction, multiplication, division
- Calcul de pourcentages (taxes, remises)
- Historique des calculs
- Conversion de devises (FCFA ↔ autres devises)

# Fonctionnalités spécialisées
- Calculs agricoles (rendements, surfaces)
- Calculs commerciaux (marges, TVA, profits)  
- Calculs financiers (intérêts simples, épargne)
- Statistiques simples (moyennes, totaux)
```

### Architecture du Code

```julia
# Structure modulaire recommandée

# 1. Fonctions de calcul de base
function additionner(a, b)
    return a + b
end

function calculer_pourcentage(montant, pourcentage)
    return montant * pourcentage / 100
end

# 2. Fonctions spécialisées burkinabè
function convertir_devise(montant_fcfa, devise, taux_change)
    # Logique de conversion
end

function calculer_rendement_agricole(production_kg, surface_hectares)
    return production_kg / surface_hectares
end

# 3. Interface utilisateur
function afficher_menu()
    # Menu principal
end

function traiter_choix_utilisateur(choix)
    # Logique de navigation
end

# 4. Gestion de l'historique
historique_calculs = []

function ajouter_historique(operation, resultat)
    push!(historique_calculs, (operation, resultat))
end
```

---

## 🎮 Projet 2: Jeu de Combat Traditionnel

### Concept du Jeu

Un jeu de combat tour par tour inspiré de la culture burkinabè:

```julia
# Contexte culturel
- Personnages inspirés des masques traditionnels
- Noms en langues locales (Mooré, Dioula)
- Lieux de combat (villages, marchés, brousse)
- Techniques de combat traditionnelles
```

### Mécaniques de Jeu

```julia
# Structure d'un personnage
mutable struct Combattant
    nom::String
    vie::Int
    attaque::Int
    defense::Int
    niveau::Int
    experience::Int
end

# Créer des combattants
function creer_combattant(nom, classe)
    if classe == "guerrier"
        return Combattant(nom, 100, 20, 15, 1, 0)
    elseif classe == "chasseur"
        return Combattant(nom, 80, 25, 10, 1, 0)
    elseif classe == "sage"
        return Combattant(nom, 90, 15, 20, 1, 0)
    end
end

# Combat tour par tour
function tour_combat(attaquant, defenseur)
    degats = max(1, attaquant.attaque - defenseur.defense)
    defenseur.vie -= degats
    return degats
end
```

---

## 🏗️ Méthodologie de Développement

### Étapes de Conception

1. **Analyse des besoins**
   - Quelles fonctionnalités sont essentielles?
   - Qui sont les utilisateurs cibles?
   - Quelles contraintes techniques?

2. **Conception modulaire**
   - Diviser en fonctions logiques
   - Séparer logique métier et interface
   - Prévoir l'extensibilité

3. **Développement itératif**
   - Version minimale fonctionnelle (MVP)
   - Ajout progressif de fonctionnalités
   - Tests constants

4. **Polissage**
   - Interface utilisateur améliorée
   - Gestion d'erreurs robuste
   - Documentation du code

### Patterns de Code Utiles

```julia
# Pattern: Validation d'entrée
function lire_nombre_positif(message)
    while true
        print(message)
        try
            nombre = parse(Float64, readline())
            if nombre >= 0
                return nombre
            else
                println("⚠️ Veuillez entrer un nombre positif.")
            end
        catch
            println("⚠️ Veuillez entrer un nombre valide.")
        end
    end
end

# Pattern: Menu avec boucle
function menu_principal()
    while true
        println("\n" * "="^50)
        println("🧮 CALCULATRICE BURKINABÈ")
        println("="^50)
        println("1. Calculs de base")
        println("2. Conversions devises") 
        println("3. Calculs agricoles")
        println("4. Voir historique")
        println("5. Quitter")
        println("="^50)
        
        choix = readline()
        
        if choix == "1"
            menu_calculs_base()
        elseif choix == "2"
            menu_conversions()
        elseif choix == "3"
            menu_agricole()
        elseif choix == "4"
            afficher_historique()
        elseif choix == "5"
            println("👋 Au revoir!")
            break
        else
            println("❌ Choix invalide. Essayez encore.")
        end
    end
end

# Pattern: Gestion d'état
mutable struct EtatJeu
    joueur::Combattant
    ennemi::Combattant
    tour::Int
    en_cours::Bool
end

function initialiser_jeu()
    return EtatJeu(
        creer_combattant("Joueur", "guerrier"),
        creer_combattant("Bandit", "chasseur"),
        1,
        true
    )
end
```

---

## 💰 Applications Contextuelles Burkinabè

### Calculatrice: Cas d'Usage Réels

```julia
# Exemple: Calcul de profit au marché
function calculer_profit_marche()
    println("🏪 CALCUL DE PROFIT AU MARCHÉ")
    println("Produit vendu au marché central de Ouagadougou")
    
    prix_achat = lire_nombre_positif("Prix d'achat total (FCFA): ")
    prix_vente = lire_nombre_positif("Prix de vente total (FCFA): ")
    
    profit_brut = prix_vente - prix_achat
    taxe_marche = profit_brut * 0.05  # 5% de taxe
    profit_net = profit_brut - taxe_marche
    
    pourcentage_marge = (profit_brut / prix_achat) * 100
    
    println("\n📊 RÉSULTATS:")
    println("Profit brut: $(round(profit_brut)) FCFA")
    println("Taxe marché (5%): $(round(taxe_marche)) FCFA") 
    println("Profit net: $(round(profit_net)) FCFA")
    println("Marge: $(round(pourcentage_marge, digits=1))%")
    
    # Ajouter à l'historique
    operation = "Profit marché: $prix_achat → $prix_vente FCFA"
    ajouter_historique(operation, profit_net)
end

# Exemple: Conversion pour voyage
function calculer_budget_voyage()
    println("✈️ BUDGET DE VOYAGE") 
    println("Conversion FCFA vers devise étrangère")
    
    taux_change = Dict(
        "EUR" => 656, "USD" => 590, "GBP" => 750,
        "CHF" => 650, "CAD" => 435
    )
    
    budget_fcfa = lire_nombre_positif("Budget disponible (FCFA): ")
    
    println("\nDevises disponibles: $(keys(taux_change))")
    devise = uppercase(strip(readline("Devise de destination: ")))
    
    if haskey(taux_change, devise)
        montant_devise = budget_fcfa / taux_change[devise]
        println("\n💱 $budget_fcfa FCFA = $(round(montant_devise, digits=2)) $devise")
        
        # Suggestions basées sur le montant
        if devise == "EUR" && montant_devise >= 1000
            println("💡 Suffisant pour un séjour en Europe!")
        elseif devise == "USD" && montant_devise >= 500
            println("💡 Budget correct pour les États-Unis!")
        end
    else
        println("❌ Devise non supportée")
    end
end
```

### Jeu: Éléments Culturels

```julia
# Personnages inspirés de la culture burkinabè
personnages_disponibles = [
    ("Karfo", "guerrier", "Brave guerrier mossi de Ouagadougou"),
    ("Aminata", "chasseuse", "Experte à l'arc de la région des Hauts-Bassins"), 
    ("Boubou", "sage", "Vieux sage dioula de Bobo-Dioulasso"),
    ("Raogo", "guerrier", "Défenseur du royaume de Tenkodogo"),
    ("Fatou", "guérisseuse", "Tradipraticienne de Banfora")
]

# Lieux de combat
lieux_combat = [
    "Village de Samestenga",
    "Marché central de Ouagadougou", 
    "Forêt de Banfora",
    "Savane près de Dori",
    "Collines de Nahouri"
]

# Techniques de combat traditionnelles
techniques_combat = [
    ("Frappe Wango", 25, "Technique de lutte traditionnelle"),
    ("Tir Précis", 20, "Maîtrise de l'arc traditionnel"),
    ("Esquive Dansa", 0, "Danse d'évitement traditionnelle"),
    ("Cri de Guerre", 15, "Intimidation ancestrale")
]

function choisir_technique_combat()
    println("\n⚔️ Choisissez votre technique:")
    for (i, (nom, degats, description)) in enumerate(techniques_combat)
        println("$i. $nom - $description (Dégâts: $degats)")
    end
    
    while true
        choix = readline("Votre choix (1-4): ")
        try
            index = parse(Int, choix)
            if 1 <= index <= length(techniques_combat)
                return techniques_combat[index]
            end
        catch
        end
        println("❌ Choix invalide, essayez encore.")
    end
end
```

---

## 🎨 Interface Utilisateur Attractive

### Techniques d'Affichage

```julia
# ASCII Art pour les titres
function afficher_titre_calculatrice()
    println("""
    ╔════════════════════════════════════════╗
    ║        🧮 CALCULATRICE BURKINABÈ       ║  
    ║                                        ║
    ║    Votre assistant pour les calculs    ║
    ║         du quotidien au Burkina        ║
    ╚════════════════════════════════════════╝
    """)
end

function afficher_titre_combat()
    println("""
    ⚔️  ===================================== ⚔️
         🎭 COMBAT DES MASQUES TRADITIONNELS
         
         Incarnez un héros burkinabè et
         affrontez les défis de la brousse!
    ⚔️  ===================================== ⚔️
    """)
end

# Barres de progression pour la vie
function afficher_barre_vie(vie_actuelle, vie_max, nom)
    pourcentage = vie_actuelle / vie_max
    longueur_barre = 20
    rempli = round(Int, pourcentage * longueur_barre)
    vide = longueur_barre - rempli
    
    couleur = pourcentage > 0.6 ? "💚" : pourcentage > 0.3 ? "💛" : "❤️"
    
    barre = "█"^rempli * "░"^vide
    println("$nom: $couleur [$barre] $vie_actuelle/$vie_max PV")
end

# Animations simples
function animation_attaque()
    animations = ["💥", "⚡", "🔥", "💀"]
    for anim in animations
        print("\r$anim Attaque en cours... ")
        sleep(0.3)
    end
    println("\r✅ Attaque réussie!        ")
    sleep(0.5)
end
```

---

## 📊 Persistance des Données

### Sauvegarde Simple

```julia
# Sauvegarde de l'historique
function sauvegarder_historique(nom_fichier="historique_calculatrice.txt")
    open(nom_fichier, "w") do fichier
        write(fichier, "=== HISTORIQUE CALCULATRICE BURKINABÈ ===\n")
        write(fichier, "Généré le: $(Dates.now())\n\n")
        
        for (i, (operation, resultat)) in enumerate(historique_calculs)
            write(fichier, "$i. $operation = $resultat\n")
        end
    end
    println("💾 Historique sauvegardé dans $nom_fichier")
end

# Sauvegarde des scores de jeu
function sauvegarder_score(joueur, score, fichier="scores_combat.txt")
    open(fichier, "a") do f  # Mode "append" pour ajouter
        write(f, "$(Dates.now()) - $(joueur.nom): Score $score\n")
    end
end

function afficher_meilleurs_scores()
    if isfile("scores_combat.txt")
        println("\n🏆 MEILLEURS SCORES:")
        scores = readlines("scores_combat.txt")
        for score in scores[end-5:end]  # 5 derniers scores
            println(score)
        end
    else
        println("Aucun score enregistré pour le moment.")
    end
end
```

---

## 🛠️ Gestion d'Erreurs Robuste

### Validation et Messages d'Erreur

```julia
# Fonction utilitaire pour la validation
function valider_et_executer(fonction, message_erreur="Erreur lors de l'exécution")
    try
        return fonction()
    catch e
        println("❌ $message_erreur")
        println("Détails: $e")
        return nothing
    end
end

# Wrapper pour les opérations mathématiques
function division_securisee(a, b)
    if b == 0
        println("❌ Division par zéro impossible!")
        return nothing
    end
    
    if !isa(a, Number) || !isa(b, Number)
        println("❌ Les opérandes doivent être des nombres!")
        return nothing
    end
    
    return a / b
end

# Gestion des entrées utilisateur
function lire_choix_menu(options_valides)
    while true
        choix = strip(readline())
        if choix in string.(options_valides)
            return parse(Int, choix)
        else
            println("❌ Choix invalide. Options: $(join(options_valides, ", "))")
            print("Votre choix: ")
        end
    end
end
```

---

## 🎯 Points Clés de la Session

### Principes de Développement

1. **Modularité** - Diviser le code en fonctions logiques
2. **Réutilisabilité** - Écrire des fonctions génériques
3. **Robustesse** - Gérer les cas d'erreur gracieusement
4. **Expérience utilisateur** - Interface claire et intuitive
5. **Contexte culturel** - Adapter au public burkinabè

### Architecture Recommandée

```julia
# Structure type d'un projet Julia
projet/
├── src/
│   ├── calculatrice.jl      # Fonctions de calcul
│   ├── conversions.jl       # Conversions de devises  
│   ├── interface.jl         # Interface utilisateur
│   └── utils.jl             # Fonctions utilitaires
├── data/
│   ├── historique.txt       # Sauvegarde des calculs
│   └── scores.txt           # Scores du jeu
├── main.jl                  # Point d'entrée principal
└── README.md                # Documentation
```

---

## 🚀 Prochaines Étapes

Cette session clôt le **Module 1 - Fondations**. Vous maîtrisez maintenant:
- Variables et types de base
- Fonctions et contrôle de flux  
- Tableaux et collections
- Dictionnaires et structures
- Développement de projets complets

**Module 2** nous permettra d'approfondir:
- Structures et types personnalisés
- Programmation orientée objet
- Gestion de fichiers
- Modules et packages
- Projets plus complexes

---

## 📝 Notes pour l'Instructeur

### Démonstrations Recommandées:
1. Développement live de la calculatrice de base
2. Création pas-à-pas du système de combat
3. Techniques de débogage et test
4. Optimisation et refactoring

### Timing Suggéré:
- **30 min** - Présentation théorique et architecture
- **45 min** - Développement calculatrice guidé
- **30 min** - Pause et questions
- **45 min** - Développement jeu de combat
- **30 min** - Polissage et tests

### Adaptations Possibles:
- Simplifier les projets pour débutants absolus
- Ajouter des fonctionnalités pour étudiants avancés
- Personnaliser avec d'autres contextes culturels locaux