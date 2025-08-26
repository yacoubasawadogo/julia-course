# 🏪 Système de Gestion de Coopérative Agricole - Code de Démarrage
# Ce fichier fournit une structure de base pour votre projet

using DataFrames, CSV, Dates, Statistics

# ============================================
# STRUCTURES DE DONNÉES
# ============================================

# Structure pour un membre de la coopérative
mutable struct Membre
    id::Int
    nom::String
    prenom::String
    village::String
    region::String
    telephone::String
    date_adhesion::Date
    parts_sociales::Int
    statut::String  # "Actif" ou "Inactif"
end

# Structure pour un produit
mutable struct Produit
    id::Int
    nom::String
    categorie::String
    unite::String
    prix_unitaire::Float64
    stock_actuel::Float64
    stock_minimum::Float64
end

# Structure pour une transaction
struct Transaction
    id::Int
    date::Date
    membre_id::Int
    produit_id::Int
    type::String  # "Achat" ou "Vente"
    quantite::Float64
    prix_unitaire::Float64
    montant_total::Float64
end

# Structure pour la coopérative
mutable struct Cooperative
    nom::String
    membres::Vector{Membre}
    produits::Vector{Produit}
    transactions::Vector{Transaction}
    capital::Float64
end

# ============================================
# FONCTIONS DE CHARGEMENT DES DONNÉES
# ============================================

"""
Charge les membres depuis un fichier CSV
"""
function charger_membres(fichier::String)
    df = CSV.read(fichier, DataFrame)
    membres = Membre[]
    
    for row in eachrow(df)
        membre = Membre(
            row.id,
            row.nom,
            row.prenom,
            row.village,
            row.region,
            row.telephone,
            Date(row.date_adhesion),
            row.parts_sociales,
            row.statut
        )
        push!(membres, membre)
    end
    
    return membres
end

"""
Charge les produits depuis un fichier CSV
"""
function charger_produits(fichier::String)
    df = CSV.read(fichier, DataFrame)
    produits = Produit[]
    
    for row in eachrow(df)
        produit = Produit(
            row.id,
            row.nom,
            row.categorie,
            row.unite,
            Float64(row.prix_unitaire),
            Float64(row.stock_actuel),
            Float64(row.stock_minimum)
        )
        push!(produits, produit)
    end
    
    return produits
end

"""
Charge les transactions depuis un fichier CSV
"""
function charger_transactions(fichier::String)
    df = CSV.read(fichier, DataFrame)
    transactions = Transaction[]
    
    for row in eachrow(df)
        transaction = Transaction(
            row.id,
            Date(row.date),
            row.membre_id,
            row.produit_id,
            row.type,
            Float64(row.quantite),
            Float64(row.prix_unitaire),
            Float64(row.montant_total)
        )
        push!(transactions, transaction)
    end
    
    return transactions
end

# ============================================
# FONCTIONS D'ANALYSE DE BASE
# ============================================

"""
Calcule le chiffre d'affaires total
"""
function chiffre_affaires_total(transactions::Vector{Transaction})
    ventes = filter(t -> t.type == "Vente", transactions)
    return sum(t.montant_total for t in ventes)
end

"""
Calcule les dépenses totales
"""
function depenses_totales(transactions::Vector{Transaction})
    achats = filter(t -> t.type == "Achat", transactions)
    return sum(t.montant_total for t in achats)
end

"""
Trouve les produits avec stock bas
"""
function produits_stock_bas(produits::Vector{Produit})
    return filter(p -> p.stock_actuel <= p.stock_minimum, produits)
end

"""
Calcule les ventes par membre
"""
function ventes_par_membre(transactions::Vector{Transaction}, membres::Vector{Membre})
    resultats = Dict{String, Float64}()
    
    for membre in membres
        ventes_membre = filter(t -> t.membre_id == membre.id && t.type == "Vente", transactions)
        total = sum(t.montant_total for t in ventes_membre)
        nom_complet = "$(membre.prenom) $(membre.nom)"
        resultats[nom_complet] = total
    end
    
    return resultats
end

"""
Top N des produits les plus vendus
"""
function top_produits_vendus(transactions::Vector{Transaction}, produits::Vector{Produit}, n::Int=5)
    ventes = filter(t -> t.type == "Vente", transactions)
    
    # Comptabiliser les ventes par produit
    ventes_par_produit = Dict{Int, Float64}()
    for vente in ventes
        if haskey(ventes_par_produit, vente.produit_id)
            ventes_par_produit[vente.produit_id] += vente.montant_total
        else
            ventes_par_produit[vente.produit_id] = vente.montant_total
        end
    end
    
    # Trier et prendre le top N
    sorted_ventes = sort(collect(ventes_par_produit), by=x->x[2], rev=true)
    top_n = first(sorted_ventes, min(n, length(sorted_ventes)))
    
    # Récupérer les noms des produits
    resultats = []
    for (prod_id, montant) in top_n
        produit = findfirst(p -> p.id == prod_id, produits)
        if produit !== nothing
            push!(resultats, (produits[produit].nom, montant))
        end
    end
    
    return resultats
end

# ============================================
# FONCTIONS D'AFFICHAGE
# ============================================

"""
Affiche un tableau de bord simple
"""
function afficher_tableau_bord(coop::Cooperative)
    println("\n" * "="^60)
    println("📊 TABLEAU DE BORD - $(coop.nom)")
    println("="^60)
    
    # Statistiques générales
    nb_membres_actifs = count(m -> m.statut == "Actif", coop.membres)
    ca = chiffre_affaires_total(coop.transactions)
    depenses = depenses_totales(coop.transactions)
    benefice = ca - depenses
    
    println("\n📈 Statistiques Générales:")
    println("   Membres actifs : $nb_membres_actifs / $(length(coop.membres))")
    println("   Chiffre d'affaires : $(round(Int, ca)) FCFA")
    println("   Dépenses : $(round(Int, depenses)) FCFA")
    println("   Bénéfice net : $(round(Int, benefice)) FCFA")
    
    # Produits avec stock bas
    stock_bas = produits_stock_bas(coop.produits)
    if !isempty(stock_bas)
        println("\n⚠️  Alertes Stock Bas:")
        for p in stock_bas
            println("   - $(p.nom) : $(p.stock_actuel) $(p.unite) (minimum: $(p.stock_minimum))")
        end
    end
    
    # Top produits
    top = top_produits_vendus(coop.transactions, coop.produits, 3)
    if !isempty(top)
        println("\n🏆 Top 3 Produits:")
        for (i, (nom, montant)) in enumerate(top)
            println("   $i. $nom : $(round(Int, montant)) FCFA")
        end
    end
    
    println("\n" * "="^60)
end

"""
Affiche un graphique en barres ASCII
"""
function graphique_barres_ascii(valeurs::Vector{Float64}, labels::Vector{String}, titre::String="")
    if !isempty(titre)
        println("\n$titre")
        println("-"^length(titre))
    end
    
    max_val = maximum(valeurs)
    max_label_len = maximum(length.(labels))
    
    for (label, val) in zip(labels, valeurs)
        label_padded = rpad(label, max_label_len)
        bar_length = round(Int, (val / max_val) * 40)
        bar = "█" ^ bar_length
        println("$label_padded | $bar $(round(Int, val))")
    end
end

# ============================================
# MENU INTERACTIF
# ============================================

"""
Affiche le menu principal
"""
function afficher_menu()
    println("\n🏪 SYSTÈME DE GESTION - COOPÉRATIVE AGRICOLE")
    println("="^50)
    println("1. 📊 Tableau de bord")
    println("2. 👥 Gestion des membres")
    println("3. 📦 Gestion de l'inventaire")
    println("4. 💰 Nouvelle transaction")
    println("5. 📈 Analyses détaillées")
    println("6. 📄 Générer rapport mensuel")
    println("7. 💾 Sauvegarder les données")
    println("8. 🚪 Quitter")
    println("="^50)
    print("Votre choix (1-8) : ")
end

"""
Fonction principale
"""
function main()
    println("🌟 Chargement des données...")
    
    # Charger les données (ajustez les chemins si nécessaire)
    try
        membres = charger_membres("data/membres.csv")
        produits = charger_produits("data/produits.csv")
        transactions = charger_transactions("data/transactions.csv")
        
        # Créer la coopérative
        coop = Cooperative(
            "Coopérative Agricole du Burkina",
            membres,
            produits,
            transactions,
            1000000.0  # Capital initial
        )
        
        println("✅ Données chargées avec succès!")
        println("   $(length(membres)) membres")
        println("   $(length(produits)) produits")
        println("   $(length(transactions)) transactions")
        
        # Boucle du menu
        continuer = true
        while continuer
            afficher_menu()
            choix = readline()
            
            if choix == "1"
                afficher_tableau_bord(coop)
            elseif choix == "2"
                println("\n👥 Module Membres - À implémenter")
                # TODO: Implémenter la gestion des membres
            elseif choix == "3"
                println("\n📦 Module Inventaire - À implémenter")
                # TODO: Implémenter la gestion de l'inventaire
            elseif choix == "4"
                println("\n💰 Nouvelle Transaction - À implémenter")
                # TODO: Implémenter l'ajout de transactions
            elseif choix == "5"
                println("\n📈 Analyses Détaillées")
                # Exemple d'analyse simple
                top = top_produits_vendus(coop.transactions, coop.produits, 5)
                if !isempty(top)
                    valeurs = [t[2] for t in top]
                    labels = [t[1] for t in top]
                    graphique_barres_ascii(valeurs, labels, "Top 5 Produits (FCFA)")
                end
            elseif choix == "6"
                println("\n📄 Génération Rapport - À implémenter")
                # TODO: Implémenter la génération de rapports
            elseif choix == "7"
                println("\n💾 Sauvegarde - À implémenter")
                # TODO: Implémenter la sauvegarde
            elseif choix == "8"
                println("\n👋 Au revoir!")
                continuer = false
            else
                println("\n❌ Choix invalide. Veuillez réessayer.")
            end
        end
        
    catch e
        println("❌ Erreur lors du chargement des données : $e")
        println("Vérifiez que les fichiers CSV sont dans le dossier 'data/'")
    end
end

# ============================================
# EXEMPLES D'UTILISATION
# ============================================

# Pour tester des fonctions individuellement :
# membres = charger_membres("data/membres.csv")
# produits = charger_produits("data/produits.csv")
# transactions = charger_transactions("data/transactions.csv")
# ca = chiffre_affaires_total(transactions)
# println("Chiffre d'affaires : $ca FCFA")

# Lancer le programme
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end