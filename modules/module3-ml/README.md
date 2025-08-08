# Module 3 : Apprentissage Automatique avec Julia

## Aperçu
Plongez dans l'apprentissage automatique en utilisant l'écosystème ML puissant de Julia, incluant MLJ, DataFrames, calcul GPU et intégration Python.

## Objectifs d'Apprentissage
- Maîtriser le framework MLJ pour l'apprentissage automatique
- Manipuler les données avec DataFrames.jl
- Implémenter la sélection et l'évaluation de modèles
- Exploiter l'accélération GPU
- Intégrer les bibliothèques ML Python

## Planning Semaines 5-6

### Jour 17-18 : Framework MLJ
- **Échauffement Matinal** : Charger et explorer des ensembles de données
- **Exercice** : Entraîner plusieurs modèles
- **Projet** : Tableau de bord de comparaison de modèles

### Jour 19-20 : Maîtrise des DataFrames
- **Échauffement Matinal** : Exercices de manipulation de données
- **Exercice** : Nettoyer des données du monde réel
- **Projet** : Pipeline de données automatisé

### Jour 21-22 : Sélection et Évaluation de Modèles
- **Échauffement Matinal** : Pratique de validation croisée
- **Exercice** : Réglage des hyperparamètres
- **Projet** : Système AutoML

### Jour 23-24 : GPU et Calcul Parallèle
- **Échauffement Matinal** : Benchmarks GPU vs CPU
- **Exercice** : Paralléliser des algorithmes ML
- **Projet** : Système d'entraînement distribué

### Jour 25-26 : Intégration Python
- **Échauffement Matinal** : Exercices PyCall
- **Exercice** : Utiliser scikit-learn depuis Julia
- **Projet Final** : Application ML full-stack

## Exercices

Tous les exercices dans `exercises/` :
- `01_mlj_basics.jl` - Fondamentaux MLJ
- `02_dataframes.jl` - Manipulation de données
- `03_model_selection.jl` - Validation croisée et réglage
- `04_gpu_computing.jl` - Programmation CUDA
- `05_python_bridge.jl` - Intégration Python

## Projets

Projets ML complets dans `projects/` :
- Tableau de Bord Classification Iris
- Prédicteur de Désabonnement Client
- Système de Reconnaissance d'Images
- Prévision de Séries Temporelles
- Moteur de Recommandation

## Concepts ML Clés

### Flux de Travail MLJ
```julia
using MLJ
# Charger les données
X, y = @load_iris
# Choisir le modèle
model = @load DecisionTreeClassifier
# Entraîner
mach = machine(model, X, y)
fit!(mach)
# Prédire
predictions = predict(mach, X)
```

### Accélération GPU
```julia
using CUDA
# Déplacer les données vers le GPU
gpu_array = CuArray(data)
# Effectuer des opérations
result = gpu_array .* 2
```

## Ensembles de Données

Pratiquez avec des données réelles :
- Iris (classification)
- Boston Housing (régression)
- MNIST (classification d'images)
- Désabonnement Client (classification binaire)
- Prix des Actions (séries temporelles)

## Évaluation

- Précision des modèles ML (30%)
- Qualité du code (30%)
- Innovation du projet (25%)
- Optimisation des performances (15%)

## Ressources

- [Documentation MLJ](https://alan-turing-institute.github.io/MLJ.jl/)
- [Guide DataFrames.jl](https://dataframes.juliadata.org/)
- [Tutoriel CUDA.jl](https://cuda.juliagpu.org/)
- [PyCall.jl](https://github.com/JuliaPy/PyCall.jl)

## Exigences du Projet Final

Construire une application ML complète qui :
1. Charge et prétraite les données
2. Entraîne plusieurs modèles
3. Sélectionne le meilleur modèle
4. Déploie avec une API
5. Inclut une visualisation

## Conseils pour Réussir

1. Commencer avec des modèles simples
2. Visualiser tout
3. Suivre les expériences
4. Optimiser les goulots d'étranglement
5. Documenter votre processus

Prêt à maîtriser le ML avec Julia ? Commençons !