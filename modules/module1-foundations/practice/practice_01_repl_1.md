# 🎯 Pratique Guidée 1: Exploration du REPL
**Module 1 - Session 1** | **Durée: 15 minutes**

---

## 🎮 Exercice 1: Calculs de Base

Demandez aux étudiants de calculer les expressions suivantes dans le REPL:

### À faire dans le REPL:
```julia
# a) Addition simple
15 + 27

# b) Soustraction
100 - 33

# c) Multiplication
8 * 12

# d) Division
144 / 12

# e) Puissance
2^8
```

### Questions interactives:
- "Qui peut me dire le résultat de 15 + 27 sans calculer?"
- "Quelle différence voyez-vous entre 144/12 et 144÷12?"

---

## 🎮 Exercice 2: Création de Variables

### Démonstration live:
```julia
# Variables personnelles
nom = "Ouédraogo"
age = 22
taille_cm = 175

# Conversion
taille_m = taille_cm / 100
```

### À faire ensemble:
- Chaque étudiant crée ses propres variables
- Calculer leur taille en mètres
- Afficher avec `println("Je mesure $taille_m m")`

---

## 🎮 Exercice 3: La Variable Magique `ans`

### Séquence guidée:
```julia
# Étape 1
50 + 50        # Résultat: 100

# Étape 2  
ans * 2        # ans vaut maintenant 100, résultat: 200

# Étape 3
ans / 10       # ans vaut maintenant 200, résultat: 20
```

### Point pédagogique:
> `ans` stocke **toujours** le dernier résultat calculé. C'est très pratique pour les calculs en chaîne!

---

## 🎮 Exercice 4: Conversion Monétaire FCFA

### Contexte burkinabè:
**Taux de change: 1 Euro = 656 FCFA**

### Calculs guidés:
```julia
# Définir le taux
taux_euro_fcfa = 656

# Conversion 1: Euros vers FCFA
euros = 25
fcfa = euros * taux_euro_fcfa
println("$euros € = $fcfa FCFA")

# Conversion 2: FCFA vers Euros  
montant_fcfa = 10000
euros = montant_fcfa / taux_euro_fcfa
euros_arrondi = round(euros, digits=2)
println("$montant_fcfa FCFA = $euros_arrondi €")
```

---

## 🏆 Mini-Défi: Prix d'un Repas

### Scénario:
Un étudiant va au restaurant et commande:
- Riz: 500 FCFA
- Sauce: 300 FCFA  
- Viande: 1000 FCFA
- Boisson: 250 FCFA

### Challenge:
```julia
# À faire ensemble
prix_riz = 500
prix_sauce = 300
prix_viande = 1000
prix_boisson = 250

# Calcul du total
total = # Les étudiants proposent le calcul
```

---

## 💡 Conseil Pro

**Navigation dans l'historique:**
- `↑` et `↓` pour naviguer dans l'historique
- `Tab` pour l'autocomplétion
- `?` devant une fonction pour voir l'aide

### Démonstration:
```julia
?println  # Montrer l'aide intégrée
?sqrt     # Explorer une fonction mathématique
```

---

## ✅ Validation des Acquis

**Questions rapides:**
1. Comment afficher "Bonjour Burkina" dans le REPL?
2. Que contient `ans` après avoir tapé `5 * 6`?  
3. Comment convertir 50 dollars en FCFA (1$ = 590 FCFA)?

**Transition:** "Maintenant que vous maîtrisez les calculs de base, explorons les types de données..."