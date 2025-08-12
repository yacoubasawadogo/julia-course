# 📝 Exercice Principal: Tableaux et Collections
**Module 1 - Session 4** | **Durée: 30 minutes** | **Points: 100**

---

## 📋 Instructions pour les Étudiants

- Utilisez tableaux et dictionnaires de manière appropriée
- Appliquez les fonctions sur collections (map, filter, etc.)
- Créez des compréhensions efficaces quand c'est pertinent
- Validez vos données et gérez les cas d'erreur
- **Total: 100 points + bonus possible**

---

## Section 1: Manipulation de Tableaux de Base (25 points)

### A) Gestion de Notes Scolaires (15 points)

Créez un système de gestion des notes pour une classe:

```julia
# 1. Créez les tableaux suivants:
noms_etudiants = ["Aminata", "Paul", "Marie", "Jean", "Fatou"]
notes_maths = [15, 11, 16, 9, 14]
notes_francais = [12, 14, 13, 11, 15] 
notes_sciences = [17, 9, 12, 15, 16]

# 2. Calculez et affichez:
# - La moyenne de chaque étudiant
# - La moyenne de classe par matière
# - Le nombre d'étudiants avec moyenne générale ≥ 12

# 3. Ajoutez un nouvel étudiant "Seydou" avec les notes [13, 10, 14]
# 4. Trouvez et affichez le nom de l'étudiant avec la meilleure moyenne générale
```

**Tests de validation:**
- Le système doit fonctionner avec un nombre variable d'étudiants
- Les moyennes doivent être arrondies à 2 décimales
- Gérez le cas où il n'y a pas de notes

### B) Analyse de Prix de Marché (10 points)

```julia
# Données: prix de 5 produits sur 7 jours (en FCFA/kg)
produits = ["Riz", "Maïs", "Mil", "Tomate", "Oignon"]
prix_semaine = [
    [350, 360, 340, 370, 365, 355, 375],  # Riz
    [180, 185, 175, 190, 188, 182, 195],  # Maïs
    [160, 165, 155, 170, 168, 162, 175],  # Mil
    [800, 850, 750, 900, 880, 820, 950],  # Tomate (très variable)
    [400, 420, 390, 410, 405, 415, 425]   # Oignon
]

# Calculez pour chaque produit:
# - Prix moyen de la semaine
# - Prix minimum et maximum  
# - Volatilité (max - min)
# - Jour le plus cher et le moins cher

# Trouvez le produit le plus stable (volatilité minimale)
```

---

## Section 2: Dictionnaires et Données Structurées (25 points)

### A) Base de Données Régionale (15 points)

Créez une base de données des régions du Burkina Faso:

```julia
"""
Créez un dictionnaire regions_bf avec pour chaque région:
- nom: nom de la région
- chef_lieu: ville principale  
- population: nombre d'habitants
- superficie: superficie en km²
- provinces: liste des provinces

Données à utiliser:
- Centre: Ouagadougou, 2415266 hab, 2805 km², ["Kadiogo"]
- Hauts-Bassins: Bobo-Dioulasso, 2293319 hab, 25958 km², ["Houet", "Kénédougou", "Tuy"]
- Sud-Ouest: Gaoua, 908354 hab, 16202 km², ["Bougouriba", "Ioba", "Noumbiel", "Poni"]

Implémentez les fonctions:
1. afficher_region(nom_region) - Affiche toutes les infos
2. region_plus_peuplee() - Retourne la région avec le plus d'habitants
3. densite_population(nom_region) - Calcule habitants/km²
4. rechercher_province(nom_province) - Dans quelle région se trouve cette province?
"""
```

### B) Système de Conversion Monétaire (10 points)

```julia
"""
Créez un convertisseur multi-devises avancé:

taux_change = Dict avec les taux par rapport au FCFA:
- EUR: 656, USD: 590, GBP: 750, CHF: 650, CAD: 435, CNY: 82

Fonctions à implémenter:
1. convertir_fcfa(montant, devise_cible) - FCFA vers autre devise
2. convertir_vers_fcfa(montant, devise_origine) - Autre devise vers FCFA  
3. convertir_entre_devises(montant, devise_from, devise_to) - Conversion directe
4. meilleure_conversion(montant_fcfa) - Quelle devise donne le plus gros montant?

Gestion d'erreurs:
- Vérifier que les devises existent
- Messages d'erreur informatifs
- Arrondir à 2 décimales
"""
```

---

## Section 3: Fonctions sur Collections (25 points)

### A) Analyse Statistique (15 points)

Appliquez les fonctions map/filter/reduce sur des données réelles:

```julia
# Données: salaires mensuels d'employés d'une entreprise (FCFA)
salaires = [180000, 250000, 150000, 320000, 200000, 280000, 175000, 
           450000, 190000, 220000, 300000, 160000]

# Utilisez les fonctions appropriées pour:

# 1. MAP: Calculer les salaires nets (retirer 15% d'impôts et 5% CNSS)
# 2. FILTER: Trouver les salaires supérieurs à 200000 FCFA  
# 3. FILTER: Employés éligibles au crédit (salaire net ≥ 150000)
# 4. REDUCE: Masse salariale totale de l'entreprise
# 5. ANY/ALL: Tous les employés ont-ils un salaire ≥ 100000?
# 6. ANY/ALL: Y a-t-il au moins un cadre supérieur (salaire ≥ 400000)?

# Calculez aussi (avec les fonctions Julia):
# - Salaire médian
# - Écart-type approximatif (√(moyenne des (salaire - moyenne)²))
```

### B) Analyse de Performance (10 points)

```julia
# Résultats d'examens: pourcentages de réussite par école
ecoles = ["Lycée Ouezzin", "Lycée Marien N'Gouabi", "Lycée Nelson Mandela", 
          "Complexe Wend-Kuuni", "Lycée Mixte de Gounghin"]
taux_reussite = [85.5, 78.2, 91.3, 67.8, 88.7]  # Pourcentages

# Utilisez les fonctions sur collections pour:
# 1. Trouver les écoles avec taux ≥ 80% (filter)
# 2. Calculer le rang de chaque école (1 = meilleur taux)
# 3. Classifier: "Excellence" (≥90%), "Bien" (≥80%), "Moyen" (<80%)
# 4. Calculer le taux moyen de réussite du district
```

---

## Section 4: Compréhensions et Applications (25 points)

### A) Système de Facturation (15 points)

Créez un système de facturation avec compréhensions:

```julia
# Catalogue produits
catalogue = [
    ("Téléphone Samsung", 125000, "Électronique"),
    ("Sac de riz 50kg", 25000, "Alimentaire"), 
    ("Huile 20L", 18000, "Alimentaire"),
    ("Ordinateur portable", 450000, "Électronique"),
    ("Savon carton", 12000, "Hygiène")
]

# Commandes: (nom_produit, quantité)
commandes = [
    ("Téléphone Samsung", 2),
    ("Sac de riz 50kg", 5),
    ("Huile 20L", 3),
    ("Savon carton", 10)
]

"""
Avec des compréhensions, calculez:

1. Prix TTC par ligne (prix × quantité × 1.18 pour TVA)
2. Montant HT total de la commande  
3. Liste des produits électroniques commandés
4. Remise de 10% si produit alimentaire ET quantité ≥ 5
5. Grille de prix: matrice [produit × quantité] pour qtés 1,5,10,20
   avec remises progressives: 5% à partir de 5, 10% à partir de 10

Affichez une facture détaillée avec:
- Détail par ligne (produit, quantité, prix unitaire, total HT, total TTC)
- Totaux généraux (HT, TVA, TTC)
- Remises appliquées
"""
```

### B) Matrice de Distances (10 points)

```julia
# Coordonnées GPS des principales villes (latitude, longitude)
villes_coords = Dict(
    "Ouagadougou" => (12.3714, -1.5197),
    "Bobo-Dioulasso" => (11.1771, -4.2979), 
    "Koudougou" => (12.2530, -2.3622),
    "Banfora" => (10.6331, -4.7618),
    "Tenkodogo" => (11.7799, -0.3728)
)

"""
Avec une compréhension 2D, créez une matrice de distances approximatives:
distance ≈ 111 × √((lat1-lat2)² + (lon1-lon2)²) km

1. Matrice distances[i,j] = distance entre ville i et ville j
2. Trouvez la paire de villes la plus distante  
3. Créez un "guide de voyage" avec toutes les distances
4. Calculez le trajet total pour visiter toutes les villes (dans l'ordre donné)
"""
```

---

## 🏆 Défi Bonus: Système de Gestion de Stock (+15 points)

Créez un système complet de gestion d'entrepôt:

```julia
"""
Système de gestion d'entrepôt avec:

Structure de données:
- Chaque produit = Dict("nom", "prix_unit", "stock_kg", "categorie", "fournisseur")
- Entrepôt = Array de produits

Produits d'exemple:
- Riz Basmati: 450 FCFA/kg, 2500 kg, céréale, Banzon
- Maïs blanc: 200 FCFA/kg, 5000 kg, céréale, Koudougou  
- Huile palmier: 1200 FCFA/L, 800 L, huile, Bobo-Dioulasso
- Sucre cristallisé: 800 FCFA/kg, 1500 kg, sucre, Banfora
- Mil rouge: 180 FCFA/kg, 1800 kg, céréale, Dori

Fonctionnalités à implémenter:

1. Gestion des stocks:
   - ajouter_stock(nom_produit, quantite)
   - retirer_stock(nom_produit, quantite) avec vérification
   - produits_en_rupture(seuil=1000) - liste des produits sous le seuil

2. Analyses financières:
   - valeur_totale_entrepot()
   - valeur_par_categorie() - Dict categorie => valeur
   - marge_beneficiaire(pourcentage_marge) - prix de vente suggérés

3. Recherche et filtrage:
   - rechercher_par_fournisseur(nom_fournisseur)
   - produits_par_gamme_prix(prix_min, prix_max)
   - top_produits_par_valeur(n=3) - les n produits les plus précieux

4. Rapports:
   - generer_rapport_complet() - statistiques détaillées
   - alerte_gestion() - produits à réapprovisionner, surstocks, etc.

Le système doit être robuste avec gestion d'erreurs et messages informatifs.
"""
```

---

## 📊 Grille d'Auto-évaluation

### Compétences techniques (cochez si maîtrisé):
- [ ] Je crée et manipule des tableaux efficacement
- [ ] Je maîtrise l'indexation base 1 et le slicing
- [ ] J'utilise les dictionnaires pour structurer les données
- [ ] J'applique map/filter/reduce appropriément
- [ ] Je crée des compréhensions lisibles et efficaces
- [ ] Je gère les erreurs d'accès aux collections
- [ ] Je combine tableaux et dictionnaires intelligemment
- [ ] Je calcule des statistiques sur des datasets

### Compétences pratiques:
- [ ] Mes structures de données sont bien choisies
- [ ] Je valide les entrées utilisateur
- [ ] Mes fonctions sont réutilisables et modulaires  
- [ ] J'affiche des résultats formatés et informatifs
- [ ] Je gère les cas limites (collections vides, clés manquantes)

---

## ✅ Finalisation

**Score attendu:**
- Section 1: ___/25 (Manipulation tableaux)
- Section 2: ___/25 (Dictionnaires structurés)
- Section 3: ___/25 (Fonctions collections)
- Section 4: ___/25 (Compréhensions)
- Bonus: ___/15 (Gestion stock)
- **Total: ___/115**

**Points d'attention:**
- N'oubliez pas: Julia est base 1 (premier élément à l'index 1)
- Utilisez `haskey()` avant d'accéder à un dictionnaire
- Préférez les compréhensions aux boucles quand c'est plus lisible
- Validez toujours les données avant traitement

**Applications métier maîtrisées:**
- Gestion scolaire (notes, statistiques)
- Analyse de marché (prix, volatilité)
- Bases de données (régions, employés)
- Systèmes de facturation
- Gestion de stocks

**Prochaine session:** Projets pratiques - Calculatrice avancée et Jeu de combat

**Correction:** `solution_exercise_04_arrays.jl`