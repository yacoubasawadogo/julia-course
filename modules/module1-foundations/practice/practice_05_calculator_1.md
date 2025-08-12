# 🎯 Pratique Guidée 1: Calculatrice Burkinabè - Fondations
**Module 1 - Session 5** | **Durée: 25 minutes**

---

## 📋 Objectifs de cette Pratique

- Créer les fonctions de base d'une calculatrice
- Implémenter la validation des entrées utilisateur
- Développer un menu interactif simple
- Tester chaque fonctionnalité au fur et à mesure

---

## 🧮 Exercice 1: Fonctions de Calcul Basiques

### Étape 1 - Opérations arithmétiques:
```julia
# Création des fonctions de base
function additionner(a, b)
    return a + b
end

function soustraire(a, b)
    return a - b
end

function multiplier(a, b)
    return a * b
end

function diviser(a, b)
    if b == 0
        println("❌ Erreur: Division par zéro impossible!")
        return nothing
    end
    return a / b
end

# Tests rapides
println("Addition: 5 + 3 = $(additionner(5, 3))")
println("Soustraction: 10 - 4 = $(soustraire(10, 4))")
println("Multiplication: 7 × 6 = $(multiplier(7, 6))")
println("Division: 15 ÷ 3 = $(diviser(15, 3))")
println("Division par zéro: $(diviser(10, 0))")
```

### Challenge interactif:
> **À vous:** "Ajoutez une fonction `calculer_puissance(base, exposant)` qui calcule base^exposant"

```julia
# Solution attendue:
function calculer_puissance(base, exposant)
    return base^exposant
end

println("Puissance: 2^8 = $(calculer_puissance(2, 8))")
```

---

## 💰 Exercice 2: Fonctions Financières Burkinabè

### Calculs de pourcentages (taxes, remises):
```julia
# Fonction polyvalente pour pourcentages
function calculer_pourcentage(montant, pourcentage)
    """Calcule un pourcentage d'un montant"""
    return montant * pourcentage / 100
end

function ajouter_tva(montant_ht)
    """Ajoute la TVA de 18% au Burkina Faso"""
    tva = calculer_pourcentage(montant_ht, 18)
    montant_ttc = montant_ht + tva
    return montant_ttc, tva
end

function calculer_remise(prix_initial, pourcentage_remise)
    """Calcule le prix après remise"""
    remise = calculer_pourcentage(prix_initial, pourcentage_remise)
    prix_final = prix_initial - remise
    return prix_final, remise
end

# Tests avec des exemples réalistes
println("\n=== CALCULS FINANCIERS ===")
prix_telephone = 125000  # FCFA

# Calcul TVA
prix_ttc, tva = ajouter_tva(prix_telephone)
println("Prix HT: $prix_telephone FCFA")
println("TVA (18%): $tva FCFA") 
println("Prix TTC: $prix_ttc FCFA")

# Calcul remise
prix_reduit, remise = calculer_remise(prix_telephone, 15)
println("\nAvec remise de 15%:")
println("Remise: $remise FCFA")
println("Prix final: $prix_reduit FCFA")
```

### Application pratique:
```julia
# Calcul de marge bénéficiaire pour commerçants
function calculer_marge(prix_achat, prix_vente)
    """Calcule la marge et le pourcentage de profit"""
    marge = prix_vente - prix_achat
    pourcentage_marge = (marge / prix_achat) * 100
    return marge, pourcentage_marge
end

# Exemple: Vente de riz au marché
prix_achat_riz = 300  # FCFA/kg
prix_vente_riz = 380  # FCFA/kg

marge, pourcentage = calculer_marge(prix_achat_riz, prix_vente_riz)
println("\n📊 ANALYSE DE MARGE - RIZ:")
println("Prix d'achat: $prix_achat_riz FCFA/kg")
println("Prix de vente: $prix_vente_riz FCFA/kg")
println("Marge unitaire: $marge FCFA/kg")
println("Pourcentage de marge: $(round(pourcentage, digits=1))%")
```

---

## 💱 Exercice 3: Convertisseur de Devises

### Système de conversion FCFA:
```julia
# Base de données des taux de change
taux_change = Dict(
    "EUR" => 656.0,    # 1 EUR = 656 FCFA
    "USD" => 590.0,    # 1 USD = 590 FCFA  
    "GBP" => 750.0,    # 1 GBP = 750 FCFA
    "CHF" => 650.0,    # 1 CHF = 650 FCFA
    "CAD" => 435.0,    # 1 CAD = 435 FCFA
    "CNY" => 82.0      # 1 CNY = 82 FCFA
)

function fcfa_vers_devise(montant_fcfa, devise)
    """Convertit des FCFA vers une autre devise"""
    if !haskey(taux_change, devise)
        println("❌ Devise '$devise' non supportée")
        println("Devises disponibles: $(keys(taux_change))")
        return nothing
    end
    
    montant_converti = montant_fcfa / taux_change[devise]
    return round(montant_converti, digits=2)
end

function devise_vers_fcfa(montant, devise)
    """Convertit une devise vers FCFA"""
    if !haskey(taux_change, devise)
        println("❌ Devise '$devise' non supportée")
        return nothing
    end
    
    montant_fcfa = montant * taux_change[devise]
    return round(montant_fcfa, digits=2)
end

# Tests de conversion
println("\n=== CONVERTISSEUR DE DEVISES ===")
salaire_fcfa = 250000

println("Salaire: $salaire_fcfa FCFA équivaut à:")
for devise in ["EUR", "USD", "GBP"]
    montant = fcfa_vers_devise(salaire_fcfa, devise)
    if montant !== nothing
        println("- $montant $devise")
    end
end

# Conversion inverse
println("\nConversion inverse:")
budget_eur = 500
equivalent_fcfa = devise_vers_fcfa(budget_eur, "EUR")
if equivalent_fcfa !== nothing
    println("$budget_eur EUR = $equivalent_fcfa FCFA")
end
```

---

## 🖥️ Exercice 4: Interface Utilisateur Simple

### Fonction de validation d'entrées:
```julia
function lire_nombre(message)
    """Lit un nombre avec validation"""
    while true
        print(message)
        try
            entree = readline()
            nombre = parse(Float64, entree)
            return nombre
        catch
            println("❌ Veuillez entrer un nombre valide.")
        end
    end
end

function lire_nombre_positif(message)
    """Lit un nombre positif avec validation"""
    while true
        nombre = lire_nombre(message)
        if nombre >= 0
            return nombre
        else
            println("❌ Le nombre doit être positif.")
        end
    end
end

# Test de validation
println("\n=== TEST DE VALIDATION ===")
# age = lire_nombre_positif("Votre âge: ")
# println("Vous avez $age ans.")
```

### Menu simple pour calculs:
```julia
function afficher_menu_calculs()
    println("\n" * "="^40)
    println("🧮 CALCULATRICE - OPÉRATIONS DE BASE")
    println("="^40)
    println("1. Addition")
    println("2. Soustraction")
    println("3. Multiplication") 
    println("4. Division")
    println("5. Pourcentage")
    println("6. Conversion devise")
    println("7. Retour menu principal")
    println("="^40)
end

function menu_calculs_interactif()
    while true
        afficher_menu_calculs()
        choix = readline("Votre choix (1-7): ")
        
        if choix == "1"
            # Addition
            a = lire_nombre("Premier nombre: ")
            b = lire_nombre("Deuxième nombre: ")
            resultat = additionner(a, b)
            println("✅ $a + $b = $resultat")
            
        elseif choix == "2"
            # Soustraction
            a = lire_nombre("Premier nombre: ")
            b = lire_nombre("Deuxième nombre: ")
            resultat = soustraire(a, b)
            println("✅ $a - $b = $resultat")
            
        elseif choix == "3"
            # Multiplication
            a = lire_nombre("Premier nombre: ")
            b = lire_nombre("Deuxième nombre: ")
            resultat = multiplier(a, b)
            println("✅ $a × $b = $resultat")
            
        elseif choix == "4"
            # Division
            a = lire_nombre("Dividende: ")
            b = lire_nombre("Diviseur: ")
            resultat = diviser(a, b)
            if resultat !== nothing
                println("✅ $a ÷ $b = $resultat")
            end
            
        elseif choix == "5"
            # Pourcentage
            montant = lire_nombre_positif("Montant: ")
            pourcentage = lire_nombre("Pourcentage: ")
            resultat = calculer_pourcentage(montant, pourcentage)
            println("✅ $pourcentage% de $montant = $resultat")
            
        elseif choix == "6"
            # Conversion
            montant = lire_nombre_positif("Montant en FCFA: ")
            println("Devises: EUR, USD, GBP, CHF, CAD, CNY")
            devise = uppercase(strip(readline("Devise cible: ")))
            resultat = fcfa_vers_devise(montant, devise)
            if resultat !== nothing
                println("✅ $montant FCFA = $resultat $devise")
            end
            
        elseif choix == "7"
            println("👋 Retour au menu principal...")
            break
            
        else
            println("❌ Choix invalide, essayez encore.")
        end
        
        println("\nAppuyez sur Entrée pour continuer...")
        readline()
    end
end

# Pour tester le menu (décommenter):
# menu_calculs_interactif()
```

---

## 📈 Exercice 5: Historique des Calculs

### Système de sauvegarde simple:
```julia
# Variable globale pour l'historique
historique_calculs = []

function ajouter_historique(operation, resultat)
    """Ajoute une opération à l'historique"""
    timestamp = Dates.now()
    push!(historique_calculs, (timestamp, operation, resultat))
end

function afficher_historique()
    """Affiche l'historique des calculs"""
    println("\n📜 HISTORIQUE DES CALCULS")
    println("="^50)
    
    if isempty(historique_calculs)
        println("Aucun calcul effectué pour le moment.")
        return
    end
    
    for (i, (temps, operation, resultat)) in enumerate(historique_calculs)
        temps_format = Dates.format(temps, "dd/mm/yyyy HH:MM:SS")
        println("$i. [$temps_format] $operation = $resultat")
    end
end

function vider_historique()
    """Remet l'historique à zéro"""
    global historique_calculs
    historique_calculs = []
    println("🗑️ Historique vidé.")
end

# Version améliorée des fonctions avec historique
function additionner_avec_historique(a, b)
    resultat = additionner(a, b)
    operation = "$a + $b"
    ajouter_historique(operation, resultat)
    return resultat
end

# Tests
println("\n=== TEST HISTORIQUE ===")
ajouter_historique("5 + 3", 8)
ajouter_historique("10 × 7", 70)
ajouter_historique("100 ÷ 4", 25)

afficher_historique()
```

---

## 🎯 Challenge Final: Mini-Calculatrice Complète

### Intégration de toutes les fonctionnalités:
```julia
function calculatrice_burkinabe_v1()
    """Version 1 de la calculatrice burkinabè"""
    
    println("""
    ╔══════════════════════════════════════════╗
    ║      🧮 CALCULATRICE BURKINABÈ v1.0      ║
    ║                                          ║
    ║   Votre assistant de calculs quotidiens  ║
    ║         Adapté au contexte local         ║
    ╚══════════════════════════════════════════╝
    """)
    
    while true
        println("\n" * "="^45)
        println("📱 MENU PRINCIPAL")
        println("="^45)
        println("1. 🧮 Calculs de base")
        println("2. 💰 Calculs financiers")
        println("3. 💱 Conversion devises")
        println("4. 📜 Voir historique")
        println("5. 🗑️ Vider historique")
        println("6. 🚪 Quitter")
        println("="^45)
        
        choix = readline("Votre choix: ")
        
        if choix == "1"
            menu_calculs_interactif()
        elseif choix == "2"
            menu_financiers()  # À implémenter
        elseif choix == "3"
            menu_conversions()  # À implémenter
        elseif choix == "4"
            afficher_historique()
        elseif choix == "5"
            vider_historique()
        elseif choix == "6"
            println("👋 Merci d'avoir utilisé la Calculatrice Burkinabè!")
            println("🇧🇫 À bientôt!")
            break
        else
            println("❌ Choix invalide. Essayez à nouveau.")
        end
        
        if choix in ["4", "5"]
            println("\nAppuyez sur Entrée pour continuer...")
            readline()
        end
    end
end

# Pour lancer la calculatrice:
# calculatrice_burkinabe_v1()
```

---

## ✅ Récapitulatif de la Pratique

### Ce que nous avons créé:
- ✅ **Fonctions arithmétiques** avec gestion d'erreurs
- ✅ **Calculs financiers** adaptés au contexte burkinabè
- ✅ **Convertisseur de devises** avec base FCFA
- ✅ **Interface utilisateur** avec validation
- ✅ **Système d'historique** pour traçabilité

### Compétences développées:
- ✅ **Architecture modulaire** - Séparation des responsabilités
- ✅ **Gestion d'erreurs** - Validation et messages informatifs
- ✅ **Interface utilisateur** - Menus et interactions
- ✅ **Structures de données** - Dictionnaires et tableaux
- ✅ **Intégration** - Combinaison de toutes les fonctionnalités

### Fonctionnalités manquantes (à développer):
- 📋 Menu financiers complet
- 📋 Menu conversions détaillé  
- 📋 Sauvegarde sur fichier
- 📋 Calculs scientifiques
- 📋 Interface graphique

**Prochaine étape:** "Maintenant, créons un jeu de combat traditionnel pour appliquer nos compétences en programmation interactive!"