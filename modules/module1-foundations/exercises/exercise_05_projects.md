# 📝 Exercice Principal: Projets Pratiques - Suite d'Applications Burkinabè
**Module 1 - Session 5** | **Durée: 45 minutes** | **Points: 100**

---

## 📋 Instructions pour les Étudiants

- Développez deux projets complets en Julia
- Appliquez tous les concepts vus dans le Module 1
- Créez des interfaces utilisateur attrayantes
- Intégrez des éléments culturels burkinabè authentiques
- **Total: 100 points + bonus possible**

---

## 🧮 Projet 1: Calculatrice Burkinabè Avancée (50 points)

### Cahier des Charges

Créez une calculatrice spécialement adaptée aux besoins burkinabè avec les fonctionnalités suivantes:

#### Section A: Fonctionnalités de Base (20 points)

```julia
# 1. Opérations Arithmétiques (8 points)
# - Addition, soustraction, multiplication, division
# - Calcul de puissances et racines carrées
# - Gestion des erreurs (division par zéro, etc.)

# 2. Calculs de Pourcentages (6 points)
# - TVA burkinabè (18%)
# - Remises commerciales
# - Calculs de marges bénéficiaires

# 3. Conversions de Devises (6 points)
# - FCFA vers EUR, USD, GBP, CHF, CAD, CNY
# - Conversions bidirectionnelles
# - Taux de change actualisés
```

#### Section B: Fonctionnalités Spécialisées (20 points)

```julia
# 1. Calculs Agricoles (8 points)
function calculer_rendement_culture()
    """
    Calcule le rendement d'une culture:
    - Surface cultivée (hectares)
    - Production obtenue (kg ou tonnes)
    - Rendement (kg/hectare)
    - Estimation revenus (prix × production - coûts)
    """
end

function calculer_irrigation()
    """
    Calcule les besoins en irrigation:
    - Surface à irriguer
    - Débit nécessaire (litres/heure)
    - Coût énergétique de pompage
    """
end

# 2. Calculs Commerciaux (7 points) 
function calculer_profit_marche()
    """
    Analyse de rentabilité au marché:
    - Prix d'achat et de vente
    - Quantités vendues
    - Taxes et frais (transport, emplacement)
    - Profit net et marge
    """
end

function calculer_prix_gros_detail()
    """
    Transition grossiste → détaillant:
    - Prix d'achat en gros
    - Marge souhaitée
    - Prix de vente recommandé
    """
end

# 3. Calculs Financiers (5 points)
function calculer_epargne_tontine()
    """
    Simulation d'épargne collective:
    - Montant mensuel par membre
    - Nombre de membres
    - Durée du cycle
    - Total redistribué par personne
    """
end

function calculer_credit_simple()
    """
    Crédit à intérêt simple:
    - Capital emprunté
    - Taux d'intérêt annuel
    - Durée
    - Remboursement total
    """
end
```

#### Section C: Interface et Expérience Utilisateur (10 points)

```julia
# 1. Menu Principal Structuré (4 points)
function afficher_menu_principal()
    """
    Menu avec:
    - ASCII art attrayant
    - Navigation claire
    - Options numérotées
    - Messages contextuels en français
    """
end

# 2. Historique des Calculs (3 points) 
function gestion_historique()
    """
    - Sauvegarde automatique des opérations
    - Affichage avec horodatage
    - Possibilité de vider l'historique
    - Export vers fichier texte
    """
end

# 3. Validation et Gestion d'Erreurs (3 points)
function validation_robuste()
    """
    - Validation des entrées numériques
    - Messages d'erreur informatifs
    - Récupération gracieuse des erreurs
    - Guides d'utilisation intégrés
    """
end
```

---

## ⚔️ Projet 2: Jeu de Combat Traditionnel (50 points)

### Cahier des Charges

Développez un jeu de combat au tour par tour inspiré de la culture burkinabè:

#### Section A: Système de Personnages (18 points)

```julia
# 1. Structure des Combattants (8 points)
mutable struct Combattant
    # À compléter avec tous les attributs nécessaires
    # nom, classe, vie, attaque, défense, niveau, expérience
    # capacités spéciales, origine géographique
end

# Classes disponibles:
classes_personnages = [
    "Guerrier Mossi",     # Tank avec haute défense
    "Chasseur Gourounsi", # DPS avec haute attaque
    "Sage Peul",          # Support avec techniques spéciales
    "Archer Lobi",        # À distance avec esquive
    "Guérisseur Bobo",    # Régénération et soins
    "Griot Mandingue"     # Buffs et débuffs par la musique
]

# 2. Personnages Pré-définis (5 points)
personnages_legendaires = [
    ("Yennenga", "La princesse guerrière mossi"),
    ("Tiéfo Amoro", "Le résistant gourounsi"),
    ("Samory Touré", "Le conquérant mandingue"),
    ("Naaba Oubri", "Le fondateur de Ouagadougou"),
    ("Guimbi Ouattara", "Le chef traditionnel bobo")
]

# 3. Système de Progression (5 points)
function gagner_experience(combattant, xp)
    # Montée de niveau automatique
    # Amélioration des statistiques
    # Déverrouillage de nouvelles techniques
end
```

#### Section B: Mécaniques de Combat (20 points)

```julia
# 1. Combat Tour par Tour (8 points)
function tour_combat(attaquant, defenseur)
    """
    Système de combat avec:
    - Calcul de dégâts avec variation aléatoire
    - Critiques et esquives
    - Effets de statut (poison, étourdissement)
    - Animations textuelles
    """
end

# 2. Techniques Spéciales (7 points)
techniques_traditionnelles = [
    ("Frappe du Wango", "Technique de lutte mossi"),
    ("Tir de l'Ancêtre", "Maîtrise de l'arc lobi"),
    ("Danse du Masque", "Esquive traditionnelle"),
    ("Chant de Guerre", "Intimidation griot"),
    ("Médecine Ancestrale", "Guérison traditionelle"),
    ("Charge du Buffle", "Attaque puissante gourounsi")
]

# 3. IA des Ennemis (5 points)
function intelligence_artificielle(ennemi, joueur)
    """
    IA adaptive qui:
    - Choisit l'action optimale selon la situation
    - Utilise les techniques au bon moment
    - S'adapte au style de jeu du joueur
    - Devient plus difficile avec le temps
    """
end
```

#### Section C: Monde et Narration (12 points)

```julia
# 1. Lieux de Combat (5 points)
lieux_emblematiques = [
    ("Ruines de Loropéni", "Site UNESCO mystérieux"),
    ("Chutes de Banfora", "Cascades sacrées"),
    ("Marché de Gorom-Gorom", "Carrefour commercial du Sahel"),
    ("Forêt de la Comoé", "Nature sauvage du Sud-Ouest"),
    ("Plateau Mossi", "Terre des ancêtres"),
    ("Bords du Mouhoun", "Fleuve légendaire")
]

# Chaque lieu influence le combat (bonus/malus)

# 2. Système de Quêtes Simple (4 points)
function generer_quete()
    """
    Quêtes procédurales:
    - Éliminer X bandits dans lieu Y
    - Récupérer objet sacré perdu
    - Protéger caravane de marchands
    - Défier champion local
    """
end

# 3. Histoire et Dialogue (3 points)
function narrateur_contextuel()
    """
    - Messages d'introduction immersifs
    - Dialogues des PNJ en contexte burkinabè
    - Références historiques et culturelles
    - Moral et leçons traditionnelles
    """
end
```

---

## 🎯 Intégration et Architecture (Bonus: +20 points)

### Menu Principal Unifié

```julia
function suite_applications_burkinabe()
    """
    Application principale qui permet de naviguer entre:
    1. 🧮 Calculatrice Burkinabè
    2. ⚔️ Jeu de Combat Traditionnel
    3. 📊 Statistiques d'utilisation
    4. ⚙️ Paramètres et configuration
    5. ℹ️ À propos et crédits
    """
end
```

### Fonctionnalités Avancées (Bonus)

```julia
# 1. Sauvegarde Persistante (+5 points)
function sauvegarder_progres()
    """
    - Sauvegarde des scores du jeu
    - Historique de la calculatrice
    - Préférences utilisateur
    - Statistiques d'utilisation
    """
end

# 2. Configuration Utilisateur (+5 points)
function parametres_application()
    """
    - Choix de la langue (français/mooré/dioula)
    - Thème d'affichage
    - Niveau de difficulté du jeu
    - Taux de change personnalisés
    """
end

# 3. Aide Contextuelle (+5 points)
function aide_integree()
    """
    - Guide d'utilisation interactif
    - Tutoriels pas-à-pas
    - Explications culturelles
    - FAQ et dépannage
    """
end

# 4. Mode Multijoueur Local (+5 points)
function combat_deux_joueurs()
    """
    - Combat entre deux joueurs humains
    - Tournoi à élimination
    - Statistiques des matchs
    - Classement des joueurs
    """
end
```

---

## 🏛️ Éléments Culturels Obligatoires

### Intégration Authentique

```julia
# 1. Langues Locales
salutations_locales = Dict(
    "mooré" => "Yibeoogo", # "Bonjour" en mooré
    "dioula" => "I ni sogoma", # "Bonjour" en dioula
    "fulfulde" => "Jam waali", # "Bonjour" en peul
    "gourmantchéma" => "Tienu"
)

# 2. Monnaie et Économie
prix_realistes = Dict(
    "sac_riz_50kg" => 25000,      # FCFA
    "telephone_basic" => 45000,    # FCFA
    "moto_yamaha" => 650000,       # FCFA
    "terrain_ouaga" => 15000000,   # FCFA/hectare
    "salaire_minimum" => 30684     # FCFA/mois
)

# 3. Géographie et Climat
donnees_climatiques = Dict(
    "saison_seche" => (11, 4),    # Novembre à Avril
    "saison_pluies" => (5, 10),   # Mai à Octobre
    "temperature_max" => 45,       # Celsius en mars-avril
    "pluviometrie_annuelle" => 600 # mm (moyenne nationale)
)

# 4. Agriculture et Élevage
cultures_principales = [
    ("mil", "culture_principale", 1200, "kg/hectare"),
    ("sorgho", "cereale_base", 1000, "kg/hectare"), 
    ("mais", "culture_cash", 2500, "kg/hectare"),
    ("riz", "irrigue", 4000, "kg/hectare"),
    ("coton", "exportation", 1200, "kg/hectare"),
    ("arachide", "legumineuse", 1500, "kg/hectare")
]
```

---

## 📊 Critères d'Évaluation Détaillés

### Calculatrice (50 points):
- **Fonctionnalités de base (20 pts):**
  - Opérations correctes (8 pts)
  - Pourcentages et TVA (6 pts) 
  - Conversions devises (6 pts)

- **Spécialisations burkinabè (20 pts):**
  - Calculs agricoles (8 pts)
  - Calculs commerciaux (7 pts)
  - Calculs financiers (5 pts)

- **Interface utilisateur (10 pts):**
  - Menu structuré (4 pts)
  - Historique fonctionnel (3 pts)
  - Gestion d'erreurs (3 pts)

### Jeu de Combat (50 points):
- **Système personnages (18 pts):**
  - Structure complète (8 pts)
  - Classes différenciées (5 pts)
  - Progression/XP (5 pts)

- **Mécaniques combat (20 pts):**
  - Combat fonctionnel (8 pts)
  - Techniques spéciales (7 pts)
  - IA ennemis (5 pts)

- **Monde et narration (12 pts):**
  - Lieux authentiques (5 pts)
  - Système quêtes (4 pts)
  - Histoire contextuelle (3 pts)

### Bonus (20 points max):
- Intégration des apps (+5 pts)
- Sauvegarde (+5 pts)
- Configuration (+5 pts)
- Multijoueur (+5 pts)

---

## 🎨 Inspiration Visuelle (ASCII Art)

### Exemples de Présentations

```julia
# Titre calculatrice
calculatrice_titre = """
╔══════════════════════════════════════════════════════════════╗
║                    🧮 CALCULATRICE BURKINABÈ                ║
║                                                              ║
║    "L'union fait la force" - Devise du Burkina Faso 🇧🇫      ║
║                                                              ║
║           Votre assistant pour tous vos calculs             ║
║              du quotidien au Pays des Hommes Intègres       ║
╚══════════════════════════════════════════════════════════════╝
"""

# Titre jeu de combat
combat_titre = """
⚔️ ═══════════════════════════════════════════════════════════ ⚔️
           🎭 COMBAT DES MASQUES TRADITIONNELS 🎭
                    
     Incarnez un héros légendaire du Burkina Faso
           et partez à la conquête de votre destin
                 dans la terre de vos ancêtres !
                 
⚔️ ═══════════════════════════════════════════════════════════ ⚔️
"""

# Barre de séparation thématique
separateur = "🌾" * "═" * 20 * "🏺" * "═" * 20 * "🌾"
```

---

## ✅ Grille d'Auto-évaluation

### Compétences Techniques:
- [ ] Je structure mon code en fonctions modulaires
- [ ] J'utilise des structures de données appropriées  
- [ ] Je gère les erreurs gracieusement
- [ ] Je valide les entrées utilisateur
- [ ] J'implémente des boucles de contrôle robustes
- [ ] Je crée des interfaces utilisateur attrayantes

### Compétences Créatives:
- [ ] J'intègre des éléments culturels authentiques
- [ ] Je crée une expérience utilisateur engageante
- [ ] J'adapte le contenu au contexte burkinabè
- [ ] Je développe une narration immersive
- [ ] Je propose des fonctionnalités innovantes

### Compétences Professionnelles:
- [ ] Mon code est lisible et bien commenté
- [ ] Je teste mes fonctionnalités au fur et à mesure
- [ ] Je respecte les bonnes pratiques Julia
- [ ] Je documente mon travail
- [ ] Je livre un produit fini et fonctionnel

---

## 🚀 Finalisation et Remise

### Livrables Attendus:

1. **Fichiers de Code:**
   - `calculatrice_burkinabe.jl` - Application calculatrice complète
   - `jeu_combat_traditionnel.jl` - Jeu de combat complet
   - `suite_applications.jl` - Menu principal unifié (bonus)

2. **Documentation:**
   - Commentaires dans le code expliquant la logique
   - Guide d'utilisation pour les utilisateurs finaux
   - Liste des fonctionnalités implémentées

3. **Démonstration:**
   - Préparation d'une démonstration de 5 minutes
   - Présentation des éléments culturels intégrés
   - Explication des défis techniques surmontés

### Critères de Réussite:
- **Excellent (90-100 pts):** Tous les objectifs atteints + bonus
- **Très bien (80-89 pts):** Fonctionnalités principales + interface soignée
- **Bien (70-79 pts):** Fonctionnalités de base fonctionnelles
- **Satisfaisant (60-69 pts):** Projets partiellement fonctionnels

---

## 💡 Conseils de Développement

### Stratégie de Développement:

1. **Phase 1 (15 min):** Planification et structure de base
2. **Phase 2 (20 min):** Développement des fonctionnalités core
3. **Phase 3 (10 min):** Interface et expérience utilisateur
4. **Phase 4 (10 min):** Tests, débogage et finitions

### Bonnes Pratiques:
- Testez chaque fonction avant de passer à la suivante
- Utilisez des noms de variables descriptifs en français
- Implémentez la gestion d'erreur dès le début
- Gardez une architecture modulaire
- N'hésitez pas à simplifier si vous manquez de temps

**Bonne chance et que la force des ancêtres vous accompagne dans ce défi !** 🇧🇫✨