# 📝 Exercice Principal: Variables, Types et Contrôle
**Module 1 - Session 2** | **Durée: 30 minutes** | **Points: 100**

---

## 📋 Instructions pour les Étudiants

- Travaillez dans le REPL Julia
- Testez chaque morceau de code avant de passer au suivant  
- Utilisez `typeof()` pour vérifier vos types
- Notez vos réponses pour vérification
- **Total: 100 points + bonus**

---

## Section 1: Système de Types (25 points)

### Partie A: Identification de Types (10 points)

Pour chaque expression, déterminez le type **avant** d'exécuter:

```julia
# Prédisez puis vérifiez avec typeof()
expression1 = 42
expression2 = 42.0  
expression3 = "42"
expression4 = '4'
expression5 = 42 == 42.0
```

**Réponses:**
```
expression1: _____ 
expression2: _____
expression3: _____
expression4: _____
expression5: _____
```

### Partie B: Conversions et Pièges (15 points)

Prédisez le résultat de ces conversions:

```julia
# Attention aux pièges!
conv1 = Int(7.9)
conv2 = Float64(10)
conv3 = parse(Int, "123")
conv4 = string(456) 
conv5 = Char(65)
```

**Réponses:**
```
conv1: _____ (attention: troncature!)
conv2: _____
conv3: _____
conv4: _____  
conv5: _____
```

---

## Section 2: Application - Profil Étudiant (25 points)

### Contexte: Base de données étudiants

Créez le profil d'un étudiant burkinabè avec les types appropriés:

```julia
# Complétez avec vos informations
prenom = # Votre prénom (String)
nom = # Votre nom (String) 
age = # Votre âge (Int)
moyenne_generale = # Ex: 14.5 (Float64)
ville_origine = # Ex: "Koudougou" (String)
bourse = # true/false (Bool)
frais_scolarite = # Ex: 75000 (Int - FCFA)
```

### Calculs demandés:

1. **Statut:** Majeur si âge ≥ 18, sinon Mineur
2. **Mention:** "Bien" si moyenne ≥ 14, "Assez Bien" si ≥ 12, sinon "Passable"
3. **Aide financière:** Si bourse ET frais > 50000, "Aide complète", sinon "Aide partielle"

**Code à écrire:**
```julia
# Utilisez des conditions if-else et opérateurs ternaires
statut = # age >= 18 ? "Majeur" : "Mineur"
mention = # Conditions multiples
aide = # Logique combinée
```

---

## Section 3: Contrôle de Flux - Gestion de Stock (25 points)

### Contexte: Boutique de téléphones

Un commerçant gère son stock de téléphones:

```julia
# Stock initial
stock_samsung = 15
stock_iphone = 8  
stock_tecno = 25
prix_samsung = 125000    # FCFA
prix_iphone = 450000     # FCFA
prix_tecno = 75000       # FCFA
```

### Tâches à programmer:

#### A) Vérificateur de disponibilité (10 points)
```julia
# Créez une fonction de vérification
telephone_demande = "Samsung"  # Changez pour tester
quantite_demandee = 3

# Utilisez if-elseif-else pour vérifier
# si le stock est suffisant et calculer le prix total
```

#### B) Système d'alerte stock faible (8 points)
```julia
# Pour chaque produit, affichez une alerte si stock < 10
# Utilisez des boucles et conditions
```

#### C) Calculateur de valeur totale (7 points)
```julia
# Calculez la valeur totale du stock
# (quantité × prix pour chaque produit)
```

---

## Section 4: Boucles et Accumulation (25 points)

### A) Générateur de tables de multiplication (10 points)

Créez un programme qui affiche la table de multiplication de 7:

```julia
# Utilisez une boucle for
# Format: "7 × 1 = 7", "7 × 2 = 14", etc.
# Jusqu'à 7 × 12
```

### B) Calculateur de moyennes (15 points)

Un professeur a les notes suivantes: 12, 15, 8, 17, 11, 14, 9, 16

```julia
# Stockez les notes dans des variables séparées
note1 = 12
note2 = 15
# ... etc

# Calculez:
# 1. La somme totale (avec une approche répétitive)
# 2. Le nombre de notes
# 3. La moyenne
# 4. Le nombre d'étudiants avec note ≥ moyenne
```

**Bonus:** Utilisez une boucle while pour compter les notes supérieures à la moyenne.

---

## 🏆 Défi Bonus: Simulateur de Croissance (+15 points)

### Contexte: Épargne avec intérêts composés

Un étudiant épargne pour ses études:

```julia
capital_initial = 50000      # FCFA
taux_interet = 0.08         # 8% par an
objectif = 100000           # FCFA
```

### Programme à créer:

1. **Simulez** année par année la croissance du capital
2. **Comptez** combien d'années nécessaires pour atteindre l'objectif  
3. **Affichez** le progression chaque année
4. **Utilisez** une boucle while avec condition d'arrêt

**Format de sortie attendu:**
```
Année 1: 54000 FCFA
Année 2: 58320 FCFA
...
Objectif atteint en X années!
```

**Formule:** nouveau_capital = ancien_capital × (1 + taux_interet)

---

## 📊 Grille d'Auto-évaluation

### Compétences techniques (cochez si maîtrisé):

- [ ] J'identifie correctement les types Julia
- [ ] Je convertis entre types sans erreur
- [ ] J'utilise if-elseif-else appropriément
- [ ] Je crée des boucles for efficaces
- [ ] Je contrôle des boucles while
- [ ] J'combine des opérateurs logiques
- [ ] J'utilise l'opérateur ternaire
- [ ] Je debug mes erreurs de syntaxe

### Compétences pratiques:

- [ ] Je modélise des données avec les bons types
- [ ] J'applique la logique métier avec des conditions
- [ ] Je valide des entrées utilisateur
- [ ] Je structure mon code clairement

---

## ✅ Finalisation

**Score attendu:**
- Section 1: ___/25
- Section 2: ___/25  
- Section 3: ___/25
- Section 4: ___/25
- Bonus: ___/15
- **Total: ___/115**

**Prochaine étape:** Session 3 - Fonctions et modularité

**Correction:** `solution_exercise_02_types.jl`