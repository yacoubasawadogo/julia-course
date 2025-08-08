# Exercice 1 : Structures de Données Avancées
# Module 2 : Programmation Julia Avancée
# Durée : 45 minutes

# 📚 AVANT DE COMMENCER
# Lisez le résumé d'apprentissage : resume_01_data_structures.md
# Découvrez comment maîtriser les structures de données vous ouvre la voie vers la Data Science !

println("📚 Consultez le résumé : modules/module2-advanced/resume_01_data_structures.md")
println("Appuyez sur Entrée quand vous êtes prêt à manipuler des données...")
readline()

println("🏗️ Structures de Données Avancées Julia")
println("="^50)

using LinearAlgebra, SparseArrays, Statistics

# Partie 1 : Matrices et Algèbre Linéaire
println("\n📊 Partie 1 : Matrices et Opérations Avancées")

# Créer différents types de matrices
println("Création de matrices spécialisées :")

# Matrice dense classique
matrice_dense = [1 2 3; 4 5 6; 7 8 9]
println("Matrice dense : ", matrice_dense)

# Matrice identité
identite = Matrix{Float64}(I, 3, 3)
println("Matrice identité : ", identite)

# Matrice creuse (sparse)
matrice_creuse = sparse([1, 2, 3], [1, 2, 3], [10, 20, 30])
println("Matrice creuse : ", matrice_creuse)

# Matrice aléatoire
matrice_aleatoire = rand(3, 3)
println("Matrice aléatoire : ", matrice_aleatoire)

# Opérations matricielles avancées
println("\n🧮 Opérations matricielles :")
A = [1.0 2.0; 3.0 4.0]
B = [5.0 6.0; 7.0 8.0]

println("A = ", A)
println("B = ", B)
println("A * B = ", A * B)  # Multiplication matricielle
println("A .* B = ", A .* B)  # Multiplication élément par élément
println("A^2 = ", A^2)  # Puissance matricielle
println("transpose(A) = ", transpose(A))
println("det(A) = ", det(A))  # Déterminant
println("inv(A) = ", inv(A))  # Inverse

# Partie 2 : Tableaux Multidimensionnels
println("\n📈 Partie 2 : Tableaux Multidimensionnels")

# Créer des tenseurs 3D
tenseur_3d = rand(2, 3, 4)
println("Dimensions du tenseur 3D : ", size(tenseur_3d))
println("Nombre d'éléments : ", length(tenseur_3d))
println("Type des éléments : ", eltype(tenseur_3d))

# Indexation avancée
println("\nIndexation avancée :")
arr = reshape(1:24, 4, 6)
println("Array original : ", arr)
println("Première ligne : ", arr[1, :])
println("Première colonne : ", arr[:, 1])
println("Sous-matrice 2x2 : ", arr[1:2, 1:2])

# Views vs copies
println("\nViews vs Copies :")
original = [1, 2, 3, 4, 5]
copie = original[1:3]  # Crée une copie
vue = @view original[1:3]  # Crée une vue

println("Original : ", original)
println("Copie : ", copie)
println("Vue : ", vue)

copie[1] = 999
println("Après modification de la copie :")
println("Original : ", original, " (inchangé)")
println("Copie : ", copie, " (modifié)")

vue[1] = 888
println("Après modification de la vue :")
println("Original : ", original, " (modifié !)")
println("Vue : ", vue, " (modifié)")

# Partie 3 : Dictionnaires Avancés
println("\n🗂️ Partie 3 : Dictionnaires et Structures Associatives")

# Dictionnaires avec différents types
dico_mixte = Dict{String, Any}(
    "nom" => "Julia",
    "version" => 1.8,
    "features" => ["performance", "simplicité", "expressivité"],
    "opensource" => true
)

println("Dictionnaire mixte : ", dico_mixte)

# Opérations sur dictionnaires
println("\nOpérations sur dictionnaires :")
for (clé, valeur) in dico_mixte
    println("$clé => $valeur")
end

# Dictionnaire avec comptage
texte = "julia est un langage julia pour julia"
mots = split(texte)
compteur = Dict{String, Int}()

for mot in mots
    compteur[mot] = get(compteur, mot, 0) + 1
end

println("Compteur de mots : ", compteur)

# Partie 4 : Types Personnalisés Avancés
println("\n🏗️ Partie 4 : Types Personnalisés et Constructeurs")

# Type immutable simple
struct Point2D
    x::Float64
    y::Float64
end

# Type mutable avec méthodes
mutable struct Compte
    nom::String
    solde::Float64
    historique::Vector{String}
    
    # Constructeur interne
    function Compte(nom::String, solde_initial::Float64 = 0.0)
        if solde_initial < 0
            throw(ArgumentError("Le solde initial ne peut pas être négatif"))
        end
        new(nom, solde_initial, ["Ouverture du compte : $(solde_initial)€"])
    end
end

# Méthodes pour le type Compte
function déposer!(compte::Compte, montant::Float64)
    if montant <= 0
        throw(ArgumentError("Le montant doit être positif"))
    end
    compte.solde += montant
    push!(compte.historique, "Dépôt : +$(montant)€ (solde : $(compte.solde)€)")
end

function retirer!(compte::Compte, montant::Float64)
    if montant <= 0
        throw(ArgumentError("Le montant doit être positif"))
    end
    if montant > compte.solde
        throw(ArgumentError("Solde insuffisant"))
    end
    compte.solde -= montant
    push!(compte.historique, "Retrait : -$(montant)€ (solde : $(compte.solde)€)")
end

function afficher_historique(compte::Compte)
    println("=== Historique du compte de $(compte.nom) ===")
    for transaction in compte.historique
        println("  $transaction")
    end
    println("=== Solde actuel : $(compte.solde)€ ===")
end

# Test du système de compte
println("Test du système de compte :")
mon_compte = Compte("Alice", 1000.0)
déposer!(mon_compte, 250.0)
retirer!(mon_compte, 150.0)
afficher_historique(mon_compte)

# Partie 5 : Collections Spécialisées
println("\n📦 Partie 5 : Collections Spécialisées")

# Sets (ensembles)
ensemble_a = Set([1, 2, 3, 4, 5])
ensemble_b = Set([4, 5, 6, 7, 8])

println("Ensemble A : ", ensemble_a)
println("Ensemble B : ", ensemble_b)
println("Union : ", union(ensemble_a, ensemble_b))
println("Intersection : ", intersect(ensemble_a, ensemble_b))
println("Différence : ", setdiff(ensemble_a, ensemble_b))

# Tuples nommés
using NamedTuples
personne = (nom="Bob", age=30, ville="Paris")
println("Personne : ", personne)
println("Nom : ", personne.nom)
println("Age : ", personne.age)

# Partie 6 : Exercices Pratiques
println("\n🎯 Partie 6 : Défis Pratiques")

println("Défi 1 : Analyseur de Texte")
function analyser_texte(texte::String)
    mots = split(lowercase(texte), r"[^a-zàáâäçéèêëïîôùûüÿñ]+")
    filter!(mot -> length(mot) > 0, mots)
    
    stats = Dict{String, Any}()
    stats["nombre_mots"] = length(mots)
    stats["mots_uniques"] = length(unique(mots))
    stats["mot_plus_long"] = argmax(length, mots)
    
    # Fréquence des mots
    freq = Dict{String, Int}()
    for mot in mots
        freq[mot] = get(freq, mot, 0) + 1
    end
    stats["frequences"] = freq
    
    return stats
end

texte_exemple = "Julia est un langage formidable ! Julia permet de programmer efficacement. Julia est rapide !"
résultats = analyser_texte(texte_exemple)
println("Analyse du texte : ", résultats)

println("\nDéfi 2 : Gestionnaire de Stock")
mutable struct Stock
    produits::Dict{String, NamedTuple{(:quantité, :prix), Tuple{Int, Float64}}}
    
    Stock() = new(Dict{String, NamedTuple{(:quantité, :prix), Tuple{Int, Float64}}}())
end

function ajouter_produit!(stock::Stock, nom::String, quantité::Int, prix::Float64)
    if haskey(stock.produits, nom)
        ancien = stock.produits[nom]
        stock.produits[nom] = (quantité = ancien.quantité + quantité, prix = prix)
    else
        stock.produits[nom] = (quantité = quantité, prix = prix)
    end
end

function valeur_stock(stock::Stock)
    total = 0.0
    for (nom, info) in stock.produits
        total += info.quantité * info.prix
    end
    return total
end

# Test du gestionnaire de stock
mon_stock = Stock()
ajouter_produit!(mon_stock, "Ordinateur", 5, 800.0)
ajouter_produit!(mon_stock, "Souris", 20, 25.0)
ajouter_produit!(mon_stock, "Clavier", 10, 60.0)

println("Stock : ", mon_stock.produits)
println("Valeur totale : ", valeur_stock(mon_stock), "€")

# Performance et optimisation
println("\n⚡ Partie 7 : Performance et Optimisation")

# Comparaison performance : tableau vs dictionnaire pour la recherche
function test_performance_recherche()
    n = 100000
    tableau = collect(1:n)
    dico = Dict(i => i for i in 1:n)
    
    # Test recherche dans tableau
    t1 = @elapsed for _ in 1:1000
        5000 in tableau
    end
    
    # Test recherche dans dictionnaire
    t2 = @elapsed for _ in 1:1000
        haskey(dico, 5000)
    end
    
    println("Recherche dans tableau : $(t1*1000)ms")
    println("Recherche dans dictionnaire : $(t2*1000)ms")
    println("Accélération dictionnaire : $(round(t1/t2, digits=2))x")
end

test_performance_recherche()

# Bilan d'apprentissage
println("\n📈 BILAN D'APPRENTISSAGE")
println("="^50)
println("✅ Structures de données maîtrisées :")
println("  - Matrices denses et creuses avec algèbre linéaire")
println("  - Tableaux multidimensionnels et indexation avancée")
println("  - Dictionnaires et structures associatives") 
println("  - Types personnalisés avec constructeurs")
println("  - Collections spécialisées (Sets, NamedTuples)")
println("  - Analyse de performance des structures de données")
println("\n🚀 Vous maîtrisez maintenant les outils de manipulation de données en Julia !")
println("📆 PROCHAINE ÉTAPE : 02_multiple_dispatch.jl - La magie de Julia !")