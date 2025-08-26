# 🚀 Projets Module 2-3 : Programmation Avancée & Analyse de Données

## 📋 Guide de Sélection des Projets

Bienvenue dans la phase projet de votre formation Julia ! Vous allez maintenant mettre en pratique tout ce que vous avez appris en réalisant un projet complet qui combine :
- ✅ Les concepts du Module 2 (structs, dispatch multiple, I/O, modules)
- ✅ L'analyse de données du Module 3 (DataFrames, statistiques, visualisation)

## 🎯 Comment Choisir Votre Projet ?

### Évaluez vos intérêts :
- **Commerce/Finance** → Projets 1 (Coopérative) ou 3 (Tontine)
- **Transport/Logistique** → Projet 2 (SOTRACO)
- **Agriculture/Météo** → Projets 1 (Coopérative) ou 4 (Prévision)
- **Jeux/Créativité** → Projet 5 (RPG Mossi)

### Évaluez votre niveau :
- **Débutant** : Projets 3 (Tontine) ou 1 (Coopérative)
- **Intermédiaire** : Projets 2 (Transport) ou 5 (RPG)
- **Avancé** : Projet 4 (Prévision Agricole)

## 📂 Les 5 Projets Disponibles

### 1. 🏪 **Système de Gestion de Coopérative Agricole**
**Niveau** : Débutant-Intermédiaire | **Durée** : 2 semaines

**Description** : Créez un système complet pour gérer une coopérative agricole burkinabè avec inventaire, membres, transactions et analyses de ventes.

**Points forts** :
- Application pratique directe pour l'économie locale
- Données réelles de produits agricoles burkinabè
- Analyses financières utiles

**Compétences développées** :
- Gestion de données avec DataFrames
- Analyses statistiques de ventes
- Génération de rapports financiers
- Export CSV/Excel

### 2. 🚌 **Simulateur de Transport SOTRACO**
**Niveau** : Intermédiaire | **Durée** : 2-3 semaines

**Description** : Modélisez et optimisez le réseau de transport public de Ouagadougou avec analyses de fréquentation et optimisation des lignes.

**Points forts** :
- Problème d'optimisation intéressant
- Données géospatiales réelles
- Impact social direct

**Compétences développées** :
- Modélisation de systèmes complexes
- Analyse de données temporelles
- Optimisation de ressources
- Visualisation de statistiques

### 3. 💰 **Application de Tontine Numérique**
**Niveau** : Débutant | **Durée** : 2 semaines

**Description** : Développez une application pour gérer une tontine traditionnelle avec suivi des cotisations, tirages et analyses financières.

**Points forts** :
- Concept culturellement familier
- Logique métier claire
- Application immédiate

**Compétences développées** :
- Gestion de transactions financières
- Calculs de pénalités et intérêts
- Rapports financiers détaillés
- Analyse de ponctualité

### 4. 🌾 **Système de Prévision Agricole**
**Niveau** : Avancé | **Durée** : 3 semaines

**Description** : Analysez les données météorologiques pour prédire les rendements agricoles et fournir des recommandations aux agriculteurs.

**Points forts** :
- Impact économique majeur
- Analyses avancées
- Données réelles du Burkina

**Compétences développées** :
- Analyse de séries temporelles
- Corrélations statistiques
- Modèles prédictifs simples
- Système d'alertes automatiques

### 5. 🎮 **RPG Éducatif : Les Royaumes Mossi**
**Niveau** : Intermédiaire | **Durée** : 2-3 semaines

**Description** : Étendez le jeu d'aventure textuelle avec système de progression, statistiques détaillées et analyse du comportement des joueurs.

**Points forts** :
- Projet ludique et engageant
- Grande liberté créative
- Apprentissage de l'histoire locale

**Compétences développées** :
- Système de progression complexe
- Tracking et analyse de données
- Persistance de données
- Génération de rapports de jeu

## 📊 Données Fournies

Chaque projet inclut des **données test réalistes** :
- ✅ Noms et lieux burkinabè authentiques
- ✅ Montants en FCFA
- ✅ Produits et services locaux
- ✅ Volume suffisant pour analyses (100-2000 lignes)

## 🛠️ Structure de Chaque Projet

```
projet-X/
├── README.md           # Description détaillée
├── requirements.md     # Spécifications complètes
├── starter.jl          # Code de démarrage
├── src/               # Votre code ici
│   ├── main.jl
│   ├── types.jl
│   └── ...
└── data/              # Données test fournies
    └── *.csv
```

## 📈 Progression Suggérée

### Semaine 1 : Fondations
- [ ] Lire et comprendre les requirements
- [ ] Explorer les données fournies
- [ ] Implémenter les structures de base
- [ ] Créer les modules principaux
- [ ] Tests unitaires de base

### Semaine 2 : Analyse de Données
- [ ] Import/export de données CSV
- [ ] Analyses statistiques avec DataFrames
- [ ] Génération de rapports
- [ ] Visualisations (ASCII ou Plots.jl)
- [ ] Optimisations

### Semaine 3 (si disponible) : Perfectionnement
- [ ] Fonctionnalités bonus
- [ ] Interface utilisateur améliorée
- [ ] Documentation complète
- [ ] Tests approfondis
- [ ] Présentation finale

## 🏆 Critères d'Évaluation

Consultez [EVALUATION.md](EVALUATION.md) pour le barème détaillé.

**Répartition des points** :
- 30% Fonctionnalités de base
- 25% Analyse de données
- 25% Qualité du code
- 15% Documentation
- 5% Créativité/Bonus

## 🚀 Comment Commencer ?

1. **Choisissez votre projet** selon vos intérêts et niveau
2. **Lisez le README du projet** choisi
3. **Explorez les données fournies** dans le dossier `data/`
4. **Étudiez le code starter** (`starter.jl`)
5. **Commencez par les requirements** de base
6. **Ajoutez progressivement** les analyses de données

## 💡 Conseils Importants

### ✅ À FAIRE :
- Utilisez les packages DataFrames.jl et CSV.jl
- Réutilisez le code du générateur de données
- Commitez régulièrement votre progression
- Testez avec les données fournies
- Documentez vos fonctions

### ❌ À ÉVITER :
- Ne pas tester avec les vraies données
- Ignorer la gestion d'erreurs
- Code monolithique sans modules
- Oublier l'analyse de données
- Copier-coller sans comprendre

## 🆘 Besoin d'Aide ?

- Consultez les exemples dans chaque `starter.jl`
- Référez-vous aux sessions précédentes
- Utilisez le générateur de données comme référence
- Demandez de l'aide pour les blocages

## 📅 Planning de Remise

- **Fin Semaine 1** : Structure de base fonctionnelle
- **Fin Semaine 2** : Analyses de données implémentées
- **Fin Semaine 3** : Projet complet avec documentation

---

**Bon courage et amusez-vous bien !** 🇧🇫

*"Le code est comme le tissage : chaque ligne compte pour créer quelque chose de beau et utile."*