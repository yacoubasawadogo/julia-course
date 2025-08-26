# Exercice 10 : Création d'un Tableau de Bord Interactif pour le Développement Local du Burkina Faso

## 🎯 Mission
Vous êtes consultant en data visualization pour l'INSD (Institut National de la Statistique et de la Démographie) du Burkina Faso. Votre mission est de créer un tableau de bord interactif complet qui permettra aux décideurs locaux de visualiser et analyser les statistiques de développement à tous les niveaux territoriaux.

## 📋 Cahier des Charges

### Objectifs du Tableau de Bord
1. **Surveillance** : Suivre les indicateurs clés de développement
2. **Comparaison** : Comparer les performances entre régions/provinces
3. **Tendances** : Identifier les évolutions temporelles
4. **Alerte** : Détecter les anomalies et points d'attention
5. **Décision** : Fournir des insights pour l'allocation des ressources

### Utilisateurs Cibles
- Gouverneurs régionaux
- Préfets et maires
- Directeurs sectoriels (santé, éducation, agriculture)
- Partenaires au développement
- Citoyens et société civile

## 🛠️ Prérequis Techniques
```julia
using Plots
using DataFrames
using Statistics
using StatsPlots
using Dates
using DataFramesMeta
using PlotlyJS

# Configuration pour interactivité maximale
plotlyjs()
```

## 📊 Phase 1: Création du Dataset Intégré (20 points)

### Dataset 1: Données territoriales de base
```julia
# Créez ce dataset avec les informations géographiques et administratives
df_territorial = DataFrame(
    code_region = 1:13,
    region = ["Boucle du Mouhoun", "Cascades", "Centre", "Centre-Est", "Centre-Nord",
              "Centre-Ouest", "Centre-Sud", "Est", "Hauts-Bassins", "Nord",
              "Plateau Central", "Sahel", "Sud-Ouest"],
    zone_climatique = ["Soudanienne", "Soudanienne", "Soudano-Sahélienne", 
                      "Soudano-Sahélienne", "Sahélienne", "Soudano-Sahélienne",
                      "Soudanienne", "Soudano-Sahélienne", "Soudanienne",
                      "Sahélienne", "Soudano-Sahélienne", "Sahélienne", "Soudanienne"],
    superficie_km2 = [34497, 18818, 2805, 14850, 19616, 21691, 11317, 46418,
                     25438, 17284, 8608, 35166, 18424],
    chef_lieu = ["Dédougou", "Banfora", "Ouagadougou", "Tenkodogo", "Kaya",
                "Koudougou", "Manga", "Fada N'Gourma", "Bobo-Dioulasso",
                "Ouahigouya", "Ziniaré", "Dori", "Gaoua"],
    distance_ouaga_km = [230, 445, 0, 140, 110, 99, 85, 250, 365, 182, 45, 295, 350]
)
```

### Dataset 2: Indicateurs socio-économiques multi-temporels
```julia
# Dataset avec évolution 2018-2023 pour tous les indicateurs
function create_master_dataset()
    # Base temporelle
    annees = 2018:2023
    regions = df_territorial.region
    
    # Génération des données pour chaque région et année
    data = []
    
    for region in regions, annee in annees
        # Simuler une progression réaliste avec variabilité
        base_year = 2018
        progress_factor = (annee - base_year) / 5
        
        # Facteurs régionaux (Centre plus développé, Sahel moins)
        regional_factor = region == "Centre" ? 1.3 : 
                         region in ["Sahel", "Nord", "Centre-Nord"] ? 0.7 : 1.0
        
        push!(data, (
            annee = annee,
            region = region,
            
            # Démographie
            population = round(Int, (50000 + 200000 * regional_factor) * (1 + 0.025)^(annee-2018) + 
                              randn() * 5000),
            densite_km2 = 0.0,  # À calculer
            taux_urbanisation = round(15 + 25 * regional_factor + 2 * progress_factor + randn() * 2, digits=1),
            
            # Économie
            pib_par_habitant = round(250000 + 200000 * regional_factor + 
                                   15000 * progress_factor + randn() * 20000),
            taux_pauvrete = round(max(15, 65 - 20 * regional_factor - 3 * progress_factor + randn() * 3), digits=1),
            emploi_formel_pct = round(8 + 15 * regional_factor + 2 * progress_factor + randn() * 2, digits=1),
            
            # Éducation
            taux_alphabetisation = round(min(85, 25 + 35 * regional_factor + 4 * progress_factor + randn() * 3), digits=1),
            taux_scolarisation_primaire = round(min(98, 65 + 20 * regional_factor + 3 * progress_factor + randn() * 2), digits=1),
            taux_scolarisation_secondaire = round(min(80, 20 + 25 * regional_factor + 4 * progress_factor + randn() * 3), digits=1),
            ratio_eleves_enseignant = round(45 - 8 * regional_factor - 1 * progress_factor + randn() * 3, digits=1),
            
            # Santé
            esperance_vie = round(52 + 8 * regional_factor + 0.8 * progress_factor + randn() * 1, digits=1),
            mortalite_infantile = round(max(25, 75 - 15 * regional_factor - 2 * progress_factor + randn() * 3), digits=1),
            acces_soins_km = round(max(2, 12 - 6 * regional_factor - 0.5 * progress_factor + randn() * 1), digits=1),
            couverture_vaccination_pct = round(min(95, 60 + 20 * regional_factor + 3 * progress_factor + randn() * 2), digits=1),
            
            # Infrastructure
            acces_eau_potable_pct = round(min(90, 35 + 30 * regional_factor + 4 * progress_factor + randn() * 3), digits=1),
            acces_electricite_pct = round(min(85, 15 + 40 * regional_factor + 5 * progress_factor + randn() * 4), digits=1),
            acces_internet_pct = round(min(75, 8 + 35 * regional_factor + 6 * progress_factor + randn() * 3), digits=1),
            routes_bitumees_km = round(200 + 500 * regional_factor + 25 * progress_factor + randn() * 30),
            
            # Agriculture
            production_cereales_tonnes = round(15000 + 45000 * regional_factor + 
                                             2000 * progress_factor + randn() * 5000),
            superficie_irriguee_ha = round(500 + 2000 * regional_factor + 200 * progress_factor + randn() * 300),
            rendement_cereales_tonne_ha = round(0.8 + 0.4 * regional_factor + 0.05 * progress_factor + randn() * 0.1, digits=2),
            
            # Environnement
            couverture_forestiere_pct = round(max(5, 25 - 5 * (annee-2018) + randn() * 2), digits=1),
            aires_protegees_pct = round(8 + 5 * regional_factor + randn() * 1, digits=1),
            
            # Gouvernance
            budget_regional_milliards = round(1.5 + 4 * regional_factor + 0.3 * progress_factor + randn() * 0.5, digits=2),
            projets_developpement = round(Int, 5 + 15 * regional_factor + 2 * progress_factor + randn() * 3)
        ))
    end
    
    return DataFrame(data)
end

df_master = create_master_dataset()

# Calcul de la densité
df_master = leftjoin(df_master, df_territorial[!, [:region, :superficie_km2]], on=:region)
transform!(df_master, [:population, :superficie_km2] => ((p, s) -> round.(p ./ s, digits=1)) => :densite_km2)

println("📊 Dataset master créé : $(nrow(df_master)) observations")
println("📅 Période : $(minimum(df_master.annee))-$(maximum(df_master.annee))")
println("🗺️ Régions : $(length(unique(df_master.region)))")
```

**🎯 Mission 1:** Validez la cohérence des données et créez un résumé statistique par dimension.

---

## 📈 Phase 2: Tableaux de Bord Sectoriels (30 points)

### Dashboard 1: Développement Humain
```julia
function dashboard_developpement_humain(annee_focus=2023)
    # Filtrer les données pour l'année focus
    df_annee = @subset(df_master, :annee .== annee_focus)
    
    # 1. Carte de l'espérance de vie
    p1 = scatter(df_annee.region, df_annee.esperance_vie,
        title="Espérance de Vie par Région ($annee_focus)",
        ylabel="Années", markersize=8, color=:red,
        series_annotations=text.(round.(df_annee.esperance_vie, digits=1), 8, :bottom))
    
    # 2. Éducation - Scatter alphabétisation vs scolarisation
    p2 = scatter(df_annee.taux_alphabetisation, df_annee.taux_scolarisation_primaire,
        title="Alphabétisation vs Scolarisation",
        xlabel="Taux d'alphabétisation (%)", ylabel="Scolarisation primaire (%)",
        series_annotations=text.(df_annee.region, 6, :bottom),
        markersize=6, color=:blue)
    
    # 3. Évolution mortalité infantile
    mort_evolution = combine(groupby(df_master, :region),
        :mortalite_infantile => (x -> x[end] - x[1]) => :evolution_mortalite)
    p3 = bar(mort_evolution.region, mort_evolution.evolution_mortalite,
        title="Évolution Mortalité Infantile (2018-2023)",
        ylabel="Variation (pour 1000)", color=:orange, rotation=45)
    
    # 4. Accès aux soins
    p4 = plot(sort(df_annee, :acces_soins_km).region, 
             sort(df_annee, :acces_soins_km).acces_soins_km,
        title="Distance Moyenne aux Soins",
        ylabel="Km", linewidth=2, marker=:circle, color=:green)
    
    plot(p1, p2, p3, p4, layout=(2,2), size=(1000, 700),
         suptitle="Dashboard Développement Humain - $annee_focus")
end

# Votre implémentation ici
dashboard_developpement_humain()
```

### Dashboard 2: Infrastructure et Services
```julia
function dashboard_infrastructure(annee_focus=2023)
    # Votre code ici
    # 1. Heatmap accès aux services (eau, électricité, internet)
    # 2. Évolution de la connectivité numérique
    # 3. Investissements en infrastructure
    # 4. Qualité des routes et transport
end
```

### Dashboard 3: Économie et Emploi
```julia
function dashboard_economie(annee_focus=2023)
    # Votre code ici
    # 1. PIB par habitant et croissance
    # 2. Taux de pauvreté et inégalités
    # 3. Emploi formel vs informel
    # 4. Budget régional et investissements
end
```

**🎯 Mission 2:** Implémentez les 3 dashboards sectoriels avec au moins 4 visualisations chacun.

---

## 🎯 Phase 3: Analyses Comparatives et Benchmarking (25 points)

### Analyse 1: Classement Multi-dimensionnel
```julia
function analyse_classement_regions(annee=2023)
    df_annee = @subset(df_master, :annee .== annee)
    
    # Création d'un score composite de développement
    # Normalisation min-max pour chaque indicateur
    function normaliser(x)
        return (x .- minimum(x)) ./ (maximum(x) - minimum(x)) .* 100
    end
    
    # Score développement humain
    score_dh = @chain df_annee begin
        @transform(
            :esp_vie_norm = normaliser(:esperance_vie),
            :alpha_norm = normaliser(:taux_alphabetisation),
            :scol_norm = normaliser(:taux_scolarisation_primaire),
            :sante_norm = 100 .- normaliser(:acces_soins_km)  # Inverser (moins = mieux)
        )
        @transform(:score_humain = (:esp_vie_norm .+ :alpha_norm .+ :scol_norm .+ :sante_norm) ./ 4)
    end
    
    # Score infrastructure
    # À compléter...
    
    # Visualisation du classement
    # À implémenter...
    
    return score_dh
end

# Votre implémentation complète ici
```

### Analyse 2: Convergence/Divergence Régionale
```julia
function analyse_convergence()
    # Analyse si les écarts entre régions se réduisent ou s'accentuent
    # 1. Calcul du coefficient de variation par année
    # 2. Graphique d'évolution des inégalités
    # 3. Identification des régions qui convergent/divergent
    # 4. Heat map des performances relatives
end
```

**🎯 Mission 3:** Créez un système de scoring et classement des régions avec visualisations interactives.

---

## 🚀 Phase 4: Dashboard Intégré et Interactif (25 points)

### Dashboard Principal Multi-onglets
```julia
function dashboard_principal_interactif()
    # Onglet 1: Vue d'ensemble nationale
    function vue_ensemble()
        # KPIs nationaux en temps réel
        # Évolution des principaux indicateurs
        # Alertes et anomalies
    end
    
    # Onglet 2: Comparaisons régionales
    function comparaisons_regionales()
        # Graphiques radar par région
        # Matrices de corrélation
        # Benchmarking inter-régional
    end
    
    # Onglet 3: Évolutions temporelles
    function evolutions_temporelles()
        # Séries temporelles interactives
        # Détection de tendances
        # Projections simples
    end
    
    # Onglet 4: Analyse sectorielle
    function analyse_sectorielle()
        # Focus par secteur (santé, éducation, etc.)
        # Corrélations croisées
        # Impact des investissements
    end
    
    # Interface principale
    # Votre implémentation avec PlotlyJS pour l'interactivité
end
```

### Fonctionnalités Interactives Requises
1. **Filtres temporels** : Sélection d'années/périodes
2. **Filtres géographiques** : Sélection de régions
3. **Sélecteurs d'indicateurs** : Choix des variables à afficher
4. **Zoom et pan** : Navigation dans les graphiques
5. **Tooltips informatifs** : Détails au survol
6. **Export de graphiques** : PNG, PDF, SVG

```julia
# Exemple d'implémentation interactive
function graphique_interactif_evolution(variable::Symbol)
    p = plot(title="Évolution de $(string(variable))")
    
    for region in unique(df_master.region)
        data_region = @subset(df_master, :region .== region)
        plot!(p, data_region.annee, data_region[!, variable],
              label=region, linewidth=2, marker=:circle)
    end
    
    # Configuration pour interactivité PlotlyJS
    plot!(p, size=(800, 500),
          xlabel="Année", 
          ylabel=string(variable),
          legend=:outertopright)
    
    return p
end

# Test avec différentes variables
graphique_interactif_evolution(:taux_alphabetisation)
```

**🎯 Mission 4:** Créez un dashboard principal avec au moins 3 niveaux d'interactivité.

---

## 📊 Phase 5: Analyses Avancées et Insights (Bonus 10 points)

### Analyse 1: Détection d'Anomalies
```julia
function detecter_anomalies_regionales()
    # 1. Identification des valeurs aberrantes par indicateur
    # 2. Détection des changements brusques d'une année à l'autre
    # 3. Comparaison avec les moyennes nationales
    # 4. Visualisation des anomalies avec alertes colorées
end
```

### Analyse 2: Clustering de Régions
```julia
function clustering_regions_similaires()
    # 1. Classification automatique des régions par profil de développement
    # 2. Visualisation des clusters sur graphiques radar
    # 3. Recommandations de politiques par cluster
end
```

### Analyse 3: Simulation de Scénarios
```julia
function simuler_scenarios_investissement()
    # 1. Impact simulé d'investissements ciblés
    # 2. Modélisation simple des effets de rattrapage
    # 3. Visualisation comparative des scénarios
end
```

## 🏆 Critères d'Évaluation

### Excellence Technique (30%)
- Maîtrise des fonctions Plots.jl avancées
- Qualité du code (lisibilité, modularité)
- Utilisation appropriée de l'interactivité
- Performance et optimisation

### Design et UX (25%)
- Clarté et lisibilité des visualisations
- Cohérence graphique et colorimétrique
- Navigation intuitive
- Adaptation aux différents utilisateurs

### Insights et Analyse (25%)
- Pertinence des indicateurs créés
- Profondeur de l'analyse
- Qualité des comparaisons
- Identification d'insights actionables

### Innovation et Créativité (20%)
- Originalité des visualisations
- Fonctionnalités créatives
- Solutions techniques innovantes
- Adaptation au contexte burkinabè

## 📋 Livrables Attendus

### 1. Code Source Complet
```julia
# Structure recommandée
module DashboardBurkinaFaso
    using Plots, DataFrames, PlotlyJS, Statistics
    
    # Fonctions de création de données
    include("data_generation.jl")
    
    # Fonctions de visualisation
    include("visualizations.jl")
    
    # Dashboards sectoriels
    include("dashboards.jl")
    
    # Dashboard principal
    include("main_dashboard.jl")
    
    # Analyses avancées
    include("advanced_analytics.jl")
end
```

### 2. Documentation Utilisateur
- Guide d'utilisation du dashboard
- Interprétation des indicateurs
- Recommandations d'usage par profil

### 3. Rapport d'Insights
- Top 10 des insights découverts
- Recommandations politiques par région
- Priorisation des interventions

### 4. Démonstration Interactive
- Scénario d'usage pour un gouverneur régional
- Cas d'utilisation pour planification budgétaire
- Exemple d'analyse comparative inter-régionale

## 💡 Conseils de Réussite

### Approche Méthodologique
1. **Commencez simple** : Dashboard de base puis enrichissement
2. **Testez régulièrement** : Vérifiez l'interactivité à chaque étape
3. **Pensez utilisateur** : Adaptez aux besoins des décideurs
4. **Optimisez l'impact** : Priorisez la clarté sur la complexité

### Bonnes Pratiques Visualisation
```julia
# Palette de couleurs cohérente
couleurs_bf = [:red, :yellow, :green, :orange, :blue, :purple]

# Thème personnalisé
function appliquer_theme_burkina()
    default(
        fontfamily="Arial",
        titlefontsize=14,
        guidefontsize=12,
        tickfontsize=10,
        palette=couleurs_bf,
        linewidth=2,
        markersize=6,
        size=(800, 500),
        dpi=150
    )
end
```

### Performance et Optimisation
```julia
# Pour gros datasets
function optimiser_performance(df::DataFrame)
    # Échantillonnage si nécessaire
    # Agrégation préalable
    # Cache des calculs coûteux
end
```

## 🎓 Ressources Complémentaires

### Documentation
- [Plots.jl Documentation](https://docs.juliaplots.org/latest/)
- [PlotlyJS.jl Guide](https://plotlyjs.org/julia/)
- [Meilleures pratiques Data Viz](https://www.data-to-viz.com/)

### Inspiration
- Tableaux de bord de la Banque Mondiale
- Dashboards de l'OCDE
- Visualisations de l'INSD Burkina Faso

Bonne chance pour ce projet de visualisation qui contribuera directement à l'amélioration de la prise de décision basée sur les données au Burkina Faso ! 🇧🇫📊