# 🎯 Pratique Guidée 2: Dictionnaires et Fonctions sur Collections
**Module 1 - Session 4** | **Durée: 20 minutes**

---

## 📚 Exercice 1: Dictionnaires de Base

### Création et utilisation:
```julia
# Capitales des pays voisins du Burkina Faso
capitales_voisins = Dict(
    "Mali" => "Bamako",
    "Niger" => "Niamey", 
    "Bénin" => "Porto-Novo",
    "Togo" => "Lomé",
    "Ghana" => "Accra",
    "Côte d'Ivoire" => "Yamoussoukro"
)

println("Capitale du Mali: $(capitales_voisins["Mali"])")
println("Capitale du Ghana: $(capitales_voisins["Ghana"])")
```

### Ajout et modification:
```julia
# Ajout d'un nouveau pays
capitales_voisins["Guinée"] = "Conakry"

# Modification (la vraie capitale politique de la CI)
capitales_voisins["Côte d'Ivoire"] = "Abidjan"  

println("Après modifications:")
println("Pays voisins: $(keys(capitales_voisins))")
println("Nombre de voisins: $(length(capitales_voisins))")
```

### Vérification d'existence:
```julia
# Test sécurisé d'accès
pays_test = "Algérie"
if haskey(capitales_voisins, pays_test)
    println("Capitale de $pays_test: $(capitales_voisins[pays_test])")
else
    println("$pays_test n'est pas un voisin direct du Burkina Faso")
end
```

---

## 💰 Exercice 2: Application - Taux de Change

### Système de conversion multi-devises:
```julia
# Taux de change par rapport au FCFA
taux_change = Dict(
    "EUR" => 656.0,    # 1 EUR = 656 FCFA
    "USD" => 590.0,    # 1 USD = 590 FCFA
    "GBP" => 750.0,    # 1 GBP = 750 FCFA
    "CHF" => 650.0,    # 1 CHF = 650 FCFA
    "CAD" => 435.0     # 1 CAD = 435 FCFA
)

function convertir_depuis_fcfa(montant_fcfa, devise)
    if haskey(taux_change, devise)
        montant_converti = montant_fcfa / taux_change[devise]
        return round(montant_converti, digits=2)
    else
        println("⚠️ Devise '$devise' non supportée")
        println("Devises disponibles: $(keys(taux_change))")
        return nothing
    end
end

# Tests de conversion
salaire_fcfa = 250000
println("Salaire $salaire_fcfa FCFA équivaut à:")
for devise in ["EUR", "USD", "GBP"]
    montant = convertir_depuis_fcfa(salaire_fcfa, devise)
    if montant !== nothing
        println("- $montant $devise")
    end
end
```

### Challenge interactif:
> "Ajoutez le Yuan chinois (CNY) avec le taux 1 CNY = 82 FCFA"

```julia
# Solution:
taux_change["CNY"] = 82.0
montant_yuan = convertir_depuis_fcfa(250000, "CNY")
println("En Yuan: $montant_yuan CNY")
```

---

## 🎓 Exercice 3: Base de Données Étudiants

### Dictionnaires imbriqués:
```julia
# Base d'étudiants avec informations complètes
etudiants_db = Dict(
    "ET001" => Dict(
        "nom" => "KONE", 
        "prenom" => "Aminata", 
        "age" => 20,
        "ville" => "Bobo-Dioulasso",
        "notes" => [15, 12, 17, 14]
    ),
    "ET002" => Dict(
        "nom" => "OUEDRAOGO", 
        "prenom" => "Paul", 
        "age" => 22,
        "ville" => "Koudougou",
        "notes" => [11, 9, 16, 13]
    ),
    "ET003" => Dict(
        "nom" => "SAWADOGO", 
        "prenom" => "Marie", 
        "age" => 19,
        "ville" => "Banfora",
        "notes" => [14, 15, 12, 18]
    )
)

# Fonction d'affichage d'un étudiant
function afficher_etudiant(code_etudiant)
    if haskey(etudiants_db, code_etudiant)
        etudiant = etudiants_db[code_etudiant]
        moyenne = sum(etudiant["notes"]) / length(etudiant["notes"])
        
        println("=== FICHE ÉTUDIANT $code_etudiant ===")
        println("Nom: $(etudiant["prenom"]) $(etudiant["nom"])")
        println("Âge: $(etudiant["age"]) ans")
        println("Ville: $(etudiant["ville"])")
        println("Notes: $(etudiant["notes"])")
        println("Moyenne: $(round(moyenne, digits=2))/20")
    else
        println("Étudiant $code_etudiant non trouvé")
    end
end

# Tests
afficher_etudiant("ET001")
afficher_etudiant("ET999")  # N'existe pas
```

### Recherche et statistiques:
```julia
# Statistiques sur tous les étudiants
function statistiques_classe()
    println("=== STATISTIQUES DE LA CLASSE ===")
    
    # Collecte des données
    toutes_notes = []
    villes_origine = []
    ages = []
    
    for (code, etudiant) in etudiants_db
        append!(toutes_notes, etudiant["notes"])
        push!(villes_origine, etudiant["ville"])
        push!(ages, etudiant["age"])
    end
    
    # Calculs
    moyenne_classe = sum(toutes_notes) / length(toutes_notes)
    age_moyen = sum(ages) / length(ages)
    villes_uniques = unique(villes_origine)
    
    println("Nombre d'étudiants: $(length(etudiants_db))")
    println("Moyenne de classe: $(round(moyenne_classe, digits=2))/20")
    println("Âge moyen: $(round(age_moyen, digits=1)) ans")
    println("Villes représentées: $villes_uniques")
end

statistiques_classe()
```

---

## 🔍 Exercice 4: Fonctions sur Collections

### Map, Filter, Reduce:
```julia
# Données de base: prix en FCFA
prix_produits = [25000, 18000, 12000, 30000, 8000]

# MAP: Appliquer une transformation
println("=== MAP: Ajouter 18% de TVA ===")
prix_ttc = map(prix -> prix * 1.18, prix_produits)
println("Prix HT: $prix_produits")
println("Prix TTC: $prix_ttc")

# Alternative avec compréhension (plus idiomatique en Julia)
prix_ttc_v2 = [prix * 1.18 for prix in prix_produits]
println("Prix TTC (v2): $prix_ttc_v2")
```

### Filter: Sélection conditionnelle:
```julia
# FILTER: Produits dans une gamme de prix
println("\n=== FILTER: Prix entre 10k et 25k FCFA ===")
prix_moyens = filter(prix -> 10000 <= prix <= 25000, prix_produits)
println("Prix dans la gamme: $prix_moyens")

# Avec indices pour retrouver les produits
noms_produits = ["Téléphone A", "Téléphone B", "Accessoire", "Téléphone Premium", "Câble"]
indices_moyens = findall(prix -> 10000 <= prix <= 25000, prix_produits)
produits_moyens = [noms_produits[i] for i in indices_moyens]
println("Produits correspondants: $produits_moyens")
```

### Reduce et agrégations:
```julia
# REDUCE: Calculs cumulés
println("\n=== REDUCE: Calculs d'agrégation ===")
total_chiffre = reduce(+, prix_produits)  # Même que sum()
produit_prix = reduce(*, [2, 3, 4, 5])   # 2×3×4×5 = 120

println("Chiffre d'affaires total: $total_chiffre FCFA")
println("Produit 2×3×4×5: $produit_prix")

# Any/All: Tests booléens
tous_positifs = all(prix -> prix > 0, prix_produits)
au_moins_cher = any(prix -> prix > 20000, prix_produits)

println("Tous les prix positifs: $tous_positifs")
println("Au moins un produit cher (>20k): $au_moins_cher")
```

---

## ⚡ Exercice 5: Compréhensions Avancées

### Compréhensions avec conditions:
```julia
# Notes d'une classe
notes_classe = [8, 12, 15, 7, 16, 11, 9, 14, 18, 6]

# Sélection des notes validantes (≥10) avec bonus
notes_validantes_bonus = [note + 1 for note in notes_classe if note >= 10]
println("Notes validantes avec bonus: $notes_validantes_bonus")

# Classification des notes
classifications = [note >= 16 ? "Très Bien" : 
                   note >= 14 ? "Bien" : 
                   note >= 12 ? "Assez Bien" : 
                   note >= 10 ? "Passable" : "Échec" 
                   for note in notes_classe]

println("Classifications:")
for (i, (note, mention)) in enumerate(zip(notes_classe, classifications))
    println("Étudiant $i: $note/20 → $mention")
end
```

### Compréhensions 2D:
```julia
# Table de multiplication
println("\n=== TABLE DE MULTIPLICATION 5×5 ===")
table = [i * j for i in 1:5, j in 1:5]

# Affichage formaté
for i in 1:5
    ligne = [string(table[i, j], pad=3) for j in 1:5]
    println(join(ligne, " "))
end
```

### Application: Grille de prix:
```julia
# Prix par quantité et par produit
produits_prix = [100, 200, 300]  # Prix unitaires
quantites = [1, 5, 10, 20]       # Quantités

println("\n=== GRILLE DE PRIX (avec remises) ===")
grille_prix = [prix * qte * (qte >= 10 ? 0.9 : qte >= 5 ? 0.95 : 1.0) 
               for prix in produits_prix, qte in quantites]

# En-têtes
print("Produit\\Qty")
for qte in quantites
    print("\t$qte")
end
println()

# Données
for (i, prix) in enumerate(produits_prix)
    print("Produit $i")
    for j in 1:length(quantites)
        print("\t$(Int(grille_prix[i, j]))")
    end
    println()
end
```

---

## 🌾 Mini-Projet: Analyse de Marché

### Scénario complet:
```julia
# Données du marché central de Ouagadougou
marche_data = Dict(
    "cereales" => Dict(
        "riz" => [350, 380, 320, 360],      # Prix sur 4 jours
        "mais" => [180, 185, 175, 190],
        "mil" => [160, 165, 155, 170]
    ),
    "legumes" => Dict(
        "tomate" => [800, 900, 750, 850],   # Prix/kg très variables
        "oignon" => [400, 420, 390, 410],
        "pomme_terre" => [300, 320, 280, 330]
    )
)

# Fonction d'analyse complète
function analyser_marche(marche_data)
    println("=== ANALYSE DU MARCHÉ ===")
    
    for (categorie, produits) in marche_data
        println("\n📊 Catégorie: $(uppercase(categorie))")
        
        for (produit, prix_historique) in produits
            prix_moyen = sum(prix_historique) / length(prix_historique)
            prix_min = minimum(prix_historique)
            prix_max = maximum(prix_historique)
            volatilite = prix_max - prix_min
            
            println("  $produit:")
            println("    Prix moyen: $(round(prix_moyen, digits=0)) FCFA/kg")
            println("    Fourchette: $prix_min - $prix_max FCFA/kg")
            println("    Volatilité: $volatilite FCFA/kg")
        end
    end
    
    # Produit le plus volatile toutes catégories
    max_volatilite = 0
    produit_plus_volatile = ""
    
    for (categorie, produits) in marche_data
        for (produit, prix_historique) in produits
            volatilite = maximum(prix_historique) - minimum(prix_historique)
            if volatilite > max_volatilite
                max_volatilite = volatilite
                produit_plus_volatile = produit
            end
        end
    end
    
    println("\n🎯 Produit le plus volatile: $produit_plus_volatile ($max_volatilite FCFA/kg d'écart)")
end

analyser_marche(marche_data)
```

---

## ✅ Récapitulatif de la Session

### Concepts maîtrisés:
- ✅ **Dictionnaires** - Clé-valeur, ajout, modification, vérification
- ✅ **Dictionnaires imbriqués** - Structures de données complexes
- ✅ **Map/Filter/Reduce** - Fonctions d'ordre supérieur
- ✅ **Any/All** - Tests booléens sur collections
- ✅ **Compréhensions** - Syntaxe élégante et performante
- ✅ **Compréhensions 2D** - Matrices et grilles

### Applications pratiques burkinabè:
- ✅ Taux de change multi-devises
- ✅ Base de données étudiants
- ✅ Analyse de marché agricole
- ✅ Système de prix avec remises
- ✅ Classifications et mentions scolaires

### Patterns utiles mémorisés:
- ✅ `haskey(dict, key)` pour éviter les erreurs
- ✅ `[expr for item in collection if condition]` 
- ✅ `unique()` pour éliminer les doublons
- ✅ `findall()` pour les indices qui matchent
- ✅ `zip()` pour itérer sur plusieurs collections

**Préparation:** "Dans l'exercice principal, vous combinerez tableaux et dictionnaires pour créer un système de gestion complet!"