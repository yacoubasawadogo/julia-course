# Exercice 5 : Bridge Python-Julia
# Module 3 : Apprentissage Automatique avec Julia
# Durée : 45 minutes

# 📚 AVANT DE COMMENCER
# Lisez le résumé d'apprentissage : resume_05_python_bridge.md
# Découvrez comment combiner le meilleur des écosystèmes Python et Julia !

println("📚 Consultez le résumé : modules/module3-ml/resume_05_python_bridge.md")
println("Appuyez sur Entrée quand vous êtes prêt à unir Python et Julia...")
readline()

println("🐍🔗 Bridge Python-Julia : Le Meilleur des Deux Mondes")
println("="^70)

# Installation et configuration des paquets nécessaires
println("🔧 Configuration de l'environnement Python-Julia...")

# Paquets Julia
using PyCall, DataFrames, CSV
using Plots, Statistics, Random
using Conda  # Pour gérer l'environnement Python

# Configuration pour reproductibilité
Random.seed!(42)

println("✅ Environnement Julia configuré")

# Partie 1 : Configuration et Test de PyCall
println("\n🔌 Partie 1 : Configuration PyCall et Test de Base")

# Vérifier la configuration Python
println("Version Python utilisée par PyCall :")
println("Python : $(PyCall.python)")
println("Version : $(PyCall.pyversion)")

# Installer des paquets Python si nécessaire
println("\nInstallation des paquets Python requis...")

# Vérifier et installer pandas si nécessaire
try
    pandas = pyimport("pandas")
    println("✅ Pandas déjà disponible")
catch
    println("📦 Installation de pandas...")
    try
        Conda.add("pandas")
        pandas = pyimport("pandas")
        println("✅ Pandas installé avec succès")
    catch e
        println("⚠️ Impossible d'installer pandas automatiquement : $e")
        println("Veuillez installer pandas manuellement dans votre environnement Python")
    end
end

# Vérifier et installer scikit-learn
try
    sklearn = pyimport("sklearn")
    println("✅ Scikit-learn déjà disponible")
catch
    println("📦 Installation de scikit-learn...")
    try
        Conda.add("scikit-learn")
        sklearn = pyimport("sklearn")
        println("✅ Scikit-learn installé avec succès")
    catch e
        println("⚠️ Installation scikit-learn échouée : $e")
        println("Continuons avec les fonctions de base Python")
    end
end

# Test de base avec Python
println("\n🧪 Tests de fonctionnement de base...")

# Appeler des fonctions Python natives
py"""
def calculer_statistiques_bf(données):
    \"\"\"Calculer des statistiques pour données burkinabè\"\"\"
    import numpy as np
    
    moyenne = np.mean(données)
    médiane = np.median(données)
    écart_type = np.std(données)
    
    return {
        'moyenne': moyenne,
        'médiane': médiane,
        'écart_type': écart_type,
        'n_observations': len(données)
    }

def convertir_fcfa_euro(montant_fcfa, taux=656):
    \"\"\"Convertir FCFA vers Euro\"\"\"
    return montant_fcfa / taux
"""

# Données d'exemple : PIB par habitant en FCFA par région BF
pib_regions_fcfa = [450000, 380000, 850000, 320000, 290000, 
                    410000, 360000, 310000, 520000, 270000,
                    480000, 250000, 420000]

régions_bf = ["Boucle du Mouhoun", "Cascades", "Centre", "Centre-Est", "Centre-Nord",
              "Centre-Ouest", "Centre-Sud", "Est", "Hauts-Bassins", "Nord",
              "Plateau-Central", "Sahel", "Sud-Ouest"]

# Appeler la fonction Python depuis Julia
stats_pib = py"calculer_statistiques_bf"(pib_regions_fcfa)

println("Statistiques PIB par habitant Burkina Faso (FCFA) :")
println("  Moyenne : $(round(Int, stats_pib["moyenne"])) FCFA")
println("  Médiane : $(round(Int, stats_pib["médiane"])) FCFA")
println("  Écart-type : $(round(Int, stats_pib["écart_type"])) FCFA")
println("  Régions : $(stats_pib["n_observations"])")

# Conversion en Euro
pib_euros = [py"convertir_fcfa_euro"(pib) for pib in pib_regions_fcfa]
println("\nPIB moyen en Euro : $(round(mean(pib_euros), digits=0)) €/habitant")

# Partie 2 : Échange de Données entre Julia et Python
println("\n📊 Partie 2 : Échange de DataFrames Julia ↔ Pandas")

# Créer un DataFrame Julia avec des données agricoles BF
données_agri_bf = DataFrame(
    région = répétition_régions_bf = repeat(régions_bf, 3),
    culture = repeat(["Mil", "Sorgho", "Maïs"], inner=13),
    superficie_ha = rand(500:5000, 39),
    rendement_tha = [
        # Mil (plus résistant à la sécheresse)
        0.6 .+ rand(13) * 0.4,  # 0.6-1.0 t/ha
        # Sorgho (bon rendement)
        0.8 .+ rand(13) * 0.4,  # 0.8-1.2 t/ha  
        # Maïs (plus sensible mais productif)
        0.9 .+ rand(13) * 0.6   # 0.9-1.5 t/ha
    ] |> x -> vcat(x...),
    pluie_mm = repeat([300, 600, 900], inner=13) .+ rand(39) * 200,
    prix_fcfa_kg = [
        repeat([200], 13),  # Mil
        repeat([180], 13),  # Sorgho
        repeat([220], 13)   # Maïs
    ] |> x -> vcat(x...) .+ rand(39) * 50
)

# Calculer production totale et revenus
données_agri_bf.production_totale = données_agri_bf.superficie_ha .* données_agri_bf.rendement_tha
données_agri_bf.revenus_fcfa = données_agri_bf.production_totale .* données_agri_bf.prix_fcfa_kg

println("DataFrame Julia créé : $(nrow(données_agri_bf)) observations")
println("Colonnes : $(join(names(données_agri_bf), ", "))")

# Convertir Julia DataFrame vers Pandas si possible
pandas_disponible = false
df_pandas = nothing

try
    pandas = pyimport("pandas")
    pandas_disponible = true
    
    # Conversion Julia → Pandas
    println("\n🐍 Conversion Julia DataFrame → Pandas...")
    
    # Méthode 1 : Via dictionnaire
    dict_données = Dict()
    for col in names(données_agri_bf)
        dict_données[col] = données_agri_bf[!, col]
    end
    
    df_pandas = pandas.DataFrame(dict_données)
    println("✅ Conversion réussie vers Pandas")
    println("Shape Pandas : $(df_pandas.shape)")
    
    # Opérations Pandas depuis Julia
    println("\n🔧 Opérations Pandas depuis Julia...")
    
    # Groupby avec Pandas
    groupby_culture = df_pandas.groupby("culture")
    stats_pandas = groupby_culture.agg(py"""
    {
        'rendement_tha': ['mean', 'std'],
        'revenus_fcfa': ['mean', 'sum']
    }
    """)
    
    println("Statistiques par culture (calculées avec Pandas) :")
    println(stats_pandas)
    
catch e
    println("⚠️ Pandas non disponible, continuons sans conversion : $e")
end

# Partie 3 : Utilisation de Scikit-learn depuis Julia
println("\n🤖 Partie 3 : Scikit-learn depuis Julia")

sklearn_disponible = false

try
    # Importer scikit-learn
    sklearn_ensemble = pyimport("sklearn.ensemble")
    sklearn_model_selection = pyimport("sklearn.model_selection")
    sklearn_metrics = pyimport("sklearn.metrics")
    
    sklearn_disponible = true
    println("✅ Scikit-learn disponible")
    
    # Préparer les données pour ML (prédire le rendement)
    println("\nPréparation des données pour Random Forest (scikit-learn)...")
    
    # Features : superficie, pluie, prix
    X = hcat(données_agri_bf.superficie_ha, données_agri_bf.pluie_mm, données_agri_bf.prix_fcfa_kg)
    y = données_agri_bf.rendement_tha
    
    println("Features : $(size(X, 2)) variables, $(size(X, 1)) observations")
    
    # Train/test split avec scikit-learn
    train_test = sklearn_model_selection.train_test_split(X, y, test_size=0.3, random_state=42)
    X_train, X_test, y_train, y_test = train_test
    
    println("Train : $(size(X_train, 1)) obs, Test : $(size(X_test, 1)) obs")
    
    # Créer et entraîner Random Forest
    println("\n🌲 Random Forest avec scikit-learn...")
    rf_sklearn = sklearn_ensemble.RandomForestRegressor(
        n_estimators=50,
        random_state=42,
        max_depth=5
    )
    
    # Entraînement
    rf_sklearn.fit(X_train, y_train)
    println("✅ Modèle Random Forest entraîné")
    
    # Prédictions
    y_pred_sklearn = rf_sklearn.predict(X_test)
    
    # Métriques avec scikit-learn
    mae_sklearn = sklearn_metrics.mean_absolute_error(y_test, y_pred_sklearn)
    r2_sklearn = sklearn_metrics.r2_score(y_test, y_pred_sklearn)
    
    println("Performance scikit-learn Random Forest :")
    println("  MAE : $(round(mae_sklearn, digits=3)) t/ha")
    println("  R² : $(round(r2_sklearn, digits=3))")
    
    # Feature importance depuis scikit-learn
    feature_names = ["Superficie (ha)", "Pluie (mm)", "Prix (FCFA/kg)"]
    importances = rf_sklearn.feature_importances_
    
    println("\nImportance des variables :")
    for (name, importance) in zip(feature_names, importances)
        println("  $name : $(round(importance * 100, digits=1))%")
    end
    
    # Prédiction pour un scénario BF typique
    # Petit producteur : 2 ha, 600mm pluie, prix moyen
    scénario_bf = reshape([2000, 600, 200], 1, :)  # reshape pour scikit-learn
    prédiction_bf = rf_sklearn.predict(scénario_bf)[1]  # Premier élément
    
    println("\n🌾 Prédiction pour petit producteur burkinabè :")
    println("  Scénario : 2 ha, 600mm pluie, 200 FCFA/kg")
    println("  Rendement prédit : $(round(prédiction_bf, digits=2)) t/ha")
    
    revenus_prévus = 2000 * prédiction_bf * 200  # superficie * rendement * prix
    println("  Revenus prévus : $(round(Int, revenus_prévus)) FCFA")
    println("  Revenus en Euro : $(round(revenus_prévus / 656, digits=0)) €")
    
catch e
    println("⚠️ Scikit-learn non disponible : $e")
    println("Continuons avec les autres fonctionnalités...")
end

# Partie 4 : Visualisation Combinée Julia + Python
println("\n📊 Partie 4 : Visualisation Hybride")

# Graphique Julia avec Plots.jl
println("Création de graphiques avec Plots.jl...")

p1 = scatter(données_agri_bf.pluie_mm, données_agri_bf.rendement_tha,
    group=données_agri_bf.culture,
    title="Rendement vs Précipitations - Burkina Faso",
    xlabel="Précipitations (mm)",
    ylabel="Rendement (t/ha)",
    legend=:topleft,
    size=(700, 400))

display(p1)

# Utiliser matplotlib depuis Julia si disponible
try
    plt = pyimport("matplotlib.pyplot")
    numpy = pyimport("numpy")
    
    println("✅ Matplotlib disponible, création d'un graphique Python...")
    
    # Créer un graphique avec matplotlib depuis Julia
    py"""
    import matplotlib.pyplot as plt
    import numpy as np
    
    def créer_histogramme_revenus(revenus, régions, titre):
        fig, ax = plt.subplots(figsize=(12, 6))
        
        # Histogramme des revenus
        ax.bar(range(len(régions)), revenus, color='green', alpha=0.7)
        ax.set_xlabel('Régions')
        ax.set_ylabel('Revenus Moyens (FCFA)')
        ax.set_title(titre)
        ax.set_xticks(range(len(régions)))
        ax.set_xticklabels(régions, rotation=45, ha='right')
        
        # Ligne de moyenne
        moyenne = np.mean(revenus)
        ax.axhline(y=moyenne, color='red', linestyle='--', 
                   label=f'Moyenne: {moyenne:,.0f} FCFA')
        ax.legend()
        
        plt.tight_layout()
        return fig
    """
    
    # Calculer revenus moyens par région
    revenus_par_région = combine(groupby(données_agri_bf, :région), :revenus_fcfa => mean => :revenus_moyen)
    sort!(revenus_par_région, :revenus_moyen, rev=true)
    
    # Créer le graphique Python depuis Julia
    fig_python = py"créer_histogramme_revenus"(
        revenus_par_région.revenus_moyen,
        revenus_par_région.région,
        "Revenus Agricoles Moyens par Région - Burkina Faso"
    )
    
    # Sauvegarder (optionnel)
    try
        fig_python.savefig("revenus_regions_bf_matplotlib.png", dpi=150, bbox_inches="tight")
        println("📊 Graphique matplotlib sauvegardé : revenus_regions_bf_matplotlib.png")
    catch
        println("⚠️ Sauvegarde graphique matplotlib échouée")
    end
    
catch e
    println("⚠️ Matplotlib non disponible : $e")
end

# Partie 5 : Calculs Numériques Avancés
println("\n🔢 Partie 5 : Calculs Numériques Hybrides")

# Utiliser NumPy pour des calculs puis traiter en Julia
try
    numpy = pyimport("numpy")
    
    println("🧮 Calculs avec NumPy depuis Julia...")
    
    # Simulation Monte Carlo avec NumPy
    py"""
    import numpy as np
    
    def simulation_monte_carlo_récolte(n_simulations=10000):
        '''Simulation des risques de récolte au Burkina Faso'''
        np.random.seed(42)
        
        # Paramètres climatiques (distributions réalistes)
        pluie = np.random.normal(600, 200, n_simulations)  # Moyenne 600mm ±200
        pluie = np.clip(pluie, 200, 1200)  # Limites réalistes
        
        # Température (impact sur rendement)
        température = np.random.normal(30, 5, n_simulations)
        température = np.clip(température, 20, 45)
        
        # Calcul rendement basé sur modèle simple
        # Rendement optimal vers 600-800mm pluie et 25-35°C
        facteur_pluie = np.where(pluie < 600, pluie/600, 
                                np.where(pluie > 800, 0.8 + 0.2*(1200-pluie)/400, 1.0))
        
        facteur_temp = np.where(température < 35, 1.0, 1.0 - (température-35)*0.05)
        facteur_temp = np.clip(facteur_temp, 0.3, 1.0)
        
        # Rendement final (base 1 t/ha)
        rendement = 1.0 * facteur_pluie * facteur_temp * np.random.uniform(0.8, 1.2, n_simulations)
        rendement = np.clip(rendement, 0.1, 2.0)
        
        return {
            'pluie': pluie,
            'température': température, 
            'rendement': rendement
        }
    """
    
    # Exécuter la simulation
    résultats_monte_carlo = py"simulation_monte_carlo_récolte"(5000)
    
    # Traiter les résultats en Julia
    pluie_sim = résultats_monte_carlo["pluie"]
    temp_sim = résultats_monte_carlo["température"]
    rendement_sim = résultats_monte_carlo["rendement"]
    
    println("Simulation Monte Carlo (5000 scénarios) :")
    println("  Rendement moyen : $(round(mean(rendement_sim), digits=2)) t/ha")
    println("  Rendement médian : $(round(median(rendement_sim), digits=2)) t/ha")
    println("  Écart-type : $(round(std(rendement_sim), digits=2)) t/ha")
    
    # Probabilités de seuils critiques
    prob_échec = mean(rendement_sim .< 0.5) * 100  # Moins de 0.5 t/ha
    prob_bon = mean(rendement_sim .> 1.2) * 100    # Plus de 1.2 t/ha
    
    println("  Probabilité d'échec (<0.5 t/ha) : $(round(prob_échec, digits=1))%")
    println("  Probabilité de bonne récolte (>1.2 t/ha) : $(round(prob_bon, digits=1))%")
    
    # Graphique de distribution avec Julia
    p_monte_carlo = histogram(rendement_sim, bins=30,
        title="Distribution des Rendements - Simulation Monte Carlo BF",
        xlabel="Rendement (t/ha)",
        ylabel="Fréquence",
        color=:green,
        alpha=0.7,
        size=(700, 400))
    
    # Ajouter lignes de seuils
    vline!([0.5], color=:red, linewidth=2, linestyle=:dash, label="Seuil d'échec")
    vline!([1.2], color=:blue, linewidth=2, linestyle=:dash, label="Bon rendement")
    
    display(p_monte_carlo)
    
catch e
    println("⚠️ Calculs NumPy non disponibles : $e")
end

# Partie 6 : Intégration Complète et Bonnes Pratiques
println("\n🎯 Partie 6 : Bonnes Pratiques d'Intégration")

println("""
🔗 STRATÉGIES D'INTÉGRATION PYTHON-JULIA OPTIMALES :

✅ QUAND UTILISER PYTHON DEPUIS JULIA :
  • Bibliothèques spécialisées non disponibles en Julia
  • Écosystème mature (ex: scikit-learn pour prototypage rapide)
  • Interface avec systèmes Python existants
  • Visualisations spécialisées (seaborn, plotly)

✅ QUAND RESTER EN JULIA PUR :
  • Performance critique (calculs intensifs)
  • Nouvelle architecture (exploiter multiple dispatch)
  • Écosystème Julia mature (MLJ.jl, Flux.jl)
  • Manipulation de types complexes

🎯 APPROCHE HYBRIDE RECOMMANDÉE :
  1. Prototypage rapide avec Python
  2. Migration vers Julia pour la production
  3. Conservation des outils de visualisation Python
  4. Interface Julia pour utilisateurs finaux
""")

# Démonstration : Comparaison performance Julia vs Python
println("\n⚡ Comparaison Performance Julia vs Python")

# Fonction de calcul intensif en Julia
function calcul_intensif_julia(n::Int)
    total = 0.0
    for i in 1:n
        total += sqrt(i) * sin(i)
    end
    return total
end

# Même fonction en Python
py"""
import math

def calcul_intensif_python(n):
    total = 0.0
    for i in range(1, n+1):
        total += math.sqrt(i) * math.sin(i)
    return total
"""

# Benchmark (sur un calcul plus petit pour éviter les timeouts)
n_test = 100000

println("Test de performance (n = $n_test) :")

# Julia
temps_julia = @elapsed résultat_julia = calcul_intensif_julia(n_test)

# Python
temps_python = @elapsed résultat_python = py"calcul_intensif_python"(n_test)

println("  Julia : $(round(temps_julia * 1000, digits=1)) ms")
println("  Python : $(round(temps_python * 1000, digits=1)) ms")
println("  Speedup Julia : $(round(temps_python / temps_julia, digits=1))x plus rapide")
println("  Différence résultats : $(abs(résultat_julia - résultat_python))")

# Recommandations finales
println("\n💡 RECOMMANDATIONS POUR PROJETS BURKINA FASO :")
println("""
🌾 AGRICULTURE :
  • Prototypage modèles avec scikit-learn
  • Production avec MLJ.jl (performance)  
  • Visualisation Matplotlib + Plots.jl
  
🌡️ CLIMAT :
  • Traitement données avec Pandas (familiarité)
  • Calculs NumPy → Julia pour performance
  • Dashboards avec Julia Genie.jl

📊 FINANCE/ÉCONOMIE :
  • Excel/CSV → Pandas → DataFrames.jl
  • Calculs économiques en Julia (précision)
  • Rapports avec Python (écosystème mature)
""")

# Bilan d'apprentissage
println("\n📈 BILAN D'APPRENTISSAGE")
println("="^70)
println("🐍🔗 MAÎTRISE DE L'INTÉGRATION PYTHON-JULIA !")
println("="^70)
println("✅ Compétences d'intégration développées :")
println("  🔧 Configuration et utilisation de PyCall.jl")
println("  🐍 Exécution de code Python depuis Julia")
println("  📊 Conversion DataFrames Julia ↔ Pandas") 
println("  🤖 Utilisation de scikit-learn depuis Julia")
println("  📈 Visualisation hybride Plots.jl + Matplotlib")
println("  🔢 Calculs NumPy avec post-traitement Julia")
println("  ⚡ Optimisation performance avec choix technologique éclairé")
println("  🇧🇫 Applications pratiques contextualisées Burkina Faso")

println("\n🌟 BADGE DÉBLOQUÉ : 'Architecte Multi-Écosystème BF'")
println("Vous maîtrisez maintenant l'art de combiner le meilleur")
println("des écosystèmes Python et Julia !")

println("\n🎯 COMPÉTENCES PROFESSIONNELLES UNIQUES :")
println("  - Intégration de systèmes ML existants (Python) avec performance Julia")
println("  - Migration progressive Python → Julia pour organisations")
println("  - Développement d'APIs hybrides haute performance")
println("  - Conseil technologique éclairé par l'expérience pratique")

println("\n🚀 PRÊT POUR LES PROJETS FINAUX !")
println("📆 PROCHAINES ÉTAPES : Projets agricole et climatique")
println("   (Combinez tout : MLJ, visualisation, et intégration Python)")
println("   (Conseil : Choisissez la technologie optimale pour chaque tâche !)")