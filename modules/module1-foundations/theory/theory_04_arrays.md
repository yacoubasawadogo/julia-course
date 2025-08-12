# 📚 Module 1 - Session 4: Tableaux et Collections
**Durée: 2 heures** | **Niveau: Débutant**

---

## 🎯 Objectifs de la Session

À la fin de cette session, vous serez capable de:
- ✅ Créer et manipuler des tableaux (arrays)
- ✅ Utiliser les dictionnaires pour des données clé-valeur
- ✅ Maîtriser l'indexation et les tranches (slicing)
- ✅ Appliquer les fonctions sur les collections
- ✅ Créer des compréhensions de listes efficaces

---

## 📊 Les Tableaux (Arrays)

### Pourquoi les Tableaux?

Les tableaux permettent de:
1. **Stocker plusieurs valeurs** du même type
2. **Organiser des données** de manière structurée  
3. **Effectuer des calculs** sur des ensembles de données
4. **Itérer facilement** sur des collections

### Types de Tableaux

```julia
# Vecteurs (1D)
nombres = [1, 2, 3, 4, 5]
noms = ["Aminata", "Paul", "Marie", "Seydou"]
prix_fcfa = [25000, 18000, 12000, 30000]

# Matrices (2D)
matrice = [1 2 3; 4 5 6; 7 8 9]
notes = [12 15 8; 17 11 14; 9 16 13]  # 3 étudiants, 3 matières

# Tableaux 3D et plus
cube = rand(3, 3, 3)  # Tableau 3D aléatoire
```

---

## 🔧 Création de Tableaux

### Méthodes de Création

```julia
# Création explicite
vecteur1 = [1, 2, 3, 4, 5]
vecteur2 = [1:5...]  # Conversion range vers array

# Tableaux typés
entiers = Int64[1, 2, 3, 4]
flottants = Float64[1.0, 2.5, 3.7]
chaines = String["Ouaga", "Bobo", "Koudougou"]

# Création avec fonctions
zeros_array = zeros(5)        # [0.0, 0.0, 0.0, 0.0, 0.0]
ones_array = ones(3)          # [1.0, 1.0, 1.0]
random_array = rand(4)        # 4 nombres aléatoires entre 0 et 1
range_array = collect(1:10)   # [1, 2, 3, ..., 10]

# Tableaux 2D
matrice_zeros = zeros(3, 4)   # Matrice 3×4 de zéros
matrice_ones = ones(2, 3)     # Matrice 2×3 de uns
identite = I(3)               # Matrice identité 3×3
```

### Applications Pratiques Burkinabè

```julia
# Données démographiques des régions
regions = ["Centre", "Hauts-Bassins", "Sud-Ouest", "Centre-Est"]
populations = [2415266, 2293319, 908354, 1482793]  # habitants

# Prix de produits agricoles (FCFA/kg)
produits = ["Riz", "Maïs", "Mil", "Sorgho"]
prix_marche = [350, 180, 160, 150]

# Notes d'étudiants (lignes = étudiants, colonnes = matières)
etudiants = ["Aminata", "Paul", "Marie"]
notes_classe = [15 12 17;    # Aminata: Maths, Français, Sciences
                11 14 9;     # Paul
                16 13 15]    # Marie
```

---

## 🎯 Indexation et Accès

### Indexation Base 1 (Important!)

```julia
# Julia utilise l'indexation base 1 (contrairement à Python/C++)
villes = ["Ouagadougou", "Bobo-Dioulasso", "Koudougou", "Banfora"]

println(villes[1])    # "Ouagadougou" (premier élément)
println(villes[2])    # "Bobo-Dioulasso" 
println(villes[end])  # "Banfora" (dernier élément)
println(villes[end-1]) # "Koudougou" (avant-dernier)

# Erreur commune à éviter
# println(villes[0])  # ❌ BoundsError! Pas d'index 0 en Julia
```

### Tranches (Slicing)

```julia
# Syntaxe: array[début:fin]
nombres = [10, 20, 30, 40, 50, 60, 70]

println(nombres[2:4])     # [20, 30, 40]
println(nombres[1:3])     # [10, 20, 30]
println(nombres[3:end])   # [30, 40, 50, 60, 70]
println(nombres[:])       # Copie complète
println(nombres[1:2:7])   # [10, 30, 50, 70] (pas de 2)

# Matrices 2D
matrice = [1 2 3; 4 5 6; 7 8 9]
println(matrice[2, :])    # Ligne 2: [4, 5, 6]
println(matrice[:, 3])    # Colonne 3: [3, 6, 9]
println(matrice[1:2, 2:3]) # Sous-matrice
```

---

## 🔄 Modification de Tableaux

### Modification d'Éléments

```julia
# Modification individuelle
prix = [1000, 2000, 3000]
prix[2] = 2500  # Modification en place
println(prix)   # [1000, 2500, 3000]

# Modification par tranches
notes = [10, 12, 8, 15, 11]
notes[2:4] = [14, 16, 18]  # Remplace plusieurs éléments
println(notes)  # [10, 14, 16, 18, 11]
```

### Ajout et Suppression

```julia
# Ajout d'éléments
fruits = ["mangue", "orange"]
push!(fruits, "papaye")        # Ajoute à la fin: ["mangue", "orange", "papaye"]
pushfirst!(fruits, "banane")   # Ajoute au début: ["banane", "mangue", "orange", "papaye"]

# Suppression d'éléments
dernier = pop!(fruits)         # Retire et retourne le dernier
premier = popfirst!(fruits)    # Retire et retourne le premier
println(fruits)                # ["mangue", "orange"]

# Insertion à une position
insert!(fruits, 2, "avocat")   # Insert à l'index 2
println(fruits)                # ["mangue", "avocat", "orange"]

# Suppression à une position
deleteat!(fruits, 2)           # Supprime l'index 2
println(fruits)                # ["mangue", "orange"]
```

### Concaténation

```julia
# Concaténation de tableaux
villes_nord = ["Ouahigouya", "Dori"]
villes_sud = ["Gaoua", "Diébougou"]
toutes_villes = [villes_nord; villes_sud]  # ["Ouahigouya", "Dori", "Gaoua", "Diébougou"]

# Alternative avec vcat
toutes_villes2 = vcat(villes_nord, villes_sud)

# Concaténation horizontale (matrices)
mat1 = [1 2; 3 4]
mat2 = [5 6; 7 8]
concatenee = [mat1 mat2]  # [1 2 5 6; 3 4 7 8]
```

---

## 📚 Dictionnaires

### Création et Utilisation

```julia
# Création de dictionnaires
capitales = Dict("Burkina Faso" => "Ouagadougou",
                "Mali" => "Bamako",
                "Niger" => "Niamey",
                "Ghana" => "Accra")

# Accès aux valeurs
println(capitales["Burkina Faso"])  # "Ouagadougou"

# Ajout/modification
capitales["Côte d'Ivoire"] = "Yamoussoukro"
capitales["Mali"] = "Bamako"  # Modification

# Vérification d'existence
if haskey(capitales, "Togo")
    println("Capitale du Togo: $(capitales["Togo"])")
else
    println("Togo non trouvé dans le dictionnaire")
end
```

### Applications Pratiques

```julia
# Base de données d'étudiants
etudiants_db = Dict(
    "ET001" => Dict("nom" => "KONE", "prenom" => "Aminata", "age" => 20),
    "ET002" => Dict("nom" => "OUEDRAOGO", "prenom" => "Paul", "age" => 22),
    "ET003" => Dict("nom" => "SAWADOGO", "prenom" => "Marie", "age" => 19)
)

# Accès aux informations
etudiant = etudiants_db["ET001"]
println("$(etudiant["prenom"]) $(etudiant["nom"]), $(etudiant["age"]) ans")

# Prix du marché par produit
prix_marche = Dict(
    "riz" => 350,      # FCFA/kg
    "mais" => 180,
    "mil" => 160,
    "huile" => 1200,   # FCFA/litre
    "sucre" => 800     # FCFA/kg
)

# Calcul facture
panier = ["riz" => 2, "huile" => 1, "sucre" => 3]  # produit => quantité
total = sum(prix_marche[produit] * qte for (produit, qte) in panier)
println("Total panier: $total FCFA")
```

---

## 🔍 Fonctions sur les Collections

### Fonctions de Base

```julia
nombres = [12, 45, 23, 67, 34, 89, 15]

# Statistiques de base
println("Somme: $(sum(nombres))")           # 285
println("Moyenne: $(sum(nombres)/length(nombres))")  # 40.71
println("Longueur: $(length(nombres))")     # 7
println("Minimum: $(minimum(nombres))")     # 12
println("Maximum: $(maximum(nombres))")     # 89

# Recherche
println("45 présent? $(45 in nombres)")     # true
println("Position de 67: $(findfirst(==(67), nombres))")  # 4

# Tri
nombres_tries = sort(nombres)               # Copie triée
sort!(nombres)                              # Tri en place (modifie l'original)
println("Triés: $nombres")
```

### Fonctions d'Ordre Supérieur

```julia
# map: applique une fonction à chaque élément
prix_ht = [1000, 2000, 3000]
prix_ttc = map(x -> x * 1.18, prix_ht)     # Ajoute 18% de TVA
println("Prix TTC: $prix_ttc")

# filter: filtre selon une condition  
notes = [8, 12, 15, 7, 16, 11, 9, 14]
notes_validantes = filter(x -> x >= 10, notes)
println("Notes ≥ 10: $notes_validantes")

# reduce: réduit à une valeur unique
produit = reduce(*, [2, 3, 4, 5])          # 2*3*4*5 = 120
println("Produit: $produit")

# any/all: tests booléens
tous_positifs = all(x -> x > 0, [1, 2, 3, 4])     # true
au_moins_un_pair = any(x -> x % 2 == 0, [1, 3, 5, 7])  # false
```

---

## ⚡ Compréhensions de Listes

### Syntaxe de Base

```julia
# Compréhension simple: [expression for variable in iterable]
carres = [x^2 for x in 1:10]
println("Carrés 1-10: $carres")

# Avec condition: [expression for variable in iterable if condition]
pairs_carres = [x^2 for x in 1:10 if x % 2 == 0]
println("Carrés des pairs: $pairs_carres")  # [4, 16, 36, 64, 100]
```

### Applications Pratiques

```julia
# Conversion FCFA vers Euros
prix_fcfa = [25000, 18000, 12000, 30000]
taux_euro = 656
prix_euros = [round(prix/taux_euro, digits=2) for prix in prix_fcfa]
println("Prix en euros: $prix_euros")

# Analyse de notes
notes_classe = [
    [15, 12, 17],  # Aminata
    [11, 14, 9],   # Paul  
    [16, 13, 15]   # Marie
]

# Moyennes par étudiant
moyennes = [sum(notes)/length(notes) for notes in notes_classe]
println("Moyennes: $moyennes")

# Mentions
mentions = [moy >= 14 ? "Bien" : moy >= 12 ? "AB" : moy >= 10 ? "Passable" : "Échec" 
           for moy in moyennes]
println("Mentions: $mentions")
```

### Compréhensions 2D

```julia
# Création de matrices avec compréhensions
table_multiplication = [i * j for i in 1:5, j in 1:5]
println("Table 5×5:")
for ligne in eachrow(table_multiplication)
    println(ligne)
end

# Matrice de distances entre villes (exemple conceptuel)
villes = ["Ouaga", "Bobo", "Koudougou"]
# distances[i,j] = distance entre ville i et ville j
distances = [abs(i-j)*100 for i in 1:3, j in 1:3]  # Distances simulées
```

---

## 🌾 Application Complète: Gestion de Stock Agricole

```julia
# Système de gestion d'entrepôt agricole avec dictionnaires
# Chaque produit est un dictionnaire avec les informations essentielles

# Initialisation du stock
entrepot = [
    Dict("nom" => "Riz parfumé", "prix_kg" => 450.0, "stock_kg" => 2500.0, "origine" => "Banzon"),
    Dict("nom" => "Maïs blanc", "prix_kg" => 200.0, "stock_kg" => 5000.0, "origine" => "Koudougou"),
    Dict("nom" => "Mil rouge", "prix_kg" => 180.0, "stock_kg" => 1800.0, "origine" => "Ouahigouya"),
    Dict("nom" => "Sorgho", "prix_kg" => 160.0, "stock_kg" => 3200.0, "origine" => "Dori"),
    Dict("nom" => "Arachide", "prix_kg" => 800.0, "stock_kg" => 1200.0, "origine" => "Kaya")
]

# Analyse avec compréhensions
println("=== ANALYSE DE L'ENTREPÔT ===")

# Valeur totale par produit
valeurs = [p["prix_kg"] * p["stock_kg"] for p in entrepot]
println("Valeurs stock: $valeurs")

# Noms des produits pour référence
noms_produits = [p["nom"] for p in entrepot]
println("Produits: $noms_produits")

# Produits en rupture (< 2000 kg)
en_rupture = [p["nom"] for p in entrepot if p["stock_kg"] < 2000]
println("Produits en rupture: $en_rupture")

# Fonction pour trouver le produit le plus précieux
function produit_plus_precieux(entrepot)
    valeur_max = 0
    produit_max = ""
    for produit in entrepot
        valeur = produit["prix_kg"] * produit["stock_kg"]
        if valeur > valeur_max
            valeur_max = valeur
            produit_max = produit["nom"]
        end
    end
    return produit_max, valeur_max
end

nom_precieux, valeur_precieux = produit_plus_precieux(entrepot)
println("Produit le plus précieux: $nom_precieux ($(round(Int, valeur_precieux)) FCFA)")

# Statistiques générales avec fonctions
function calculer_statistiques(entrepot)
    valeur_totale = sum(p["prix_kg"] * p["stock_kg"] for p in entrepot)
    stock_total = sum(p["stock_kg"] for p in entrepot)
    prix_moyen = sum(p["prix_kg"] for p in entrepot) / length(entrepot)
    return valeur_totale, stock_total, prix_moyen
end

valeur_totale, stock_total, prix_moyen = calculer_statistiques(entrepot)

println("\n=== STATISTIQUES GÉNÉRALES ===")
println("Valeur totale entrepôt: $(round(Int, valeur_totale)) FCFA")
println("Stock total: $(round(Int, stock_total)) kg")
println("Prix moyen: $(round(prix_moyen, digits=2)) FCFA/kg")

# Groupement par région avec dictionnaires
origines = unique([p["origine"] for p in entrepot])
println("\nRégions représentées: $origines")

for origine in origines
    produits_origine = filter(p -> p["origine"] == origine, entrepot)
    nb_produits = length(produits_origine)
    noms_origine = [p["nom"] for p in produits_origine]
    println("$origine: $nb_produits produit(s) → $noms_origine")
end

# Fonction de recherche
function chercher_produit(entrepot, nom_recherche)
    for (index, produit) in enumerate(entrepot)
        if produit["nom"] == nom_recherche
            println("Produit trouvé à l'index $index:")
            println("  Prix: $(produit["prix_kg"]) FCFA/kg")
            println("  Stock: $(produit["stock_kg"]) kg") 
            println("  Origine: $(produit["origine"])")
            return produit
        end
    end
    println("Produit '$nom_recherche' non trouvé")
    return nothing
end

# Test de recherche
chercher_produit(entrepot, "Riz parfumé")
```

---

## 💡 Bonnes Pratiques

### Performances et Mémoire

```julia
# ✅ BON - Préallocation pour boucles
fonction_rapide() = begin
    result = Vector{Float64}(undef, 1000)  # Préallocation
    for i in 1:1000
        result[i] = i^2
    end
    result
end

# ❌ LENT - Croissance dynamique
fonction_lente() = begin
    result = Float64[]
    for i in 1:1000
        push!(result, i^2)  # Réallocation à chaque ajout
    end
    result
end

# ✅ Meilleur - Compréhension (plus lisible et rapide)
fonction_optimale() = [i^2 for i in 1:1000]
```

### Immutabilité vs Mutabilité

```julia
# Fonctions avec ! modifient en place
arr = [3, 1, 4, 1, 5]
sort!(arr)         # Modifie arr directement
println(arr)       # [1, 1, 3, 4, 5]

# Fonctions sans ! retournent une copie
arr = [3, 1, 4, 1, 5]
arr_trie = sort(arr)  # arr reste inchangé
println(arr)          # [3, 1, 4, 1, 5]
println(arr_trie)     # [1, 1, 3, 4, 5]
```

---

## 🎯 Points Clés à Retenir

1. **Indexation base 1** - Premier élément à l'index 1
2. **Tranches inclusives** - `array[1:3]` inclut les indices 1, 2, 3
3. **Fonctions !** - Modifient en place, sans ! créent des copies
4. **Compréhensions** - Plus lisibles et souvent plus rapides
5. **Types homogènes** - Tableaux performants avec un seul type

---

## 🚀 Prochaines Étapes

Dans la prochaine session, nous créerons:
- Calculatrice avancée avec historique
- Jeu de combat avec personnages
- Applications pratiques complètes
- Interface utilisateur simple

---

## 📝 Notes Importantes

### Démonstrations Live Recommandées:
1. Créer un tableau de notes d'étudiants et calculer statistiques
2. Montrer la différence entre `sort` et `sort!`
3. Construire un dictionnaire de traduction français-mooré
4. Créer une matrice de distances entre villes

### Pièges Courants à Éviter:
- Oublier que Julia est base 1 (pas base 0)
- Confondre `=` et `==` dans les compréhensions
- Utiliser des types mixtes sans raison (performance)
- Oublier les `!` pour modifications en place

### Exercices Interactifs Suggérés:
- Créer un carnet de notes électronique
- Système d'inventaire de boutique
- Calculateur de statistiques agricoles
- Jeu de devinettes avec scores