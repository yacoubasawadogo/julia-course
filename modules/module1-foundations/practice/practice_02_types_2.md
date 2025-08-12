# 🎯 Pratique Guidée 2: Structures de Contrôle avec Types
**Module 1 - Session 2** | **Durée: 20 minutes**

---

## 🔀 Exercice 1: Instructions Conditionnelles

### Démonstration live - Catégorie d'âge:
```julia
# Exemple concret
age = 25

if age < 18
    println("Mineur - École obligatoire")
elseif age < 65  
    println("Adulte actif - Âge de travailler")
else
    println("Senior - Âge de la sagesse")
end
```

### Test interactif avec les étudiants:
> Demandez différents âges et faites prédire la catégorie avant d'exécuter

```julia
# Tests suggérés:
age = 15   # → "Mineur"
age = 30   # → "Adulte actif" 
age = 70   # → "Senior"
```

### Applications burkinabè:
```julia
# Système électoral burkinabè
age_citoyen = 22

if age_citoyen >= 18
    println("Peut voter aux élections")
    if age_citoyen >= 35
        println("Peut être candidat président")
    end
else
    println("Trop jeune pour voter")
end
```

---

## 🔄 Exercice 2: Boucles For Polyvalentes

### Boucle simple avec range:
```julia
# Compter de 1 à 5
for i in 1:5
    println("Étape $i terminée")
end
```

### Boucle avec pas personnalisé:
```julia
# Températures par paliers de 5°C
for temperature in 20:5:40
    println("$temperature°C - ", temperature > 35 ? "Très chaud" : "Acceptable")
end
```

### Parcourir une chaîne:
```julia
# Épeler "BURKINA"
for lettre in "BURKINA"
    println("Lettre: $lettre")
end
```

### Challenge pour les étudiants:
> "Créez une boucle qui affiche les multiples de 3 de 3 à 30"

```julia
# Solution attendue:
for multiple in 3:3:30
    println(multiple)
end
# Ou alternative:
for i in 1:10
    println(i * 3)
end
```

---

## ⏰ Exercice 3: Boucles While Dynamiques

### Compteur simple:
```julia
compteur = 1
while compteur <= 10
    println("Compte à rebours: $(11 - compteur)")
    compteur += 1
end
println("Décollage! 🚀")
```

### Challenge mathématique:
> "Calculez la somme 1+2+3+...+100 avec une boucle while"

```julia
# Guide pour les étudiants:
somme = 0
i = 1
while i <= 100
    somme += i
    i += 1
end
println("Somme = $somme")  # Doit être 5050
```

### Vérification ludique:
> "Gauss a trouvé une formule: n(n+1)/2. Vérifions avec 100(101)/2 = 5050 ✓"

---

## ⚡ Exercice 4: Opérateur Ternaire Magique

### Syntaxe: `condition ? si_vrai : si_faux`

```julia
# Exemple de base
age = 20
statut = age >= 18 ? "Majeur" : "Mineur"
println("Statut: $statut")
```

### Exercices dirigés:

#### a) Parité d'un nombre:
```julia
nombre = 7
parite = nombre % 2 == 0 ? "Pair" : "Impair"
println("$nombre est $parite")
```

#### b) Évaluation scolaire:
```julia
note = 15
resultat = note >= 10 ? "Réussi 🎉" : "Échec 😞"
println("Note $note/20 → $resultat")
```

#### c) Météo burkinabè:
```julia
temperature = 38
confort = temperature > 35 ? "Très chaud 🌡️" : temperature > 25 ? "Chaud ☀️" : "Agréable 😊"
println("$temperature°C → $confort")
```

---

## 💰 Exercice 5: Convertisseur de Devises Intelligent

### Système de conversion FCFA:
```julia
# Taux de change actuels
taux_euro = 656     # 1 EUR = 656 FCFA
taux_dollar = 590   # 1 USD = 590 FCFA

montant_fcfa = 100000
devise_cible = "EUR"  # Changez pour tester

if devise_cible == "EUR"
    montant_converti = montant_fcfa / taux_euro
    println("$montant_fcfa FCFA = $(round(montant_converti, digits=2)) €")
elseif devise_cible == "USD"
    montant_converti = montant_fcfa / taux_dollar
    println("$montant_fcfa FCFA = $(round(montant_converti, digits=2)) \$")
else
    println("Devise '$devise_cible' non supportée")
    println("Devises disponibles: EUR, USD")
end
```

### Tests interactifs:
- `devise_cible = "EUR"` → 152.44 €
- `devise_cible = "USD"` → 169.49 $
- `devise_cible = "GBP"` → Message d'erreur

---

## 🎭 Exercice 6: Opérateurs Logiques Combinés

### Scénario: Éligibilité taxi-brousse
```julia
age = 25
a_permis = true
experience_annees = 3
casier_propre = true

# Conditions multiples
peut_conduire_taxi = (age >= 21) && a_permis && (experience_annees >= 2) && casier_propre

println("Éligible taxi-brousse: $peut_conduire_taxi")

# Détail des vérifications
println("✓ Âge ≥ 21: $(age >= 21)")
println("✓ A le permis: $a_permis") 
println("✓ Expérience ≥ 2 ans: $(experience_annees >= 2)")
println("✓ Casier propre: $casier_propre")
```

### Autres applications:
```julia
# Réduction étudiant/senior
age = 22
reduction_age = (age < 26) || (age > 65)
println("Éligible réduction: $reduction_age")

# Crédit bancaire
revenus = 200000  # FCFA/mois
a_dettes = false
eligible_credit = (age >= 18) && (age <= 65) && (revenus >= 150000) && !a_dettes
println("Éligible crédit: $eligible_credit")
```

---

## 🌤️ Challenge Final: Analyseur Météo Intelligent

### Système complet d'analyse:
```julia
# Données météo du jour
temperature = 35
humidite = 80
pluie = false
vent_kmh = 15

# Analyse de la température
if temperature > 35
    message_temp = "Très chaud"
elseif temperature >= 25
    message_temp = "Chaud" 
else
    message_temp = "Modéré"
end

# Ajout conditions secondaires
if humidite > 70
    message_temp = message_temp * " et humide"
end

if pluie
    message_temp = message_temp * " avec pluie"
elseif vent_kmh > 20
    message_temp = message_temp * " et venteux"
end

# Conseil activité
conseil = if temperature > 35
    "Restez à l'ombre! 🏠"
elseif pluie
    "Prenez un parapluie ☔"
else
    "Parfait pour sortir! 🌞"
end

println("Météo: $message_temp")
println("Conseil: $conseil")
```

### Résultat attendu:
```
Météo: Chaud et humide
Conseil: Parfait pour sortir! 🌞
```

---

## ✅ Points Clés Maîtrisés

**Structures de contrôle:**
- ✅ `if-elseif-else` pour les conditions multiples
- ✅ `for` avec ranges et chaînes
- ✅ `while` avec conditions dynamiques
- ✅ Opérateur ternaire `? :`

**Opérateurs logiques:**
- ✅ `&&` (ET), `||` (OU), `!` (NON)
- ✅ Comparaisons `==`, `!=`, `<`, `>`, `<=`, `>=`

**Bonnes pratiques:**
- ✅ Indentation pour la lisibilité
- ✅ Noms de variables explicites
- ✅ Messages utilisateur clairs

**Transition:** "Avec ces outils, nous pouvons maintenant créer des fonctions réutilisables!"