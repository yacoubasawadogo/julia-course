# Module 2 : Programmation Julia Avancée

## Aperçu
Maîtrisez les concepts avancés de Julia incluant les structures de données, la répartition multiple, le développement de paquets et l'optimisation des performances.

## Objectifs d'Apprentissage
- Maîtriser les structures de données puissantes de Julia
- Comprendre et exploiter la répartition multiple
- Créer et gérer des paquets Julia
- Optimiser le code pour des performances maximales

## Planning Semaines 3-4

### Jour 9-10 : Terrain de Jeu des Structures de Données
- **Échauffement Matinal** : Défis de manipulation de tableaux
- **Exercice** : Visualiseur d'opérations matricielles
- **Projet** : Système de gestion de contacts

### Jour 11-12 : Magie de la Répartition Multiple
- **Échauffement Matinal** : Jeux de surcharge de fonctions
- **Exercice** : Moteur physique avec répartition
- **Projet** : Système de types personnalisé pour un jeu

### Jour 13-14 : Gestion des Paquets
- **Échauffement Matinal** : Exploration de paquets
- **Exercice** : Créer un paquet utilitaire
- **Projet** : Publier votre premier paquet

### Jour 15-16 : Optimisation des Performances
- **Échauffement Matinal** : Compétitions de vitesse
- **Exercice** : Profiler et optimiser le code
- **Projet** : Processeur de données haute performance

## Exercices

Tous les exercices sont dans le dossier `exercises/` :
- `01_data_structures.jl` - Tableaux, matrices, dictionnaires
- `02_multiple_dispatch.jl` - Spécialisation de méthodes
- `03_package_creation.jl` - Construire un paquet
- `04_performance.jl` - Techniques d'optimisation

## Projets

Projets complets dans `projects/` :
- Processeur d'Images (matrices)
- Simulateur Physique (répartition)
- Paquet Utilitaire (packaging)
- Pipeline de Données (performance)

## Concepts Clés

### Répartition Multiple
```julia
# Même fonction, comportements différents
process(x::Int) = x * 2
process(x::String) = uppercase(x)
process(x::Vector) = sum(x)
```

### Conseils de Performance
- La stabilité des types est cruciale
- Éviter les variables globales
- Utiliser `@time` et `@benchmark`
- Profiler avant d'optimiser

## Évaluation

- Exercices quotidiens (40%)
- Qualité des projets (40%)
- Performance du code (20%)

## Ressources

- [Conseils de Performance Julia](https://docs.julialang.org/en/v1/manual/performance-tips/)
- [Développement de Paquets](https://pkgdocs.julialang.org/)
- [Guide de Répartition Multiple](https://docs.julialang.org/en/v1/manual/methods/)

## Conseils pour Réussir

1. Benchmarker tout
2. Penser en types
3. Adopter la répartition multiple
4. Profiler avant d'optimiser
5. Partager vos paquets

Prêt pour Julia avancé ? Allons-y !