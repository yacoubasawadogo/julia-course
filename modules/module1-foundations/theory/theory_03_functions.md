# 📚 Module 1 - Session 3: Fonctions et Contrôle de Flux

**Durée: 2 heures** | **Niveau: Débutant**

---

## 🎯 Objectifs de la Session

À la fin de cette session, vous serez capable de:

- ✅ Créer et utiliser des fonctions personnalisées
- ✅ Comprendre les paramètres et valeurs de retour
- ✅ Maîtriser les différentes syntaxes de fonctions
- ✅ Utiliser les arguments optionnels et par mots-clés
- ✅ Appliquer les bonnes pratiques de documentation

---

## 🔧 Pourquoi les Fonctions?

### Les 4 Piliers des Fonctions

1. **Réutilisabilité** - Écrire une fois, utiliser partout
2. **Organisation** - Diviser le code en blocs logiques
3. **Testabilité** - Valider des comportements isolés
4. **Lisibilité** - Code auto-documenté et compréhensible

### Exemple Concret: Sans vs Avec Fonctions

```julia
# ❌ SANS FONCTIONS - Code répétitif
# Calcul TVA pour 3 produits différents
prix1 = 25000
tva1 = prix1 * 0.18
prix_ttc1 = prix1 + tva1

prix2 = 15000
tva2 = prix2 * 0.18
prix_ttc2 = prix2 + tva2

prix3 = 8000
tva3 = prix3 * 0.18
prix_ttc3 = prix3 + tva3

# ✅ AVEC FONCTIONS - Code réutilisable
function calculer_prix_ttc(prix_ht)
    tva = prix_ht * 0.18
    return prix_ht + tva
end

prix_ttc1 = calculer_prix_ttc(25000)
prix_ttc2 = calculer_prix_ttc(15000)
prix_ttc3 = calculer_prix_ttc(8000)
```

---

## 📝 Syntaxes des Fonctions

### 1. Syntaxe Complète (Recommandée)

```julia
function nom_fonction(parametre1, parametre2)
    # Corps de la fonction
    resultat = parametre1 + parametre2
    return resultat
end

# Utilisation
somme = nom_fonction(5, 3)  # 8
```

### 2. Syntaxe Compacte (Une Ligne)

```julia
# Pour les fonctions simples
carre(x) = x^2
double(x) = 2x  # Multiplication implicite

# Utilisation
resultat1 = carre(5)   # 25
resultat2 = double(4)  # 8
```

### 3. Fonctions Anonymes (Lambda)

```julia
# Syntaxe: paramètres -> expression
multiplier = (x, y) -> x * y
racine = x -> sqrt(x)

# Utilisation
produit = multiplier(6, 7)  # 42
racine_16 = racine(16)      # 4.0
```

---

## 🎨 Fonctions avec Applications Burkinabè

### Exemple 1: Convertisseur FCFA

```julia
# Conversion FCFA vers différentes devises
function fcfa_vers_euro(montant_fcfa)
    taux = 656  # 1 EUR = 656 FCFA
    return montant_fcfa / taux
end

function fcfa_vers_dollar(montant_fcfa)
    taux = 590  # 1 USD = 590 FCFA
    return montant_fcfa / taux
end

# Utilisation pratique
salaire_fcfa = 180000
salaire_euros = fcfa_vers_euro(salaire_fcfa)
println("Salaire: $(round(salaire_euros, digits=2)) €")
```

### Exemple 2: Calculateur de Récolte

```julia
function calculer_rendement(surface_hectares, production_kg)
    if surface_hectares <= 0
        println("Erreur: Surface doit être positive")
        return 0
    end
    return production_kg / surface_hectares
end

function estimer_revenus(surface_hectares, rendement_kg_ha, prix_kg)
    production_totale = surface_hectares * rendement_kg_ha
    revenus = production_totale * prix_kg
    return revenus
end

# Application concrète
surface_mais = 2.5  # hectares
rendement = calculer_rendement(surface_mais, 4500)  # kg
revenus = estimer_revenus(surface_mais, rendement, 200)  # FCFA/kg

println("Rendement: $rendement kg/ha")
println("Revenus estimés: $revenus FCFA")
```

---

## ⚙️ Paramètres et Arguments

### Arguments Positionnels

```julia
function presenter_personne(prenom, nom, age)
    println("Je m'appelle $prenom $nom et j'ai $age ans")
end

# L'ordre est important!
presenter_personne("Aminata", "Ouédraogo", 25)
# presenter_personne(25, "Aminata", "Ouédraogo")  # ❌ Erreur logique!
```

### Arguments Optionnels (Valeurs par Défaut)

```julia
function saluer(nom, moment="matin")
    if moment == "matin"
        println("Bonjour $nom!")
    elseif moment == "soir"
        println("Bonsoir $nom!")
    else
        println("Salut $nom!")
    end
end

# Utilisations flexibles
saluer("Paul")           # "Bonjour Paul!"
saluer("Marie", "soir")  # "Bonsoir Marie!"
saluer("Jean", "midi")   # "Salut Jean!"
```

### Arguments par Mots-Clés

```julia
function commander_repas(plat; boisson="eau", epice="normal", livraison=false)
    println("Commande: $plat")
    println("Boisson: $boisson")
    println("Épices: $epice")
    println("Livraison: $(livraison ? "Oui" : "Non")")
end

# Syntaxe claire et flexible
commander_repas("Riz sauce", boisson="bissap", epice="piquant")
commander_repas("Tô", livraison=true, boisson="dolo")
```

---

## 📊 Types de Retour

### Retour Simple

```julia
function calculer_moyenne(a, b, c)
    return (a + b + c) / 3
end

moyenne = calculer_moyenne(12, 15, 18)  # 15.0
```

### Retours Multiples (Tuples)

```julia
function analyser_notes(notes...)  # Varargs: nombre variable d'arguments
    moyenne = sum(notes) / length(notes)
    moy_minimum = minimum(notes)
    moy_maximum = maximum(notes)
    return moyenne, moy_minimum, moy_maximum  # Retourne un tuple
end

# Décomposition du tuple
moy, mini, maxi = analyser_notes(12, 15, 8, 17, 11)
println("Moyenne: $moy, Min: $mini, Max: $maxi")
```

### Retour Conditionnel

```julia
function evaluer_note(note)
    if note >= 16 # dans python : et l'indentation
        return "Très bien", "🏆"
    elseif note >= 14
        return "Bien", "👍"
    elseif note >= 10 # python => elif instead of elseif
        return "Assez bien", "👌"
    else
        return "Insuffisant", "📚"
    end # n'existe pas dans python
end

mention, emoji = evaluer_note(15)
println("Note 15/20 → $mention $emoji")
```

---

## 🔍 Fonctions Avancées

### Fonctions avec Validation

```julia
function diviser_securise(a, b)
    if b == 0
        println("⚠️ Erreur: Division par zéro impossible!")
        return nothing  # Type spécial Julia
    end
    return a / b
end

# Utilisation sécurisée
resultat = diviser_securise(10, 2)   # 5.0
resultat = diviser_securise(10, 0)   # nothing + message d'erreur
```

### Fonctions Récursives

```julia
function factorielle(n)
    if n <= 1
        return 1
    else
        return n * factorielle(n - 1)
    end
end

# Calcul élégant
fact_5 = factorielle(5)  # 120
println("5! = $fact_5")

# Version itérative pour comparaison
function factorielle_iterative(n)
    resultat = 1
    for i in 1:n
        resultat *= i
    end
    return resultat
end
```

---

## 🌍 Application Pratique: Système de Gestion Scolaire

```julia
# Module de gestion des notes d'étudiants burkinabè

function calculer_moyenne_ponderee(notes, coefficients)
    if length(notes) != length(coefficients)
        println("Erreur: Nombre de notes ≠ nombre de coefficients")
        return 0
    end

    somme_ponderee = 0
    somme_coefficients = 0

    for i in 1:length(notes)
        somme_ponderee += notes[i] * coefficients[i]
        somme_coefficients += coefficients[i]
    end

    return somme_ponderee / somme_coefficients
end

function determiner_mention(moyenne)
    if moyenne >= 16
        return "Très Bien"
    elseif moyenne >= 14
        return "Bien"
    elseif moyenne >= 12
        return "Assez Bien"
    elseif moyenne >= 10
        return "Passable"
    else
        return "Ajournement"
    end
end

function rapport_etudiant(nom, notes, coefficients, frais_scolarite=75000)
    moyenne = calculer_moyenne_ponderee(notes, coefficients)
    mention = determiner_mention(moyenne)

    println("=== BULLETIN DE $nom ===")
    println("Moyenne générale: $(round(moyenne, digits=2))/20")
    println("Mention: $mention")
    println("Frais de scolarité: $frais_scolarite FCFA")

    if moyenne >= 10
        reduction = moyenne > 14 ? 0.20 : 0.10
        nouveau_frais = frais_scolarite * (1 - reduction)
        println("Réduction mérite: $(reduction*100)%")
        println("Nouveaux frais: $(Int(nouveau_frais)) FCFA")
    end

    return moyenne, mention
end

# Utilisation du système
notes_aminata = [15, 12, 17, 14]
coefficients = [3, 2, 4, 2]  # Maths, Français, Sciences, Histoire

moyenne, mention = rapport_etudiant("Aminata KONE", notes_aminata, coefficients)
```

---

## 📚 Documentation des Fonctions

### Docstrings (Documentation Intégrée)

````julia
"""
    convertir_temperature(celsius)

Convertit une température de Celsius vers Fahrenheit.

# Arguments
- `celsius::Number`: Température en degrés Celsius

# Retour
- `Float64`: Température en degrés Fahrenheit

# Exemples
```julia-repl
julia> convertir_temperature(25)
77.0

julia> convertir_temperature(0)
32.0
````

"""
function convertir_temperature(celsius)
return celsius \* 9/5 + 32
end

# Utilisation de l'aide

?convertir_temperature # Affiche la documentation

````

---

## 💡 Bonnes Pratiques

### 1. Nommage des Fonctions

```julia
# ✅ BON - Noms explicites et verbes d'action
calculer_prix_total(prix, tva)
verifier_age_majeur(age)
formatter_numero_telephone(numero)

# ❌ MAUVAIS - Noms ambigus ou non descriptifs
calc(p, t)
check(a)
format(n)
````

### 2. Une Fonction, Une Responsabilité

```julia
# ✅ BON - Responsabilités séparées
function calculer_tva(prix_ht, taux_tva)
    return prix_ht * taux_tva
end

function formatter_prix(prix)
    return "$(round(prix, digits=2)) FCFA"
end

# ❌ MAUVAIS - Fonction qui fait trop de choses
function calculer_et_afficher_prix_complet(prix_ht, taux_tva, devise)
    # Calcul + formatage + affichage = trop de responsabilités!
end
```

### 3. Gestion des Erreurs

```julia
function diviser(a, b)
    if !isa(a, Number) || !isa(b, Number)
        throw(ArgumentError("Arguments doivent être des nombres"))
    end
    if b == 0
        throw(DivideError())
    end
    return a / b
end
```

---

## 🎯 Points Clés à Retenir

1. **DRY (Don't Repeat Yourself)** - Les fonctions évitent la répétition
2. **Paramètres par défaut** - Rendent les fonctions flexibles
3. **Return explicite** - Clarté sur ce qui est retourné
4. **Documentation** - Les docstrings expliquent l'utilisation
5. **Tests simples** - Vérifiez vos fonctions avec des exemples

---

## 🚀 Prochaines Étapes

Dans la prochaine session, nous explorerons:

- Les tableaux et collections
- Fonctions sur les tableaux
- Compréhensions de liste
- Manipulation de données structurées

---

## 📝 Notes pour l'Instructeur

### Démonstrations Live Recommandées:

1. Créer une fonction de conversion FCFA/Euro ensemble
2. Montrer les erreurs communes (oubli du `return`)
3. Démontrer l'aide avec `?nom_fonction`
4. Comparaison performance récursif vs itératif

### Exercices Interactifs:

- Fonction de calcul d'âge à partir de date de naissance
- Calculateur d'intérêts composés
- Validateur de numéro de téléphone burkinabè

### Points d'Attention:

- Les étudiants oublient souvent le mot-clé `return`
- Confusion entre paramètres et arguments
- Importance de l'ordre des paramètres positionnels
- Différence entre `print` et `return`
