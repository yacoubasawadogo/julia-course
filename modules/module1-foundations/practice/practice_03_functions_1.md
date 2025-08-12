# 🎯 Pratique Guidée 1: Création de Fonctions de Base
**Module 1 - Session 3** | **Durée: 15 minutes**

---

## 🔧 Exercice 1: Première Fonction Simple

### Démonstration live - Fonction de salutation:
```julia
# Créons ensemble une fonction basique
function saluer(nom)
    println("Bonjour $nom!")
end

# Test immédiat
saluer("Aminata")  # "Bonjour Aminata!"
```

### Challenge étudiant:
> "Créez une fonction `saluer_soir` qui dit bonsoir au lieu de bonjour"

```julia
# Solution attendue:
function saluer_soir(nom)
    println("Bonsoir $nom!")
end
```

### Extension interactive:
```julia
# Version avec retour de valeur
function creer_salutation(nom)
    return "Bonjour $nom!"
end

message = creer_salutation("Paul")
println(message)  # Affichage différé
```

---

## 🧮 Exercice 2: Fonctions Mathématiques Pratiques

### A) Calculateur de surface:
```julia
# Rectangle
function surface_rectangle(longueur, largeur)
    return longueur * largeur
end

# Test avec un champ burkinabè
surface_champ = surface_rectangle(50, 30)  # 1500 m²
println("Surface du champ: $surface_champ m²")
```

### B) Challenge: Cercle
> "À vous! Créez `surface_cercle(rayon)` avec π de Julia"

```julia
# Solution guidée ensemble:
function surface_cercle(rayon)
    return π * rayon^2
end

# Test
surface_puits = surface_cercle(1.5)
println("Surface puits: $(round(surface_puits, digits=2)) m²")
```

### C) Volume cylindrique:
```julia
# Combinaison de fonctions
function volume_cylindre(rayon, hauteur)
    base = surface_cercle(rayon)  # Réutilisation!
    return base * hauteur
end

# Application: réservoir d'eau
volume_reservoir = volume_cylindre(2.0, 3.0)
litres = volume_reservoir * 1000  # m³ → litres
println("Capacité: $(round(litres)) litres")
```

---

## 💰 Exercice 3: Fonctions Financières Burkinabè

### Convertisseur FCFA:
```julia
# Fonction de base
function fcfa_vers_euro(montant_fcfa)
    taux = 656  # 1 EUR = 656 FCFA
    return montant_fcfa / taux
end

# Test pratique
salaire_fcfa = 180000
salaire_euros = fcfa_vers_euro(salaire_fcfa)
println("Salaire: $(round(salaire_euros, digits=2)) €")
```

### Challenge multiple devises:
> "Ajoutons `fcfa_vers_dollar` avec le taux 1 USD = 590 FCFA"

```julia
function fcfa_vers_dollar(montant_fcfa)
    taux = 590
    return montant_fcfa / taux
end

# Tests comparatifs
montant = 100000  # FCFA
println("$montant FCFA =")
println("  $(round(fcfa_vers_euro(montant), digits=2)) €")
println("  $(round(fcfa_vers_dollar(montant), digits=2)) \$")
```

---

## ⚡ Exercice 4: Syntaxes Compactes

### Transformation en syntaxe courte:
```julia
# Version longue → version courte
function carre_long(x)
    return x^2
end

# Version compacte
carre(x) = x^2

# Tests identiques
println(carre_long(5))  # 25
println(carre(5))       # 25
```

### Challenge de conversion:
> "Convertissez ces fonctions en syntaxe compacte:"

```julia
# À convertir ensemble:
function double_long(x)
    return 2 * x
end

function cube_long(x)
    return x^3
end

# Solutions:
double(x) = 2x        # Multiplication implicite
cube(x) = x^3
```

---

## 🔍 Exercice 5: Fonctions avec Validation

### Fonction sécurisée - Division:
```julia
function diviser_securise(a, b)
    if b == 0
        println("⚠️ Erreur: Division par zéro!")
        return nothing
    end
    return a / b
end

# Tests de sécurité
resultat1 = diviser_securise(10, 2)   # 5.0
resultat2 = diviser_securise(10, 0)   # nothing + erreur
println("Résultats: $resultat1, $resultat2")
```

### Application: Calcul de moyenne sécurisé
```julia
function moyenne_securise(notes...)  # Varargs
    if length(notes) == 0
        println("⚠️ Erreur: Aucune note fournie!")
        return nothing
    end
    return sum(notes) / length(notes)
end

# Tests
moy1 = moyenne_securise(12, 15, 18)      # 15.0
moy2 = moyenne_securise()                # nothing + erreur
println("Moyenne: $moy1")
```

---

## 🎮 Mini-Challenge: Calculateur d'Âge

### Fonction complète:
```julia
function calculer_age(annee_naissance)
    annee_actuelle = 2024  # Ou year(now()) avec Dates
    
    if annee_naissance > annee_actuelle
        println("⚠️ Année de naissance invalide!")
        return nothing
    end
    
    age = annee_actuelle - annee_naissance
    return age
end

# Tests interactifs
age1 = calculer_age(2000)  # 24
age2 = calculer_age(2030)  # Erreur
println("Âges calculés: $age1")
```

### Extension avec catégories:
```julia
function categoriser_age(annee_naissance)
    age = calculer_age(annee_naissance)
    
    if age === nothing  # Gestion d'erreur
        return "Invalide"
    elseif age < 18
        return "Mineur ($age ans)"
    elseif age < 65
        return "Adulte ($age ans)"
    else
        return "Senior ($age ans)"
    end
end

# Tests
println(categoriser_age(2010))  # "Mineur (14 ans)"
println(categoriser_age(1990))  # "Adulte (34 ans)"
```

---

## 📊 Exercice 6: Fonction avec Retours Multiples

### Analyseur de notes:
```julia
function analyser_notes(notes...)
    if length(notes) == 0
        return nothing, nothing, nothing
    end
    
    moyenne = sum(notes) / length(notes)
    minimum = minimum(notes)
    maximum = maximum(notes)
    
    return moyenne, minimum, maximum
end

# Décomposition du tuple
notes_classe = [12, 15, 8, 17, 11, 14, 9, 16]
moy, mini, maxi = analyser_notes(notes_classe...)

println("Analyse de la classe:")
println("- Moyenne: $(round(moy, digits=1))")
println("- Note minimale: $mini")
println("- Note maximale: $maxi")
```

---

## 💡 Points Clés de la Session

### Syntaxes apprises:
- ✅ `function nom() ... end` - Syntaxe complète
- ✅ `nom() = expression` - Syntaxe compacte
- ✅ Arguments multiples et varargs `...`
- ✅ Validation avec `if` et `return nothing`

### Bonnes pratiques vues:
- ✅ Noms de fonctions explicites et verbes d'action
- ✅ Validation des paramètres d'entrée
- ✅ Messages d'erreur clairs pour l'utilisateur
- ✅ Réutilisation de fonctions dans d'autres fonctions

### Applications burkinabè intégrées:
- ✅ Conversions FCFA/devises internationales
- ✅ Calculs agricoles (surfaces, volumes)
- ✅ Données démographiques et âges
- ✅ Système de notation scolaire

**Transition:** "Maintenant, explorons les arguments optionnels et par mots-clés..."