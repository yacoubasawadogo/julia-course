# 📇 Exercice 7 : Gestionnaire de Contacts avec Persistance

## 🎯 Mission Principale
Créer un système complet de gestion de contacts pour une organisation burkinabè, avec sauvegarde automatique, import/export de données, et fonctionnalités avancées de recherche.

## 📋 Objectifs d'apprentissage
- Maîtriser la lecture/écriture de fichiers CSV et JSON
- Implémenter un système de persistance robuste
- Créer des fonctionnalités d'import/export de données
- Gérer la validation et l'intégrité des données
- Développer une interface utilisateur complète

---

## 🏗️ Phase 1 : Architecture et structures de base (25 points)

### Étape 1.1 : Structures de données

Créez les structures suivantes pour votre gestionnaire de contacts :

```julia
using JSON, CSV, DataFrames, Dates

# Structure pour une adresse
struct Adresse
    rue::String
    quartier::String
    ville::String
    region::String
    code_postal::String
    
    # TODO: Constructeur avec validation des villes burkinabè
    function Adresse(rue::String, quartier::String, ville::String, region::String, code_postal::String = "")
        # Valider que la ville existe au Burkina Faso
        villes_valides = [
            "Ouagadougou", "Bobo-Dioulasso", "Koudougou", "Banfora", 
            "Ouahigouya", "Pouytenga", "Dédougou", "Kaya", "Gaoua", 
            "Fada N'Gourma", "Ziniaré", "Dori", "Tenkodogo", "Réo"
        ]
        
        # TODO: Vérifier que la ville est dans la liste
        # TODO: Valider que la région correspond à la ville
        # TODO: Créer la nouvelle adresse
    end
end

# Structure pour un contact
mutable struct Contact
    id::String
    nom::String
    prenom::String
    telephones::Vector{String}
    emails::Vector{String}
    adresse::Union{Adresse, Nothing}
    profession::String
    organisation::String
    notes::String
    date_creation::String
    date_modification::String
    tags::Vector{String}
    
    # TODO: Constructeur avec génération automatique d'ID
    function Contact(nom::String, prenom::String)
        # Générer un ID unique (format: BF + année + 6 chiffres aléatoires)
        # Initialiser les vecteurs vides
        # Mettre les dates de création et modification à maintenant
        # TODO: Implémenter le constructeur complet
    end
end

# Structure principale du gestionnaire
mutable struct GestionnaireContacts
    contacts::Vector{Contact}
    fichier_sauvegarde::String
    derniere_sauvegarde::String
    statistiques::Dict{String, Any}
    
    function GestionnaireContacts(fichier::String = "contacts_burkina.json")
        new(Contact[], fichier, "", Dict())
    end
end
```

**🎯 Défi 1.1 :** Implémentez toutes ces structures avec leurs constructeurs et validations complètes.

### Étape 1.2 : Fonctions de base

Implémentez ces fonctions essentielles :

```julia
# Fonction pour générer un ID unique
function generer_id_unique()::String
    # TODO: Format BF + année + 6 chiffres aléatoires
    # Exemple: BF2024123456
end

# Fonction pour valider un numéro de téléphone burkinabè
function valider_telephone(numero::String)::Bool
    # TODO: Formats valides:
    # +226 XX XX XX XX (international)
    # 00226 XX XX XX XX (international)
    # XX XX XX XX (local, 8 chiffres)
    # Préfixes valides: 01, 02, 03, 05, 06, 07 (premiers 2 chiffres)
end

# Fonction pour valider un email
function valider_email(email::String)::Bool
    # TODO: Vérification basique du format email
    # Doit contenir @ et un point après le @
end

# Fonction pour formater un nom proprement
function formater_nom(nom::String)::String
    # TODO: Première lettre majuscule, reste en minuscule
    # Gérer les noms composés avec tirets ou espaces
end

# Fonction d'affichage d'un contact
function afficher_contact(contact::Contact, format::String = "complet")
    # TODO: Formats "complet", "resume", "carte"
    # Format "carte" = style carte de visite
    # Format "resume" = une ligne
    # Format "complet" = toutes les informations
end
```

**🎯 Défi 1.2 :** Testez vos fonctions avec des données burkinabè réalistes.

---

## 📚 Phase 2 : Gestion CRUD des contacts (30 points)

### Étape 2.1 : Opérations de base

```julia
# Ajouter un contact
function ajouter_contact!(gestionnaire::GestionnaireContacts, contact::Contact)
    # TODO: Vérifier que l'ID n'existe pas déjà
    # TODO: Valider tous les champs du contact
    # TODO: Ajouter au gestionnaire
    # TODO: Mettre à jour les statistiques
    # TODO: Afficher confirmation
end

# Rechercher un contact par ID
function chercher_contact_par_id(gestionnaire::GestionnaireContacts, id::String)
    # TODO: Retourner le contact ou nothing si non trouvé
end

# Rechercher des contacts par nom/prénom
function chercher_contacts_par_nom(gestionnaire::GestionnaireContacts, terme::String)
    # TODO: Recherche insensible à la casse
    # TODO: Chercher dans nom ET prénom
    # TODO: Retourner un vecteur de contacts correspondants
end

# Modifier un contact
function modifier_contact!(gestionnaire::GestionnaireContacts, id::String, champ::String, nouvelle_valeur)
    # TODO: Trouver le contact par ID
    # TODO: Valider la nouvelle valeur selon le champ
    # TODO: Mettre à jour le champ
    # TODO: Mettre à jour la date de modification
    # TODO: Confirmer la modification
end

# Supprimer un contact
function supprimer_contact!(gestionnaire::GestionnaireContacts, id::String)
    # TODO: Trouver le contact par ID
    # TODO: Demander confirmation
    # TODO: Supprimer du gestionnaire
    # TODO: Mettre à jour les statistiques
end

# Lister tous les contacts
function lister_contacts(gestionnaire::GestionnaireContacts, tri::String = "nom")
    # TODO: Options de tri: "nom", "prenom", "date_creation", "ville"
    # TODO: Afficher avec numérotation
    # TODO: Gérer les listes vides
end
```

### Étape 2.2 : Interface de saisie

```julia
function interface_ajout_contact(gestionnaire::GestionnaireContacts)
    println("👤 === AJOUT D'UN NOUVEAU CONTACT ===")
    
    # TODO: Demander toutes les informations nécessaires
    # TODO: Valider chaque champ en temps réel
    # TODO: Permettre d'ajouter plusieurs téléphones/emails
    # TODO: Permettre de saisir l'adresse complète
    # TODO: Créer et ajouter le contact
    # TODO: Afficher récapitulatif
end

function interface_modification_contact(gestionnaire::GestionnaireContacts)
    println("✏️  === MODIFICATION D'UN CONTACT ===")
    
    # TODO: Afficher liste des contacts avec numéros
    # TODO: Permettre sélection par numéro ou ID
    # TODO: Afficher le contact sélectionné
    # TODO: Menu des champs modifiables
    # TODO: Saisie des nouvelles valeurs
    # TODO: Confirmation des modifications
end
```

**🎯 Défi 2 :** Créez au moins 10 contacts avec des données burkinabè réalistes :

Suggestions de contacts :
- Fonctionnaires (Ministères, Mairies)
- Commerçants (Grand Marché, Rood Woko)
- Artisans (Faso Dan Fani, sculpteurs)
- Professionnels (médecins, avocats, enseignants)
- Organisations (associations, ONG)

---

## 💾 Phase 3 : Système de persistance (25 points)

### Étape 3.1 : Sauvegarde et chargement JSON

```julia
# Fonction pour convertir un gestionnaire en dictionnaire
function gestionnaire_vers_dict(gestionnaire::GestionnaireContacts)
    # TODO: Convertir toutes les structures en dictionnaires
    # TODO: Inclure métadonnées (version, date de sauvegarde, etc.)
    # TODO: Gérer les cas où adresse est Nothing
end

# Fonction pour restaurer un gestionnaire depuis un dictionnaire
function dict_vers_gestionnaire(data::Dict)
    # TODO: Reconstruire toutes les structures
    # TODO: Valider l'intégrité des données
    # TODO: Gérer les versions anciennes de sauvegarde
    # TODO: Retourner le gestionnaire reconstruit
end

# Sauvegarde automatique
function sauvegarder_gestionnaire(gestionnaire::GestionnaireContacts)
    # TODO: Créer dossier de sauvegarde si nécessaire
    # TODO: Créer un backup de la sauvegarde précédente
    # TODO: Sauvegarder en JSON avec indentation
    # TODO: Mettre à jour la date de dernière sauvegarde
    # TODO: Afficher confirmation avec taille du fichier
end

# Chargement des données
function charger_gestionnaire(nom_fichier::String)
    # TODO: Vérifier que le fichier existe
    # TODO: Charger et parser le JSON
    # TODO: Valider l'intégrité des données
    # TODO: Reconstruire le gestionnaire
    # TODO: Afficher résumé du chargement
end

# Sauvegarde automatique périodique
function activer_sauvegarde_auto(gestionnaire::GestionnaireContacts, intervalle_minutes::Int = 30)
    # TODO: Créer un système de sauvegarde automatique
    # TODO: Sauvegarder seulement si des modifications ont eu lieu
    # TODO: Afficher notification discrète lors de la sauvegarde
end
```

### Étape 3.2 : Export/Import CSV

```julia
# Export vers CSV
function exporter_csv(gestionnaire::GestionnaireContacts, nom_fichier::String)
    # TODO: Créer un DataFrame avec tous les contacts
    # TODO: Aplatir les structures complexes (adresse, téléphones multiples)
    # TODO: Gérer les caractères spéciaux
    # TODO: Sauvegarder avec CSV.jl
    # TODO: Afficher statistiques d'export
end

# Import depuis CSV
function importer_csv(gestionnaire::GestionnaireContacts, nom_fichier::String)
    # TODO: Lire le fichier CSV
    # TODO: Valider les en-têtes de colonnes
    # TODO: Convertir chaque ligne en Contact
    # TODO: Gérer les doublons (même nom/prénom)
    # TODO: Afficher rapport d'import (réussis/échoués)
end

# Export spécialisé pour cartes de visite
function exporter_cartes_visite(gestionnaire::GestionnaireContacts, nom_fichier::String)
    # TODO: Format spécial pour impression de cartes
    # TODO: Inclure seulement les informations essentielles
    # TODO: Format texte lisible pour impression
end
```

**🎯 Défi 3 :** Testez tous vos systèmes de sauvegarde et créez des fichiers d'export.

---

## 🔍 Phase 4 : Fonctionnalités avancées (30 points)

### Étape 4.1 : Recherche et filtrage avancés

```julia
# Recherche multi-critères
function recherche_avancee(gestionnaire::GestionnaireContacts; 
                          nom::String = "", 
                          ville::String = "", 
                          profession::String = "",
                          organisation::String = "",
                          tags::Vector{String} = String[])
    # TODO: Filtrer par tous les critères fournis
    # TODO: Recherche insensible à la casse
    # TODO: Support des recherches partielles
    # TODO: Retourner les résultats triés par pertinence
end

# Recherche par proximité géographique
function contacts_par_region(gestionnaire::GestionnaireContacts, region::String)
    # TODO: Filtrer par région
    # TODO: Grouper par ville
    # TODO: Afficher avec statistiques par ville
end

# Détection de doublons
function detecter_doublons(gestionnaire::GestionnaireContacts)
    # TODO: Comparer nom + prénom (avec variations)
    # TODO: Comparer numéros de téléphone
    # TODO: Comparer adresses email
    # TODO: Proposer fusion des doublons
end

# Statistiques avancées
function generer_statistiques(gestionnaire::GestionnaireContacts)
    # TODO: Nombre total de contacts
    # TODO: Répartition par région/ville
    # TODO: Répartition par profession
    # TODO: Contacts les plus anciens/récents
    # TODO: Graphiques textuels simples
end
```

### Étape 4.2 : Système de tags et catégories

```julia
# Gestion des tags
function ajouter_tag!(contact::Contact, tag::String)
    # TODO: Ajouter le tag s'il n'existe pas déjà
    # TODO: Formater le tag (minuscules, sans espaces)
end

function supprimer_tag!(contact::Contact, tag::String)
    # TODO: Retirer le tag du contact
end

function lister_tous_tags(gestionnaire::GestionnaireContacts)
    # TODO: Collecter tous les tags uniques
    # TODO: Compter la fréquence de chaque tag
    # TODO: Trier par fréquence ou alphabétique
end

function contacts_par_tag(gestionnaire::GestionnaireContacts, tag::String)
    # TODO: Filtrer les contacts ayant ce tag
    # TODO: Afficher avec informations résumées
end

# Suggestions de tags automatiques
function suggerer_tags(contact::Contact)
    # TODO: Basé sur la profession
    # TODO: Basé sur l'organisation
    # TODO: Basé sur la ville/région
    # TODO: Retourner liste de suggestions
end
```

### Étape 4.3 : Rapports et analyses

```julia
# Rapport complet
function generer_rapport_complet(gestionnaire::GestionnaireContacts, nom_fichier::String)
    # TODO: Rapport détaillé au format texte
    # TODO: Statistiques générales
    # TODO: Liste par région
    # TODO: Index par profession
    # TODO: Contacts récemment ajoutés/modifiés
end

# Annuaire par organisation
function generer_annuaire_organisations(gestionnaire::GestionnaireContacts)
    # TODO: Grouper par organisation
    # TODO: Trier les contacts dans chaque organisation
    # TODO: Format d'annuaire professionnel
end

# Carnet d'adresses personnel
function generer_carnet_personnel(gestionnaire::GestionnaireContacts, tags_inclus::Vector{String})
    # TODO: Filtrer par tags spécifiés
    # TODO: Format compact pour impression
    # TODO: Ordre alphabétique strict
end
```

---

## 🎮 Phase 5 : Interface utilisateur complète (15 points)

### Menu principal avec toutes les fonctionnalités

```julia
function menu_principal()
    gestionnaire = GestionnaireContacts()
    
    # Tenter de charger une sauvegarde existante
    if isfile(gestionnaire.fichier_sauvegarde)
        print("📂 Sauvegarde existante trouvée. La charger? (o/n): ")
        if lowercase(readline()) == "o"
            gestionnaire = charger_gestionnaire(gestionnaire.fichier_sauvegarde)
        end
    end
    
    while true
        println("\n📇 === GESTIONNAIRE DE CONTACTS BURKINA ===")
        println("👤 Contacts actuels: $(length(gestionnaire.contacts))")
        if !isempty(gestionnaire.derniere_sauvegarde)
            println("💾 Dernière sauvegarde: $(gestionnaire.derniere_sauvegarde)")
        end
        
        println("\n1. 👥 Gestion des contacts")
        println("2. 🔍 Recherche et filtrage")
        println("3. 💾 Import/Export/Sauvegarde")
        println("4. 📊 Statistiques et rapports")
        println("5. 🏷️  Gestion des tags")
        println("6. ⚙️  Administration")
        println("7. 🚪 Quitter (avec sauvegarde)")
        
        print("Votre choix (1-7): ")
        choix = readline()
        
        # TODO: Implémenter chaque menu avec sous-options détaillées
        # Menu 1: Ajouter, modifier, supprimer, lister contacts
        # Menu 2: Recherche simple, avancée, par région, doublons
        # Menu 3: Sauvegarder, charger, exporter CSV, importer CSV
        # Menu 4: Statistiques, rapports, annuaires
        # Menu 5: Gérer tags, suggestions, filtrer par tags
        # Menu 6: Paramètres, nettoyage, vérification intégrité
    end
end
```

---

## 🏅 Système de notation

### Barème détaillé :

- **Phase 1 (25 points) :** Structures correctes avec validation complète
- **Phase 2 (30 points) :** CRUD complet avec interface utilisateur
- **Phase 3 (25 points) :** Système de persistance robuste avec JSON et CSV
- **Phase 4 (30 points) :** Fonctionnalités avancées de recherche et analyse
- **Phase 5 (15 points) :** Interface utilisateur complète et intuitive

### Bonus (jusqu'à 25 points) :
- **Synchronisation cloud** (Google Drive, Dropbox)
- **Export PDF** des annuaires
- **Import depuis vCard** (.vcf)
- **Système de permissions** (public/privé)
- **Historique des modifications** avec undo/redo
- **API REST simple** pour accès externe

---

## 🎯 Critères d'évaluation

### Excellence (115-150 points) :
- ✅ Toutes les phases implémentées parfaitement
- ✅ Interface utilisateur exceptionnelle
- ✅ Gestion d'erreurs exemplaire
- ✅ Code optimisé et bien documenté
- ✅ Au moins 3 fonctionnalités bonus

### Très bien (90-114 points) :
- ✅ Phases 1-4 complètes
- ✅ Interface utilisateur fonctionnelle
- ✅ Persistance de données fiable
- ✅ Une fonctionnalité bonus

### Bien (70-89 points) :
- ✅ Phases 1-3 complètes
- ✅ Fonctionnalités de base opérationnelles
- ✅ Sauvegarde/chargement fonctionnel

### À améliorer (< 70 points) :
- ❌ Phases incomplètes
- ❌ Erreurs dans la persistance
- ❌ Interface non fonctionnelle

---

## 💡 Conseils pour réussir

1. **Commencez par les structures** : Assurez-vous qu'elles sont solides
2. **Testez la persistance tôt** : JSON est critique pour tout le reste
3. **Utilisez des données réalistes** : Noms burkinabè, adresses locales
4. **Gérez les erreurs** : Fichiers corrompus, données invalides
5. **Interface intuitive** : Pensez à un utilisateur non-technique
6. **Documentation** : Commentez votre code pour la maintenance
7. **Validation rigoureuse** : Vérifiez tous les inputs utilisateur

---

## 🚀 Extension possible

Une fois terminé, votre gestionnaire pourrait évoluer vers :
- Application web avec interface graphique
- Synchronisation entre appareils
- Integration avec systèmes de messagerie
- Analyse prédictive des contacts
- Géolocalisation et cartes interactives

**📇 Bon courage pour créer le meilleur gestionnaire de contacts du Burkina Faso !**

---

*Temps estimé : 6-8 heures pour une implémentation complète*
*Difficulté : ⭐⭐⭐⭐⭐ (Expert)*