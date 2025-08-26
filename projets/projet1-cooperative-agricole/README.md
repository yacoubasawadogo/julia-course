# 🏪 Système de Gestion de Coopérative Agricole

## 📋 Description du Projet

Vous allez créer un système complet de gestion pour une coopérative agricole burkinabè. Ce système permettra de gérer les membres, l'inventaire des produits, les transactions (achats/ventes), et fournira des analyses détaillées pour optimiser les opérations.

## 🎯 Objectifs d'Apprentissage

À la fin de ce projet, vous saurez :
- ✅ Modéliser un système complexe avec des structs Julia
- ✅ Manipuler des données avec DataFrames.jl
- ✅ Effectuer des analyses statistiques sur des données réelles
- ✅ Générer des rapports financiers automatisés
- ✅ Créer des visualisations de données (ASCII ou graphiques)
- ✅ Implémenter un système de persistance avec CSV

## 🌍 Contexte

Les coopératives agricoles sont essentielles pour l'économie burkinabè. Elles permettent aux petits producteurs de :
- Mutualiser leurs ressources
- Obtenir de meilleurs prix
- Accéder à des marchés plus larges
- Partager les bénéfices équitablement

Votre système aidera une coopérative fictive de 50 membres à gérer ses opérations quotidiennes et à prendre des décisions basées sur les données.

## 📊 Données Fournies

Dans le dossier `data/`, vous trouverez :

### membres.csv (50 membres)
- Informations personnelles (nom, prénom, village, région)
- Date d'adhésion et parts sociales
- Statut (actif/inactif)

### produits.csv (25 produits agricoles)
- Produits locaux : mil, sorgho, maïs, karité, coton, etc.
- Prix unitaires en FCFA
- Stock actuel et minimum

### transactions.csv (500 transactions)
- Historique sur 12 mois
- Types : achats et ventes
- Montants et quantités

## 🛠️ Fonctionnalités à Implémenter

### 1. Module de Gestion des Membres
- [ ] Ajouter/modifier/supprimer un membre
- [ ] Calculer les parts sociales totales
- [ ] Lister les membres actifs/inactifs
- [ ] Historique des transactions par membre

### 2. Module d'Inventaire
- [ ] Gestion du stock (entrées/sorties)
- [ ] Alertes de stock minimum
- [ ] Valeur totale de l'inventaire
- [ ] Produits les plus/moins vendus

### 3. Module de Transactions
- [ ] Enregistrer une nouvelle transaction
- [ ] Validation des montants et stocks
- [ ] Calcul automatique des totaux
- [ ] Historique filtrable par date/produit/membre

### 4. Module d'Analyse de Données
- [ ] Chiffre d'affaires par période
- [ ] Top 5 des produits rentables
- [ ] Analyse saisonnière des ventes
- [ ] Tendances de prix
- [ ] Performance par membre

### 5. Module de Rapports
- [ ] Rapport mensuel automatique
- [ ] Bilan financier
- [ ] Export CSV des analyses
- [ ] Tableau de bord synthétique

### 6. Module de Distribution des Bénéfices
- [ ] Calcul des bénéfices nets
- [ ] Répartition selon les parts sociales
- [ ] Historique des distributions
- [ ] Simulation de scénarios

## 📁 Structure Suggérée

```julia
src/
├── main.jl              # Point d'entrée et menu principal
├── types.jl             # Définition des structs
├── membres.jl           # Gestion des membres
├── inventaire.jl        # Gestion du stock
├── transactions.jl      # Opérations commerciales
├── analysis.jl          # Analyses de données
├── rapports.jl          # Génération de rapports
├── utils.jl             # Fonctions utilitaires
└── io_operations.jl     # Import/export CSV
```

## 🚀 Guide de Démarrage

### 1. Configuration de l'environnement

```julia
using Pkg
Pkg.add("DataFrames")
Pkg.add("CSV")
Pkg.add("Statistics")
Pkg.add("Dates")
Pkg.add("PrettyTables")  # Pour affichage de tableaux (optionnel)
```

### 2. Chargement des données

```julia
using CSV, DataFrames

# Charger les données
membres_df = CSV.read("data/membres.csv", DataFrame)
produits_df = CSV.read("data/produits.csv", DataFrame)
transactions_df = CSV.read("data/transactions.csv", DataFrame)
```

### 3. Structure de base

Consultez `starter.jl` pour un exemple de démarrage avec :
- Structs de base définies
- Menu interactif simple
- Fonctions essentielles

## 💡 Conseils de Développement

### Analyse des Ventes
```julia
# Exemple : Top 5 produits
using DataFrames, Statistics

function top_produits(transactions::DataFrame, n::Int=5)
    ventes = filter(row -> row.type == "Vente", transactions)
    grouped = groupby(ventes, :produit_nom)
    resume = combine(grouped, 
        :montant_total => sum => :total_ventes,
        :quantite => sum => :quantite_totale
    )
    sort!(resume, :total_ventes, rev=true)
    return first(resume, n)
end
```

### Visualisation ASCII
```julia
function graphique_barres(valeurs::Vector, labels::Vector)
    max_val = maximum(valeurs)
    for (label, val) in zip(labels, valeurs)
        barre = "█" ^ round(Int, (val/max_val) * 30)
        println("$label: $barre $(round(Int, val))")
    end
end
```

## 📈 Analyses Suggérées

1. **Saisonnalité** : Les ventes de céréales augmentent-elles pendant la soudure ?
2. **Rentabilité** : Quels produits ont la meilleure marge ?
3. **Membres actifs** : Qui contribue le plus au chiffre d'affaires ?
4. **Tendances** : Les prix évoluent-ils avec les saisons ?
5. **Stock** : Quels produits nécessitent un réapprovisionnement ?

## 🎯 Critères de Réussite

- ✅ Toutes les fonctionnalités de base implémentées
- ✅ Au moins 5 analyses différentes
- ✅ Rapport mensuel généré automatiquement
- ✅ Export/import CSV fonctionnel
- ✅ Interface utilisateur claire et intuitive
- ✅ Gestion d'erreurs robuste
- ✅ Code modulaire et documenté

## 🏆 Bonus

- Prédiction des ventes futures
- Système de notifications (stock bas, échéances)
- Graphiques avec Plots.jl
- Interface web simple avec Genie.jl
- Base de données SQLite

## 📚 Ressources

- [Documentation DataFrames.jl](https://dataframes.juliadata.org/stable/)
- [Documentation CSV.jl](https://csv.juliadata.org/stable/)
- [Guide Julia](https://docs.julialang.org)

## 🆘 Besoin d'Aide ?

1. Commencez par explorer les données dans le REPL
2. Implémentez une fonctionnalité à la fois
3. Testez avec un sous-ensemble de données d'abord
4. Utilisez `@show` pour déboguer
5. Consultez le `starter.jl` pour des exemples

---

**Bon courage !** 🇧🇫

*"Une coopérative forte fait des agriculteurs prospères."*