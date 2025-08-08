# Exercice 3 : Visualisation Scientifique avec Julia
# Module 3 : Apprentissage Automatique avec Julia
# Durée : 45 minutes

# 📚 AVANT DE COMMENCER
# Lisez le résumé d'apprentissage : resume_03_visualization.md
# Découvrez comment créer des visualisations percutantes avec Plots.jl !

println("📚 Consultez le résumé : modules/module3-ml/resume_03_visualization.md")
println("Appuyez sur Entrée quand vous êtes prêt à créer des graphiques comme un pro...")
readline()

println("📈 Visualisation Scientifique : Données du Burkina Faso")
println("="^65)

# TODO 1 : Installation et configuration (5 minutes)
# Importez les paquets nécessaires et configurez l'environnement graphique

# TODO : Importez Plots, StatsPlots, PlotlyJS
using Plots  # Complétez cette ligne avec les autres paquets

# TODO : Importez DataFrames, CSV, Statistics, Dates


# TODO : Importez Colors, ColorSchemes et Random


# TODO : Fixez le seed aléatoire à 42


# TODO : Configurez PlotlyJS comme backend et utilisez le thème :bright


println("🎨 Configuration graphique : Backend PlotlyJS activé")
println("Thème : Bright (optimisé pour présentations)")

# Partie 1 : Données Climatiques Burkinabè
println("\n🌡️ Partie 1 : Visualisation Climatique du Burkina Faso")

# TODO 2 : Création des données climatiques (10 minutes)
# Créez un dataset réaliste pour les 13 régions du Burkina Faso

# TODO : Définissez la liste des 13 régions du Burkina Faso
régions_bf = [
    "Boucle du Mouhoun", "Cascades", "Centre", "Centre-Est", "Centre-Nord",
    "Centre-Ouest", "Centre-Sud", "Est", "Hauts-Bassins", "Nord",
    "Plateau-Central", "Sahel", "Sud-Ouest"
]

# TODO : Créez un DataFrame avec des données climatiques réalistes
# Astuce : Utilisez repeat() pour les régions et les mois
# Créez des patterns de température cohérents avec les zones climatiques :
# - Sahel : plus chaud (35-42°C)
# - Centre : modéré (28-37°C) 
# - Sud : plus frais (26-35°C)

données_climat = DataFrame(
    # TODO : Complétez la création du DataFrame
    région=repeat(régions_bf, 12),
    mois=111,
    # TODO : répéter 1:12 pour chaque région
    # TODO : Ajoutez une colonne température avec des valeurs réalistes
    # TODO : Ajoutez une colonne précipitations (pattern sahélien juin-sept)
)

# TODO : Ajoutez les noms de mois en français
noms_mois = ["Jan", "Fév", "Mar", "Avr", "Mai", "Jun",
    "Jul", "Aoû", "Sep", "Oct", "Nov", "Déc"]
# TODO : Ajoutez une colonne mois_nom au DataFrame

println("Données climatiques générées pour $(length(régions_bf)) régions")

# TODO 3 : Premier graphique - Températures par région (10 minutes)
println("\n📊 Graphique 1 : Températures Moyennes par Région")

# TODO : Calculez les températures moyennes par région avec combine() et groupby()
# temp_moyennes = 

# TODO : Triez par température décroissante avec sort!()


# TODO : Créez un graphique en barres (bar plot)
# Paramètres suggérés : title, xlabel, ylabel, color=:thermal, rotation=45
# p1 = 

# TODO : Ajoutez une ligne horizontale pour la moyenne nationale
# Astuce : utilisez hline!() et mean()


# TODO : Affichez le graphique avec display()


println("✅ Défi 1 complété ! Passons aux précipitations...")

# TODO 4 : Cycle saisonnier des précipitations (10 minutes)
println("\n🌧️ Graphique 2 : Cycle Saisonnier des Précipitations")

# TODO : Calculez les précipitations moyennes par mois
# precip_mensuelles = 

# TODO : Créez un graphique linéaire (plot)
# Montrez l'évolution des précipitations au cours de l'année
# p2 = 

# BONUS : Ajoutez une zone colorée pour la saison des pluies (mois 5-10)
# Astuce : utilisez vspan!()


# TODO : Affichez le graphique


println("✅ Défi 2 complété ! Créons des visualisations avancées...")

# TODO 5 : Visualisation géographique (10 minutes)
println("\n🗺️ Graphique 3 : Carte Climatique du Burkina Faso")

# Coordonnées approximatives des régions (fournies)
coords_régions = DataFrame(
    région=régions_bf,
    latitude=[12.3, 10.8, 12.4, 11.9, 13.3, 12.1, 11.2, 12.0, 11.2, 13.5, 12.3, 14.0, 10.3],
    longitude=[-2.9, -4.3, -1.5, -0.3, -1.5, -2.3, -1.0, 0.5, -4.3, -2.3, -1.2, -0.2, -3.2]
)

# TODO : Fusionnez les coordonnées avec vos données climatiques
# Astuce : utilisez leftjoin() avec temp_moyennes


# TODO : Créez un scatter plot où :
# - x = longitude, y = latitude
# - couleur = température moyenne (zcolor)
# - taille = proportionnelle aux précipitations
# p3 = 

# TODO : Ajoutez des labels pour les régions avec annotate!()


# TODO : Affichez le graphique


println("✅ Défi 3 complété ! Finale avancée...")

# TODO 6 : Défi créatif - Dashboard multi-graphiques (Bonus)
println("\n📊 Défi Final : Dashboard Burkina Faso")

# TODO : Créez un layout combiné avec plot() et layout=(2,2)
# Combinez vos 3 graphiques précédents + un 4ème de votre choix
# Exemples : histogramme, boxplot, heatmap...

# dashboard = plot(p1, p2, p3, p4, layout=(2,2), 
#                 plot_title="🇧🇫 Dashboard Climatique Burkina Faso")

# TODO : Affichez votre dashboard


# TODO 7 : Export et sauvegarde (Bonus)
# TODO : Sauvegardez vos graphiques avec savefig()
# Exemple : savefig(p1, "temperatures_bf.png")

# Bilan d'apprentissage
println("\n📈 BILAN D'APPRENTISSAGE")
println("="^65)
println("📊 FÉLICITATIONS ! VOUS MAÎTRISEZ LA VISUALISATION JULIA !")
println("="^65)
println("✅ Compétences acquises :")
println("  🎨 Configuration Plots.jl avec backends interactifs")
println("  📊 Graphiques statistiques (bar, line, scatter)")
println("  🗺️ Visualisations géographiques avec coordonnées")
println("  🎯 Personnalisation avancée (couleurs, labels, layouts)")
println("  💾 Export professionnel pour publications")
println("  🇧🇫 Application données burkinabè authentiques")

println("\n🌟 BADGE DÉBLOQUÉ : 'Visualiseur de Données Burkina Faso'")
println("Vos graphiques racontent maintenant l'histoire du climat sahélien !")

println("\n🚀 PROCHAINE ÉTAPE : 04_advanced_ml.jl")
println("   (Vos visualisations valideront les modèles ML !)")

# TODO BONUS : Explorez d'autres types de graphiques !
# - Histogrammes avec histogram()
# - Boîtes à moustaches avec boxplot()  
# - Matrices de corrélation avec heatmap()
# - Animations avec @animate
# - Graphiques 3D avec surface() ou scatter3d()

# Graphique 2 : Cycle saisonnier des précipitations  
println("\n🌧️ Graphique 2 : Cycle Saisonnier des Précipitations")

precip_mensuelles = combine(groupby(données_climat, :mois),
    :précipitations => mean => :precip_moyenne)
sort!(precip_mensuelles, :mois)

p2 = plot(precip_mensuelles.mois, precip_mensuelles.precip_moyenne,
    title="🌧️ Cycle des Précipitations - Burkina Faso",
    xlabel="Mois",
    ylabel="Précipitations (mm)",
    color=:blue,
    linewidth=3,
    marker=:circle,
    markersize=6,
    legend=false,
    xticks=(1:12, noms_mois),
    size=(800, 400))

# Zone de saison des pluies
vspan!([5, 10], alpha=0.2, color=:blue, label="Saison des pluies")

display(p2)

# Partie 2 : Données Agricoles
println("\n🌾 Partie 2 : Visualisation des Rendements Agricoles")

# Données de production agricole (tonnes/hectare)
cultures_bf = ["Mil", "Sorgho", "Maïs", "Riz", "Niébé", "Arachide", "Coton", "Sésame"]
années = 2018:2023

production_agri = DataFrame()
for culture in cultures_bf, année in années
    # Rendements basés sur données FAO approximatives pour le BF
    rendement_base = Dict(
        "Mil" => 0.8, "Sorgho" => 0.9, "Maïs" => 1.2, "Riz" => 2.1,
        "Niébé" => 0.6, "Arachide" => 1.1, "Coton" => 1.3, "Sésame" => 0.4
    )[culture]

    # Variation climatique réaliste
    variation = 1.0 + (rand() - 0.5) * 0.4  # ±20% variation

    push!(production_agri, (
        culture=culture,
        année=année,
        rendement=rendement_base * variation,
        superficie=rand(50000:500000)  # hectares
    ))
end

production_agri.production_totale = production_agri.rendement .* production_agri.superficie

# Graphique 3 : Évolution des rendements par culture
println("\n📈 Graphique 3 : Évolution des Rendements Agricoles")

p3 = plot(title="🌾 Évolution des Rendements - Burkina Faso (2018-2023)",
    xlabel="Année",
    ylabel="Rendement (tonnes/hectare)",
    legend=:outertopright,
    size=(900, 500))

couleurs = palette(:tab10)
for (i, culture) in enumerate(cultures_bf)
    données_culture = filter(row -> row.culture == culture, production_agri)
    plot!(données_culture.année, données_culture.rendement,
        label=culture,
        color=couleurs[i],
        linewidth=2,
        marker=:circle,
        markersize=4)
end

display(p3)

# Graphique 4 : Comparaison production par culture (dernière année)
println("\n📊 Graphique 4 : Production par Culture (2023)")

prod_2023 = filter(row -> row.année == 2023, production_agri)
sort!(prod_2023, :production_totale, rev=true)

p4 = bar(prod_2023.culture, prod_2023.production_totale / 1000,  # en milliers de tonnes
    title="🌾 Production Totale par Culture - 2023",
    xlabel="Culture",
    ylabel="Production (milliers de tonnes)",
    color=:viridis,
    legend=false,
    rotation=45,
    size=(800, 500))

# Annotations sur les barres
for (i, row) in enumerate(eachrow(prod_2023))
    annotate!(i, row.production_totale / 1000 + 50,
        text("$(round(row.production_totale/1000, digits=0))k", 8, :center))
end

display(p4)

# Partie 3 : Données Démographiques et Économiques
println("\n👥 Partie 3 : Démographie et Économie")

# Données démographiques par région (approximatives)
demo_data = DataFrame(
    région=régions_bf,
    population=[
        1898166, 734993, 2453496, 1578075, 1529977,  # Boucle, Cascades, Centre, Centre-Est, Centre-Nord
        1369509, 796085, 1661673, 2201027, 1481553,  # Centre-Ouest, Centre-Sud, Est, Hauts-Bassins, Nord
        808224, 1235563, 878759                       # Plateau-Central, Sahel, Sud-Ouest
    ],
    pib_par_habitant=[
        450, 380, 850, 320, 290,     # FCFA (milliers)
        410, 360, 310, 520, 270,
        480, 250, 420
    ],
    taux_alphabetisation=[
        35.2, 28.5, 68.9, 22.1, 18.7,  # %
        31.4, 26.8, 19.3, 42.5, 16.2,
        38.9, 14.3, 33.7
    ]
)

# Graphique 5 : Relation Population vs PIB par habitant
println("\n💰 Graphique 5 : Population vs Développement Économique")

p5 = scatter(demo_data.population / 1000, demo_data.pib_par_habitant,
    title="👥 Population vs PIB par Habitant - Régions BF",
    xlabel="Population (milliers)",
    ylabel="PIB par habitant (milliers FCFA)",
    color=:red,
    markersize=8,
    alpha=0.7,
    size=(800, 500))

# Ajouter labels des régions
for row in eachrow(demo_data)
    annotate!(row.population / 1000, row.pib_par_habitant + 20,
        text(row.région, 8, :center))
end

# Ligne de tendance
using GLM
model = lm(@formula(pib_par_habitant ~ population), demo_data)
x_trend = range(minimum(demo_data.population), maximum(demo_data.population), length=100)
y_trend = predict(model, DataFrame(population=x_trend))
plot!(x_trend / 1000, y_trend, color=:blue, linewidth=2, linestyle=:dash,
    label="Tendance", legend=:topright)

display(p5)

# Partie 4 : Carte Thématique du Burkina Faso
println("\n🗺️ Partie 4 : Visualisation Géographique")

# Coordonnées approximatives des chefs-lieux de régions
coords_régions = DataFrame(
    région=régions_bf,
    latitude=[12.3, 10.8, 12.4, 11.9, 13.3, 12.1, 11.2, 12.0, 11.2, 13.5, 12.3, 14.0, 10.3],
    longitude=[-2.9, -4.3, -1.5, -0.3, -1.5, -2.3, -1.0, 0.5, -4.3, -2.3, -1.2, -0.2, -3.2]
)

# Fusionner avec les données économiques
coords_éco = leftjoin(coords_régions, demo_data, on=:région)

p6 = scatter(coords_éco.longitude, coords_éco.latitude,
    title="🗺️ Développement Économique par Région - Burkina Faso",
    xlabel="Longitude",
    ylabel="Latitude",
    zcolor=coords_éco.pib_par_habitant,
    markersize=sqrt.(coords_éco.population / 50000),  # Taille proportionnelle à population
    colorbar_title="PIB/hab (k FCFA)",
    size=(900, 600),
    aspect_ratio=1)

# Ajouter contour approximatif du Burkina Faso
burkina_contour_lon = [-5.5, -5.5, 2.4, 2.4, -5.5]
burkina_contour_lat = [9.4, 15.1, 15.1, 9.4, 9.4]
plot!(burkina_contour_lon, burkina_contour_lat,
    color=:black, linewidth=2, linestyle=:solid, label="Frontières BF")

display(p6)

# Partie 5 : Dashboard Interactif
println("\n📊 Partie 5 : Dashboard Multi-Graphiques")

# Créer un layout combiné
println("Création d'un dashboard complet...")

# Mini-graphiques pour le dashboard
p_temp_mini = plot(1:12,
    [mean(filter(row -> row.mois == m, données_climat).température) for m in 1:12],
    title="Température", color=:red, legend=false, size=(300, 200))

p_precip_mini = plot(1:12,
    [mean(filter(row -> row.mois == m, données_climat).précipitations) for m in 1:12],
    title="Précipitations", color=:blue, legend=false, size=(300, 200))

p_pop_mini = bar(demo_data.région[1:5], demo_data.population[1:5] / 1000,
    title="Top 5 Régions", legend=false, size=(300, 200), rotation=45)

p_agri_mini = plot(années, [mean(filter(row -> row.année == a, production_agri).rendement) for a in années],
    title="Rendement Moyen", color=:green, legend=false, size=(300, 200))

# Combiner en dashboard
dashboard = plot(p_temp_mini, p_precip_mini, p_pop_mini, p_agri_mini,
    layout=(2, 2),
    plot_title="🇧🇫 Dashboard Burkina Faso - Indicateurs Clés",
    size=(900, 600))

display(dashboard)

# Partie 6 : Visualisations Avancées et Interactives
println("\n🎨 Partie 6 : Visualisations Avancées")

# Heatmap des corrélations
println("Création d'une heatmap de corrélations...")

# Matrice de corrélation entre variables
variables_numériques = [:température, :précipitations, :population, :pib_par_habitant, :taux_alphabetisation]

# Préparer données pour corrélation
données_corr = DataFrame()
for région in régions_bf
    données_région = filter(row -> row.région == région, données_climat)
    demo_région = filter(row -> row.région == région, demo_data)[1, :]

    push!(données_corr, (
        région=région,
        temp_moyenne=mean(données_région.température),
        precip_totale=sum(données_région.précipitations),
        population=demo_région.population,
        pib_par_habitant=demo_région.pib_par_habitant,
        alphabetisation=demo_région.taux_alphabetisation
    ))
end

# Calculer matrice de corrélation
using Statistics
vars = [:temp_moyenne, :precip_totale, :population, :pib_par_habitant, :alphabetisation]
n_vars = length(vars)
cor_matrix = zeros(n_vars, n_vars)

for i in 1:n_vars, j in 1:n_vars
    cor_matrix[i, j] = cor(données_corr[!, vars[i]], données_corr[!, vars[j]])
end

labels = ["Temp", "Précip", "Pop", "PIB", "Alpha"]
p7 = heatmap(labels, labels, cor_matrix,
    title="🔍 Matrice de Corrélations - Variables Burkina Faso",
    color=:RdBu,
    aspect_ratio=1,
    size=(600, 500))

# Ajouter valeurs dans les cellules
for i in 1:n_vars, j in 1:n_vars
    annotate!(i, j, text(round(cor_matrix[i, j], digits=2), 10, :center, :white))
end

display(p7)

# Partie 7 : Animation Temporelle
println("\n🎬 Partie 7 : Animation des Données Temporelles")

# Animation de l'évolution des rendements
println("Création d'une animation des rendements agricoles...")

# Préparer l'animation
anim = Animation()

for année in années
    données_année = filter(row -> row.année == année, production_agri)
    sort!(données_année, :rendement, rev=true)

    p_anim = bar(données_année.culture, données_année.rendement,
        title="🌾 Rendements Agricoles - $année",
        xlabel="Culture",
        ylabel="Rendement (t/ha)",
        ylim=(0, 2.5),
        color=:viridis,
        legend=false,
        size=(800, 500))

    # Ajouter annotations
    for (i, row) in enumerate(eachrow(données_année))
        annotate!(i, row.rendement + 0.1,
            text("$(round(row.rendement, digits=2))", 8, :center))
    end

    frame(anim, p_anim)
end

# Sauvegarder l'animation (optionnel)
try
    gif(anim, "rendements_evolution.gif", fps=1)
    println("✅ Animation sauvegardée : rendements_evolution.gif")
catch
    println("⚠️ Sauvegarde animation échouée (normal dans certains environnements)")
end

# Partie 8 : Export et Sauvegarde
println("\n💾 Partie 8 : Export des Visualisations")

# Sauvegarder les graphiques principaux
graphiques_export = [
    (p1, "temperatures_regions_bf.png"),
    (p2, "cycle_precipitations_bf.png"),
    (p3, "evolution_rendements_bf.png"),
    (p4, "production_cultures_2023_bf.png"),
    (p5, "population_vs_pib_bf.png"),
    (p6, "carte_economique_bf.png"),
    (dashboard, "dashboard_burkina_faso.png"),
    (p7, "correlation_matrix_bf.png")
]

println("Sauvegarde des graphiques...")
saved_count = 0

for (graphique, nom_fichier) in graphiques_export
    try
        savefig(graphique, nom_fichier)
        println("✅ $nom_fichier")
        saved_count += 1
    catch e
        println("⚠️ Échec $nom_fichier : $e")
    end
end

println("📊 $saved_count/$(length(graphiques_export)) graphiques sauvegardés")

# Partie 9 : Conseils et Bonnes Pratiques
println("\n🎯 Partie 9 : Conseils pour Visualisations Professionnelles")

println("""
📋 CHECKLIST VISUALISATION PROFESSIONNELLE :
✅ Titres explicites et contextualisés
✅ Axes étiquetés avec unités
✅ Couleurs cohérentes et accessibles
✅ Légendes claires et positionnées intelligemment
✅ Annotations pour valeurs importantes
✅ Taille de police lisible
✅ Aspect ratio approprié au contenu
✅ Backend adapté au contexte (statique/interactif)
""")

# Démonstration des thèmes
println("\n🎨 Démonstration des thèmes disponibles :")
thèmes_disponibles = [:default, :bright, :dark, :vibrant, :mute, :wong, :sand, :gruvbox_dark]

for thème in thèmes_disponibles[1:4]  # Montrer quelques thèmes
    theme(thème)
    p_demo = plot([1, 2, 3], [1, 4, 2], title="Thème : $thème", legend=false)
    display(p_demo)
end

# Retourner au thème bright
theme(:bright)

# Bilan d'apprentissage
println("\n📈 BILAN D'APPRENTISSAGE")
println("="^65)
println("📊 MAÎTRISE DE LA VISUALISATION SCIENTIFIQUE JULIA !")
println("="^65)
println("✅ Compétences de Data Visualizer développées :")
println("  🎨 Maîtrise complète de Plots.jl avec backend interactif")
println("  📊 Graphiques statistiques avancés avec StatsPlots.jl")
println("  🗺️ Cartographie thématique et visualisation géospatiale")
println("  📈 Dashboards multi-graphiques professionnels")
println("  🔍 Heatmaps et matrices de corrélation")
println("  🎬 Animations temporelles pour données évolutives")
println("  💾 Export multi-format pour publications et présentations")
println("  🌍 Contextualisation avec données burkinabè authentiques")

println("\n🌟 BADGE DÉBLOQUÉ : 'Visualiseur de Données Burkina Faso'")
println("Vous savez maintenant créer des visualisations percutantes")
println("qui racontent l'histoire de vos données !")

println("\n🎯 COMPÉTENCES TRANSFÉRABLES :")
println("  - Rapports d'analyse avec visualisations professionnelles")
println("  - Dashboards de monitoring en temps réel")
println("  - Publications scientifiques avec graphiques de qualité")
println("  - Présentations impactantes pour décideurs")

println("\n🚀 PRÊT POUR L'ÉTAPE SUIVANTE !")
println("📆 PROCHAINE ÉTAPE : 04_advanced_ml.jl - Machine Learning Avancé")
println("   (Vos visualisations seront cruciales pour valider les modèles ML)")
println("   (Conseil : Explorez d'autres backends comme GR() ou PyPlot() !)")