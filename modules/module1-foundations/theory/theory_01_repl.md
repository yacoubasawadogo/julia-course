# 📚 Module 1 - Session 1: Le REPL Julia et les Bases

**Durée: 2 heures** | **Niveau: Débutant**

---

## 🎯 Objectifs de la Session

À la fin de cette session, vous serez capable de:

- ✅ Naviguer dans le REPL Julia avec confiance
- ✅ Effectuer des calculs arithmétiques de base
- ✅ Créer et manipuler des variables
- ✅ Utiliser le système d'aide intégré
- ✅ Comprendre les types de base en Julia

---

## 🔍 Qu'est-ce que le REPL?

### REPL = Read-Eval-Print-Loop

1. **Read** (Lire): Julia lit votre commande
2. **Eval** (Évaluer): Julia exécute votre code
3. **Print** (Afficher): Julia montre le résultat
4. **Loop** (Boucler): Julia attend la prochaine commande

### 💡 Pourquoi le REPL est Important?

- **Expérimentation rapide** sans créer de fichiers
- **Feedback immédiat** sur votre code
- **Exploration interactive** des fonctions
- **Débogage en temps réel**
- **Apprentissage par la pratique**

---

## ⚡ Les Modes du REPL

### Mode Julia (par défaut)

```julia
julia> 2 + 2
4
```

### Mode Aide (`?`)

```julia
help?> println
# Affiche la documentation de println
```

### Mode Shell (`;`)

```julia
shell> ls
# Execute des commandes système
```

### Mode Package (`]`)

```julia
pkg> add DataFrames
# Gère les packages Julia
```

**Navigation:** Appuyez sur `Backspace` pour revenir au mode Julia

---

## 🧮 Arithmétique de Base

### Opérateurs Fondamentaux

| Opération        | Symbole | Exemple  | Résultat |
| ---------------- | ------- | -------- | -------- |
| Addition         | `+`     | `5 + 3`  | `8`      |
| Soustraction     | `-`     | `10 - 4` | `6`      |
| Multiplication   | `*`     | `3 * 7`  | `21`     |
| Division         | `/`     | `15 / 3` | `5.0`    |
| Division entière | `÷`     | `17 ÷ 5` | `3`      |
| Modulo           | `%`     | `17 % 5` | `2`      |
| Puissance        | `^`     | `2^10`   | `1024`   |

### Fonctions Mathématiques Utiles

```julia
sqrt(16)        # Racine carrée: 4.0
abs(-5)         # Valeur absolue: 5
round(3.7)      # Arrondi: 4.0
floor(3.7)      # Arrondi inférieur: 3.0
ceil(3.2)       # Arrondi supérieur: 4.0
```

---

## 📦 Variables et Affectation

### Création de Variables

```julia
# Variables numériques
age = 25
prix_fcfa = 1500.50
pi_approx = 3.14159

# Variables texte
nom = "Ouédraogo"
ville = "Ouagadougou"

# Variables booléennes
est_etudiant = true
a_termine = false
```

### Conventions de Nommage

✅ **Bonnes pratiques:**

- `nombre_etudiants`
- `prix_total_fcfa`
- `temperature_celsius`

❌ **À éviter:**

- `2nombre` (ne peut pas commencer par un chiffre)
- `prix-total` (tiret non autorisé)
- Mots réservés (`if`, `for`, `function`)

### La Variable Spéciale `ans`

```julia
julia> 10 + 10
20

julia> ans * 2
40

julia> ans / 5
8.0
```

`ans` stocke toujours le dernier résultat calculé!

---

## 🎨 Types de Base

### Types Numériques

```julia
# Entiers
nombre_entier = 42
typeof(nombre_entier)  # Int64

# Flottants
nombre_decimal = 3.14
typeof(nombre_decimal)  # Float64

# Complexes
nombre_complexe = 2 + 3im
typeof(nombre_complexe)  # Complex{Int64}
```

### Types Texte

```julia
# Caractère unique
lettre = 'A'
typeof(lettre)  # Char

# Chaîne de caractères
phrase = "Bienvenue au Burkina Faso!"
typeof(phrase)  # String
```

### Type Booléen

```julia
vrai = true
faux = false
typeof(vrai)  # Bool
```

---

## 🌍 Applications Pratiques

### Exemple 1: Conversion FCFA ↔ Euro

```julia
# Taux de change (1 Euro = 656 FCFA)
taux_euro_fcfa = 656

# Conversion Euro vers FCFA
euros = 10
fcfa = euros * taux_euro_fcfa
println("$euros € = $fcfa FCFA")

# Conversion FCFA vers Euro
montant_fcfa = 5000
montant_euros = montant_fcfa / taux_euro_fcfa
println("$montant_fcfa FCFA = $(round(montant_euros, digits=2)) €")
```

### Exemple 2: Calcul de Surface Agricole

```julia
# Parcelle rectangulaire
longueur_m = 50
largeur_m = 30
surface_m2 = longueur_m * largeur_m
surface_hectares = surface_m2 / 10000

println("Surface: $surface_m2 m² ou $surface_hectares hectares")
```

---

## 💡 Astuces du REPL

### Navigation dans l'Historique

- `↑` : Commande précédente
- `↓` : Commande suivante
- `Ctrl+R` : Recherche dans l'historique

### Raccourcis Utiles

- `Tab` : Autocomplétion
- `Ctrl+C` : Interrompre l'exécution
- `Ctrl+D` : Quitter Julia
- `Ctrl+L` : Effacer l'écran

### Unicode et Symboles Mathématiques

```julia
# Tapez \pi puis Tab
π  # 3.141592653589793

# Tapez \sqrt puis Tab
√16  # 4.0

# Tapez \alpha puis Tab
α = 0.5
```

---

## 🎯 Points Clés à Retenir

1. **Le REPL est votre laboratoire** - Expérimentez sans crainte!
2. **Julia est expressif** - Le code ressemble aux maths
3. **Les types sont automatiques** - Julia devine le type
4. **L'aide est intégrée** - Utilisez `?` généreusement
5. **`ans` est votre ami** - Pour les calculs en chaîne

---

## 🚀 Prochaines Étapes

Dans la prochaine session, nous approfondirons:

- Les structures de contrôle (if, else)
- Les boucles (for, while)
- Les fonctions personnalisées
- Les tableaux et collections

---

## 📝 Notes Importantes

### Démonstrations Live Recommandées:

1. Montrer les 4 modes du REPL
2. Calculer le prix d'un sac de riz en FCFA
3. Explorer une fonction avec `?`
4. Utiliser l'autocomplétion avec Tab
5. Montrer des erreurs communes et comment les corriger

### Questions d'Interaction:

- "Qui peut calculer 2^10 de tête?"
- "Quel est le type de 3.0?"
- "Comment vérifier le type d'une variable?"

### Piège Courant:

Les étudiants oublient souvent que Julia utilise l'indexation base 1 (pas base 0 comme Python/C)
