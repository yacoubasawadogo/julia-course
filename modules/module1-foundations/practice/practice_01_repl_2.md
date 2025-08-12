# 🎯 Pratique Guidée 2: Types et Fonctions Mathématiques
**Module 1 - Session 1** | **Durée: 15 minutes**

---

## 🔍 Exercice 1: Exploration des Types

### Démonstration interactive:
```julia
# Montrer et faire deviner les types
typeof(100)           # Int64
typeof(3.14159)       # Float64
typeof("Burkina")     # String
typeof('B')           # Char
typeof(true)          # Bool
```

### Jeu interactif:
> **"Devinez le type!"** - Affichez une valeur, les étudiants prédisent le type, puis vérifiez ensemble.

### Points clés à souligner:
- `100` vs `100.0` → Types différents!
- `"B"` vs `'B'` → String vs Char
- Julia devine automatiquement les types

---

## 🧮 Exercice 2: Fonctions Mathématiques

### Démonstrations live:
```julia
# Fonctions de base
sqrt(144)        # 12.0
abs(-25)         # 25
round(3.7)       # 4.0
floor(9.8)       # 9.0  
ceil(2.1)        # 3.0
```

### Challenge interactif:
> **"Calculatrice humaine vs Julia"** - Donnez des calculs mentaux puis vérifiez avec Julia.

### Applications pratiques:
```julia
# Distance entre deux points (Ouaga-Bobo)
distance_km = sqrt((12.3-11.2)^2 + (-1.5-(-4.3))^2) * 111  # km approximatifs
println("Distance approximative: $(round(distance_km)) km")
```

---

## 🔄 Exercice 3: Conversions de Types

### Démonstrations avec pièges:
```julia
# Conversions simples
Int(5.0)           # 5 ✓
Float64(10)        # 10.0 ✓
string(42)         # "42" ✓

# Attention aux pièges!
Int(5.9)           # 5 (troncature!)
# Int("42")        # ERREUR! Utiliser parse()
parse(Int, "42")   # 42 ✓
```

### Point pédagogique important:
> **Troncature vs Arrondissement:** `Int(5.9)` donne `5`, pas `6`!

---

## 🌍 Exercice 4: Application Géométrique

### Contexte: Parcelle agricole circulaire

```julia
# Données d'un champ au Burkina Faso
rayon_metres = 25
π_julia = π  # Julia a π intégré!

# Calculs ensemble
circonference = 2 * π * rayon_metres
surface = π * rayon_metres^2

println("Circonférence: $(round(circonference, digits=1)) m")
println("Surface: $(round(surface, digits=1)) m²")
```

### Questions d'engagement:
- "Combien d'hectares fait ce champ?" (surface ÷ 10000)
- "Combien de temps pour faire le tour à pied?" (circonférence ÷ vitesse)

---

## ➗ Exercice 5: Division Entière et Reste

### Scénario concret:
```julia
# Distribution équitable de mangues
total_mangues = 47
nombre_enfants = 5

# Division entière
mangues_par_enfant = total_mangues ÷ 5     # ou div(47, 5)
mangues_restantes = total_mangues % 5      # modulo

println("Chaque enfant reçoit: $mangues_par_enfant mangues")
println("Mangues restantes: $mangues_restantes")
```

### Vérification ludique:
> Faites calculer: `mangues_par_enfant * nombre_enfants + mangues_restantes`
> Doit égaler `total_mangues`!

---

## 🎮 Mini-Quiz Interactif

### Questions rapides (réponse à main levée):
1. `typeof(10/2)` → Float64 ou Int64?
2. Quelle fonction arrondit vers le bas?
3. Comment calculer la racine carrée de 16?
4. `Int(3.8)` donne quoi?

### Correction collective avec explications

---

## 🏆 Défi Bonus: Triangle Rectangle

### Challenge mathématique:
```julia
# Théorème de Pythagore
cote_a = 3
cote_b = 4

# Les étudiants proposent la formule
hypotenuse = sqrt(cote_a^2 + cote_b^2)
```

### Extension amusante:
> "Ce triangle a des côtés 3-4-5. Comment appelle-t-on ce triangle spécial?"

---

## 🎨 Bonus: Symboles Unicode

### Démonstration magique:
```julia
# Tapez \pi puis Tab
π           # 3.141592653589793

# Tapez \sqrt puis Tab  
√16         # 4.0

# Autres symboles utiles
α = 0.5     # \alpha + Tab
β = 1.5     # \beta + Tab
```

### Réaction attendue:
> "Wow! Julia supporte les vrais symboles mathématiques!"

---

## ✅ Récapitulatif Rapide

**Ce qu'on vient d'apprendre:**
- ✅ Identifier les types avec `typeof()`
- ✅ Utiliser les fonctions mathématiques
- ✅ Convertir entre types
- ✅ Division entière vs division normale
- ✅ Symboles Unicode mathématiques

**Prochaine étape:** "Maintenant, créons nos propres fonctions!"