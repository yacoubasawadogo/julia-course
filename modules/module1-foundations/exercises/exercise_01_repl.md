# 📝 Exercice Principal: Maîtrise du REPL Julia
**Module 1 - Session 1** | **Durée: 30 minutes** | **Points: 100**

---

## 📋 Instructions pour les Étudiants

- Ouvrez Julia et travaillez directement dans le REPL
- Complétez chaque section dans l'ordre
- Notez vos réponses pour vérification
- Levez la main si vous êtes bloqué
- **Total: 100 points + bonus possible**

---

## Section 1: Calculs Financiers (20 points)

### Contexte: Commerce à Bobo-Dioulasso

Un commerçant vend les produits suivants:
- Sac de riz (50kg): **25000 FCFA**
- Bidon d'huile (20L): **18000 FCFA**  
- Carton de savon: **12000 FCFA**

### 📝 Tâches à réaliser:

1. **Créez des variables** pour chaque prix
2. **Un client achète:** 2 sacs de riz, 1 bidon d'huile, 3 cartons de savon
3. **Calculez le total** à payer
4. **Le client paie** avec 100000 FCFA. Calculez la monnaie à rendre

### Réponses attendues:
```
Prix total: _____ FCFA
Monnaie: _____ FCFA
```

---

## Section 2: Données Agricoles (20 points)

### Contexte: Rendements d'une exploitation

Un agriculteur a les rendements suivants (kg/hectare):
- **Maïs:** 1250.5
- **Mil:** 890.75  
- **Sorgho:** 1100.25
- **Riz:** 2500.0

### 📝 Tâches à réaliser:

1. **Stockez** chaque rendement dans une variable
2. **Calculez** le rendement moyen
3. **Trouvez** le rendement maximum (utilisez `max()`)
4. **Si le prix moyen est 150 FCFA/kg**, calculez la valeur totale par hectare

### Réponses attendues:
```
Rendement moyen: _____ kg/ha
Rendement maximum: _____ kg/ha
Valeur totale/hectare: _____ FCFA
```

---

## Section 3: Conversions et Types (20 points)

### 📝 Complétez les conversions suivantes:

1. **Température:** 35°C en Fahrenheit (formule: F = C × 9/5 + 32)
2. **Distance:** 150 km en miles (1 km = 0.621371 miles)
3. **Poids:** 75 kg en livres (1 kg = 2.20462 livres)  
4. **Surface:** 5 hectares en m² (1 hectare = 10000 m²)

### Instructions spéciales:
- Utilisez `typeof()` pour vérifier le type de chaque résultat
- Arrondissez à 2 décimales avec `round(valeur, digits=2)` si nécessaire

### Réponses attendues:
```
35°C = _____ °F (type: _____)
150 km = _____ miles (type: _____)  
75 kg = _____ livres (type: _____)
5 ha = _____ m² (type: _____)
```

---

## Section 4: Fonctions Mathématiques (20 points)

### Contexte: Puits cylindrique

Un puits a les dimensions suivantes:
- **Rayon:** 1.5 mètres
- **Profondeur:** 12 mètres

### 📝 Calculez:

1. **Circonférence** du puits (C = 2πr)
2. **Surface de l'ouverture** (A = πr²)  
3. **Volume d'eau maximal** (V = πr²h)
4. **Capacité en litres** (1 m³ = 1000 litres)

### Note importante:
Utilisez `π` de Julia (pas 3.14) pour plus de précision

### Réponses attendues:
```
Circonférence: _____ m
Surface ouverture: _____ m²
Volume: _____ m³  
Capacité: _____ litres
```

---

## Section 5: Logique et Comparaisons (20 points)

### 📝 Évaluez ces expressions (true/false):

1. `10 > 5 && 3 < 7`
2. `100 == 100.0`
3. `"Julia" < "Python"` (ordre alphabétique)
4. `typeof(5) == typeof(5.0)`
5. `sqrt(16) == 4`
6. `10 % 3 == 1`
7. `2^10 > 1000`
8. `'A' < 'a'` (code ASCII)

### Réponses attendues:
```
1. _____    5. _____
2. _____    6. _____  
3. _____    7. _____
4. _____    8. _____
```

---

## 🏆 Défi Bonus (+10 points)

### Mini-programme interactif

Créez un programme qui:
1. Demande le nom de l'utilisateur avec `readline()`
2. Demande son année de naissance  
3. Calcule son âge en 2024
4. Affiche un message personnalisé

### Code de démarrage:
```julia
print("Votre nom: ")
nom = readline()
# Continuez ici...
```

### Exemple de sortie:
```
"Bonjour Aminata! Vous avez 25 ans en 2024."
```

---

## 📊 Auto-évaluation

### Cochez les compétences maîtrisées:

- [ ] Je peux créer et manipuler des variables
- [ ] Je connais les types de base de Julia  
- [ ] Je peux effectuer des calculs mathématiques
- [ ] Je peux utiliser les fonctions mathématiques
- [ ] Je comprends les opérateurs logiques
- [ ] Je peux convertir entre différents types
- [ ] Je peux utiliser le système d'aide (?)
- [ ] Je peux naviguer dans l'historique du REPL

---

## ✅ Remise du Travail

**Quand vous avez terminé:**
1. Vérifiez vos réponses avec la solution
2. Calculez votre score total (/100)
3. Identifiez les points à retravailler
4. Préparez-vous pour la session suivante!

**Fichier de correction:** `solution_exercise_01_repl.jl`