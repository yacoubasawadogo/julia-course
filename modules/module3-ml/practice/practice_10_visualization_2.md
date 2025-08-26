# Practice 10.2 : Visualisation des Indicateurs Économiques du Burkina Faso

## 🎯 Objectif
Créer des visualisations avancées des indicateurs économiques et financiers du Burkina Faso, incluant les taux de change FCFA, prix des matières premières, indices boursiers régionaux et indicateurs de développement.

## 📋 Prérequis
```julia
using Plots
using DataFrames
using Statistics
using StatsPlots
using Dates
using DataFramesMeta

# Configuration pour graphiques interactifs
plotlyjs()
```

## 💰 Création des Données Économiques

### Étape 1: Dataset principal des indicateurs économiques
```julia
# Données économiques mensuelles 2020-2023
dates = Date(2020,1,1):Month(1):Date(2023,12,1)
n_mois = length(dates)

df_economie = DataFrame(
    date = dates,
    annee = year.(dates),
    mois = month.(dates),
    mois_nom = monthname.(dates, locale="french"),
    
    # Taux de change FCFA (pour 1 EUR et 1 USD)
    fcfa_eur = 655.957 .+ cumsum(randn(n_mois) .* 2.0),  # Fixe mais avec petites variations
    fcfa_usd = 550.0 .+ cumsum(randn(n_mois) .* 8.0 .+ 0.5),  # Plus volatile
    
    # Prix des matières premières (FCFA/tonne)
    prix_coton = 1200000 .+ cumsum(randn(n_mois) .* 15000 .+ 2000),
    prix_or_fcfa_once = 35000 .+ cumsum(randn(n_mois) .* 1000 .+ 100),
    prix_sesame = 800000 .+ cumsum(randn(n_mois) .* 12000),
    prix_arachide = 450000 .+ cumsum(randn(n_mois) .* 8000),
    
    # Indices de prix intérieurs
    indice_prix_consommation = 100 .+ cumsum(randn(n_mois) .* 0.3 .+ 0.15),
    indice_prix_agricoles = 100 .+ cumsum(randn(n_mois) .* 1.2 .+ 0.4),
    
    # Indicateurs monétaires (milliards FCFA)
    masse_monetaire_m2 = 3500 .+ cumsum(randn(n_mois) .* 15 .+ 8),
    credits_economie = 2800 .+ cumsum(randn(n_mois) .* 25 .+ 12),
    depot_bancaires = 2200 .+ cumsum(randn(n_mois) .* 18 .+ 6),
    
    # Commerce extérieur (milliards FCFA)
    exportations = 180 .+ 60 .* sin.(2π .* (1:n_mois) ./ 12) .+ cumsum(randn(n_mois) .* 2),
    importations = 220 .+ 40 .* sin.(2π .* (1:n_mois) ./ 12 .+ π/3) .+ cumsum(randn(n_mois) .* 3),
    
    # Indicateurs sectoriels (indices base 100)
    production_industrielle = 100 .+ cumsum(randn(n_mois) .* 1.5 .+ 0.2),
    activite_miniere = 100 .+ cumsum(randn(n_mois) .* 2.8 .+ 0.8),
    
    # Taux d'intérêt (%)
    taux_interet_bceao = 2.5 .+ cumsum(randn(n_mois) .* 0.1),
    taux_credit_bancaire = 8.5 .+ cumsum(randn(n_mois) .* 0.2),
    
    # Inflation (% annuel)
    inflation_annuelle = 2.0 .+ cumsum(randn(n_mois) .* 0.15 .+ 0.05)
)

# Calculs dérivés
transform!(df_economie,
    [:exportations, :importations] => ((-) => :balance_commerciale),
    [:prix_coton, :prix_or_fcfa_once] => ((c, o) -> (c .+ o.*10) ./ 2) => :indice_matieres_premieres,
    [:credits_economie, :depot_bancaires] => ((c, d) -> c ./ d) => :ratio_credit_depot
)

println("📊 Dataset économique créé avec $(nrow(df_economie)) observations")
println("📅 Période couverte : $(minimum(df_economie.date)) à $(maximum(df_economie.date))")
```

**🎯 Défi 1 :** Explorez les statistiques descriptives des principales variables économiques.

---

### Étape 2: Évolution des taux de change FCFA
```julia
# Graphique de l'évolution des taux de change
p_change = plot(df_economie.date, [df_economie.fcfa_eur df_economie.fcfa_usd],
    title="Évolution des Taux de Change FCFA (2020-2023)",
    xlabel="Date", ylabel="FCFA pour 1 unité",
    label=["EUR/FCFA" "USD/FCFA"],
    linewidth=2, color=[:blue :red],
    size=(800, 500))

# Ligne de référence (taux fixe EUR)
hline!([655.957], linestyle=:dash, color=:blue, alpha=0.5, label="Parité EUR fixe")

# Zones de volatilité
volatilite_usd = rolling(x -> std(x), df_economie.fcfa_usd, 6)
plot!(p_change, df_economie.date[6:end], df_economie.fcfa_usd[6:end],
      ribbon=volatilite_usd.*2, fillalpha=0.2, color=:red, label="")

display(p_change)
```

**🎯 Défi 2 :** Calculez la volatilité moyenne de l'USD/FCFA sur la période.

---

### Étape 3: Prix des matières premières
```julia
# Normalisation des prix (base 100 en janvier 2020)
prix_normalises = @chain df_economie begin
    @transform(
        :coton_norm = :prix_coton ./ :prix_coton[1] .* 100,
        :or_norm = :prix_or_fcfa_once ./ :prix_or_fcfa_once[1] .* 100,
        :sesame_norm = :prix_sesame ./ :prix_sesame[1] .* 100,
        :arachide_norm = :prix_arachide ./ :prix_arachide[1] .* 100
    )
end

# Graphique des évolutions relatives
plot(prix_normalises.date, [prix_normalises.coton_norm prix_normalises.or_norm 
                           prix_normalises.sesame_norm prix_normalises.arachide_norm],
    title="Évolution des Prix des Matières Premières (Base 100 = Jan 2020)",
    xlabel="Date", ylabel="Indice (Base 100)",
    label=["Coton" "Or" "Sésame" "Arachide"],
    linewidth=2, size=(900, 500),
    legend=:topleft)

# Ligne de référence
hline!([100], linestyle=:dash, color=:gray, label="Niveau initial")
```

**🎯 Défi 3 :** Quelle matière première a connu la plus forte hausse sur la période ?

---

### Étape 4: Balance commerciale et commerce extérieur
```julia
# Graphique en aires empilées du commerce extérieur
p_commerce = plot(df_economie.date, df_economie.exportations,
    title="Commerce Extérieur du Burkina Faso",
    xlabel="Date", ylabel="Milliards FCFA",
    label="Exportations", fillrange=0, fillalpha=0.6, color=:green,
    size=(800, 500))

plot!(p_commerce, df_economie.date, -df_economie.importations,
      label="Importations", fillrange=0, fillalpha=0.6, color=:red)

# Balance commerciale
plot!(p_commerce, df_economie.date, df_economie.balance_commerciale,
      label="Balance commerciale", linewidth=3, color=:blue)

# Ligne zéro
hline!([0], linestyle=:dash, color=:black, alpha=0.5, label="")

display(p_commerce)
```

**🎯 Défi 4 :** Calculez le déficit commercial moyen par année.

---

### Étape 5: Analyse de l'inflation et des prix
```julia
# Graphique dual inflation vs indices de prix
p_inflation = plot(df_economie.date, df_economie.inflation_annuelle,
    title="Inflation et Indices de Prix",
    xlabel="Date", ylabel="Inflation (%)",
    label="Inflation annuelle", linewidth=3, color=:red,
    size=(800, 500))

# Axe secondaire pour les indices
plot!(twinx(), df_economie.date, [df_economie.indice_prix_consommation df_economie.indice_prix_agricoles],
      ylabel="Indice (Base 100)", label=["IPC" "Prix agricoles"],
      linewidth=2, color=[:blue :green], linestyle=[:solid :dash])

# Zone de cible d'inflation (exemple 1-3%)
plot!(p_inflation, df_economie.date, ones(n_mois), fillrange=3*ones(n_mois),
      fillalpha=0.1, color=:green, label="Cible inflation", linealpha=0)

display(p_inflation)
```

**🎯 Défi 5 :** L'inflation est-elle restée dans la cible sur toute la période ?

---

### Étape 6: Secteur bancaire et monétaire
```julia
# Évolution des agrégats monétaires
p_monetaire = plot(df_economie.date, [df_economie.masse_monetaire_m2 df_economie.credits_economie df_economie.depot_bancaires],
    title="Évolution des Agrégats Monétaires",
    xlabel="Date", ylabel="Milliards FCFA",
    label=["Masse monétaire M2" "Crédits à l'économie" "Dépôts bancaires"],
    linewidth=2, size=(800, 500))

# Graphique du ratio crédit/dépôt
p_ratio = plot(df_economie.date, df_economie.ratio_credit_depot,
    title="Ratio Crédits/Dépôts",
    xlabel="Date", ylabel="Ratio",
    linewidth=3, color=:purple, size=(600, 300))

hline!([1.0], linestyle=:dash, color=:red, label="Équilibre")

# Assemblage vertical
plot(p_monetaire, p_ratio, layout=(2,1), size=(800, 700))
```

**🎯 Défi 6 :** Le système bancaire est-il en expansion (ratio > 1) ou en consolidation ?

---

### Étape 7: Tableau de bord macroéconomique
```julia
# Fonction pour créer un dashboard macroéconomique
function dashboard_macro()
    # Dernières valeurs
    dernier_mois = last(df_economie, 1)
    
    # 1. PIB et croissance (simulation)
    annees = 2020:2023
    croissance_pib = [1.2, 6.9, 2.8, 5.1]  # % de croissance
    p1 = bar(string.(annees), croissance_pib,
        title="Croissance du PIB (%)",
        ylabel="%", color=:lightblue)
    
    # 2. Évolution inflation
    p2 = plot(df_economie.date, df_economie.inflation_annuelle,
        title="Inflation (%)",
        ylabel="%", color=:red, linewidth=2)
    
    # 3. Balance commerciale cumulative
    balance_cumul = cumsum(df_economie.balance_commerciale)
    p3 = plot(df_economie.date, balance_cumul,
        title="Balance Commerciale Cumulée",
        ylabel="Milliards FCFA", color=:blue, linewidth=2)
    hline!([0], linestyle=:dash, color=:gray)
    
    # 4. Prix matières premières (moyennes mobiles)
    ma_coton = rolling(mean, df_economie.prix_coton, 6)
    ma_or = rolling(mean, df_economie.prix_or_fcfa_once, 6)
    p4 = plot(df_economie.date[6:end], [ma_coton ma_or],
        title="Prix Matières Premières (MM6)",
        ylabel="FCFA", label=["Coton" "Or"])
    
    # Assemblage
    plot(p1, p2, p3, p4, layout=(2,2), size=(1000, 700),
         suptitle="Tableau de Bord Macroéconomique - Burkina Faso")
end

dashboard_macro()
```

**🎯 Défi 7 :** Ajoutez un 5ème graphique montrant l'évolution de la masse monétaire.

---

### Étape 8: Analyse saisonnière des exportations
```julia
# Décomposition saisonnière des exportations
exportations_par_mois = combine(groupby(df_economie, :mois),
    :exportations => mean => :export_moyen,
    :exportations => std => :export_std
)

# Graphique de saisonnalité
p_saison = bar(exportations_par_mois.mois, exportations_par_mois.export_moyen,
    title="Saisonnalité des Exportations",
    xlabel="Mois", ylabel="Exportations Moyennes (Milliards FCFA)",
    yerror=exportations_par_mois.export_std,
    color=:lightgreen, size=(800, 500))

# Ligne de moyenne annuelle
moyenne_annuelle = mean(exportations_par_mois.export_moyen)
hline!([moyenne_annuelle], linestyle=:dash, color=:red, 
       label="Moyenne annuelle", linewidth=2)

display(p_saison)
```

**🎯 Défi 8 :** Quels mois sont les plus favorables aux exportations ?

---

### Étape 9: Corrélations entre indicateurs économiques
```julia
# Sélection des variables pour analyse de corrélation
variables_eco = [:inflation_annuelle, :fcfa_usd, :prix_coton, :prix_or_fcfa_once,
                :production_industrielle, :activite_miniere, :exportations, :importations]

# Matrice de corrélation
matrice_corr_eco = cor(Matrix(df_economie[!, variables_eco]))

# Heatmap des corrélations
heatmap(string.(variables_eco), string.(variables_eco), matrice_corr_eco,
    title="Corrélations entre Indicateurs Économiques",
    color=:RdYlBu, aspect_ratio=1, size=(700, 600))

# Ajouter les valeurs
for i in 1:length(variables_eco)
    for j in 1:length(variables_eco)
        val = round(matrice_corr_eco[i,j], digits=2)
        color_text = abs(val) > 0.5 ? :white : :black
        annotate!(i, j, text(val, 8, color_text))
    end
end
```

**🎯 Défi 9 :** Identifiez les 3 paires de variables les plus corrélées.

---

### Étape 10: Analyse des tendances à long terme
```julia
# Calcul des tendances linéaires pour les principaux indicateurs
function calculer_tendance(x, y)
    n = length(x)
    x_num = 1:n
    slope = (n*sum(x_num .* y) - sum(x_num)*sum(y)) / (n*sum(x_num.^2) - sum(x_num)^2)
    return slope
end

# Tendances principales
tendance_inflation = calculer_tendance(1:n_mois, df_economie.inflation_annuelle)
tendance_prix_coton = calculer_tendance(1:n_mois, df_economie.prix_coton)
tendance_usd = calculer_tendance(1:n_mois, df_economie.fcfa_usd)

# Graphique des tendances
p_tendances = plot(title="Tendances Économiques à Long Terme",
                  xlabel="Période", ylabel="Valeur Normalisée",
                  size=(800, 500))

# Normalisation et affichage des tendances
for (var, nom, couleur) in [(:inflation_annuelle, "Inflation", :red),
                           (:prix_coton, "Prix Coton", :green),
                           (:fcfa_usd, "USD/FCFA", :blue)]
    y_norm = (df_economie[!, var] .- minimum(df_economie[!, var])) ./ 
             (maximum(df_economie[!, var]) - minimum(df_economie[!, var])) .* 100
    
    plot!(p_tendances, 1:n_mois, y_norm, label=nom, linewidth=2, color=couleur)
    
    # Ligne de tendance
    trend_line = y_norm[1] .+ calculer_tendance(1:n_mois, y_norm) .* (1:n_mois .- 1)
    plot!(p_tendances, 1:n_mois, trend_line, linestyle=:dash, color=couleur, alpha=0.7)
end

display(p_tendances)

println("📈 Tendances calculées :")
println("   Inflation : $(round(tendance_inflation*12, digits=2))% par an")
println("   Prix coton : $(round(tendance_prix_coton*12, digits=0)) FCFA/tonne par an")
println("   USD/FCFA : $(round(tendance_usd*12, digits=2)) FCFA par an")
```

**🎯 Défi 10 :** Calculez les tendances pour la production industrielle et l'activité minière.

---

### Étape 11: Indice de conditions économiques
```julia
# Création d'un indice composite des conditions économiques
function calculer_ice(df::DataFrame)
    # Normalisation de chaque composante (0-100)
    inflation_norm = 100 .- (df.inflation_annuelle .- 1.0) .* 10  # Plus bas = mieux
    production_norm = (df.production_industrielle .- 90) .* 2    # Plus haut = mieux
    commerce_norm = (df.exportations .- minimum(df.exportations)) ./ 
                    (maximum(df.exportations) - minimum(df.exportations)) .* 100
    prix_norm = (df.indice_matieres_premieres .- minimum(df.indice_matieres_premieres)) ./
                (maximum(df.indice_matieres_premieres) - minimum(df.indice_matieres_premieres)) .* 100
    
    # ICE = moyenne pondérée
    ice = 0.3 .* inflation_norm .+ 0.3 .* production_norm .+ 
          0.2 .* commerce_norm .+ 0.2 .* prix_norm
    
    return ice
end

# Calcul et visualisation de l'ICE
df_economie.ice = calculer_ice(df_economie)

p_ice = plot(df_economie.date, df_economie.ice,
    title="Indice des Conditions Économiques (ICE)",
    xlabel="Date", ylabel="ICE (0-100)",
    linewidth=3, color=:purple, size=(800, 500))

# Zones d'interprétation
hline!([75], linestyle=:dash, color=:green, label="Conditions favorables")
hline!([50], linestyle=:dash, color=:orange, label="Conditions moyennes")
hline!([25], linestyle=:dash, color=:red, label="Conditions difficiles")

# Moyenne mobile pour lisser
ice_ma = rolling(mean, df_economie.ice, 6)
plot!(p_ice, df_economie.date[6:end], ice_ma, linewidth=2, color=:black, 
      linestyle=:solid, label="Moyenne mobile 6 mois")

display(p_ice)
```

**🎯 Défi 11 :** Identifiez les périodes de meilleures et pires conditions économiques.

---

### Étape 12: Analyse de volatilité économique
```julia
# Calcul de la volatilité sur fenêtres glissantes
function volatilite_glissante(x, fenetre=6)
    n = length(x)
    vol = Vector{Float64}(undef, n)
    for i in 1:n
        debut = max(1, i-fenetre+1)
        vol[i] = std(x[debut:i])
    end
    return vol
end

# Volatilité des principales variables
vol_inflation = volatilite_glissante(df_economie.inflation_annuelle)
vol_usd = volatilite_glissante(df_economie.fcfa_usd)
vol_coton = volatilite_glissante(df_economie.prix_coton)

# Graphique de volatilité
p_vol = plot(df_economie.date, [vol_inflation./maximum(vol_inflation) 
                               vol_usd./maximum(vol_usd)
                               vol_coton./maximum(vol_coton)] .* 100,
    title="Volatilité Économique Relative",
    xlabel="Date", ylabel="Volatilité Relative (%)",
    label=["Inflation" "USD/FCFA" "Prix Coton"],
    linewidth=2, size=(800, 500))

# Indice de volatilité composite
vol_composite = (vol_inflation./maximum(vol_inflation) .+ 
                vol_usd./maximum(vol_usd) .+ 
                vol_coton./maximum(vol_coton)) ./ 3 .* 100

plot!(p_vol, df_economie.date, vol_composite, linewidth=3, color=:black,
      label="Volatilité composite")

display(p_vol)
```

**🎯 Défi 12 :** Quelles périodes ont été les plus volatiles économiquement ?

---

### Étape 13: Prévision simple par extrapolation
```julia
# Prévision simple pour les 6 prochains mois
function prevoir_tendance(y, horizion=6)
    n = length(y)
    x = 1:n
    
    # Régression linéaire simple
    slope = calculer_tendance(x, y)
    intercept = mean(y) - slope * mean(x)
    
    # Prévision
    x_futur = (n+1):(n+horizion)
    y_prevu = intercept .+ slope .* x_futur
    
    return y_prevu
end

# Prévisions pour les principales variables
dates_futur = last(df_economie.date) + Month(1):Month(1):last(df_economie.date) + Month(6)

prev_inflation = prevoir_tendance(df_economie.inflation_annuelle)
prev_usd = prevoir_tendance(df_economie.fcfa_usd)
prev_coton = prevoir_tendance(df_economie.prix_coton)

# Graphique avec prévisions
p_prev = plot(df_economie.date, df_economie.inflation_annuelle,
    title="Prévisions Économiques - 6 Mois",
    xlabel="Date", ylabel="Inflation (%)",
    label="Historique", linewidth=2, color=:blue,
    size=(800, 500))

plot!(p_prev, dates_futur, prev_inflation,
      label="Prévision", linewidth=2, color=:red, linestyle=:dash)

# Zone d'incertitude
plot!(p_prev, dates_futur, prev_inflation,
      ribbon=0.5, fillalpha=0.2, color=:red, label="Intervalle confiance")

display(p_prev)

println("🔮 Prévisions pour les 6 prochains mois :")
println("   Inflation moyenne prévue : $(round(mean(prev_inflation), digits=1))%")
println("   USD/FCFA moyen prévu : $(round(mean(prev_usd), digits=0)) FCFA")
println("   Prix coton moyen prévu : $(round(mean(prev_coton), digits=0)) FCFA/tonne")
```

**🎯 Défi 13 :** Créez des prévisions pour les exportations et analysez leur fiabilité.

---

### Étape 14: Rapport économique automatisé
```julia
# Génération d'un rapport économique synthétique
function generer_rapport_economique()
    println("=" * 70)
    println("📊 RAPPORT ÉCONOMIQUE - BURKINA FASO")
    println("   Période : $(minimum(df_economie.date)) à $(maximum(df_economie.date))")
    println("=" * 70)
    
    # Statistiques clés
    println("\n💰 INDICATEURS CLÉS (Dernière observation)")
    derniere_obs = last(df_economie, 1)
    println("   Inflation : $(round(derniere_obs.inflation_annuelle[1], digits=1))%")
    println("   USD/FCFA : $(round(derniere_obs.fcfa_usd[1], digits=0))")
    println("   Prix coton : $(round(derniere_obs.prix_coton[1], digits=0)) FCFA/tonne")
    println("   Balance commerciale : $(round(derniere_obs.balance_commerciale[1], digits=1)) milliards FCFA")
    
    # Tendances
    println("\n📈 TENDANCES SUR LA PÉRIODE")
    croissance_m2 = (last(df_economie.masse_monetaire_m2) - first(df_economie.masse_monetaire_m2)) / 
                    first(df_economie.masse_monetaire_m2) * 100
    println("   Croissance masse monétaire : +$(round(croissance_m2, digits=1))%")
    
    evolution_ice = last(df_economie.ice) - first(df_economie.ice)
    println("   Évolution ICE : $(round(evolution_ice, digits=1)) points")
    
    # Performance matières premières
    println("\n🌾 MATIÈRES PREMIÈRES (Performance totale)")
    perf_coton = (last(df_economie.prix_coton) - first(df_economie.prix_coton)) / 
                 first(df_economie.prix_coton) * 100
    perf_or = (last(df_economie.prix_or_fcfa_once) - first(df_economie.prix_or_fcfa_once)) / 
              first(df_economie.prix_or_fcfa_once) * 100
    
    println("   Coton : $(round(perf_coton, digits=1))%")
    println("   Or : $(round(perf_or, digits=1))%")
    
    # Commerce extérieur
    println("\n🌍 COMMERCE EXTÉRIEUR")
    export_total = sum(df_economie.exportations)
    import_total = sum(df_economie.importations)
    taux_couverture = export_total / import_total * 100
    
    println("   Taux de couverture moyen : $(round(taux_couverture, digits=1))%")
    println("   Solde commercial cumulé : $(round(sum(df_economie.balance_commerciale), digits=1)) milliards FCFA")
    
    println("\n" * "=" * 70)
end

generer_rapport_economique()
```

**🎯 Défi Final :** Enrichissez le rapport en ajoutant une section "Recommandations" basée sur l'analyse des tendances.

---

## 🎯 Exercices Supplémentaires

### Exercice A: Analyse de cycles économiques
```julia
# Identifiez les cycles économiques en analysant les oscillations de l'ICE
```

### Exercice B: Impact des chocs externes
```julia
# Simulez l'impact d'un choc sur les prix des matières premières
```

### Exercice C: Modèle de prévision ARIMA simple
```julia
# Implémentez un modèle ARIMA basique pour les prévisions
```

### Exercice D: Tableau de bord interactif
```julia
# Créez un dashboard avec PlotlyJS permettant de filtrer par période
```

## 🏆 Points Clés Appris
- ✅ Visualisation de séries temporelles économiques
- ✅ Analyse de la volatilité et des tendances
- ✅ Création d'indices composites (ICE)
- ✅ Graphiques multi-axes pour variables hétérogènes
- ✅ Analyse des corrélations entre indicateurs
- ✅ Prévisions simples par extrapolation
- ✅ Tableaux de bord macroéconomiques
- ✅ Rapports automatisés d'analyse économique
- ✅ Décomposition saisonnière des données
- ✅ Visualisation des incertitudes et intervalles de confiance

Ces compétences en visualisation économique nous préparent maintenant à créer des tableaux de bord complets intégrant toutes les dimensions du développement burkinabè !