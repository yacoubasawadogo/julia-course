# 🎓 Exercice 6 : Système de Gestion d'Étudiants

## 🎯 Mission Principale
Créer un système complet de gestion des étudiants pour un lycée burkinabè, avec gestion des notes, classes, et statistiques.

## 📋 Objectifs d'apprentissage
- Concevoir un système multi-structures complexe
- Implémenter des relations entre différents types de données
- Gérer des calculs statistiques et des rapports
- Créer une interface utilisateur interactive en console

---

## 🏗️ Phase 1 : Architecture du système (25 points)

### Étape 1.1 : Structures de base

Créez les structures suivantes :

```julia
# Structure pour un étudiant (immutable pour les infos personnelles)
struct Etudiant
    nom_complet::String
    numero_etudiant::String
    date_naissance::String
    lieu_naissance::String
    contact_urgence::String
    
    # TODO: Ajoutez un constructeur qui génère automatiquement 
    # le numéro d'étudiant au format "BF" + année + 4 chiffres aléatoires
end

# Structure pour une matière
struct Matiere
    nom::String
    coefficient::Int
    enseignant::String
    
    # TODO: Ajoutez validation (coefficient entre 1 et 5)
end

# Structure pour une note (immutable)
struct Note
    matiere::Matiere
    valeur::Float64
    type_evaluation::String  # "Devoir", "Composition", "Examen"
    date::String
    
    # TODO: Ajoutez validation (note entre 0 et 20)
end

# Structure pour une classe (mutable)
mutable struct Classe
    nom::String              # "Première A", "Terminale S", etc.
    niveau::String           # "Première", "Terminale"
    serie::String            # "A", "C", "D", "S"
    etudiants::Vector{Etudiant}
    matieres::Vector{Matiere}
    
    # TODO: Constructeur avec validation
end

# Structure principale du lycée (mutable)
mutable struct Lycee
    nom::String
    ville::String
    classes::Vector{Classe}
    annee_scolaire::String
    
    # TODO: Constructeur
end
```

**🎯 Défi 1.1 :** Implémentez toutes ces structures avec leurs constructeurs et validations.

### Étape 1.2 : Données initiales

Créez un lycée avec des données réalistes :

```julia
# TODO: Créez un lycée "Lycée Mixte de Ouagadougou"
# TODO: Ajoutez 3 classes : "Première A", "Terminale S", "Terminale A"
# TODO: Pour chaque classe, ajoutez 4-5 matières typiques avec enseignants burkinabè

# Suggestions de matières :
# Première A : Français (coef 4), Histoire-Géo (coef 3), Mathématiques (coef 3), etc.
# Terminale S : Mathématiques (coef 5), Physique-Chimie (coef 4), SVT (coef 3), etc.

# Noms d'enseignants suggestions :
# "M. Ouédraogo", "Mme Sawadogo", "M. Compaoré", "Mme Traoré"
```

---

## 📚 Phase 2 : Gestion des étudiants (30 points)

### Étape 2.1 : Fonctions de base

Implémentez ces fonctions :

```julia
# Fonction pour ajouter un étudiant à une classe
function ajouter_etudiant!(classe::Classe, etudiant::Etudiant)
    # TODO: Vérifier que l'étudiant n'existe pas déjà
    # TODO: Ajouter l'étudiant à la classe
    # TODO: Afficher confirmation
end

# Fonction pour chercher un étudiant par numéro
function chercher_etudiant(lycee::Lycee, numero::String)
    # TODO: Chercher dans toutes les classes
    # TODO: Retourner l'étudiant et sa classe si trouvé
end

# Fonction pour afficher la liste des étudiants d'une classe
function afficher_etudiants(classe::Classe)
    # TODO: Afficher nom, numéro, lieu de naissance
    # TODO: Compter le total d'étudiants
end

# Fonction pour transférer un étudiant entre classes
function transferer_etudiant!(lycee::Lycee, numero_etudiant::String, 
                              classe_origine::String, classe_destination::String)
    # TODO: Trouver l'étudiant
    # TODO: Le retirer de la classe origine
    # TODO: L'ajouter à la classe destination
    # TODO: Gérer les erreurs
end
```

### Étape 2.2 : Interface d'inscription

Créez une interface pour inscrire de nouveaux étudiants :

```julia
function interface_inscription(lycee::Lycee)
    println("🎓 === INSCRIPTION NOUVEAU ÉTUDIANT ===")
    
    # TODO: Demander toutes les informations nécessaires
    # TODO: Afficher les classes disponibles
    # TODO: Permettre de choisir la classe
    # TODO: Créer et ajouter l'étudiant
    # TODO: Afficher récapitulatif avec numéro d'étudiant généré
end
```

**🎯 Défi 2 :** Inscrivez au moins 8 étudiants avec des noms burkinabè réalistes, répartis dans vos 3 classes.

Suggestions de noms complets :
- "Aminata Ouédraogo"
- "Ibrahim Sawadogo" 
- "Fatimata Compaoré"
- "Boureima Traoré"
- "Mariam Kaboré"
- "Abdoulaye Sankara"

---

## 📊 Phase 3 : Gestion des notes (35 points)

### Étape 3.1 : Système de notes

Créez une structure pour gérer les notes :

```julia
# Structure pour gérer toutes les notes d'un étudiant
mutable struct BulletinEtudiant
    etudiant::Etudiant
    notes::Vector{Note}
    
    function BulletinEtudiant(etudiant::Etudiant)
        new(etudiant, Note[])
    end
end

# Fonction pour ajouter une note
function ajouter_note!(bulletin::BulletinEtudiant, matiere::Matiere, 
                      valeur::Float64, type_eval::String)
    # TODO: Valider la note (0-20)
    # TODO: Créer la note avec date actuelle
    # TODO: Ajouter au bulletin
end

# Fonction pour calculer la moyenne d'une matière
function moyenne_matiere(bulletin::BulletinEtudiant, nom_matiere::String)
    # TODO: Filtrer les notes de cette matière
    # TODO: Calculer la moyenne pondérée selon le type d'évaluation
    # TODO: Devoir: coef 1, Composition: coef 2, Examen: coef 3
end

# Fonction pour calculer la moyenne générale
function moyenne_generale(bulletin::BulletinEtudiant, classe::Classe)
    # TODO: Calculer moyenne de chaque matière
    # TODO: Appliquer les coefficients des matières
    # TODO: Retourner moyenne générale sur 20
end
```

### Étape 3.2 : Interface de saisie des notes

```julia
function interface_saisie_notes(lycee::Lycee)
    println("📝 === SAISIE DES NOTES ===")
    
    # TODO: Afficher les classes disponibles
    # TODO: Sélectionner une classe
    # TODO: Afficher les étudiants de la classe
    # TODO: Sélectionner un étudiant
    # TODO: Afficher les matières disponibles
    # TODO: Permettre la saisie de plusieurs notes
    # TODO: Afficher le bulletin mis à jour
end
```

### Étape 3.3 : Génération de bulletins

```julia
function generer_bulletin(bulletin::BulletinEtudiant, classe::Classe)
    println("\n📋 === BULLETIN SCOLAIRE ===")
    println("Étudiant: $(bulletin.etudiant.nom_complet)")
    println("Numéro: $(bulletin.etudiant.numero_etudiant)")
    println("Classe: $(classe.nom)")
    println("Année: $(lycee.annee_scolaire)")
    
    # TODO: Afficher les notes par matière
    # TODO: Afficher les moyennes par matière
    # TODO: Afficher la moyenne générale
    # TODO: Afficher le rang dans la classe
    # TODO: Afficher appréciation selon la moyenne
end
```

**🎯 Défi 3 :** Saisissez des notes réalistes pour tous vos étudiants (au moins 3 notes par matière).

---

## 📈 Phase 4 : Statistiques et rapports (20 points)

### Étape 4.1 : Statistiques de classe

```julia
function statistiques_classe(classe::Classe, bulletins::Vector{BulletinEtudiant})
    println("\n📊 === STATISTIQUES $(classe.nom) ===")
    
    # TODO: Nombre total d'étudiants
    # TODO: Moyenne générale de la classe
    # TODO: Note la plus haute et la plus basse
    # TODO: Nombre d'étudiants par tranche de moyenne
    #       (< 10, 10-12, 12-14, 14-16, 16-18, 18-20)
    # TODO: Matière avec la meilleure moyenne
    # TODO: Matière avec la plus faible moyenne
end

function classement_classe(classe::Classe, bulletins::Vector{BulletinEtudiant})
    println("\n🏆 === CLASSEMENT $(classe.nom) ===")
    
    # TODO: Trier les étudiants par moyenne décroissante
    # TODO: Afficher rang, nom, moyenne
    # TODO: Identifier les mentions (Très Bien ≥16, Bien ≥14, Assez Bien ≥12)
end
```

### Étape 4.2 : Rapport du lycée

```julia
function rapport_lycee(lycee::Lycee, tous_bulletins::Vector{BulletinEtudiant})
    println("\n🏫 === RAPPORT GÉNÉRAL $(lycee.nom) ===")
    
    # TODO: Statistiques globales du lycée
    # TODO: Effectifs par classe et niveau
    # TODO: Taux de réussite par classe (moyenne ≥ 10)
    # TODO: Comparaison des performances entre classes
    # TODO: Recommandations d'amélioration
end
```

### Étape 4.3 : Analyse des performances

```julia
function analyser_performances(lycee::Lycee, bulletins::Vector{BulletinEtudiant})
    println("\n🔍 === ANALYSE DES PERFORMANCES ===")
    
    # TODO: Identifier les étudiants en difficulté (moyenne < 8)
    # TODO: Identifier les étudiants excellents (moyenne ≥ 16)
    # TODO: Matières où les étudiants ont le plus de difficultés
    # TODO: Suggestions de soutien ou d'orientation
end
```

---

## 🎮 Phase 5 : Interface utilisateur complète (15 points)

### Créez un menu principal interactif :

```julia
function menu_principal(lycee::Lycee)
    bulletins = BulletinEtudiant[]  # Base de données des bulletins
    
    while true
        println("\n🏫 === SYSTÈME DE GESTION - $(lycee.nom) ===")
        println("1. 👥 Gestion des étudiants")
        println("2. 📝 Gestion des notes")
        println("3. 📋 Bulletins et rapports")
        println("4. 📊 Statistiques")
        println("5. ⚙️  Administration")
        println("6. 🚪 Quitter")
        
        print("Votre choix (1-6): ")
        choix = readline()
        
        # TODO: Implémenter chaque menu avec sous-options
        # Menu 1: Inscrire, chercher, transférer étudiants
        # Menu 2: Saisir notes, modifier notes
        # Menu 3: Générer bulletins, imprimer classements
        # Menu 4: Stats par classe, rapport lycée, analyses
        # Menu 5: Ajouter classes, modifier matières
    end
end
```

---

## 🏅 Système de notation

### Barème détaillé :

- **Phase 1 (25 points) :** Structures correctement définies avec constructeurs et validations
- **Phase 2 (30 points) :** Gestion complète des étudiants avec interface
- **Phase 3 (35 points) :** Système de notes fonctionnel avec calculs corrects
- **Phase 4 (20 points) :** Statistiques et rapports complets
- **Phase 5 (15 points) :** Interface utilisateur fluide et complète

### Bonus (jusqu'à 25 points) :
- **Sauvegarde automatique** des données dans un fichier
- **Système d'authentification** pour les enseignants
- **Gestion des absences** et retards
- **Calendrier scolaire** avec gestion des périodes
- **Interface graphique** simple avec des packages Julia

---

## 🎯 Critères d'évaluation

### Excellence (90-125 points) :
- ✅ Toutes les phases implémentées
- ✅ Code bien structuré et commenté
- ✅ Gestion d'erreurs robuste
- ✅ Interface utilisateur intuitive
- ✅ Au moins 2 fonctionnalités bonus

### Très bien (70-89 points) :
- ✅ Phases 1-4 complètes
- ✅ Interface de base fonctionnelle
- ✅ Calculs corrects
- ✅ Une fonctionnalité bonus

### Bien (50-69 points) :
- ✅ Phases 1-3 complètes
- ✅ Fonctionnalités de base opérationnelles
- ✅ Quelques bugs mineurs acceptables

### À améliorer (< 50 points) :
- ❌ Phases incomplètes
- ❌ Erreurs majeures dans les calculs
- ❌ Interface non fonctionnelle

---

## 💡 Conseils pour réussir

1. **Commencez simple** : Implémentez d'abord les structures de base
2. **Testez au fur et à mesure** : Vérifiez chaque fonction avant de passer à la suivante
3. **Utilisez des données réalistes** : Noms burkinabè, matières du système éducatif local
4. **Gérez les erreurs** : Anticipez les saisies incorrectes
5. **Commentez votre code** : Expliquez votre logique
6. **Optimisez l'interface** : Rendez-la intuitive pour un utilisateur non-programmeur

---

## 🚀 Extension possible

Une fois terminé, vous pourrez étendre votre système pour :
- Gérer plusieurs années scolaires
- Intégrer un système de messagerie interne
- Générer des documents PDF
- Créer des graphiques de progression
- Connecter à une base de données

**🎓 Bon courage, futurs gestionnaires d'établissement scolaire burkinabè !**

---

*Temps estimé : 4-6 heures pour une implémentation complète*
*Difficulté : ⭐⭐⭐⭐ (Avancé)*