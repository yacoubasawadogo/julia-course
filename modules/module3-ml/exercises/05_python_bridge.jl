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

# TODO 1 : Configuration environnement Python-Julia (10 minutes)
# Configurez PyCall et testez la connectivité avec Python

# TODO : Importez les paquets Julia nécessaires
using PyCall  # Complétez avec les autres paquets

# TODO : Importez DataFrames, Statistics, Random


println("✅ Paquets Julia importés")

# TODO : Vérifiez la configuration Python
println("Configuration Python-Julia :")
println("Python : $(PyCall.python)")
# TODO : Affichez la version Python avec PyCall.pyversion

# TODO 2 : Premier test - Fonctions Python simples (10 minutes)
println("\n🧪 Test 1 : Appel de fonctions Python depuis Julia")

# TODO : Définissez une fonction Python avec py""" ... """
# Créez une fonction qui calcule des statistiques pour données burkinabè

py"""
def calculer_statistiques_bf(données):
    # TODO : Importez numpy dans la fonction Python
    
    # TODO : Calculez moyenne, médiane, écart-type
    moyenne = # TODO
    médiane = # TODO
    écart_type = # TODO
    
    return {
        'moyenne': moyenne,
        'médiane': médiane,
        'écart_type': écart_type,
        'n_observations': len(données)
    }

def convertir_fcfa_euro(montant_fcfa, taux=656):
    # TODO : Implémentez la conversion FCFA → Euro
    return # TODO
"""

# TODO : Testez vos fonctions Python
# Données d'exemple : PIB par habitant FCFA des régions BF
pib_regions_fcfa = [450000, 380000, 850000, 320000, 290000,
    410000, 360000, 310000, 520000, 270000,
    480000, 250000, 420000]

# TODO : Appelez la fonction Python depuis Julia
stats_pib = # TODO : py"calculer_statistiques_bf"(pib_regions_fcfa)
    println("Statistiques PIB Burkina Faso :")
# TODO : Affichez les résultats (moyenne, médiane, etc.)

# TODO : Convertissez quelques valeurs en Euro
pib_ouaga_euro = # TODO : py"convertir_fcfa_euro"(850000)
    println("PIB Ouagadougou en Euro : $(round(pib_ouaga_euro, digits=0)) €")

println("✅ Test 1 réussi ! Python et Julia communiquent !")

# TODO 3 : Échange de données - DataFrames ↔ Pandas (15 minutes)  
println("\n📊 Test 2 : Échange DataFrames Julia ↔ Pandas")

# TODO : Créez un DataFrame Julia avec données agricoles BF
données_agri_bf = DataFrame(
    région=[
    # TODO : Listez quelques régions du BF
    ],
    culture=[
    # TODO : Cultures correspondantes
    ],
    superficie_ha=[
    # TODO : Superficies réalistes (500-5000 ha)
    ],
    rendement_tha=[
    # TODO : Rendements réalistes (0.5-2.0 t/ha)
    ],
    prix_fcfa_kg=[
    # TODO : Prix réalistes (150-400 FCFA/kg)
    ]
)

# TODO : Calculez production totale et revenus
données_agri_bf.production_totale = # TODO : superficie × rendement
    données_agri_bf.revenus_fcfa = # TODO : production × prix
        println("DataFrame Julia créé : $(nrow(données_agri_bf)) observations")

# TODO 4 : Utilisation de Pandas depuis Julia (Défi)
println("\n🐍 Défi : Utilisation de Pandas depuis Julia")

# Tentative d'import pandas (peut échouer selon installation)
try
    pandas = pyimport("pandas")
    println("✅ Pandas disponible !")

    # TODO : Convertissez DataFrame Julia → Pandas
    # Astuce : Créez un dictionnaire puis pandas.DataFrame
    dict_données = Dict()
    for col in names(données_agri_bf)
        # TODO : Remplissez le dictionnaire
        dict_données[col] = "#TODO"
    end

    df_pandas = # TODO : pandas.DataFrame(dict_données)
        println("Conversion Julia → Pandas réussie !")
    println("Shape Pandas : $(df_pandas.shape)")

    # TODO : Opération Pandas - groupby par région
    stats_pandas = ""
    # TODO : df_pandas.groupby("région").agg({"rendement_tha": "mean", "revenus_fcfa": "sum"})

    println("Statistiques par région (Pandas) :")
    println(stats_pandas)
catch e
    println("⚠️ Pandas non disponible : $e")
    println("Continuons avec les fonctionnalités de base...")
end

# TODO 5 : Scikit-learn depuis Julia (Défi Expert)
println("\n🤖 Défi Expert : Scikit-learn depuis Julia")

try
    # TODO : Importez scikit-learn
    sklearn_ensemble = # TODO : pyimport("sklearn.ensemble")
        sklearn_metrics = # TODO : pyimport("sklearn.metrics")
            println("✅ Scikit-learn disponible !")

    # TODO : Préparez données pour ML
    # Features : superficie, prix
    X = # TODO : Matrice [superficie, prix] 
        y = # TODO : Vecteur rendements

        # TODO : Créez et entraînez Random Forest avec scikit-learn
            rf_sklearn = # TODO : sklearn_ensemble.RandomForestRegressor(n_estimators=10, random_state=42)

            # TODO : Entraînement
            # TODO : rf_sklearn.fit(X, y)

            # TODO : Prédictions
                y_pred = # TODO : rf_sklearn.predict(X)

                # TODO : Métriques
                    mae_sklearn = # TODO : sklearn_metrics.mean_absolute_error(y, y_pred)
                        println("Random Forest scikit-learn :")
    println("  MAE : $(round(mae_sklearn, digits=3)) t/ha")

    # TODO : Prédiction pour nouveau scénario
    nouveau_scénario = # TODO : [2000, 200] (2000 ha, 200 FCFA/kg)
        prediction_nouvelle = # TODO : rf_sklearn.predict([nouveau_scénario])
            println("Prédiction nouveau scénario : $(round(prediction_nouvelle[1], digits=2)) t/ha")

catch e
    println("⚠️ Scikit-learn non disponible : $e")
    println("C'est normal, continuons l'apprentissage...")
end

# TODO 6 : Comparaison performance Julia vs Python (10 minutes)
println("\n⚡ Test 3 : Comparaison Performance Julia vs Python")

# TODO : Fonction de calcul intensif en Julia
function calcul_intensif_julia(n::Int)
    total = 0.0
    for i in 1:n
        # TODO : Opération mathématique complexe
        total += "# TODO : sqrt(i) * sin(i) ou équivalent"
    end
    return total
end

# TODO : Même fonction en Python
py"""
import math

def calcul_intensif_python(n):
    total = 0.0
    # TODO : Implémentez la même boucle en Python
    for i in range(1, n+1):
        # TODO : Même opération qu'en Julia
        total += # TODO
    return total
"""

# TODO : Benchmark des deux versions
n_test = 50000  # Ajustez selon performance de votre machine

println("Test de performance (n = $n_test) :")

# TODO : Mesurez temps Julia avec @elapsed
temps_julia = # TODO : @elapsed résultat_julia = calcul_intensif_julia(n_test)

# TODO : Mesurez temps Python
    temps_python = # TODO : @elapsed résultat_python = py"calcul_intensif_python"(n_test)
        println("  Julia : $(round(temps_julia * 1000, digits=1)) ms")
println("  Python : $(round(temps_python * 1000, digits=1)) ms")

# TODO : Calculez le speedup
speedup = # TODO : temps_python / temps_julia
    println("  Speedup Julia : $(round(speedup, digits=1))x plus rapide")

# Vérification résultats identiques
println("  Différence résultats : $(abs(résultat_julia - résultat_python))")

# TODO 7 : Recommandations et bonnes pratiques (5 minutes)
println("\n💡 Recommandations Python-Julia")

println("""
🔗 STRATÉGIES D'INTÉGRATION OPTIMALES :

✅ UTILISEZ PYTHON QUAND :
  • Bibliothèques spécialisées non disponibles en Julia
  • Équipe déjà experte en Python
  • Prototypage rapide d'idées
  • Interface avec systèmes Python existants

✅ UTILISEZ JULIA QUAND :
  • Performance critique requise  
  • Calculs scientifiques avancés
  • Nouvelle architecture (exploiter multiple dispatch)
  • Manipulation de types complexes

🎯 APPROCHE HYBRIDE RECOMMANDÉE :
  1. Prototypage avec Python (familiarité)
  2. Production avec Julia (performance)  
  3. Visualisation : garder outils Python si nécessaire
  4. Interface Julia pour utilisateurs finaux
""")

println("\n💡 APPLICATIONS BURKINA FASO :")
println("""
🌾 AGRICULTURE :
  • Prototypage modèles avec scikit-learn
  • Production avec MLJ.jl (vitesse)
  • Visualisation Matplotlib + Plots.jl

🌡️ CLIMAT :
  • Traitement données avec Pandas (familiarité équipes)
  • Calculs Julia pour performance
  • Dashboards avec Julia Genie.jl

📊 ÉCONOMIE :
  • Excel/CSV → Pandas → DataFrames.jl
  • Calculs économiques en Julia (précision)
  • Rapports avec Python (écosystème mature)
""")

# TODO 8 : Créez votre propre fonction hybride ! (Bonus)
println("\n🚀 Défi Final : Votre Fonction Hybride !")

# TODO : Créez une fonction qui utilise Python pour preprocessing
# et Julia pour le calcul final

# Exemple d'idée :
# - Python : nettoie et formate les données
# - Julia : calcul statistique ou ML rapide
# - Retour résultat formaté

# TODO : Implémentez votre idée créative !

# Bilan d'apprentissage
println("\n📈 BILAN D'APPRENTISSAGE")
println("="^70)
println("🐍🔗 FÉLICITATIONS ! MAÎTRISE DE L'INTÉGRATION PYTHON-JULIA !")
println("="^70)
println("✅ Compétences d'architecte multi-écosystème :")
println("  🔧 Configuration et utilisation de PyCall.jl")
println("  🐍 Exécution de code Python depuis Julia")
println("  📊 Échange de données entre écosystèmes")
println("  🤖 Utilisation de scikit-learn depuis Julia")
println("  ⚡ Optimisation performance avec choix technologique")
println("  🇧🇫 Applications pratiques contexte burkinabè")

println("\n🌟 BADGE DÉBLOQUÉ : 'Architecte Multi-Écosystème BF'")
println("Vous maîtrisez l'art de combiner le meilleur des")
println("écosystèmes Python et Julia !")

println("\n🎯 COMPÉTENCES UNIQUES ACQUISES :")
println("  - Intégration systèmes ML existants (Python) avec performance Julia")
println("  - Migration progressive Python → Julia pour organisations")
println("  - Développement APIs hybrides haute performance")
println("  - Conseil technologique éclairé par expérience pratique")

println("\n🚀 PRÊT POUR LES PROJETS FINAUX !")
println("📆 PROCHAINES ÉTAPES : Projets agricole et climatique")
println("   (Combinez tout : MLJ, visualisation, et intégration Python)")
println("   (Conseil : Choisissez la technologie optimale pour chaque tâche !)")

# NOTES POUR L'INSTRUCTEUR :
# Cet exercice couvre :
# 1. Configuration PyCall.jl
# 2. Appel de fonctions Python depuis Julia
# 3. Échange de données DataFrames ↔ Pandas
# 4. Utilisation scikit-learn depuis Julia
# 5. Comparaison performance Julia vs Python
# 6. Bonnes pratiques d'intégration
# 7. Applications contextualisées BF

# Points d'attention :
# - PyCall peut nécessiter configuration selon installation
# - Pandas/scikit-learn peuvent ne pas être disponibles
# - Gestion gracieuse des échecs d'import
# - Focus sur concepts même si packages manquants