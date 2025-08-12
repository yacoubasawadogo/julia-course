# 📝 Exercice Principal: Fonctions et Modularité
**Module 1 - Session 3** | **Durée: 30 minutes** | **Points: 100**

---

## 📋 Instructions pour les Étudiants

- Créez des fonctions réutilisables et bien documentées
- Testez chaque fonction avec plusieurs cas d'usage
- Utilisez les bonnes pratiques vues en cours
- Validez vos paramètres d'entrée
- **Total: 100 points + bonus possible**

---

## Section 1: Fonctions de Base (25 points)

### A) Calculatrices Spécialisées (15 points)

Créez les fonctions suivantes avec validation:

```julia
# 1. Calculateur d'aire (5 points)
# Rectangle: function aire_rectangle(longueur, largeur)
# Validation: longueur > 0 ET largeur > 0
# Retour: aire ou message d'erreur

# 2. Calculateur de volume (5 points) 
# Cylindre: function volume_cylindre(rayon, hauteur)
# Utilise π de Julia
# Validation: rayon > 0 ET hauteur > 0

# 3. Calculateur de pourcentage (5 points)
# function calculer_pourcentage(valeur, total)
# Retourne le pourcentage avec 2 décimales
# Validation: total ≠ 0
```

**Tests à effectuer:**
```julia
# Testez vos fonctions avec:
aire_rectangle(5, 3)      # Doit retourner 15
aire_rectangle(-2, 3)     # Doit afficher une erreur
volume_cylindre(2, 5)     # Doit utiliser π
calculer_pourcentage(15, 60)  # Doit retourner 25.0
```

### B) Convertisseurs (10 points)

```julia
# 4. Convertisseur de température (5 points)
# function celsius_vers_fahrenheit(celsius)
# Formule: F = C × 9/5 + 32

# 5. Convertisseur FCFA (5 points)
# function convertir_fcfa(montant, devise)
# devise peut être "EUR" (656 FCFA/€) ou "USD" (590 FCFA/$)
# Si devise inconnue, retourner message d'erreur
```

---

## Section 2: Arguments Avancés (25 points)

### A) Fonction avec Arguments Optionnels (15 points)

Créez un système de facturation pour un magasin:

```julia
"""
Créez: function calculer_facture(prix_unitaire, quantite, tva=0.18, remise=0.0)

Paramètres:
- prix_unitaire: Prix d'un article en FCFA
- quantite: Nombre d'articles
- tva: Taux de TVA (défaut 18%)  
- remise: Remise en pourcentage (défaut 0%)

Calculs:
1. Montant HT = prix_unitaire × quantite
2. Montant après remise = Montant HT × (1 - remise)
3. Montant TVA = Montant après remise × tva
4. Montant TTC = Montant après remise + Montant TVA

Retour: (montant_ht, montant_remise, montant_tva, montant_ttc)
Affichage: Facture détaillée avec tous les montants
"""
```

**Tests requis:**
```julia
# Testez avec:
calculer_facture(1000, 5)                    # TVA 18%, pas de remise
calculer_facture(1000, 5, 0.20)              # TVA 20%, pas de remise  
calculer_facture(1000, 5, 0.18, 0.10)        # TVA 18%, remise 10%
```

### B) Fonction avec Arguments par Mots-Clés (10 points)

```julia
"""
Créez: function analyser_etudiant(nom, notes; 
                                 coefficients=[1,1,1], 
                                 seuil_reussite=10, 
                                 mention_bien=14,
                                 afficher_detail=true)

Calcule la moyenne pondérée et détermine la mention.
Si afficher_detail=true, affiche un bulletin complet.

Mentions: "Très Bien" (≥16), "Bien" (≥14), "Assez Bien" (≥12), 
         "Passable" (≥10), "Échec" (<10)
"""
```

---

## Section 3: Application Pratique - Gestion Agricole (30 points)

### Contexte: Coopérative Agricole Burkinabè

Créez un système complet d'analyse pour une coopérative agricole.

### A) Fonction d'Analyse de Culture (15 points)

```julia
"""
function analyser_culture(nom_culture, surface_ha, production_kg; 
                         prix_vente_kg=200, 
                         couts_production=100000,
                         main_oeuvre=50000,
                         afficher_rapport=true)

Calcule:
- Rendement (kg/ha)
- Chiffre d'affaires 
- Coûts totaux (production + main d'œuvre)
- Bénéfice net
- Rentabilité (bénéfice/coûts × 100)

Si afficher_rapport=true: affiche rapport détaillé
Retourne: (rendement, ca, benefice, rentabilite_pct)
"""
```

### B) Comparateur de Cultures (15 points)

```julia
"""
function comparer_cultures(culture1, culture2)

Prend deux résultats d'analyser_culture() et détermine:
- Quelle culture a le meilleur rendement
- Quelle culture est la plus rentable
- Recommandation finale

Affiche une comparaison détaillée.
"""
```

**Scénario de test:**
```julia
# Analysez ces deux cultures:
mais = analyser_culture("Maïs", 3.0, 5400, prix_vente_kg=180)
riz = analyser_culture("Riz", 2.0, 6000, prix_vente_kg=350, couts_production=120000)

# Puis comparez:
comparer_cultures(mais, riz)
```

---

## Section 4: Fonctions Avancées (20 points)

### A) Fonction avec Documentation Professionnelle (10 points)

Documentez complètement une de vos fonctions avec:
- Description claire
- Liste des paramètres avec types
- Description du retour
- Au moins 2 exemples d'utilisation
- Notes sur limitations ou cas spéciaux

```julia
"""
    votre_fonction(parametre1, parametre2; option=defaut)

Description détaillée de ce que fait la fonction.

# Arguments
- `parametre1::Type`: Description du paramètre
- `parametre2::Type`: Description du paramètre  
- `option::Type=defaut`: Description de l'option

# Retour
- `Type`: Description de ce qui est retourné

# Exemples
```julia-repl
julia> votre_fonction(exemple1)
resultat_exemple1

julia> votre_fonction(exemple2, option=valeur)
resultat_exemple2
```

# Notes
Informations importantes sur l'utilisation.
"""
function votre_fonction(parametre1, parametre2; option=defaut)
    # Votre implémentation
end
```

### B) Fonction Récursive (10 points)

Choisissez et implémentez une de ces fonctions récursives:

**Option 1: Calcul de Factorielle**
```julia
function factorielle_recursive(n)
    # Cas de base: n <= 1 retourne 1
    # Cas récursif: n * factorielle(n-1)
    # Validation: n >= 0
end
```

**Option 2: Somme des Chiffres**
```julia
function somme_chiffres(nombre)
    # Exemple: somme_chiffres(1234) = 1+2+3+4 = 10
    # Cas de base: nombre < 10
    # Cas récursif: (nombre % 10) + somme_chiffres(nombre ÷ 10)
end
```

**Option 3: PGCD (Plus Grand Commun Diviseur)**
```julia
function pgcd_recursive(a, b)
    # Algorithme d'Euclide récursif
    # Cas de base: b == 0 retourne a
    # Cas récursif: pgcd(b, a % b)
end
```

---

## 🏆 Défi Bonus: Système de Crédit Agricole (+15 points)

Créez un système complet d'évaluation de crédit pour agriculteurs:

```julia
function evaluer_credit_agricole(nom_agriculteur, age, revenus_annuels, 
                               surface_exploitee, type_culture;
                               montant_demande=500000,
                               duree_mois=36,
                               historique="nouveau",
                               garanties=false)

"""
Système d'évaluation automatique avec:

Critères de base:
- Âge entre 21 et 65 ans
- Revenus ≥ 30% du montant demandé  
- Surface ≥ 1 hectare

Scoring bonus:
- Type culture: "riz"=+2pts, "maïs"=+1pt, autres=0pt
- Historique: "excellent"=+3pts, "bon"=+1pt, "nouveau"=0pt
- Garanties: +2pts si true

Décision:
- Score ≥ 6: Approuvé, taux 8%
- Score 3-5: Conditionnel, taux 10%  
- Score < 3: Refusé

Affiche: rapport complet avec justification et calcul de mensualité
"""
```

**Test avec ces profils:**
```julia
# Profil 1: Jeune agriculteur prometteur
evaluer_credit_agricole("Koné Seydou", 28, 600000, 2.5, "riz",
                       montant_demande=400000, historique="bon")

# Profil 2: Agriculteur expérimenté  
evaluer_credit_agricole("Ouédraogo Paul", 45, 1200000, 5.0, "maïs",
                       montant_demande=800000, historique="excellent", 
                       garanties=true)
```

---

## 📊 Grille d'Auto-évaluation

### Compétences techniques (cochez si maîtrisé):
- [ ] Je crée des fonctions avec syntaxe complète et compacte
- [ ] J'utilise les arguments optionnels appropriément  
- [ ] Je maîtrise les arguments par mots-clés
- [ ] Je valide les paramètres d'entrée
- [ ] Je documente mes fonctions professionnellement
- [ ] Je gère les cas d'erreur avec `nothing` ou messages
- [ ] Je retourne des valeurs multiples avec tuples
- [ ] Je crée des fonctions récursives correctes

### Compétences pratiques:
- [ ] Mes fonctions ont des noms explicites
- [ ] Je réutilise mes fonctions dans d'autres fonctions
- [ ] Je sépare la logique métier de l'affichage
- [ ] Mes fonctions sont testables indépendamment
- [ ] J'applique le principe "une fonction, une responsabilité"

---

## ✅ Finalisation

**Score attendu:**
- Section 1: ___/25 (Fonctions de base)
- Section 2: ___/25 (Arguments avancés)
- Section 3: ___/30 (Application agricole)  
- Section 4: ___/20 (Fonctions avancées)
- Bonus: ___/15 (Système de crédit)
- **Total: ___/115**

**Points d'attention:**
- Validez TOUS vos paramètres d'entrée
- Testez avec des cas limites (0, négatif, etc.)
- Utilisez `return` explicitement
- Documentez au moins une fonction complètement

**Prochaine session:** Tableaux et collections - manipuler des données structurées

**Correction:** `solution_exercise_03_functions.jl`