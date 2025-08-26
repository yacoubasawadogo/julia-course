# Session 10 : Visualisation de Données avec Plots.jl

## 🎯 Objectifs de la Session
- Maîtriser les bases de la visualisation avec Plots.jl
- Créer différents types de graphiques (lignes, barres, scatter, histogrammes)
- Personnaliser l'apparence et le style des graphiques
- Créer des tableaux de bord interactifs
- Visualiser des données géographiques
- Appliquer les meilleures pratiques de data visualization

## 📊 Introduction à Plots.jl

### Pourquoi Plots.jl ?
Plots.jl est l'écosystème de visualisation le plus populaire en Julia car il :
- Offre une interface unifiée pour différents backends
- Permet de créer rapidement des graphiques de qualité
- Supporte l'interactivité et l'animation
- S'intègre parfaitement avec DataFrames.jl

### Installation et configuration
```julia
using Pkg
Pkg.add("Plots")
Pkg.add("PlotlyJS")      # Backend interactif
Pkg.add("GR")            # Backend par défaut (rapide)
Pkg.add("StatsPlots")    # Extensions statistiques
Pkg.add("PlotThemes")    # Thèmes prédéfinis

using Plots
using DataFrames
using StatsPlots
using PlotThemes
```

### Choix du backend
```julia
# Backend par défaut (GR) - rapide, bonne qualité
gr()

# Backend interactif (PlotlyJS) - pour exploration
plotlyjs()

# Backend pour publications (PGFPlotsX) - haute qualité
# pgfplotsx()
```

## 📈 Types de Graphiques Fondamentaux

### 1. Graphiques en Lignes
```julia
# Données d'exemple : température à Ouagadougou
mois = ["Jan", "Fév", "Mar", "Avr", "Mai", "Jun", 
        "Jul", "Aoû", "Sep", "Oct", "Nov", "Déc"]
temp_max = [33, 36, 39, 41, 40, 37, 34, 33, 35, 38, 36, 33]
temp_min = [16, 19, 23, 26, 28, 25, 23, 22, 23, 22, 19, 16]

# Graphique simple
plot(mois, temp_max, 
     title="Températures à Ouagadougou",
     xlabel="Mois", ylabel="Température (°C)",
     label="Température maximale",
     linewidth=2, color=:red)

# Ajouter une deuxième série
plot!(mois, temp_min, 
      label="Température minimale",
      linewidth=2, color=:blue)
```

### 2. Graphiques en Barres
```julia
# Production céréalière par région (en milliers de tonnes)
regions = ["Centre", "Nord", "Hauts-Bassins", "Est", "Boucle du Mouhoun"]
production = [485, 723, 624, 557, 685]

# Graphique en barres vertical
bar(regions, production,
    title="Production Céréalière par Région (2023)",
    xlabel="Région", ylabel="Production (milliers de tonnes)",
    color=:lightblue,
    rotation=45,  # Rotation des labels x
    size=(600, 400))
```

### 3. Graphiques de Dispersion (Scatter)
```julia
# Relation PIB par habitant vs espérance de vie
pib_par_hab = [450000, 380000, 520000, 420000, 360000, 480000, 390000]
esperance_vie = [58.2, 56.8, 61.5, 59.1, 55.9, 60.3, 57.4]
regions_scatter = ["Centre", "Nord", "Hauts-Bassins", "Est", "Sud-Ouest", "Cascades", "Sahel"]

scatter(pib_par_hab, esperance_vie,
        title="PIB par Habitant vs Espérance de Vie",
        xlabel="PIB par habitant (FCFA)", ylabel="Espérance de vie (années)",
        series_annotations=text.(regions_scatter, 8, :bottom),
        markersize=8, color=:green,
        size=(700, 500))
```

### 4. Histogrammes
```julia
# Distribution des âges dans une province
using Random
Random.seed!(123)
ages = rand(18:65, 1000)

histogram(ages,
          title="Distribution des Âges - Province du Kadiogo",
          xlabel="Âge", ylabel="Fréquence",
          bins=20, color=:orange, alpha=0.7,
          size=(600, 400))
```

## 🎨 Personnalisation des Graphiques

### Couleurs et Styles
```julia
# Palette de couleurs personnalisée (couleurs du drapeau burkinabè)
couleurs_bf = [:red, :white, :green, :yellow]

# Données de production par type de céréale
cereales = ["Mil", "Sorgho", "Maïs", "Riz"]
production_2023 = [1250, 1100, 950, 180]  # milliers de tonnes

bar(cereales, production_2023,
    title="Production Céréalière Nationale 2023",
    color=couleurs_bf,
    ylabel="Production (milliers de tonnes)",
    legend=false,
    size=(600, 400))
```

### Thèmes prédéfinis
```julia
# Appliquer un thème
theme(:dark)  # Thème sombre
# theme(:bright)  # Thème clair
# theme(:vibrant)  # Couleurs vives

# Graphique avec thème
plot(mois, temp_max,
     title="Températures Maximales - Ouagadougou",
     xlabel="Mois", ylabel="°C",
     linewidth=3, marker=:circle,
     size=(700, 400))
```

### Annotations et texte
```julia
plot(mois, temp_max,
     title="Climat de Ouagadougou",
     xlabel="Mois", ylabel="Température (°C)",
     linewidth=2, color=:red)

# Ajouter des annotations
annotate!(6, 40, text("Saison sèche", 10, :red))
annotate!(8, 35, text("Saison pluvieuse", 10, :blue))

# Ligne horizontale pour la moyenne
hline!([mean(temp_max)], linestyle=:dash, color=:gray, label="Moyenne")
```

## 📊 Graphiques Multi-panneaux et Sous-graphiques

### Layout avec plusieurs graphiques
```julia
# Données économiques fictives
annees = 2018:2023
pib_croissance = [5.8, 6.2, 2.1, -3.2, 4.5, 5.7]
inflation = [2.1, 3.4, 1.9, 2.8, 3.8, 4.2]
chomage = [15.2, 14.8, 16.1, 18.3, 17.1, 15.9]

# Création de sous-graphiques
p1 = plot(annees, pib_croissance, title="Croissance PIB (%)", 
          ylabel="Croissance (%)", color=:blue, linewidth=2)
p2 = plot(annees, inflation, title="Inflation (%)", 
          ylabel="Inflation (%)", color=:red, linewidth=2)
p3 = plot(annees, chomage, title="Taux de Chômage (%)", 
          ylabel="Chômage (%)", color=:orange, linewidth=2)

# Assemblage en layout
plot(p1, p2, p3, layout=(1,3), size=(900, 300),
     suptitle="Indicateurs Économiques du Burkina Faso")
```

### Graphiques avec axes secondaires
```julia
# PIB et population sur le même graphique
annees = 2015:2023
pib_milliards = [12.8, 13.9, 14.2, 15.1, 13.7, 14.8, 16.2, 17.1, 18.3]
population_millions = [18.6, 19.2, 19.8, 20.4, 21.0, 21.6, 22.2, 22.8, 23.4]

# Graphique principal (PIB)
p = plot(annees, pib_milliards,
         title="Évolution PIB et Population - Burkina Faso",
         xlabel="Année", ylabel="PIB (milliards USD)",
         label="PIB", color=:blue, linewidth=2)

# Axe secondaire (Population)
plot!(twinx(), annees, population_millions,
      ylabel="Population (millions)", label="Population",
      color=:red, linewidth=2, linestyle=:dash)
```

## 📊 Visualisation de Données avec DataFrames

### Intégration avec DataFrames
```julia
# Création d'un DataFrame exemple
df_agri = DataFrame(
    region = ["Centre", "Nord", "Hauts-Bassins", "Est", "Sud-Ouest"],
    mil = [485, 723, 456, 557, 398],
    sorgho = [342, 645, 521, 489, 367],
    mais = [256, 198, 387, 298, 234],
    population = [3.3, 1.6, 1.9, 1.7, 0.9]  # millions
)

# Graphique en barres groupées avec @df
@df df_agri groupedbar([:mil :sorgho :mais],
                       title="Production Céréalière par Région",
                       xlabel="Région", ylabel="Production (milliers tonnes)",
                       xticks=(1:5, df_agri.region),
                       label=["Mil" "Sorgho" "Maïs"],
                       size=(700, 500))
```

### Graphiques statistiques avec StatsPlots
```julia
using StatsPlots

# Boxplot pour comparer les distributions
cereales_data = [df_agri.mil, df_agri.sorgho, df_agri.mais]
boxplot(["Mil", "Sorgho", "Maïs"], cereales_data,
        title="Distribution de la Production par Céréale",
        ylabel="Production (milliers tonnes)",
        size=(600, 400))

# Corrélogramme (matrice de corrélation)
corrplot(Matrix(df_agri[:, 2:4]), 
         label=["Mil" "Sorgho" "Maïs"],
         title="Corrélations entre Productions Céréalières")
```

## 🗺️ Visualisation Géographique Simple

### Cartes de chaleur (heatmaps)
```julia
# Simulation d'une matrice de distances entre villes
villes = ["Ouagadougou", "Bobo-Dioulasso", "Koudougou", "Ouahigouya", "Banfora"]
distances = [0 365 99 182 437;
            365 0 276 307 72;
            99 276 0 181 348;
            182 307 181 0 489;
            437 72 348 489 0]

heatmap(distances,
        title="Matrice des Distances entre Villes (km)",
        xlabel="Villes", ylabel="Villes",
        xticks=(1:5, villes), yticks=(1:5, villes),
        color=:plasma, size=(600, 500))
```

### Graphiques en secteurs (pie charts)
```julia
# Répartition de la population par région
regions_pop = ["Centre", "Hauts-Bassins", "Nord", "Est", "Autres"]
pourcentages = [15.8, 9.2, 7.5, 8.1, 59.4]

pie(pourcentages, labels=regions_pop,
    title="Répartition de la Population par Région (%)",
    size=(600, 600))
```

## 📱 Interactivité et Animation

### Graphiques interactifs
```julia
# Utiliser PlotlyJS pour l'interactivité
plotlyjs()

# Graphique scatter interactif
df_interactive = DataFrame(
    region = ["Centre", "Nord", "Hauts-Bassins", "Est", "Sud-Ouest", "Cascades"],
    pib_hab = [750000, 420000, 680000, 490000, 530000, 620000],
    alphabetisation = [78.4, 28.9, 52.7, 35.6, 34.5, 49.8],
    population = [3.3, 1.6, 1.9, 1.7, 0.9, 0.6]
)

scatter(df_interactive.pib_hab, df_interactive.alphabetisation,
        markersize=df_interactive.population .* 3,
        series_annotations=text.(df_interactive.region, 8),
        title="PIB/hab vs Alphabétisation (taille = population)",
        xlabel="PIB par habitant (FCFA)", ylabel="Taux d'alphabétisation (%)",
        hover=df_interactive.region,
        size=(800, 600))
```

### Animations simples
```julia
# Animation de l'évolution de la production agricole
@gif for annee in 2018:2023
    production_annee = rand(5) .* 100 .+ 400  # Simulation de données
    
    bar(regions, production_annee,
        title="Production Céréalière - Année $annee",
        xlabel="Région", ylabel="Production (milliers tonnes)",
        ylims=(0, 600), color=:lightblue,
        size=(600, 400))
end
```

## 🎯 Applications Spécifiques au Burkina Faso

### Visualisation des données climatiques
```julia
# Données pluviométriques par région
regions_climat = ["Sahel", "Nord", "Centre", "Sud-Ouest"]
pluviometrie = [300, 600, 800, 1200]  # mm/an
temperature_moy = [28.5, 27.8, 26.5, 25.2]  # °C

# Graphique double axe
p_climat = plot(regions_climat, pluviometrie,
                title="Climat par Zone Géographique",
                xlabel="Zone", ylabel="Pluviométrie (mm/an)",
                color=:blue, linewidth=3, marker=:circle,
                label="Pluviométrie")

plot!(twinx(), regions_climat, temperature_moy,
      ylabel="Température (°C)", color=:red,
      linewidth=3, marker=:square, label="Température")
```

### Dashboard agricole
```julia
# Création d'un mini-dashboard
function create_agri_dashboard(df::DataFrame)
    # Graphique 1 : Production totale
    p1 = @df df bar(:region, :mil + :sorgho + :mais,
                    title="Production Totale",
                    ylabel="Tonnes (milliers)", color=:green)
    
    # Graphique 2 : Productivité par habitant
    p2 = @df df scatter(:population, (:mil + :sorgho + :mais) ./ :population,
                        title="Productivité par Habitant",
                        xlabel="Population (millions)",
                        ylabel="Tonnes/habitant", color=:orange)
    
    # Graphique 3 : Composition par céréale
    p3 = @df df groupedbar([:mil :sorgho :mais],
                           title="Répartition par Céréale",
                           xticks=(1:nrow(df), df.region),
                           label=["Mil" "Sorgho" "Maïs"])
    
    # Graphique 4 : Parts relatives
    p4 = @df df plot(:region, [:mil :sorgho :mais],
                     title="Évolution Relative",
                     ylabel="Production", linetype=:steppre)
    
    plot(p1, p2, p3, p4, layout=(2,2), size=(800, 600),
         suptitle="Dashboard Agricole - Burkina Faso")
end

# Utilisation
create_agri_dashboard(df_agri)
```

## 📊 Visualisation de Séries Temporelles

### Données économiques temporelles
```julia
# Simulation d'indices économiques
dates = Date(2020,1,1):Month(1):Date(2023,12,1)
n_mois = length(dates)

# Indices avec tendances réalistes
indice_prix = 100 .+ cumsum(randn(n_mois) .* 0.5 .+ 0.2)
production_industrielle = 100 .+ cumsum(randn(n_mois) .* 1.2)
exports_coton = 50 .+ 30 .* sin.(2π .* (1:n_mois) ./ 12) .+ cumsum(randn(n_mois) .* 0.8)

# Graphique des séries temporelles
plot(dates, [indice_prix production_industrielle exports_coton],
     title="Indicateurs Économiques - Burkina Faso",
     xlabel="Date", ylabel="Indice (base 100)",
     label=["Prix" "Production Industrielle" "Exports Coton"],
     linewidth=2, size=(800, 500))
```

### Détection de saisonnalité
```julia
# Analyse de la production agricole saisonnière
mois_production = 1:12
production_mensuelle = [10, 15, 25, 40, 60, 85, 95, 80, 65, 45, 25, 15]  # Index saisonnier

plot(mois_production, production_mensuelle,
     title="Saisonnalité de la Production Agricole",
     xlabel="Mois", ylabel="Index de Production",
     xticks=(1:12, ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"]),
     linewidth=3, marker=:circle, color=:darkgreen,
     fill=(0, α=0.3), size=(700, 400))

# Ajouter ligne de moyenne
hline!([mean(production_mensuelle)], linestyle=:dash, 
       label="Moyenne annuelle", color=:red)
```

## 🎨 Personnalisation Avancée

### Styles et thèmes personnalisés
```julia
# Définir un thème "Burkina Faso"
function theme_burkina_faso()
    Plots.pyplot()
    default(
        bg=:white,
        fg=:black,
        fontfamily="Arial",
        titlefontsize=14,
        guidefontsize=12,
        tickfontsize=10,
        legendfontsize=10,
        palette=[:red, :yellow, :green, :orange, :blue],
        linewidth=2,
        markersize=6,
        grid=true,
        gridwidth=1,
        gridcolor=:lightgray,
        size=(600, 400)
    )
end

# Appliquer le thème
theme_burkina_faso()
```

### Sauvegarder les graphiques
```julia
# Créer un graphique
p = plot(regions, production,
         title="Production Céréalière - Burkina Faso",
         ylabel="Production (milliers tonnes)")

# Sauvegarder en différents formats
savefig(p, "production_cereales.png")
savefig(p, "production_cereales.pdf")
savefig(p, "production_cereales.svg")

# Haute résolution pour impression
savefig(p, "production_cereales_hd.png", dpi=300)
```

## 🔧 Optimisation et Performance

### Graphiques pour gros datasets
```julia
# Pour de grandes quantités de données
function plot_large_dataset(x, y; sample_size=1000)
    if length(x) > sample_size
        indices = sort(sample(1:length(x), sample_size, replace=false))
        x_sample = x[indices]
        y_sample = y[indices]
    else
        x_sample, y_sample = x, y
    end
    
    scatter(x_sample, y_sample, alpha=0.6, markersize=2)
end

# Utilisation avec données simulées
big_x = randn(10000)
big_y = 2 .* big_x .+ randn(10000)
plot_large_dataset(big_x, big_y)
```

### Graphiques interactifs optimisés
```julia
# Utiliser PlotlyJS pour l'interactivité sans sacrifier la performance
plotlyjs()

# Configuration pour de meilleures performances
ENV["PLOTLYJS_DELETE_TMP"] = true  # Nettoyer les fichiers temporaires
```

## 🎓 Bonnes Pratiques de Visualisation

### Principes de design
1. **Clarté** : Le message doit être immédiatement compréhensible
2. **Simplicité** : Éviter la surcharge visuelle
3. **Précision** : Les données doivent être représentées fidèlement
4. **Esthétique** : Le graphique doit être agréable à regarder

### Checklist qualité
```julia
function validate_plot_quality(p)
    println("✓ Titre informatif présent ?")
    println("✓ Axes correctement étiquetés ?") 
    println("✓ Légende claire si nécessaire ?")
    println("✓ Couleurs accessibles (daltonisme) ?")
    println("✓ Taille de police lisible ?")
    println("✓ Données source mentionnées ?")
    return p
end
```

### Couleurs et accessibilité
```julia
# Palette accessible pour daltoniens
couleurs_accessibles = [:blue, :orange, :green, :red, :purple, :brown, :pink, :gray]

# Test de contraste
function test_contraste()
    data = rand(5, 3)
    bar(data, color=couleurs_accessibles[1:3],
        title="Test Palette Accessible")
end
```

## 🏆 Projet Pratique : Tableau de Bord Burkina Faso

### Dashboard complet
```julia
function dashboard_burkina_faso()
    # Données exemple
    regions = ["Centre", "Hauts-Bassins", "Nord", "Est", "Sud-Ouest"]
    
    # 1. PIB par région
    pib = [2845, 1567, 987, 757, 635]
    p1 = bar(regions, pib, title="PIB par Région (milliards FCFA)",
             color=:lightblue, ylabel="PIB")
    
    # 2. Évolution population urbaine
    annees = 2010:2020
    pop_urbaine_pct = 15:2:35
    p2 = plot(annees, pop_urbaine_pct, title="Urbanisation (%)",
              linewidth=3, marker=:circle, color=:green)
    
    # 3. Production agricole
    cereales = ["Mil", "Sorgho", "Maïs"]
    prod_nat = [1250, 1100, 950]
    p3 = pie(prod_nat, labels=cereales, title="Production Nationale (kt)")
    
    # 4. Indicateurs sociaux
    indicateurs = ["Alphabétisation", "Eau potable", "Électricité", "Santé"]
    scores = [41.2, 61.4, 35.8, 52.7]
    p4 = bar(indicateurs, scores, title="Indicateurs Sociaux (%)",
             color=:orange, orientation=:horizontal)
    
    # Assemblage final
    plot(p1, p2, p3, p4, layout=(2,2), size=(1000, 700),
         suptitle="Tableau de Bord - Burkina Faso 2023")
end

# Exécution
dashboard_burkina_faso()
```

## 📚 Ressources et Extensions

### Packages complémentaires
- **PlotlyJS.jl** : Interactivité avancée
- **GR.jl** : Backend rapide pour production
- **PGFPlotsX.jl** : Qualité publication LaTeX
- **PlotThemes.jl** : Thèmes prédéfinis
- **Colors.jl** : Gestion avancée des couleurs
- **Measures.jl** : Contrôle précis des dimensions

### Formats d'export
```julia
# Différents formats selon l'usage
savefig("graph_web.png")        # Web
savefig("graph_print.pdf")      # Impression
savefig("graph_vector.svg")     # Vectoriel
savefig("graph_latex.tex")      # LaTeX
```

## 🏆 Points Clés à Retenir

1. **Plots.jl** offre une interface unifiée et puissante
2. Le choix du **backend** dépend de l'usage (rapidité vs interactivité)
3. La **personnalisation** permet d'adapter aux besoins spécifiques
4. L'intégration avec **DataFrames** simplifie l'analyse
5. Les **bonnes pratiques** de design sont essentielles
6. L'**interactivité** enrichit l'exploration des données
7. La **sauvegarde** en multiple formats facilite la diffusion

Dans la prochaine session, nous utiliserons ces compétences de visualisation pour créer des graphiques climatiques et économiques spécifiques au contexte burkinabè !