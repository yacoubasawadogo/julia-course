# Exercice 2 : DataFrames.jl - Manipulation Avancée de Données
# Module 3 : Apprentissage Automatique avec Julia
# Durée : 60 minutes

# 📚 AVANT DE COMMENCER
# Lisez le résumé d'apprentissage : resume_02_dataframes.md
# Découvrez pourquoi DataFrames.jl révolutionne l'analyse de données !

println("📚 Consultez le résumé : modules/module3-ml/resume_02_dataframes.md")
println("Appuyez sur Entrée quand vous êtes prêt à manipuler des données comme un pro...")
readline()

println("📊 DataFrames.jl : Manipulation Avancée de Données")
println("="^60)

# Installation et importation des paquets
using DataFrames, CSV, Statistics, StatsBase, Dates
using Chain, DataFramesMeta
using Random
Random.seed!(42)

# Configuration d'affichage
ENV["COLUMNS"] = 120  # Pour un meilleur affichage des DataFrames

# Partie 1 : Création et Exploration de DataFrames
println("🏗️ Partie 1 : Création et Exploration de DataFrames")

# Création manuelle d'un DataFrame
println("Création d'un DataFrame de démonstration...")
df_ventes = DataFrame(
    produit=["Ordinateur", "Tablet", "Smartphone", "Écouteurs", "Clavier", "Souris"],
    prix=[1200.0, 600.0, 800.0, 150.0, 80.0, 25.0],
    quantité=[45, 120, 200, 300, 150, 400],
    catégorie=["Électronique", "Électronique", "Électronique", "Audio", "Accessoires", "Accessoires"],
    date_vente=Date(2024, 1, 1):Month(1):Date(2024, 6, 1)
)

println("DataFrame de ventes initial :")
println(df_ventes)

# Exploration basique
println("\nInformations sur le DataFrame :")
println("  - Dimensions : $(size(df_ventes))")
println("  - Colonnes : $(names(df_ventes))")
println("  - Types : ")
for (nom, type) in zip(names(df_ventes), eltype.(eachcol(df_ventes)))
    println("    $nom : $type")
end

# Statistiques descriptives
println("\nStatistiques descriptives :")
println(describe(df_ventes))

# Partie 2 : Indexation et Sélection Avancée
println("\n🎯 Partie 2 : Indexation et Sélection de Données")

println("Sélection par colonnes :")
println("Prix et quantités :")
println(select(df_ventes, [:prix, :quantité]))

println("\nSélection avec transformation :")
df_avec_ca = select(df_ventes,
    :produit,
    :prix,
    :quantité,
    :ca => ByRow((prix, qty) -> prix * qty) => :chiffre_affaires)
println(df_avec_ca)

# Filtrage avancé
println("\nFiltrage des données :")
println("Produits avec prix > 100€ :")
produits_chers = filter(row -> row.prix > 100, df_ventes)
println(produits_chers)

println("\nProduits électroniques avec quantité > 100 :")
électronique_populaire = filter(row -> row.catégorie == "Électronique" && row.quantité > 100, df_ventes)
println(électronique_populaire)

# Partie 3 : Transformations et Mutations
println("\n🔧 Partie 3 : Transformations et Calculs")

# Ajout de colonnes calculées
println("Ajout de colonnes calculées...")
df_enrichi = copy(df_ventes)

# Calcul du chiffre d'affaires
df_enrichi.chiffre_affaires = df_enrichi.prix .* df_enrichi.quantité

# Calcul de catégories de prix
df_enrichi.gamme = map(prix -> prix < 100 ? "Économique" :
                               prix < 500 ? "Milieu de gamme" : "Premium",
    df_enrichi.prix)

# Trimestre de vente
df_enrichi.trimestre = map(date -> "T$(quarter(date))", df_enrichi.date_vente)

println("DataFrame enrichi :")
println(df_enrichi)

# Partie 4 : Groupement et Agrégation
println("\n📈 Partie 4 : Analyse par Groupes")

println("Analyse par catégorie :")
analyse_catégorie = combine(groupby(df_enrichi, :catégorie)) do group
    DataFrame(
        nb_produits=nrow(group),
        ca_total=sum(group.chiffre_affaires),
        prix_moyen=mean(group.prix),
        quantité_totale=sum(group.quantité)
    )
end
println(analyse_catégorie)

println("\nAnalyse par gamme de prix :")
analyse_gamme = combine(groupby(df_enrichi, :gamme)) do group
    DataFrame(
        produits=nrow(group),
        ca_moyen=mean(group.chiffre_affaires),
        prix_min=minimum(group.prix),
        prix_max=maximum(group.prix)
    )
end
println(analyse_gamme)

# Analyse temporelle
println("\nAnalyse par trimestre :")
analyse_temporelle = combine(groupby(df_enrichi, :trimestre)) do group
    DataFrame(
        ca_trimestre=sum(group.chiffre_affaires),
        ventes_moyennes=mean(group.quantité),
        nb_références=nrow(group)
    )
end
println(analyse_temporelle)

# Partie 5 : DataFramesMeta.jl - Syntaxe Moderne
println("\n✨ Partie 5 : Syntaxe Moderne avec DataFramesMeta")

println("Utilisation de @select, @filter, @transform...")

# Syntaxe moderne équivalente
résultat_moderne = @chain df_ventes begin
    @select(:produit, :prix, :quantité)
    @transform(:ca = :prix * :quantité)
    @filter(:ca > 10000)
    @orderby(-:ca)
end

println("Produits avec CA > 10000€ (syntaxe moderne) :")
println(résultat_moderne)

# Pipeline complexe
analyse_complexe = @chain df_enrichi begin
    @filter(:catégorie != "Accessoires")
    @transform(:rentabilité = :chiffre_affaires / :quantité)
    @groupby(:catégorie)
    @combine(
        :ca_total = sum(:chiffre_affaires),
        :rentabilité_moyenne = mean(:rentabilité),
        :meilleur_produit = :produit[argmax(:chiffre_affaires)]
    )
end

println("\nAnalyse complexe par catégorie (hors accessoires) :")
println(analyse_complexe)

# Partie 6 : Jointures et Fusion de Données
println("\n🔗 Partie 6 : Jointures et Fusion de DataFrames")

# Créer un DataFrame de stock
df_stock = DataFrame(
    produit=["Ordinateur", "Tablet", "Smartphone", "Écouteurs", "Webcam", "Imprimante"],
    stock_disponible=[12, 45, 67, 89, 34, 23],
    fournisseur=["Faso Tech", "Faso Tech", "Burkina Mobile", "Audio Sahel", "Faso Tech", "Impression BF"],
    délai_livraison=[7, 5, 3, 2, 10, 14]
)

println("DataFrame de stock :")
println(df_stock)

# Inner join
println("\nJointure interne (produits présents dans les deux tables) :")
ventes_avec_stock = innerjoin(df_enrichi, df_stock, on=:produit)
println(select(ventes_avec_stock, [:produit, :quantité, :stock_disponible, :fournisseur]))

# Left join
println("\nJointure gauche (tous les produits de ventes + stock si disponible) :")
ventes_complètes = leftjoin(df_enrichi, df_stock, on=:produit)
println(select(ventes_complètes, [:produit, :quantité, :stock_disponible]))

# Outer join
println("\nJointure externe (tous les produits des deux tables) :")
inventaire_complet = outerjoin(df_enrichi, df_stock, on=:produit)
println(select(inventaire_complet, [:produit, :quantité, :stock_disponible]))

# Partie 7 : Gestion des Données Manquantes
println("\n🔍 Partie 7 : Gestion des Valeurs Manquantes")

# Créer des données avec valeurs manquantes
df_avec_missing = DataFrame(
    nom=["Aminata", "Boukary", "Clarisse", "Daouda", "Eveline"],
    âge=[25, missing, 35, 28, missing],
    salaire=[450000, 520000, missing, 480000, 550000],  # Salaires en FCFA
    département=["Informatique", "RH", "Informatique", missing, "Finance"]
)

println("DataFrame avec valeurs manquantes :")
println(df_avec_missing)

# Identifier les valeurs manquantes
println("\nAnalyse des valeurs manquantes :")
for col in names(df_avec_missing)
    nb_missing = count(ismissing, df_avec_missing[!, col])
    println("  $col : $nb_missing valeurs manquantes")
end

# Filtrer les lignes complètes
println("\nLignes sans valeurs manquantes :")
lignes_complètes = dropmissing(df_avec_missing)
println(lignes_complètes)

# Remplacer les valeurs manquantes
println("\nRemplacement des valeurs manquantes :")
df_sans_missing = copy(df_avec_missing)

# Remplacer l'âge manquant par la moyenne
âge_moyen = mean(skipmissing(df_sans_missing.âge))
df_sans_missing.âge = coalesce.(df_sans_missing.âge, round(Int, âge_moyen))

# Remplacer le salaire manquant par la médiane
salaire_médian = median(skipmissing(df_sans_missing.salaire))
df_sans_missing.salaire = coalesce.(df_sans_missing.salaire, salaire_médian)

# Remplacer département manquant par "Non spécifié"
df_sans_missing.département = coalesce.(df_sans_missing.département, "Non spécifié")

println(df_sans_missing)

# Partie 8 : Reshaping et Pivot
println("\n🔄 Partie 8 : Transformation de Structure (Reshape/Pivot)")

# Créer un DataFrame de ventes trimestrielles
df_trimestres = DataFrame(
    région=["Nord", "Sud", "Est", "Ouest", "Nord", "Sud", "Est", "Ouest"],
    trimestre=["T1", "T1", "T1", "T1", "T2", "T2", "T2", "T2"],
    ventes=[120, 95, 110, 85, 140, 105, 125, 92]
)

println("Données de ventes par région et trimestre (format long) :")
println(df_trimestres)

# Pivot wider (de long vers large)
println("\nTransformation en format large (pivot) :")
df_pivot = unstack(df_trimestres, :trimestre, :ventes)
println(df_pivot)

# Pivot longer (de large vers long)
println("\nRetour au format long :")
df_long = stack(df_pivot, [:T1, :T2], variable_name=:trimestre, value_name=:ventes)
println(sort(df_long, [:région, :trimestre]))

# Partie 9 : Opérations sur Chaînes et Dates
println("\n📅 Partie 9 : Manipulation de Chaînes et Dates")

# Créer un dataset avec dates et chaînes
df_logs = DataFrame(
    timestamp=DateTime(2024, 1, 1):Hour(6):DateTime(2024, 1, 3),
    user_agent=["Chrome/121.0 (Windows)", "Firefox/122.0 (Mac)", "Safari/17.0 (iOS)",
        "Chrome/121.0 (Android)", "Edge/120.0 (Windows)", "Firefox/122.0 (Linux)",
        "Chrome/121.0 (Windows)", "Safari/17.0 (Mac)", "Chrome/121.0 (Windows)"],
    status_code=[200, 404, 200, 500, 200, 403, 200, 200, 301]
)

println("Logs d'accès web :")
println(df_logs)

# Extraction d'informations des chaînes
println("\nExtraction du navigateur et OS :")
df_logs_enrichi = @chain df_logs begin
    @transform(
        :navigateur = map(ua -> split(split(ua, "/")[1], " ")[1], :user_agent),
        :os = map(ua -> match(r"\(([^)]+)\)", ua).captures[1], :user_agent),
        :heure = hour.(:timestamp),
        :jour = dayname.(:timestamp)
    )
end

println(select(df_logs_enrichi, [:timestamp, :navigateur, :os, :status_code]))

# Analyse par navigateur et statut
analyse_logs = @chain df_logs_enrichi begin
    @groupby([:navigateur, :status_code])
    @combine(:count = length(:timestamp))
    @orderby(-:count)
end

println("\nAnalyse des logs par navigateur et code de statut :")
println(analyse_logs)

# Partie 10 : Performance et Optimisation
println("\n⚡ Partie 10 : Optimisation de Performance")

# Créer un dataset plus grand pour les tests de performance
println("Création d'un grand dataset pour tests de performance...")
n = 100_000
df_large = DataFrame(
    id=1:n,
    groupe=rand(["A", "B", "C", "D"], n),
    valeur=rand(n),
    date=rand(Date(2023, 1, 1):Day(1):Date(2024, 12, 31), n)
)

println("Dataset créé : $(nrow(df_large)) lignes")

# Test de performance : groupby vs indexation
println("\nTest de performance - Groupby :")
temps_groupby = @elapsed begin
    résultat_groupby = combine(groupby(df_large, :groupe), :valeur => mean => :moyenne)
end
println("  Temps groupby : $(round(temps_groupby * 1000, digits=2))ms")
println("  Résultat : ", résultat_groupby)

# Test de performance : filtrage
println("\nTest de performance - Filtrage :")
temps_filter = @elapsed begin
    résultat_filter = filter(row -> row.valeur > 0.5, df_large)
end
println("  Temps filtrage : $(round(temps_filter * 1000, digits=2))ms")
println("  Lignes filtrées : $(nrow(résultat_filter))")

# Optimisation mémoire
println("\nOptimisation mémoire - Catégories :")
df_optimisé = copy(df_large)
df_optimisé.groupe = categorical(df_optimisé.groupe)

mémoire_avant = Base.summarysize(df_large.groupe)
mémoire_après = Base.summarysize(df_optimisé.groupe)

println("  Mémoire avant (String) : $(round(mémoire_avant / 1024^2, digits=2)) MB")
println("  Mémoire après (Categorical) : $(round(mémoire_après / 1024^2, digits=2)) MB")
println("  Réduction : $(round((1 - mémoire_après/mémoire_avant) * 100, digits=1))%")

# Partie 11 : Export et Sauvegarde
println("\n💾 Partie 11 : Export et Persistance")

# Sauvegarder en CSV
println("Sauvegarde des analyses en CSV...")
try
    CSV.write("analyse_ventes.csv", df_enrichi)
    CSV.write("analyse_categories.csv", analyse_catégorie)
    println("✅ Fichiers CSV sauvegardés :")
    println("  - analyse_ventes.csv")
    println("  - analyse_categories.csv")
catch e
    println("⚠️ Erreur lors de la sauvegarde : $e")
end

# Créer un résumé exécutif
résumé_exécutif = DataFrame(
    métrique=["CA Total", "Produit le plus vendu", "Catégorie dominante", "Trimestre le plus fort"],
    valeur=[
        string(round(sum(df_enrichi.chiffre_affaires), digits=0), "€"),
        df_enrichi.produit[argmax(df_enrichi.chiffre_affaires)],
        analyse_catégorie.catégorie[argmax(analyse_catégorie.ca_total)],
        analyse_temporelle.trimestre[argmax(analyse_temporelle.ca_trimestre)]
    ]
)

println("\nRésumé exécutif :")
println(résumé_exécutif)

# Partie 12 : Pipeline ETL Complet
println("\n🔄 Partie 12 : Pipeline ETL (Extract, Transform, Load)")

println("Démonstration d'un pipeline ETL complet...")

function pipeline_etl(données_brutes)
    println("🔍 EXTRACT : Chargement des données...")
    df = copy(données_brutes)

    println("🔧 TRANSFORM : Nettoyage et enrichissement...")
    df_transformé = @chain df begin
        # Nettoyage
        dropmissing(:produit)
        @filter(:prix > 0 && :quantité > 0)

        # Enrichissement
        @transform(
            :ca = :prix * :quantité,
            :prix_unitaire = round.(:prix, digits=2),
            :gamme = map(p -> p < 100 ? "Éco" : p < 500 ? "Standard" : "Premium", :prix)
        )

        # Normalisation
        @transform(:produit = uppercase.(:produit))
    end

    println("📊 LOAD : Agrégation finale...")
    rapport_final = @chain df_transformé begin
        @groupby(:catégorie)
        @combine(
            :nb_produits = length(:produit),
            :ca_total = sum(:ca),
            :ca_moyen = mean(:ca),
            :meilleur_ca = maximum(:ca)
        )
        @orderby(-:ca_total)
    end

    return df_transformé, rapport_final
end

# Exécution du pipeline
données_propres, rapport = pipeline_etl(df_ventes)

println("\nDonnées après pipeline ETL :")
println(first(données_propres, 3))

println("\nRapport final :")
println(rapport)

# Bilan d'apprentissage
println("\n📈 BILAN D'APPRENTISSAGE")
println("="^70)
println("📊 MAÎTRISE EXPERTE DE DATAFRAMES.JL !")
println("="^70)
println("✅ Compétences de Data Scientist développées :")
println("  🏗️ Création et manipulation de DataFrames complexes")
println("  🎯 Sélection et filtrage de données avec conditions avancées")
println("  🔧 Transformations et calculs de colonnes dérivées")
println("  📈 Groupements et agrégations pour analyses statistiques")
println("  ✨ Syntaxe moderne avec DataFramesMeta et chaînes de traitement")
println("  🔗 Jointures multiples et fusion de sources de données")
println("  🔍 Gestion professionnelle des valeurs manquantes")
println("  🔄 Transformation de structure (pivot, reshape)")
println("  📅 Manipulation avancée de chaînes et dates")
println("  ⚡ Optimisation de performance pour big data")
println("  💾 Pipelines ETL complets avec export automatisé")

println("\n🌟 BADGE DÉBLOQUÉ : 'Data Engineer Julia'")
println("Vous maîtrisez maintenant l'ensemble des outils pour manipuler")
println("et analyser des données comme un professionnel !")

println("\n🎯 COMPÉTENCES TRANSFÉRABLES :")
println("  - Analyse de données business avec métriques KPI")
println("  - Nettoyage et préparation de datasets ML")
println("  - Création de rapports automatisés")
println("  - Optimisation de workflows de données")

println("\n🚀 PRÊT POUR L'ÉTAPE SUIVANTE !")
println("📆 PROCHAINE ÉTAPE : 03_visualization.jl - Créer des visualisations percutantes")
println("   (DataFrames + Plots = Le combo parfait pour l'analyse de données)")
println("   (Conseil : Explorez vos propres datasets avec ces techniques !)")