# 📦 Session 8 : Modules et Packages

## 🎯 Objectifs d'apprentissage
À la fin de cette session, vous saurez :
- Créer vos propres modules Julia
- Organiser votre code en packages réutilisables
- Gérer les dépendances avec Pkg.jl
- Publier et partager vos créations
- Utiliser l'environnement de développement Julia

## 🌍 Introduction : L'organisation comme les coopératives burkinabè

Au Burkina Faso, nous organisons notre travail en coopératives : chacun apporte sa spécialité pour créer quelque chose de plus grand. En Julia, les modules fonctionnent de la même manière !

```julia
# Au lieu d'avoir tout dans un seul fichier gigantesque...
function calculer_impots() ... end
function gerer_employes() ... end  
function traiter_commandes() ... end
# ... 500 autres fonctions ...

# Organisons en modules spécialisés !
module GestionFinanciere
    export calculer_impots, generer_facture
    # Fonctions financières
end

module GestionPersonnel  
    export ajouter_employe, calculer_salaire
    # Fonctions RH
end
```

## 📚 Qu'est-ce qu'un Module ?

Un **module** est un espace de noms qui regroupe des fonctions, types et variables liées. C'est comme organiser une bibliothèque par sections !

### Module simple

```julia
module MathsBurkina
    export aire_cercle, aire_rectangle, convertir_fcfa_euro

    # Constantes locales au module
    const PI_BURKINABE = 3.14159
    const TAUX_CHANGE_EURO = 655.957  # 1 EUR = 655.957 FCFA (approximatif)

    # Fonction publique (exportée)
    function aire_cercle(rayon)
        return PI_BURKINABE * rayon^2
    end

    # Fonction publique
    function aire_rectangle(longueur, largeur)
        return longueur * largeur
    end

    # Fonction publique pour conversion monétaire
    function convertir_fcfa_euro(fcfa)
        return fcfa / TAUX_CHANGE_EURO
    end

    # Fonction privée (non exportée)
    function fonction_interne()
        println("Ceci est privé au module")
    end

end  # fin du module

# Utilisation du module
using .MathsBurkina  # Le point indique un module local

# Maintenant on peut utiliser les fonctions exportées
superficie = aire_cercle(5)
prix_euros = convertir_fcfa_euro(100000)  # 100,000 FCFA en euros

println("Superficie du cercle: $superficie")
println("100,000 FCFA = $(round(prix_euros, digits=2)) EUR")
```

### Contrôle des exportations

```julia
module OutilsBurkina
    # Export seulement certaines fonctions
    export saluer_en_moore, calculer_age_africain
    
    # Fonction exportée
    function saluer_en_moore(nom)
        return "Kongo na $nom!"  # Salut en mooré
    end
    
    # Fonction exportée  
    function calculer_age_africain(annee_naissance)
        # En Afrique, on compte souvent l'année en cours
        return 2024 - annee_naissance + 1
    end
    
    # Fonction NON exportée (usage interne)
    function fonction_secrete()
        return "Ceci est privé!"
    end
    
    # Variable NON exportée
    const SECRET_MODULE = "Valeur cachée"
end

using .OutilsBurkina

# Fonctions disponibles directement
salutation = saluer_en_moore("Aminata")
age = calculer_age_africain(1995)

# Pour accéder aux fonctions non exportées, utiliser le nom complet
# resultat = OutilsBurkina.fonction_secrete()  # Possible mais non recommandé
```

## 🗂️ Organisation en fichiers séparés

### Structure recommandée pour un projet

```
MonProjetBurkina/
├── src/
│   ├── MonProjetBurkina.jl    # Module principal
│   ├── finances.jl             # Sous-module finances
│   ├── agriculture.jl          # Sous-module agriculture
│   └── utils.jl               # Utilitaires communs
├── test/
│   └── runtests.jl            # Tests unitaires
├── Project.toml               # Description du package
└── README.md                  # Documentation
```

### Exemple : Module principal (src/MonProjetBurkina.jl)

```julia
module MonProjetBurkina

# Inclure les sous-modules
include("finances.jl")
include("agriculture.jl") 
include("utils.jl")

# Re-exporter les fonctions importantes
using .Finances
using .Agriculture
using .Utils

export calculer_impots, gerer_recolte, formater_fcfa

# Fonction principale du module
function bienvenue()
    println("🇧🇫 Bienvenue dans MonProjetBurkina!")
    println("Un package Julia pour le développement au Burkina Faso")
end

end  # module
```

### Sous-module finances (src/finances.jl)

```julia
module Finances

export calculer_impots, formater_fcfa, calculer_tva

"""
Calcule les impôts selon le système fiscal burkinabè
"""
function calculer_impots(revenu_annuel::Int)
    if revenu_annuel <= 50000
        return 0  # Exonéré
    elseif revenu_annuel <= 2000000
        return Int(round(revenu_annuel * 0.15))  # 15%
    else
        return Int(round(revenu_annuel * 0.25))  # 25%
    end
end

"""
Formate un montant en FCFA avec séparateurs de milliers
"""
function formater_fcfa(montant::Int)
    # Convertir en string et ajouter les espaces
    str_montant = string(montant)
    longueur = length(str_montant)
    
    if longueur <= 3
        return "$str_montant FCFA"
    end
    
    # Ajouter des espaces tous les 3 chiffres depuis la droite
    resultat = ""
    for (i, char) in enumerate(reverse(str_montant))
        if i > 1 && (i - 1) % 3 == 0
            resultat = " " * resultat
        end
        resultat = char * resultat
    end
    
    return "$resultat FCFA"
end

"""
Calcule la TVA au taux burkinabè (18%)
"""
function calculer_tva(montant_ht::Int)
    return Int(round(montant_ht * 0.18))
end

end  # module Finances
```

### Sous-module agriculture (src/agriculture.jl)

```julia
module Agriculture

export calculer_rendement, prevoir_recolte, saison_optimale

# Types de cultures au Burkina Faso
const CULTURES_BURKINA = [
    "mil", "sorgho", "maïs", "riz", "coton", 
    "arachide", "niébé", "sésame", "igname"
]

"""
Calcule le rendement d'une culture en kg/hectare
"""
function calculer_rendement(production_kg::Int, superficie_ha::Float64)
    return round(production_kg / superficie_ha, digits=2)
end

"""
Prévoit la récolte basée sur la pluviométrie
"""
function prevoir_recolte(culture::String, pluviometrie_mm::Int)
    if !(culture in CULTURES_BURKINA)
        error("Culture non reconnue pour le Burkina Faso")
    end
    
    # Modèle simplifié basé sur la pluviométrie
    if culture in ["mil", "sorgho"]  # Résistantes à la sécheresse
        if pluviometrie_mm >= 400
            return "Excellente récolte prévue"
        elseif pluviometrie_mm >= 250
            return "Bonne récolte prévue"
        else
            return "Récolte difficile prévue"
        end
    elseif culture in ["maïs", "riz"]  # Demandent plus d'eau
        if pluviometrie_mm >= 800
            return "Excellente récolte prévue"
        elseif pluviometrie_mm >= 500
            return "Bonne récolte prévue"
        else
            return "Récolte difficile prévue"
        end
    else
        return "Prévision non disponible pour cette culture"
    end
end

"""
Détermine la saison optimale pour une culture
"""
function saison_optimale(culture::String)
    saisons = Dict(
        "mil" => "Juin - Septembre",
        "sorgho" => "Juin - Octobre", 
        "maïs" => "Mai - Septembre",
        "riz" => "Juin - Novembre",
        "coton" => "Mai - Novembre",
        "arachide" => "Juin - Octobre"
    )
    
    return get(saisons, culture, "Saison non définie")
end

end  # module Agriculture
```

## 📦 Créer un Package complet

### Project.toml - Le fichier de configuration

```toml
name = "MonProjetBurkina"
uuid = "12345678-1234-1234-1234-123456789abc"
version = "1.0.0"
authors = ["Aminata Ouédraogo <aminata@burkina.bf>"]

[deps]
JSON = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"

[compat]
julia = "1.6"
JSON = "0.21"
CSV = "0.10"
DataFrames = "1.3"
```

### Utilisation du gestionnaire de packages

```julia
# Activer l'environnement local
using Pkg
Pkg.activate(".")

# Ajouter des dépendances
Pkg.add("JSON")
Pkg.add("CSV") 
Pkg.add("DataFrames")

# Installer toutes les dépendances
Pkg.instantiate()

# Voir l'état des packages
Pkg.status()

# Mettre à jour les packages
Pkg.update()
```

## 🔧 Gestion avancée des modules

### Modules imbriqués

```julia
module SystemeBancaireBurkina
    export Compte, Transaction, effectuer_virement

    # Module interne pour les comptes
    module Comptes
        export Compte, creer_compte
        
        mutable struct Compte
            numero::String
            titulaire::String
            solde::Int  # en FCFA
            banque::String
        end
        
        function creer_compte(numero, titulaire, banque)
            return Compte(numero, titulaire, 0, banque)
        end
    end
    
    # Module interne pour les transactions
    module Transactions
        export Transaction, effectuer_virement
        
        struct Transaction
            de::String
            vers::String
            montant::Int
            date::String
            reference::String
        end
        
        function effectuer_virement(compte_source, compte_dest, montant)
            # Logique de virement
            println("Virement de $(montant) FCFA effectué")
        end
    end
    
    # Rendre disponibles les types et fonctions importantes
    using .Comptes
    using .Transactions
    
end  # module principal
```

### Chargement conditionnel

```julia
module OutilsAdaptatifs

export afficher_avec_couleur, sauvegarder_donnees

# Chargement conditionnel de packages
function __init__()
    # Vérifier si le package Crayons est disponible pour la couleur
    try
        @eval using Crayons
        @info "Support des couleurs activé"
    catch
        @warn "Package Crayons non trouvé - affichage monochrome"
    end
end

function afficher_avec_couleur(texte, couleur="blanc")
    if @isdefined(Crayons)
        # Utiliser les couleurs si disponible
        if couleur == "rouge"
            println(crayon"red"(texte))
        elseif couleur == "vert"
            println(crayon"green"(texte))
        else
            println(texte)
        end
    else
        # Affichage simple sinon
        println(texte)
    end
end

end
```

## 🌐 Environnements et gestion de projets

### Créer un environnement isolé

```julia
# Créer un nouveau projet
Pkg.generate("MonNouveauProjet")

# Entrer dans le dossier et activer l'environnement
cd("MonNouveauProjet")
Pkg.activate(".")

# Ajouter des dépendances spécifiques à ce projet
Pkg.add("JSON")
Pkg.add("HTTP")

# L'environnement est maintenant isolé
```

### Partager un environnement

```julia
# Générer un fichier Manifest.toml avec les versions exactes
Pkg.instantiate()

# Pour reproduire exactement cet environnement ailleurs :
# 1. Copier Project.toml et Manifest.toml
# 2. Exécuter : Pkg.instantiate()
```

## 📝 Documentation et tests

### Documentation avec docstrings

```julia
module CalculsBurkina

export aire_terrain, prix_construction

"""
    aire_terrain(longueur, largeur)

Calcule la superficie d'un terrain en mètres carrés.

# Arguments
- `longueur::Real`: Longueur du terrain en mètres
- `largeur::Real`: Largeur du terrain en mètres

# Retourne
- `Real`: Superficie en m²

# Exemples
```julia
julia> aire_terrain(50, 30)
1500

julia> aire_terrain(25.5, 40.2)
1025.1
```

# Note
Cette fonction est optimisée pour les terrains rectangulaires 
typiques au Burkina Faso.
"""
function aire_terrain(longueur, largeur)
    return longueur * largeur
end

end
```

### Tests unitaires (test/runtests.jl)

```julia
using Test
using MonProjetBurkina

@testset "Tests du module Finances" begin
    @test calculer_impots(30000) == 0  # Exonéré
    @test calculer_impots(100000) == 15000  # 15%
    @test calculer_impots(3000000) == 750000  # 25%
    
    @test formater_fcfa(1000) == "1 000 FCFA"
    @test formater_fcfa(1000000) == "1 000 000 FCFA"
end

@testset "Tests du module Agriculture" begin
    @test calculer_rendement(5000, 2.5) == 2000.0
    @test saison_optimale("mil") == "Juin - Septembre"
    @test_throws ErrorException prevoir_recolte("banane", 500)  # Culture non reconnue
end

# Exécuter avec : include("test/runtests.jl")
```

## 🎯 Exemple complet : Package "BurkinaUtils"

```julia
module BurkinaUtils

export 
    # Fonctions financières
    formater_fcfa, calculer_impots,
    # Fonctions culturelles  
    saluer_en_langues_locales, convertir_calendrier,
    # Fonctions géographiques
    distance_entre_villes, regions_burkina

include("finances.jl")
include("culture.jl") 
include("geographie.jl")

using .FinancesBurkina
using .CultureBurkina
using .GeographieBurkina

"""
    bienvenue()

Affiche un message de bienvenue pour le package BurkinaUtils.
"""
function bienvenue()
    println("🇧🇫 === BURKINA UTILS ===")
    println("Package Julia pour le développement au Burkina Faso")
    println("Inclut : finances, culture, géographie")
    println("Auteur : Communauté des développeurs burkinabè")
    println("Version : 1.0.0")
    println()
    
    # Démonstration rapide
    println("💰 Exemple financier:")
    println("   100,000 FCFA formaté : $(formater_fcfa(100000))")
    
    println("🗣️  Exemple culturel:")
    println("   Salut en mooré : $(saluer_en_langues_locales("Fatou", "moore"))")
    
    println("🗺️  Exemple géographique:")
    println("   Régions : $(length(regions_burkina())) régions référencées")
end

end  # module BurkinaUtils
```

## 🚀 Publication et partage

### Préparer pour publication

```julia
# 1. Structure de fichiers complète
# 2. Tests qui passent tous
# 3. Documentation claire
# 4. Licence appropriée (MIT, GPL, etc.)

# Vérifier que tout fonctionne
Pkg.test()

# Créer le repository Git
# git init
# git add .
# git commit -m "Version initiale"
# git remote add origin https://github.com/votre-nom/BurkinaUtils.jl
# git push -u origin main
```

### Enregistrement dans le registre Julia

```julia
# Une fois sur GitHub, utiliser PkgTemplates.jl pour la structure
# Puis soumettre au registre général Julia via pull request
```

## 📋 Bonnes pratiques

1. **Organisation claire** : Un module par responsabilité
2. **Noms explicites** : `CalculsFinanciers` plutôt que `Utils`
3. **Documentation** : Chaque fonction publique documentée
4. **Tests** : Couvrir au moins 80% du code
5. **Versioning** : Utiliser le versioning sémantique (1.2.3)
6. **Dépendances minimales** : N'ajouter que ce qui est nécessaire

## 🎯 Points clés à retenir

1. **`module ... end`** : Définit un espace de noms
2. **`export`** : Rend les fonctions publiques
3. **`using`** : Importe et utilise un module
4. **`include()`** : Charge du code depuis un fichier
5. **Project.toml** : Définit les métadonnées et dépendances
6. **Pkg.jl** : Gestionnaire de packages intégré

## 🚀 Dans la pratique suivante...

Nous allons créer :
1. 🧮 Un module d'utilitaires mathématiques
2. 🎮 Un module pour les jeux et divertissements  
3. 📦 Un package complet avec tests et documentation

Prêt(e) à devenir un(e) architecte de code burkinabè ?

🎯 **Un bon module est comme une bonne coopérative : organisé, spécialisé et utile à tous !**