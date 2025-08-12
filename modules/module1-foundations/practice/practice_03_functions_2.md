# 🎯 Pratique Guidée 2: Arguments Avancés et Documentation
**Module 1 - Session 3** | **Durée: 20 minutes**

---

## 🔧 Exercice 1: Arguments Optionnels (Valeurs par Défaut)

### Fonction de salutation flexible:
```julia
function saluer_flexible(nom, moment="matin")
    if moment == "matin"
        println("Bonjour $nom!")
    elseif moment == "midi"
        println("Bon après-midi $nom!")
    elseif moment == "soir"
        println("Bonsoir $nom!")
    else
        println("Salut $nom!")
    end
end

# Tests de flexibilité
saluer_flexible("Aminata")           # "Bonjour Aminata!" (défaut)
saluer_flexible("Paul", "soir")      # "Bonsoir Paul!"
saluer_flexible("Marie", "weekend")  # "Salut Marie!"
```

### Application: Calcul de prix avec TVA
```julia
function calculer_prix_ttc(prix_ht, taux_tva=0.18)
    tva = prix_ht * taux_tva
    prix_ttc = prix_ht + tva
    return prix_ttc, tva  # Retourne les deux valeurs
end

# Utilisations variées
prix1, tva1 = calculer_prix_ttc(25000)        # TVA 18% (défaut)
prix2, tva2 = calculer_prix_ttc(15000, 0.20)  # TVA 20% personnalisée

println("Prix 1: $prix1 FCFA (TVA: $tva1)")
println("Prix 2: $prix2 FCFA (TVA: $tva2)")
```

### Challenge étudiant:
> "Créez `commander_boisson(type, taille="normale")` avec 3 tailles différentes"

```julia
# Solution guidée:
function commander_boisson(type, taille="normale")
    prix = if type == "bissap"
        taille == "petite" ? 200 : taille == "normale" ? 300 : 450
    elseif type == "dolo"
        taille == "petite" ? 150 : taille == "normale" ? 250 : 400
    else
        taille == "petite" ? 100 : taille == "normale" ? 150 : 200
    end
    
    println("$type ($taille): $prix FCFA")
    return prix
end

# Tests
commander_boisson("bissap")            # normale par défaut
commander_boisson("dolo", "grande")    # taille spécifiée
```

---

## ⚙️ Exercice 2: Arguments par Mots-Clés

### Système de commande de repas:
```julia
function commander_repas(plat; boisson="eau", epice="normal", livraison=false, pourboire=0)
    prix_base = 2500  # Prix du plat de base
    
    # Calcul des suppléments
    prix_boisson = boisson == "bissap" ? 300 : boisson == "eau" ? 0 : 200
    supplement_epice = epice == "piquant" ? 100 : 0
    frais_livraison = livraison ? 500 : 0
    
    total = prix_base + prix_boisson + supplement_epice + frais_livraison + pourboire
    
    println("=== COMMANDE ===")
    println("Plat: $plat")
    println("Boisson: $boisson (+$prix_boisson FCFA)")
    println("Épices: $epice (+$supplement_epice FCFA)")
    println("Livraison: $(livraison ? "Oui (+$frais_livraison FCFA)" : "Non")")
    println("Pourboire: $pourboire FCFA")
    println("TOTAL: $total FCFA")
    
    return total
end

# Syntaxe claire et flexible
commander_repas("Riz sauce", boisson="bissap", epice="piquant")
commander_repas("Tô", livraison=true, pourboire=200, boisson="dolo")
```

### Point pédagogique:
> **Avantage des mots-clés:** L'ordre n'importe plus, le code est auto-documenté!

---

## 📚 Exercice 3: Documentation avec Docstrings

### Fonction documentée professionnellement:
```julia
"""
    convertir_temperature(celsius; vers="fahrenheit")

Convertit une température de Celsius vers Fahrenheit ou Kelvin.

# Arguments
- `celsius::Number`: Température en degrés Celsius
- `vers::String="fahrenheit"`: Unité cible ("fahrenheit" ou "kelvin")

# Retour
- `Float64`: Température convertie

# Exemples
```julia-repl
julia> convertir_temperature(25)
77.0

julia> convertir_temperature(0, vers="kelvin")
273.15
```

# Notes
Utilise les formules standard de conversion thermodynamique.
"""
function convertir_temperature(celsius; vers="fahrenheit")
    if vers == "fahrenheit"
        return celsius * 9/5 + 32
    elseif vers == "kelvin"
        return celsius + 273.15
    else
        error("Unité non supportée: $vers")
    end
end

# Test de la documentation
?convertir_temperature  # Affiche la doc dans le REPL
```

### Démonstration de l'aide:
```julia
# Tests avec notre fonction documentée
temp_f = convertir_temperature(35)                    # 95.0°F
temp_k = convertir_temperature(100, vers="kelvin")    # 373.15K

println("35°C = $temp_f°F")
println("100°C = $temp_k K")
```

---

## 🌾 Exercice 4: Application Agricole Complète

### Système d'analyse de parcelle:
```julia
"""
    analyser_parcelle(surface_ha, culture; rendement_moyen=1200, 
                     prix_kg=200, cout_production=150000)

Analyse la rentabilité d'une parcelle agricole burkinabè.

# Arguments
- `surface_ha::Float64`: Surface en hectares
- `culture::String`: Type de culture (maïs, mil, sorgho, riz)
- `rendement_moyen::Int=1200`: Rendement attendu en kg/ha
- `prix_kg::Int=200`: Prix de vente en FCFA/kg
- `cout_production::Int=150000`: Coût de production total en FCFA

# Retour
- `NamedTuple`: (production, revenus, profit, rentable)
"""
function analyser_parcelle(surface_ha, culture; 
                          rendement_moyen=1200, 
                          prix_kg=200, 
                          cout_production=150000)
    
    production_kg = surface_ha * rendement_moyen
    revenus_bruts = production_kg * prix_kg
    profit = revenus_bruts - cout_production
    rentable = profit > 0
    
    println("=== ANALYSE PARCELLE ($culture) ===")
    println("Surface: $surface_ha ha")
    println("Production estimée: $(Int(production_kg)) kg")
    println("Revenus bruts: $(Int(revenus_bruts)) FCFA")
    println("Coûts: $cout_production FCFA")
    println("Profit: $(Int(profit)) FCFA")
    println("Rentabilité: $(rentable ? "✅ Rentable" : "❌ Non rentable")")
    
    return (
        production = production_kg,
        revenus = revenus_bruts, 
        profit = profit,
        rentable = rentable
    )
end

# Scénarios réalistes burkinabè
parcelle_mais = analyser_parcelle(2.5, "maïs", 
                                 rendement_moyen=1800, 
                                 prix_kg=180,
                                 cout_production=200000)

parcelle_riz = analyser_parcelle(1.0, "riz",
                                rendement_moyen=3000,
                                prix_kg=300,
                                cout_production=180000)
```

---

## 🔄 Exercice 5: Fonctions avec Logique Métier

### Système de crédit agricole:
```julia
function evaluer_demande_credit(revenus_annuels, age, surface_exploitee;
                              montant_demande=500000,
                              historique_remboursement="bon",
                              garanties=false)
    
    println("=== ÉVALUATION CRÉDIT AGRICOLE ===")
    
    # Critères d'éligibilité
    age_eligible = 18 <= age <= 65
    revenus_suffisants = revenus_annuels >= montant_demande * 0.3  # 30% du montant
    surface_adequate = surface_exploitee >= 1.0  # Minimum 1 hectare
    
    println("Âge ($age ans): $(age_eligible ? "✅" : "❌")")
    println("Revenus ($(revenus_annuels) FCFA): $(revenus_suffisants ? "✅" : "❌")")
    println("Surface ($(surface_exploitee) ha): $(surface_adequate ? "✅" : "❌")")
    println("Historique: $(historique_remboursement)")
    println("Garanties: $(garanties ? "Oui" : "Non")")
    
    # Decision finale
    criteres_base = age_eligible && revenus_suffisants && surface_adequate
    bonus_historique = historique_remboursement == "excellent"
    bonus_garanties = garanties
    
    if criteres_base && (bonus_historique || bonus_garanties)
        decision = "APPROUVÉ"
        taux = bonus_historique && bonus_garanties ? 8.5 : 9.5
    elseif criteres_base
        decision = "APPROUVÉ CONDITIONNEL"
        taux = 11.0
    else
        decision = "REFUSÉ"
        taux = 0.0
    end
    
    println("\n🏦 DÉCISION: $decision")
    if taux > 0
        println("💰 Taux proposé: $taux%")
        mensualite = (montant_demande * (taux/100/12)) / (1 - (1 + taux/100/12)^(-36))  # 3 ans
        println("💳 Mensualité (36 mois): $(round(Int, mensualite)) FCFA")
    end
    
    return decision, taux
end

# Cas pratiques
cas1 = evaluer_demande_credit(800000, 35, 3.0,
                             montant_demande=400000,
                             historique_remboursement="excellent", 
                             garanties=true)

cas2 = evaluer_demande_credit(300000, 28, 1.5,
                             montant_demande=600000,
                             historique_remboursement="moyen")
```

---

## 🎯 Exercice 6: Fonctions Récursives (Bonus)

### Calcul récursif - Suite de Fibonacci:
```julia
function fibonacci(n)
    if n <= 0
        return 0
    elseif n == 1
        return 1
    else
        return fibonacci(n-1) + fibonacci(n-2)
    end
end

# Affichage de la séquence
println("Séquence de Fibonacci:")
for i in 0:10
    print("$(fibonacci(i)) ")
end
println()
```

### Version optimisée (itérative):
```julia
function fibonacci_rapide(n)
    if n <= 0; return 0; end
    if n == 1; return 1; end
    
    a, b = 0, 1
    for i in 2:n
        a, b = b, a + b
    end
    return b
end

# Comparaison de performance
@time fib_rec = fibonacci(35)        # Lent (récursif)
@time fib_iter = fibonacci_rapide(35)  # Rapide (itératif)
println("Même résultat: $(fib_rec == fib_iter)")
```

---

## ✅ Récapitulatif de la Session

### Concepts maîtrisés:
- ✅ **Arguments optionnels** avec valeurs par défaut
- ✅ **Arguments par mots-clés** pour clarté et flexibilité
- ✅ **Documentation** avec docstrings professionnelles
- ✅ **Retours multiples** avec tuples nommés
- ✅ **Validation métier** avec logique complexe
- ✅ **Récursion** vs approches itératives

### Applications pratiques burkinabè:
- ✅ Système de commande de restaurant
- ✅ Convertisseur de température
- ✅ Analyse de rentabilité agricole
- ✅ Évaluation de crédit agricole
- ✅ Calculs financiers avec options

### Bonnes pratiques appliquées:
- ✅ Noms explicites et documentation claire
- ✅ Validation robuste des paramètres
- ✅ Messages utilisateur informatifs
- ✅ Gestion d'erreurs avec `error()` et `nothing`
- ✅ Séparation des responsabilités

**Préparation:** "Dans l'exercice principal, vous combinerez tous ces concepts pour créer un système complet!"