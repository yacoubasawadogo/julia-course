# 📝 Exercice Principal: Multiple Dispatch - Système de Gestion Commerciale Burkinabè
**Module 2 - Session 2** | **Durée: 40 minutes** | **Points: 100**

---

## 📋 Instructions pour les Étudiants

- Implémentez un système complet de gestion commerciale
- Utilisez le multiple dispatch pour optimiser les performances
- Créez des hiérarchies de types cohérentes
- Développez des interfaces extensibles et robustes
- **Total: 100 points + bonus possible**

---

## 🏪 Projet: Système de Gestion Commerciale "Faso Commerce"

### Contexte du Projet

Vous devez développer un système de gestion pour une chaîne commerciale burkinabè qui gère:
- **Différents types de magasins** (alimentaire, électronique, textile)
- **Multiples devises** (FCFA, EUR, USD) avec conversions automatiques
- **Systèmes de prix** flexibles (fixe, négociable, promotionnel)
- **Gestion d'inventaire** optimisée par type de produit
- **Calculs financiers** adaptés au contexte burkinabè

---

## 📊 Section 1: Hiérarchie de Types Commerciaux (25 points)

### Partie A: Types Abstraits et Magasins (15 points)

```julia
# 1. Créez la hiérarchie de types suivante:
abstract type Magasin end
abstract type MagasinSpecialise <: Magasin end
abstract type MagasinGeneral <: Magasin end

# 2. Implémentez les types concrets:
struct Supermarche <: MagasinGeneral
    nom::String
    quartier::String
    surface_m2::Int
    employes::Int
    ouvert_24h::Bool
end

struct Boutique <: MagasinSpecialise
    nom::String
    specialite::String  # "électronique", "textile", "alimentation"
    proprietaire::String
    surface_m2::Int
    licence::String
end

struct MarcheTraitionnel <: MagasinGeneral
    nom::String
    jour_marche::String  # "lundi", "mercredi", "samedi"
    nb_etals::Int
    ville::String
    prix_emplacement::Int  # FCFA par étal
end

struct GrosCommerce <: MagasinSpecialise
    nom::String
    secteur::String  # "import-export", "distribution", "production"
    capital_fcfa::Int
    nb_employes::Int
    regions_couvertes::Vector{String}
end

# 3. Méthodes spécialisées par type (dispatch automatique):
function calculer_chiffre_affaires_potentiel(# À compléter)
    # Supermarché: surface × 1500 FCFA/m²/jour
    # Boutique: selon spécialité (électronique: 2000, textile: 800, alimentation: 1200)
    # Marché: nb_etals × prix_emplacement × 4 (jours/mois moyen)
    # Gros commerce: capital × 0.15 (15% annuel) / 12 mois
end

function type_clientele(# À compléter)
    # Retourner la clientèle cible selon le type de magasin
end

function horaires_ouverture(# À compléter)
    # Horaires selon le type de commerce
end
```

### Partie B: Interface Commune (10 points)

```julia
# 4. Implémentez l'interface commune pour tous les magasins:
function cout_exploitation_mensuel(magasin::Magasin)
    error("cout_exploitation_mensuel doit être implémentée pour $(typeof(magasin))")
end

function zone_chalandise_km(magasin::Magasin)
    error("zone_chalandise_km doit être implémentée pour $(typeof(magasin))")
end

function est_rentable(magasin::Magasin)
    # Méthode générique: CA potentiel > coûts d'exploitation
    ca = calculer_chiffre_affaires_potentiel(magasin)
    cout = cout_exploitation_mensuel(magasin)
    return ca > cout
end

# À implémenter pour chaque type concret
```

---

## 💰 Section 2: Système Monétaire Multi-Devises (25 points)

### Partie A: Types de Devises (10 points)

```julia
# 1. Créez la hiérarchie monétaire:
abstract type Devise end
abstract type DeviseAfricaine <: Devise end
abstract type DeviseInternationale <: Devise end

# 2. Types concrets avec validation:
struct FCFA <: DeviseAfricaine
    montant::Float64
    
    # Constructeur avec validation
    function FCFA(montant::Real)
        montant >= 0 || throw(ArgumentError("Montant FCFA doit être positif"))
        new(Float64(montant))
    end
end

struct Euro <: DeviseInternationale
    montant::Float64
    
    function Euro(montant::Real)
        montant >= 0 || throw(ArgumentError("Montant EUR doit être positif"))
        new(Float64(montant))
    end
end

struct DollarUS <: DeviseInternationale
    montant::Float64
    
    function DollarUS(montant::Real)
        montant >= 0 || throw(ArgumentError("Montant USD doit être positif"))
        new(Float64(montant))
    end
end

# 3. Taux de change actualisés (base FCFA):
const TAUX_CHANGE = Dict(
    Euro => 656.0,
    DollarUS => 590.0
)
```

### Partie B: Conversions et Opérations (15 points)

```julia
# 4. Implémentez les conversions automatiques:
function convertir(source::FCFA, ::Type{T}) where T <: DeviseInternationale
    # Conversion FCFA vers devise internationale
end

function convertir(source::T, ::Type{FCFA}) where T <: DeviseInternationale
    # Conversion devise internationale vers FCFA
end

function convertir(source::T1, ::Type{T2}) where {T1 <: DeviseInternationale, T2 <: DeviseInternationale}
    # Conversion entre devises internationales (via FCFA)
end

# 5. Surcharge des opérateurs arithmétiques:
import Base: +, -, *, /, <, >, ==

function +(a::T, b::T) where T <: Devise
    # Addition de même devise
end

function +(a::Devise, b::Devise)
    # Addition de devises différentes (conversion automatique en FCFA)
end

function >(a::Devise, b::Devise)
    # Comparaison via conversion en FCFA
end

# 6. Affichage personnalisé:
function Base.show(io::IO, fcfa::FCFA)
    print(io, "$(round(Int, fcfa.montant)) FCFA")
end

function Base.show(io::IO, eur::Euro)
    print(io, "$(round(eur.montant, digits=2)) EUR")
end

function Base.show(io::IO, usd::DollarUS)
    print(io, "$(round(usd.montant, digits=2)) USD")
end
```

---

## 🛍️ Section 3: Système de Produits et Prix (25 points)

### Partie A: Types de Produits Paramétrés (15 points)

```julia
# 1. Type produit paramétré pour optimisation:
struct Produit{P<:Devise, Q<:Real}
    nom::String
    prix_unitaire::P
    stock_quantite::Q
    unite_mesure::String
    categorie::String
    fournisseur::String
    date_peremption::Union{Date, Nothing}
end

# 2. Constructeurs spécialisés:
function Produit(nom::String, prix::FCFA, stock::Int, unite::String, categorie::String, fournisseur::String)
    # Produit avec prix FCFA et stock en unités entières
end

function Produit(nom::String, prix::Euro, stock::Float64, unite::String, categorie::String, fournisseur::String)
    # Produit importé avec prix EUR et stock en décimales
end

# 3. Méthodes spécialisées selon le type de prix:
function calculer_valeur_stock(produit::Produit{FCFA, Int})
    # Optimisation pour prix FCFA entiers
    return FCFA(produit.prix_unitaire.montant * produit.stock_quantite)
end

function calculer_valeur_stock(produit::Produit{T, Float64}) where T <: DeviseInternationale
    # Gestion précise pour devises internationales et stocks décimaux
    valeur = produit.prix_unitaire.montant * produit.stock_quantite
    return T(round(valeur, digits=2))
end

# 4. Gestion de la péremption:
function est_perime(produit::Produit)
    # Vérifier si le produit est périmé
end

function jours_avant_peremption(produit::Produit)
    # Nombre de jours avant péremption (nothing si pas périssable)
end
```

### Partie B: Types de Prix Flexibles (10 points)

```julia
# 5. Union type pour prix flexibles:
const PrixFlexible = Union{FCFA, Euro, DollarUS, Missing, String}

struct ArticleMarche
    nom::String
    prix::PrixFlexible
    vendeur::String
    qualite::String  # "premium", "standard", "economique"
    negotiable::Bool
end

# 6. Multiple dispatch pour gestion des prix:
function afficher_prix_detaille(article::ArticleMarche, prix::FCFA)
    # Prix fixe en FCFA
end

function afficher_prix_detaille(article::ArticleMarche, prix::DeviseInternationale)
    # Prix en devise étrangère avec conversion
end

function afficher_prix_detaille(article::ArticleMarche, ::Missing)
    # Prix à négocier
end

function afficher_prix_detaille(article::ArticleMarche, prix::String)
    # Prix spécial (ex: "3 pour 1000 FCFA")
end

# 7. Calcul de remises selon le type:
function appliquer_remise_quantite(prix::FCFA, quantite::Int)
    # Remises par paliers: 5% si >10, 10% si >50, 15% si >100
end

function appliquer_remise_qualite(article::ArticleMarche)
    # Remise selon la qualité et négociabilité
end
```

---

## 📈 Section 4: Analyses et Rapports (25 points)

### Partie A: Interface d'Analyse (10 points)

```julia
# 1. Interface pour objets analysables:
abstract type Analysable end

function generer_rapport(obj::Analysable)
    error("generer_rapport doit être implémentée pour $(typeof(obj))")
end

function metriques_cles(obj::Analysable)
    error("metriques_cles doit être implémentée pour $(typeof(obj))")
end

function recommandations(obj::Analysable)
    error("recommandations doit être implémentée pour $(typeof(obj))")
end

# 2. Implémentation pour les magasins:
# Faire hériter Magasin de Analysable
abstract type Magasin <: Analysable end

# 3. Rapports spécialisés par type de magasin
```

### Partie B: Analyses Comparatives (15 points)

```julia
# 4. Fonctions de comparaison et classement:
function comparer_rentabilite(magasins::Vector{<:Magasin})
    # Classer les magasins par rentabilité
end

function analyser_couverture_geographique(magasins::Vector{<:Magasin})
    # Analyser la répartition géographique
end

function optimiser_portfolio(magasins::Vector{<:Magasin}, budget::FCFA)
    # Recommandations d'investissement
end

# 5. Analyses financières:
function calculer_roi_mensuel(magasin::Magasin)
    # Retour sur investissement mensuel
end

function simuler_croissance(magasin::Magasin, taux_croissance::Float64, mois::Int)
    # Simulation de croissance sur N mois
end

function analyser_saisonnalite(magasin::MarcheTraitionnel)
    # Analyse spécifique aux marchés traditionnels
end
```

---

## 🎯 Bonus: Extensions Avancées (+20 points)

### Extensibilité et Performance (+10 points)

```julia
# 1. Méthodes générées dynamiquement:
# Créer automatiquement des méthodes de conversion 
# pour toutes les paires de devises

# 2. Optimisation avec @generated:
@generated function calculer_taxe(montant::T, taux::Float64) where T <: Devise
    # Génération de code optimisé selon le type
end

# 3. Interface pour nouveaux types de magasins:
# Permettre l'ajout facile de nouveaux types sans modification du code existant
```

### Analyses Prédictives (+10 points)

```julia
# 4. Modèles de prédiction simples:
function predire_ventes_saisonniers(magasin::Magasin, historique::Vector{Float64})
    # Prédiction basée sur les tendances saisonnières
end

function detecter_anomalies_stock(produits::Vector{<:Produit})
    # Détection d'anomalies dans les stocks
end

function optimiser_prix_dynamique(produit::Produit, demande::Float64, concurrence::Float64)
    # Optimisation dynamique des prix
end
```

---

## 🧪 Tests et Validation

### Scénarios de Test Obligatoires

```julia
# 1. Test de la hiérarchie de magasins:
function test_magasins()
    magasins = [
        Supermarche("Marina Market", "Zone du Bois", 1200, 25, true),
        Boutique("TechnoMax", "électronique", "Jean Ouédraogo", 150, "BF-2024-001"),
        MarcheTraitionnel("Marché de Rood-Woko", "mercredi", 150, "Ouagadougou", 2000),
        GrosCommerce("CFAO Motors", "import-export", 500_000_000, 120, ["Centre", "Hauts-Bassins"])
    ]
    
    # Tests des méthodes dispatch
    for magasin in magasins
        println("=== $(typeof(magasin)) ===")
        println("CA potentiel: $(calculer_chiffre_affaires_potentiel(magasin))")
        println("Clientèle: $(type_clientele(magasin))")
        println("Rentable: $(est_rentable(magasin))")
        println()
    end
end

# 2. Test du système monétaire:
function test_devises()
    # Conversions automatiques
    salaire_fcfa = FCFA(350_000)
    budget_eur = Euro(800)
    achat_usd = DollarUS(1500)
    
    # Tests d'opérations
    total_fcfa = salaire_fcfa + budget_eur + achat_usd
    println("Total en FCFA: $total_fcfa")
    
    # Tests de comparaisons
    if budget_eur > DollarUS(600)
        println("Budget EUR > 600 USD")
    end
end

# 3. Test des produits:
function test_produits()
    produits = [
        Produit("Riz local", FCFA(350), 1000, "kg", "céréale", "Coopérative Riz Bagré"),
        Produit("iPhone 15", Euro(800), 5.0, "unité", "électronique", "Apple Europe"),
        Produit("Téléviseur Samsung", DollarUS(450), 3.0, "unité", "électronique", "Samsung USA")
    ]
    
    for produit in produits
        valeur = calculer_valeur_stock(produit)
        println("$(produit.nom): Valeur stock = $valeur")
    end
end
```

---

## 📊 Grille d'Évaluation

### Section 1: Hiérarchie de Types (25 points)
- **Types abstraits et concrets (10 pts):** Structure claire, héritage cohérent
- **Méthodes spécialisées (10 pts):** Multiple dispatch fonctionnel
- **Interface commune (5 pts):** Méthodes partagées correctement implémentées

### Section 2: Système Monétaire (25 points)
- **Hiérarchie de devises (8 pts):** Types et validation
- **Conversions automatiques (10 pts):** Dispatch pour toutes les paires
- **Opérateurs surchargés (7 pts):** Arithmétique et comparaisons

### Section 3: Produits et Prix (25 points)
- **Types paramétrés (10 pts):** Optimisation selon les types
- **Prix flexibles (8 pts):** Union types et dispatch
- **Gestion complète (7 pts):** Péremption, remises, validations

### Section 4: Analyses et Rapports (25 points)
- **Interface d'analyse (8 pts):** Contrat et implémentation
- **Comparaisons (10 pts):** Méthodes de classement et analyse
- **Métriques financières (7 pts):** Calculs ROI et simulations

### Bonus (20 points max)
- **Extensions techniques (10 pts):** Génération dynamique, optimisations
- **Analyses prédictives (10 pts):** Modèles et détections

---

## ✅ Critères de Réussite

### Code Fonctionnel:
- [ ] Toutes les méthodes de dispatch fonctionnent correctement
- [ ] Les conversions monétaires sont exactes
- [ ] Les interfaces sont respectées par toutes les implémentations
- [ ] Les tests de validation passent sans erreur

### Performance et Optimisation:
- [ ] Types paramétrés utilisés efficacement
- [ ] Stabilité de type maintenue
- [ ] Multiple dispatch préféré aux conditions if/else
- [ ] Gestion mémoire optimisée

### Qualité du Code:
- [ ] Hiérarchie de types logique et extensible
- [ ] Noms de fonctions et variables descriptifs
- [ ] Documentation des interfaces publiques
- [ ] Gestion d'erreurs appropriée

### Contexte Burkinabè:
- [ ] Données réalistes (prix, devises, commerces)
- [ ] Références géographiques authentiques
- [ ] Pratiques commerciales locales intégrées
- [ ] Adaptation aux réalités économiques

---

## 🚀 Conseils de Développement

### Stratégie Recommandée:
1. **Phase 1 (10 min):** Créer la hiérarchie de types de base
2. **Phase 2 (15 min):** Implémenter le système monétaire complet
3. **Phase 3 (10 min):** Développer les types de produits
4. **Phase 4 (15 min):** Créer les analyses et rapports
5. **Phase bonus (10 min):** Extensions et optimisations

### Priorités:
- **Fonctionnalité avant optimisation**
- **Interface cohérente avant spécialisation**
- **Tests simples avant fonctionnalités avancées**
- **Multiple dispatch systématique**

**Bonne chance pour ce défi de programmation avancée !** 🇧🇫🚀