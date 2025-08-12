# 🎯 Pratique Guidée 1: Création et Manipulation de Tableaux
**Module 1 - Session 4** | **Durée: 15 minutes**

---

## 📊 Exercice 1: Création de Tableaux Basiques

### Démonstration live - Différentes méthodes:
```julia
# Création explicite
villes_bf = ["Ouagadougou", "Bobo-Dioulasso", "Koudougou", "Banfora"]
populations = [2415266, 2293319, 356117, 117452]  # habitants

println("Villes: $villes_bf")
println("Populations: $populations")
```

### Challenge étudiant:
> "Créez un tableau `provinces` avec 5 provinces du Burkina Faso"

```julia
# Solution attendue:
provinces = ["Kadiogo", "Houet", "Boulkiemdé", "Comoé", "Bazèga"]
```

### Tableaux avec types spécifiques:
```julia
# Types explicites
prix_marche = Float64[350.0, 180.0, 160.0, 150.0]  # FCFA/kg
quantites = Int64[25, 50, 30, 40]  # kg

println("Prix (FCFA/kg): $prix_marche")
println("Quantités (kg): $quantites")
```

---

## 🔧 Exercice 2: Création avec Fonctions

### Tableaux pré-remplis:
```julia
# Zeros et ones
notes_initiales = zeros(10)           # 10 zéros pour 10 étudiants
presence = ones(Int, 5)               # 5 présents par défaut

println("Notes initiales: $notes_initiales")
println("Présences: $presence")
```

### Tableaux aléatoires et ranges:
```julia
# Nombres aléatoires
temperatures = rand(7) * 10 .+ 25     # Températures entre 25-35°C
println("Températures simulées: $(round.(temperatures, digits=1))")

# Conversion range vers array
jours_mois = collect(1:31)
annees_independance = collect(1960:2024)

println("Jours: $(jours_mois[1:5])...")  # Premiers 5
println("Années depuis indépendance: $(length(annees_independance)) ans")
```

### Challenge interactif:
> "Créez un tableau des multiples de 5 de 5 à 100"

```julia
# Solutions possibles:
multiples_5_v1 = collect(5:5:100)
multiples_5_v2 = [5*i for i in 1:20]
println("Multiples de 5: $multiples_5_v1")
```

---

## 🎯 Exercice 3: Indexation et Accès

### ⚠️ Rappel Important: Base 1!
```julia
# Julia commence à 1, pas 0!
produits = ["Riz", "Maïs", "Mil", "Sorgho"]

println("Premier produit: $(produits[1])")     # "Riz"
println("Deuxième produit: $(produits[2])")    # "Maïs"
println("Dernier produit: $(produits[end])")   # "Sorgho"
println("Avant-dernier: $(produits[end-1])")   # "Mil"

# println(produits[0])  # ❌ ERREUR! Pas d'index 0
```

### Tranches (Slicing):
```julia
notes_classe = [12, 15, 8, 17, 11, 14, 9, 16, 13, 10]

# Différentes façons de découper
premieres_notes = notes_classe[1:3]        # [12, 15, 8]
dernieres_notes = notes_classe[8:end]      # [16, 13, 10]
notes_paires = notes_classe[2:2:8]         # [15, 17, 14, 16] (indices pairs)
toutes_notes = notes_classe[:]             # Copie complète

println("3 premières: $premieres_notes")
println("3 dernières: $dernieres_notes")
println("Indices pairs: $notes_paires")
```

### Test de compréhension:
> "Dans un tableau de 10 éléments, quel est l'index du 7ème élément?"
> Réponse: **7** (pas 6 comme en Python!)

---

## ✏️ Exercice 4: Modification de Tableaux

### Modification d'éléments:
```julia
# Prix qui changent
prix_cereales = [350, 180, 160, 150]  # FCFA/kg
println("Prix initiaux: $prix_cereales")

# Le prix du riz augmente
prix_cereales[1] = 380
println("Prix après hausse riz: $prix_cereales")

# Modification de plusieurs éléments
prix_cereales[2:3] = [190, 170]  # Maïs et mil augmentent
println("Prix après ajustements: $prix_cereales")
```

### Ajout et suppression:
```julia
# Liste de courses qui évolue
courses = ["Pain", "Lait"]
println("Courses initiales: $courses")

# Ajouts
push!(courses, "Œufs")           # Ajoute à la fin
pushfirst!(courses, "Fruits")    # Ajoute au début
println("Après ajouts: $courses")

# Suppressions
dernier = pop!(courses)          # Retire le dernier
premier = popfirst!(courses)     # Retire le premier
println("Retiré: $dernier et $premier")
println("Courses finales: $courses")
```

### Challenge pratique:
> "Gérez une liste d'attente: ajoutez 'Paul', 'Marie', 'Jean', puis servez dans l'ordre"

```julia
# Solution guidée:
file_attente = String[]  # Tableau vide de chaînes

# Arrivées
push!(file_attente, "Paul")
push!(file_attente, "Marie") 
push!(file_attente, "Jean")
println("File d'attente: $file_attente")

# Service (FIFO - First In, First Out)
servi1 = popfirst!(file_attente)
println("$servi1 a été servi. Restant: $file_attente")
```

---

## 📋 Exercice 5: Matrices 2D

### Création et accès:
```julia
# Notes de 3 étudiants sur 4 matières
notes_classe = [15 12 17 14;    # Aminata
                11 9  16 13;    # Paul  
                14 15 12 18]    # Marie

println("Notes de la classe:")
println(notes_classe)

# Accès par lignes et colonnes
println("Notes d'Aminata: $(notes_classe[1, :])")     # Ligne 1
println("Notes en maths: $(notes_classe[:, 1])")      # Colonne 1
println("Note de Paul en sciences: $(notes_classe[2, 3])")  # Ligne 2, colonne 3
```

### Opérations sur matrices:
```julia
# Statistiques par étudiant (moyennes des lignes)
moyennes_etudiants = [sum(notes_classe[i, :]) / size(notes_classe, 2) for i in 1:3]
println("Moyennes par étudiant: $moyennes_etudiants")

# Statistiques par matière (moyennes des colonnes)
moyennes_matieres = [sum(notes_classe[:, j]) / size(notes_classe, 1) for j in 1:4]
println("Moyennes par matière: $moyennes_matieres")
```

---

## 📊 Exercice 6: Tableaux Parallèles

### Données liées:
```julia
# Informations sur les marchés burkinabè
marches = ["Rood-Woko", "Central", "Sankaryaré", "Gounghin"]
villes = ["Ouagadougou", "Ouagadougou", "Ouagadougou", "Ouagadougou"] 
frequentation = [15000, 25000, 8000, 12000]  # visiteurs/jour

println("=== MARCHÉS DE OUAGADOUGOU ===")
for i in 1:length(marches)
    println("$(marches[i]): $(frequentation[i]) visiteurs/jour")
end
```

### Tri coordonné:
```julia
# Trier les marchés par fréquentation
indices_tries = sortperm(frequentation, rev=true)  # Indices pour tri décroissant

println("\n=== CLASSEMENT PAR FRÉQUENTATION ===")
for i in indices_tries
    println("$(marches[i]): $(frequentation[i]) visiteurs/jour")
end
```

### Challenge de synchronisation:
> "Ajoutez le marché 'Tanghin' avec 6000 visiteurs, en maintenant la cohérence"

```julia
# Solution complète:
push!(marches, "Tanghin")
push!(villes, "Ouagadougou")
push!(frequentation, 6000)

println("Après ajout de Tanghin:")
println("Marchés: $marches")
println("Fréquentation: $frequentation")
```

---

## 🎮 Mini-Challenge: Inventaire Boutique

### Scénario complet:
```julia
# Boutique de téléphones
modeles = ["Samsung A12", "iPhone 12", "Tecno Spark", "Infinix Hot"]
prix_unite = [125000, 450000, 85000, 95000]  # FCFA
stock = [15, 3, 25, 18]  # unités

println("=== INVENTAIRE BOUTIQUE ===")
for i in 1:length(modeles)
    valeur = prix_unite[i] * stock[i]
    println("$(modeles[i]): $(stock[i]) unités × $(prix_unite[i]) = $(valeur) FCFA")
end

# Calculs globaux
valeur_totale = sum(prix_unite[i] * stock[i] for i in 1:length(modeles))
stock_total = sum(stock)

println("\nRésumé:")
println("Stock total: $stock_total unités")
println("Valeur totale: $valeur_totale FCFA")

# Alerte stock faible (< 10 unités)
alertes = [modeles[i] for i in 1:length(modeles) if stock[i] < 10]
if length(alertes) > 0
    println("⚠️ Stock faible: $alertes")
else
    println("✅ Tous les stocks sont corrects")
end
```

---

## ✅ Récapitulatif de la Session

### Concepts maîtrisés:
- ✅ **Création de tableaux** - Explicite, avec fonctions, ranges
- ✅ **Indexation base 1** - Premier élément à l'index 1
- ✅ **Tranches (slicing)** - `array[début:fin]` inclusif
- ✅ **Modifications** - Éléments individuels et par tranches
- ✅ **Ajout/suppression** - `push!`, `pop!`, `pushfirst!`, `popfirst!`
- ✅ **Matrices 2D** - Accès par `[ligne, colonne]`

### Applications burkinabè intégrées:
- ✅ Données démographiques des villes
- ✅ Prix de marché des céréales
- ✅ Système de notes scolaires
- ✅ Gestion des marchés locaux
- ✅ Inventaire de boutique

### Erreurs communes évitées:
- ✅ Confusion indexation base 0 vs base 1
- ✅ Oubli du `!` pour modifications en place
- ✅ Accès hors limites avec des indices invalides

**Transition:** "Maintenant, explorons les dictionnaires et les fonctions avancées sur les collections..."