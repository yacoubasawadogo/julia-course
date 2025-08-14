# 📁 Session 7 : Entrées/Sorties de Fichiers et Gestion des Données

## 🎯 Objectifs d'apprentissage
À la fin de cette session, vous saurez :
- Lire et écrire des fichiers texte
- Manipuler des données CSV
- Gérer des fichiers JSON
- Créer des systèmes de sauvegarde et de chargement
- Traiter des erreurs liées aux fichiers

## 🌍 Introduction : Préserver les données comme les traditions burkinabè

Au Burkina Faso, nous préservons nos traditions oralement, de génération en génération. En programmation, nous devons aussi préserver nos données, mais dans des fichiers ! 

```julia
# Au lieu de perdre vos données à chaque fermeture du programme...
scores_jeu = [1500, 2300, 1800]  # Perdues à la fermeture !

# Sauvegardons-les dans un fichier !
# open("scores.txt", "w") do fichier
#     for score in scores_jeu
#         println(fichier, score)
#     end
# end
```

## 📖 Lecture de fichiers texte

### Lecture simple ligne par ligne

```julia
# Méthode 1 : Lecture complète
contenu = read("mon_fichier.txt", String)
println(contenu)

# Méthode 2 : Ligne par ligne (plus efficace pour gros fichiers)
open("mon_fichier.txt", "r") do fichier
    for ligne in eachline(fichier)
        println("Ligne lue: $ligne")
    end
end

# Méthode 3 : Lecture en tableau
lignes = readlines("mon_fichier.txt")
for (i, ligne) in enumerate(lignes)
    println("Ligne $i: $ligne")
end
```

### Exemple pratique : Lire une liste de villes burkinabè

```julia
# Créons d'abord un fichier avec des villes
villes_burkina = [
    "Ouagadougou",
    "Bobo-Dioulasso", 
    "Koudougou",
    "Banfora",
    "Ouahigouya",
    "Pouytenga",
    "Dédougou",
    "Kaya",
    "Gaoua",
    "Fada N'Gourma"
]

# Sauvegarde dans un fichier
open("villes_burkina.txt", "w") do fichier
    for ville in villes_burkina
        println(fichier, ville)
    end
end

# Lecture et traitement
println("🏘️  Villes du Burkina Faso:")
open("villes_burkina.txt", "r") do fichier
    numero = 1
    for ville in eachline(fichier)
        println("$numero. $ville")
        numero += 1
    end
end
```

## ✍️ Écriture de fichiers texte

### Écriture simple

```julia
# Méthode 1 : Écriture directe
write("message.txt", "Bonjour du Burkina Faso!")

# Méthode 2 : Avec open/close automatique
open("rapport.txt", "w") do fichier
    println(fichier, "=== RAPPORT MENSUEL ===")
    println(fichier, "Date: $(Dates.today())")
    println(fichier, "Auteur: Aminata Ouédraogo")
    println(fichier, "")
    println(fichier, "Ventes du mois:")
    println(fichier, "- Pagnes: 150 000 FCFA")
    println(fichier, "- Bijoux: 75 000 FCFA")
end

# Méthode 3 : Ajout à un fichier existant (mode "a")
open("rapport.txt", "a") do fichier
    println(fichier, "")
    println(fichier, "Note ajoutée plus tard...")
end
```

### Exemple : Journal de bord quotidien

```julia
function ajouter_entree_journal(texte::String)
    date_actuelle = Dates.format(Dates.now(), "dd/mm/yyyy HH:MM")
    
    open("journal_burkina.txt", "a") do fichier
        println(fichier, "[$date_actuelle] $texte")
    end
    
    println("✅ Entrée ajoutée au journal")
end

# Utilisation
ajouter_entree_journal("Visite du marché de Ouagadougou - beaucoup d'affluence")
ajouter_entree_journal("Réunion avec les artisans du Faso Dan Fani")
ajouter_entree_journal("Formation en informatique très enrichissante")

# Lecture du journal
println("\n📖 Mon journal:")
if isfile("journal_burkina.txt")
    open("journal_burkina.txt", "r") do fichier
        for ligne in eachline(fichier)
            println(ligne)
        end
    end
end
```

## 📊 Gestion des fichiers CSV

CSV (Comma-Separated Values) est parfait pour les données tabulaires.

### Écriture CSV manuelle

```julia
# Données des étudiants du lycée de Ouagadougou
etudiants = [
    ("Aminata Ouédraogo", 17, "Première A", "Ouagadougou"),
    ("Ibrahim Sawadogo", 16, "Première A", "Koudougou"),
    ("Fatimata Compaoré", 18, "Terminale S", "Bobo-Dioulasso"),
    ("Boureima Traoré", 17, "Terminale S", "Banfora"),
    ("Mariam Kaboré", 16, "Première A", "Ouahigouya")
]

# Écriture CSV
open("etudiants.csv", "w") do fichier
    # En-têtes
    println(fichier, "Nom,Age,Classe,Ville")
    
    # Données
    for (nom, age, classe, ville) in etudiants
        println(fichier, "$nom,$age,$classe,$ville")
    end
end

println("✅ Fichier CSV créé!")
```

### Lecture CSV manuelle

```julia
function lire_csv_etudiants(nom_fichier::String)
    etudiants_lus = []
    
    open(nom_fichier, "r") do fichier
        # Ignorer la première ligne (en-têtes)
        readline(fichier)
        
        for ligne in eachline(fichier)
            # Séparer par les virgules
            champs = split(ligne, ",")
            
            if length(champs) == 4
                nom = champs[1]
                age = parse(Int, champs[2])
                classe = champs[3]
                ville = champs[4]
                
                push!(etudiants_lus, (nom, age, classe, ville))
            end
        end
    end
    
    return etudiants_lus
end

# Test de lecture
etudiants_charges = lire_csv_etudiants("etudiants.csv")
println("\n👥 Étudiants chargés depuis le fichier:")
for (i, (nom, age, classe, ville)) in enumerate(etudiants_charges)
    println("$i. $nom ($age ans) - $classe - $ville")
end
```

### Utilisation du package CSV.jl (plus avancé)

```julia
using CSV, DataFrames

# Lecture avec CSV.jl
df_etudiants = CSV.read("etudiants.csv", DataFrame)
println(df_etudiants)

# Écriture avec CSV.jl
nouveaux_etudiants = DataFrame(
    Nom = ["Abdoulaye Sankara", "Rasmata Compaoré"],
    Age = [17, 16],
    Classe = ["Terminale A", "Première S"],
    Ville = ["Dédougou", "Gaoua"]
)

CSV.write("nouveaux_etudiants.csv", nouveaux_etudiants)
```

## 🗂️ Gestion des fichiers JSON

JSON est parfait pour des données structurées complexes.

### Utilisation du package JSON.jl

```julia
using JSON

# Structure de données complexe : un marché burkinabè
marche_ouaga = Dict(
    "nom" => "Grand Marché de Ouagadougou",
    "ville" => "Ouagadougou",
    "secteurs" => [
        Dict(
            "nom" => "Textile",
            "produits" => ["Pagne Faso Dan Fani", "Boubou", "Tissus"]
        ),
        Dict(
            "nom" => "Artisanat",
            "produits" => ["Masques", "Calebasses", "Bijoux en bronze"]
        ),
        Dict(
            "nom" => "Alimentaire",
            "produits" => ["Mil", "Sorgho", "Arachides", "Karité"]
        )
    ],
    "horaires" => Dict(
        "ouverture" => "06:00",
        "fermeture" => "18:00",
        "jours_fermes" => ["Dimanche matin"]
    ),
    "contact" => Dict(
        "telephone" => "+226 25 30 XX XX",
        "email" => "marche.ouaga@bf.gov"
    )
)

# Sauvegarde en JSON
open("marche_ouaga.json", "w") do fichier
    JSON.print(fichier, marche_ouaga, 4)  # 4 = indentation pour lisibilité
end

println("✅ Données du marché sauvegardées en JSON")

# Lecture depuis JSON
marche_charge = JSON.parsefile("marche_ouaga.json")

println("\n🏪 Informations du marché chargées:")
println("Nom: $(marche_charge["nom"])")
println("Ville: $(marche_charge["ville"])")
println("Secteurs disponibles:")
for secteur in marche_charge["secteurs"]
    println("  - $(secteur["nom"]): $(join(secteur["produits"], ", "))")
end
```

## 💾 Sauvegarde d'état de jeu

Exemple pratique : sauvegarder l'état d'un jeu.

```julia
# Structure de données d'un joueur
mutable struct JoueurSauvegarde
    nom::String
    niveau::Int
    points::Int
    inventaire::Vector{String}
    position::Tuple{Int, Int}
    derniere_connexion::String
end

# Fonction pour sauvegarder un joueur
function sauvegarder_joueur(joueur::JoueurSauvegarde, nom_fichier::String)
    donnees_joueur = Dict(
        "nom" => joueur.nom,
        "niveau" => joueur.niveau,
        "points" => joueur.points,
        "inventaire" => joueur.inventaire,
        "position" => [joueur.position[1], joueur.position[2]],
        "derniere_connexion" => joueur.derniere_connexion
    )
    
    open(nom_fichier, "w") do fichier
        JSON.print(fichier, donnees_joueur, 2)
    end
    
    println("💾 Partie de $(joueur.nom) sauvegardée!")
end

# Fonction pour charger un joueur
function charger_joueur(nom_fichier::String)
    if !isfile(nom_fichier)
        println("❌ Fichier de sauvegarde non trouvé!")
        return nothing
    end
    
    donnees = JSON.parsefile(nom_fichier)
    
    joueur = JoueurSauvegarde(
        donnees["nom"],
        donnees["niveau"],
        donnees["points"],
        donnees["inventaire"],
        (donnees["position"][1], donnees["position"][2]),
        donnees["derniere_connexion"]
    )
    
    println("📂 Partie de $(joueur.nom) chargée!")
    return joueur
end

# Test du système de sauvegarde
hero_burkina = JoueurSauvegarde(
    "Tiéméogo le Brave",
    5,
    2500,
    ["Épée traditionnelle", "Amulette de protection", "Calebasse d'eau"],
    (10, 15),
    string(Dates.now())
)

# Sauvegarde
sauvegarder_joueur(hero_burkina, "sauvegarde_tiemeogo.json")

# Simulation d'une modification
hero_burkina.points += 500
hero_burkina.niveau += 1
push!(hero_burkina.inventaire, "Trésor de Yennenga")

# Nouvelle sauvegarde
sauvegarder_joueur(hero_burkina, "sauvegarde_tiemeogo.json")

# Chargement
joueur_charge = charger_joueur("sauvegarde_tiemeogo.json")
if joueur_charge !== nothing
    println("Joueur: $(joueur_charge.nom), Niveau: $(joueur_charge.niveau)")
    println("Points: $(joueur_charge.points)")
    println("Inventaire: $(join(joueur_charge.inventaire, ", "))")
end
```

## 🔍 Gestion des erreurs avec les fichiers

```julia
function lire_fichier_securise(nom_fichier::String)
    try
        contenu = read(nom_fichier, String)
        println("✅ Fichier lu avec succès!")
        return contenu
    catch SystemError as e
        if e.errnum == 2  # Fichier non trouvé
            println("❌ Fichier '$nom_fichier' non trouvé!")
            println("💡 Vérifiez que le fichier existe et que le chemin est correct.")
        elseif e.errnum == 13  # Permission refusée
            println("❌ Permission refusée pour '$nom_fichier'!")
            println("💡 Vérifiez vos droits d'accès au fichier.")
        else
            println("❌ Erreur système: $(e.errnum)")
        end
        return nothing
    catch e
        println("❌ Erreur inattendue: $e")
        return nothing
    end
end

function ecrire_fichier_securise(nom_fichier::String, contenu::String)
    try
        write(nom_fichier, contenu)
        println("✅ Fichier écrit avec succès!")
        return true
    catch SystemError as e
        println("❌ Impossible d'écrire le fichier: $(e.errnum)")
        return false
    catch e
        println("❌ Erreur inattendue lors de l'écriture: $e")
        return false
    end
end

# Tests
contenu = lire_fichier_securise("fichier_inexistant.txt")
succes = ecrire_fichier_securise("test_ecriture.txt", "Contenu de test")
```

## 📁 Manipulation de répertoires et chemins

```julia
# Vérifier l'existence
if isfile("mon_fichier.txt")
    println("Le fichier existe")
end

if isdir("mon_dossier")
    println("Le répertoire existe")
end

# Créer un répertoire
if !isdir("donnees_burkina")
    mkdir("donnees_burkina")
    println("Répertoire créé!")
end

# Lister le contenu d'un répertoire
println("Contenu du répertoire actuel:")
for item in readdir(".")
    type_item = isdir(item) ? "📁" : "📄"
    println("$type_item $item")
end

# Chemin absolu et relatif
println("Répertoire actuel: $(pwd())")
println("Chemin absolu: $(abspath("mon_fichier.txt"))")

# Jointure de chemins (portable entre OS)
chemin_data = joinpath("donnees_burkina", "etudiants", "classe_A.csv")
println("Chemin construit: $chemin_data")
```

## 🎯 Exemple complet : Système de gestion de bibliothèque

```julia
using JSON, Dates

struct Livre
    titre::String
    auteur::String
    isbn::String
    annee::Int
    disponible::Bool
end

mutable struct Bibliotheque
    nom::String
    livres::Vector{Livre}
    
    Bibliotheque(nom::String) = new(nom, Livre[])
end

function sauvegarder_bibliotheque(bib::Bibliotheque, fichier::String)
    donnees = Dict(
        "nom" => bib.nom,
        "livres" => [
            Dict(
                "titre" => livre.titre,
                "auteur" => livre.auteur,
                "isbn" => livre.isbn,
                "annee" => livre.annee,
                "disponible" => livre.disponible
            ) for livre in bib.livres
        ],
        "date_sauvegarde" => string(Dates.now())
    )
    
    open(fichier, "w") do f
        JSON.print(f, donnees, 2)
    end
    
    println("📚 Bibliothèque '$(bib.nom)' sauvegardée!")
end

function charger_bibliotheque(fichier::String)
    if !isfile(fichier)
        println("❌ Fichier de bibliothèque non trouvé!")
        return nothing
    end
    
    donnees = JSON.parsefile(fichier)
    bib = Bibliotheque(donnees["nom"])
    
    for livre_data in donnees["livres"]
        livre = Livre(
            livre_data["titre"],
            livre_data["auteur"], 
            livre_data["isbn"],
            livre_data["annee"],
            livre_data["disponible"]
        )
        push!(bib.livres, livre)
    end
    
    println("📂 Bibliothèque '$(bib.nom)' chargée!")
    println("$(length(bib.livres)) livres disponibles")
    return bib
end

# Test du système
bib_ouaga = Bibliotheque("Bibliothèque Municipale de Ouagadougou")

# Ajout de livres (littérature burkinabè et africaine)
livres_burkina = [
    Livre("Le Parachutage", "Norbert Zongo", "978-2-XXX", 1988, true),
    Livre("Crépuscule des temps anciens", "Nazi Boni", "978-2-YYY", 1962, true),
    Livre("L'Aventure ambiguë", "Cheikh Hamidou Kane", "978-2-ZZZ", 1961, true)
]

for livre in livres_burkina
    push!(bib_ouaga.livres, livre)
end

# Sauvegarde
sauvegarder_bibliotheque(bib_ouaga, "bibliotheque_ouaga.json")

# Chargement (simulation d'un redémarrage)
bib_chargee = charger_bibliotheque("bibliotheque_ouaga.json")

if bib_chargee !== nothing
    println("\n📖 Livres dans la bibliothèque:")
    for (i, livre) in enumerate(bib_chargee.livres)
        statut = livre.disponible ? "✅ Disponible" : "❌ Emprunté"
        println("$i. $(livre.titre) - $(livre.auteur) ($statut)")
    end
end
```

## 📝 Points clés à retenir

1. **Lecture** : `read()`, `readline()`, `readlines()`, `eachline()`
2. **Écriture** : `write()`, `println(fichier, ...)`
3. **Modes d'ouverture** : `"r"` (lecture), `"w"` (écriture), `"a"` (ajout)
4. **CSV** : Format simple pour données tabulaires
5. **JSON** : Format pour données structurées complexes
6. **Gestion d'erreurs** : Toujours prévoir les cas d'échec
7. **Chemins** : Utiliser `joinpath()` pour la portabilité

## 🚀 Dans la pratique suivante...

Nous allons créer :
1. 📊 Un lecteur de fichier de notes d'étudiants
2. 💾 Un système de sauvegarde d'état de jeu
3. 📇 Un gestionnaire de contacts avec persistance

Prêt(e) à devenir un(e) expert(e) en gestion de fichiers burkinabè ? 

🎯 **Les données bien gérées sont comme les traditions bien préservées !**