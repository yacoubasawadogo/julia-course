# 🎯 Pratique Guidée 1: Exploration des Types Julia
**Module 1 - Session 2** | **Durée: 15 minutes**

---

## 🔍 Exercice 1: Types Fondamentaux

### Jeu de prédiction interactive:
> Affichez chaque valeur et demandez aux étudiants de prédire le type avant de vérifier!

```julia
# À faire ensemble dans le REPL
typeof(42)              # Prédiction: _____ → Int64
typeof(3.14159)         # Prédiction: _____ → Float64
typeof("Burkina Faso")  # Prédiction: _____ → String
typeof('F')             # Prédiction: _____ → Char
typeof(true)            # Prédiction: _____ → Bool
typeof(2 + 3im)         # Prédiction: _____ → Complex{Int64}
```

### Points pédagogiques clés:
- **Entier vs Flottant:** `42` vs `42.0` → types différents!
- **String vs Char:** `"F"` vs `'F'` → guillemets vs apostrophes
- **Complexes:** Julia supporte nativement les nombres complexes

---

## 🔢 Exercice 2: Précision des Types Numériques

### Comparaisons révélatrices:
```julia
# Montrez les différences subtiles
typeof(1)           # Int64
typeof(1.0)         # Float64 - même valeur, type différent!

# Types numériques spécialisés
typeof(1f0)         # Float32 (notation f0)
typeof(UInt8(255))  # UInt8 (entier non-signé 8-bit)
typeof(Int8(127))   # Int8 (entier signé 8-bit)
```

### Investigation sur la taille:
```julia
# Exploration de la mémoire
sizeof(Int32)       # 4 octets
sizeof(Int64)       # 8 octets  
sizeof(Float32)     # 4 octets
sizeof(Float64)     # 8 octets
```

### Question d'engagement:
> "Pourquoi utiliser Int8 au lieu de Int64?" (Économie mémoire pour gros datasets)

---

## 🔄 Exercice 3: Conversions avec Pièges

### Conversions simples:
```julia
# Conversions évidentes
Int(5.0)           # 5 ✓
Float64(10)        # 10.0 ✓
string(42)         # "42" ✓
```

### ⚠️ Attention aux pièges!
```julia
# Troncature, pas arrondi!
Int(5.9)           # 5 (pas 6!)
Int(5.1)           # 5 (pas 5!)

# Conversions de caractères
Char(65)           # 'A' (code ASCII)
Int('A')           # 65 (retour au code)
```

### Point crucial:
> **Julia tronque, ne arrondit pas:** `Int(5.9) = 5` ≠ `round(Int, 5.9) = 6`

---

## ✅ Exercice 4: Tests de Type (isa et <:)

### Tests d'appartenance:
```julia
# Tests isa() - "est-ce que c'est un...?"
isa(42, Int)        # true
isa(42, Number)     # true - 42 est un Number
isa("hello", Int)   # false

# Hiérarchie des types avec <:
Int <: Number       # true - Int est un sous-type de Number  
Float64 <: Real     # true - Float64 est un sous-type de Real
String <: Any       # true - Tout est un sous-type de Any
```

### Démonstration de hiérarchie:
```julia
# Montrer la chaîne de types
supertype(Int64)    # Signed
supertype(Signed)   # Integer  
supertype(Integer)  # Real
supertype(Real)     # Number
supertype(Number)   # Any
```

---

## 🇧🇫 Exercice 5: Application - Données Démographiques

### Créons ensemble un profil du Burkina Faso:
```julia
# Variables avec types appropriés
nom_pays = "Burkina Faso"           # String
population = 21_497_096             # Int64 (habitants)
superficie_km2 = 274_200.0          # Float64 (km²)
annee_independance = 1960           # Int64
nombre_langues = 60                 # Int64 (langues locales)
est_enclave = true                  # Bool (pas d'accès mer)
```

### Vérification interactive:
```julia
# Analysons nos choix de types
println("Population: $(typeof(population))")      # Int64
println("Superficie: $(typeof(superficie_km2))")  # Float64
println("Est enclavé: $(typeof(est_enclave))")    # Bool
```

### Questions d'approfondissement:
- "Pourquoi Float64 pour la superficie?" (Précision décimale)
- "Pourquoi pas Float64 pour la population?" (Nombre entier exact)

---

## 🎮 Mini-Challenge: Détective des Types

### Défi rapide:
```julia
# Devinez le type résultant AVANT d'exécuter
mystere1 = 10 / 2        # Type: _____ (piège!)
mystere2 = 10 ÷ 2        # Type: _____ 
mystere3 = "Bonjour " * "Burkina"  # Type: _____
mystere4 = true + false  # Type: _____ (surprise!)
```

### Révélation:
- `mystere1`: Float64 (division `/` retourne toujours Float64!)
- `mystere2`: Int64 (division entière `÷`)
- `mystere3`: String (concaténation)
- `mystere4`: Int64 (true = 1, false = 0)

---

## 💡 Conseil Pro: Autocomplétion des Types

### Démonstration live:
```julia
# Dans le REPL, tapez:
Int[Tab]    # Voir Int8, Int16, Int32, Int64, Int128
Float[Tab]  # Voir Float16, Float32, Float64
UInt[Tab]   # Voir UInt8, UInt16, UInt32, UInt64, UInt128
```

### Exploration guidée:
> "Explorez les types disponibles avec Tab. C'est comme un dictionnaire intégré!"

---

## ✅ Récapitulatif Express

**Types de base maîtrisés:**
- ✅ `Int64`, `Float64`, `String`, `Char`, `Bool`
- ✅ Conversion avec `Int()`, `Float64()`, `string()`
- ✅ Tests avec `isa()` et `<:`
- ✅ Inspection avec `typeof()` et `sizeof()`

**Piège à retenir:**
> Division `/` → toujours Float64, même entre entiers!

**Transition:** "Maintenant, utilisons ces types dans des structures de contrôle..."