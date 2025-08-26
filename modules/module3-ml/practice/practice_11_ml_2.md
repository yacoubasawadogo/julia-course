# Practice 11.2 : Classification de Messages en Langues Locales du Burkina Faso

## 🎯 Objectif
Développer un système de classification automatique pour identifier la langue et le sentiment de messages texte en langues nationales du Burkina Faso (Mooré, Dioula, Fulfuldé). Ce système sera utile pour analyser les réseaux sociaux, enquêtes d'opinion et communications gouvernementales.

## 📋 Prérequis
```julia
using MLJ
using DataFrames
using Statistics
using Random
using StatsBase
using TextAnalysis

# Modèles de classification
MultinomialClassifier = @load MultinomialNB pkg=MLJNaiveBayesInterface
DecisionTreeClassifier = @load DecisionTreeClassifier pkg=DecisionTree
LogisticClassifier = @load LogisticClassifier pkg=MLJLinearModels

Random.seed!(2024)
```

## 🗣️ Phase 1: Création du Dataset Linguistique

### Étape 1: Construction du corpus multilingue
```julia
# Dataset de messages en langues locales du Burkina Faso
function create_multilingual_dataset(n_messages=1000)
    
    # Vocabulaire de base par langue avec traductions approximatives
    vocabulaire = Dict(
        "Moore" => Dict(
            "salutations" => ["Yaa sooma", "Mba ne o sida", "Kumyaare", "Laafi bala", "Yamba"],
            "famille" => ["maama", "taaba", "biiga", "pugsisi", "paga", "sabtaaba"],
            "nourriture" => ["baam", "zom", "tuum", "noom", "saaga"],
            "emotions_positives" => ["raab seb", "wend raab", "koe raab", "n raab", "wendpuiri"],
            "emotions_negatives" => ["n biiga", "sukuru", "tanbsgo", "ye n biigiame"],
            "agriculture" => ["bugum", "naab tuum", "suka", "naab saaga", "koose"],
            "climat" => ["sugur", "saam", "kiuuri", "yuuni", "kibse"],
            "sante" => ["laafi", "bukone", "tibo", "laafimi", "yiibu"],
            "politique" => ["naaba", "naam", "pugsaandame", "naabdem"],
            "connecteurs" => ["la", "ye", "ka", "fo", "n", "be", "taa"]
        ),
        "Dioula" => Dict(
            "salutations" => ["I ni tile", "I ni sogoma", "Aw ni tile", "A ka kene", "I ni wula"],
            "famille" => ["fa", "ba", "muso", "denmuso", "den", "denke"],
            "nourriture" => ["dumuni", "nkomi", "malo", "taba", "ji"],
            "emotions_positives" => ["a ka nyi", "nisongoya", "a ka fisa", "m'bi fara"],
            "emotions_negatives" => ["jugu", "a tere n na", "tiiriya", "dimi"],
            "agriculture" => ["sene", "sanji", "nakɔ", "jiri", "seni"],
            "climat" => ["san", "kɔrɔn", "dugukuru", "fiɲɲe"],
            "sante" => ["keneya", "banani", "dɔgɔtɔrɔ", "furakɛɲɛ"],
            "politique" => ["mansa", "jamunadɔn", "fasow", "laadi"],
            "connecteurs" => ["ni", "wa", "ka", "fo", "ye", "la", "kɔ"]
        ),
        "Fulfuldé" => Dict(
            "salutations" => ["Jam tan", "Jam walli", "No mbadda", "Ɗum jaraama", "Jam weeti"],
            "famille" => ["baaba", "nene", "sukaaku", "rewɓe", "mayre"],
            "nourriture" => ["nyaamdu", "njabbu", "laam", "kosam", "ndiyam"],
            "emotions_positives" => ["mi jaɓii", "e yaɓata", "renndo", "sukaaɓe"],
            "emotions_negatives" => ["mi ɓernini", "haɓɓude", "ceendu", "ndaar"],
            "agriculture" => ["ɓiɗɗo", "lekki", "naange", "nyaamewal"],
            "climat" => ["seeɗa", "ɗemngal", "yamru", "pelle"],
            "sante" => ["paggude", "jaango", "dokotoor", "yiiteende"],
            "politique" => ["laamɗo", "laamu", "leydi", "hoore"],
            "connecteurs" => ["e", "kaa", "to", "faa", "bee", "nde", "hay"]
        )
    )
    
    # Messages types par catégorie
    patterns_messages = [
        # Salutations et politesse
        ("greeting", ["salutations", "connecteurs", "famille"]),
        # Agriculture et économie  
        ("agriculture", ["agriculture", "climat", "emotions_positives", "connecteurs"]),
        # Santé et bien-être
        ("health", ["sante", "emotions_positives", "famille", "connecteurs"]),
        # Politique et société
        ("politics", ["politique", "connecteurs", "emotions_negatives"]),
        # Vie quotidienne
        ("daily_life", ["nourriture", "famille", "emotions_positives", "connecteurs"])
    ]
    
    # Messages avec sentiment
    sentiments = ["positif", "negatif", "neutre"]
    
    data = []
    
    for i in 1:n_messages
        # Sélection aléatoire de langue et catégorie
        langue = rand(["Moore", "Dioula", "Fulfuldé"])
        categorie, champs = rand(patterns_messages)
        sentiment = rand(sentiments)
        
        # Construction du message
        mots = String[]
        n_mots = rand(3:12)  # Longueur variable du message
        
        for j in 1:n_mots
            champ = rand(champs)
            if haskey(vocabulaire[langue], champ) && !isempty(vocabulaire[langue][champ])
                mot = rand(vocabulaire[langue][champ])
                push!(mots, mot)
            end
        end
        
        # Ajustement selon le sentiment
        if sentiment == "positif" && haskey(vocabulaire[langue], "emotions_positives")
            push!(mots, rand(vocabulaire[langue]["emotions_positives"]))
        elseif sentiment == "negatif" && haskey(vocabulaire[langue], "emotions_negatives")
            push!(mots, rand(vocabulaire[langue]["emotions_negatives"]))
        end
        
        message = join(mots, " ")
        
        # Ajout de variabilité (répétitions, ponctuation)
        if rand() < 0.3
            message = message * " " * rand(mots)  # Répétition d'un mot
        end
        
        if rand() < 0.2
            message = message * "!"
        elseif rand() < 0.1
            message = message * "?"
        end
        
        push!(data, (
            message = message,
            langue = langue,
            categorie = categorie,
            sentiment = sentiment,
            longueur_mots = length(mots),
            longueur_caracteres = length(message)
        ))
    end
    
    return DataFrame(data)
end

# Création du dataset
df_messages = create_multilingual_dataset(1200)

println("📱 Dataset de messages créé :")
println("📊 Total messages : $(nrow(df_messages))")
println("🗣️ Répartition par langue :")
println(countmap(df_messages.langue))
println("📖 Répartition par catégorie :")
println(countmap(df_messages.categorie))
println("💭 Répartition par sentiment :")
println(countmap(df_messages.sentiment))
```

**🎯 Défi 1 :** Explorez la distribution des longueurs de messages et identifiez les patterns par langue.

---

### Étape 2: Enrichissement avec des messages réalistes
```julia
# Ajout de messages plus complexes et réalistes
messages_realistes = [
    # Mooré - Agriculture
    ("Moore", "Naab tuum ra yaa ka suka la tuum woto raab seb", "agriculture", "positif"),
    ("Moore", "Sugur koese la n biiga fo bug tuum ye poor", "agriculture", "negatif"),
    ("Moore", "Wend puiri naab saaga la market price ka raab", "agriculture", "positif"),
    
    # Dioula - Politique  
    ("Dioula", "Mansa ka jamunadɔn caman kɛ wa fasow la", "politics", "neutre"),
    ("Dioula", "Laadi ninnu tɛ ka ɲi wa a ka tiiriya dɔn", "politics", "negatif"),
    ("Dioula", "Dɔgɔtɔrɔ ka nyi jamana keneya hakili la", "politics", "positif"),
    
    # Fulfuldé - Santé
    ("Fulfuldé", "Dokotoor ka wi jaango paggude hoore men", "health", "positif"),
    ("Fulfuldé", "Mi ɓernini ko yiiteende ndaar ka tawi", "health", "negatif"),
    ("Fulfuldé", "Laam be nyaamdu renndo sukaaɓe bee", "health", "positif"),
    
    # Messages mélangés (code-switching)
    ("Moore", "Yaa sooma doctor ba n ti hospital", "health", "neutre"),
    ("Dioula", "I ni tile ka market ka nkomi san", "daily_life", "neutre"),
    ("Fulfuldé", "Jam tan mama ko ɓiɗɗo lekki", "greeting", "positif")
]

# Ajout au dataset principal
for (langue, message, categorie, sentiment) in messages_realistes
    push!(df_messages, (
        message = message,
        langue = langue, 
        categorie = categorie,
        sentiment = sentiment,
        longueur_mots = length(split(message)),
        longueur_caracteres = length(message)
    ))
end

println("📝 Dataset enrichi : $(nrow(df_messages)) messages")
```

**🎯 Défi 2 :** Ajoutez 10 messages réalistes supplémentaires dans chaque langue.

---

### Étape 3: Préparation des features textuelles
```julia
# Fonction pour extraire des features textuelles
function extraire_features_textuelles(messages::Vector{String})
    features = DataFrame()
    
    # Features de base
    features.longueur_mots = [length(split(msg)) for msg in messages]
    features.longueur_caracteres = [length(msg) for msg in messages]
    features.mots_moyens_longueur = [mean(length.(split(msg))) for msg in messages]
    
    # Features de ponctuation
    features.nb_exclamations = [count("!", msg) for msg in messages]
    features.nb_questions = [count("?", msg) for msg in messages]
    features.nb_espaces = [count(" ", msg) for msg in messages]
    
    # Features linguistiques (présence de caractères spéciaux)
    features.a_accents = [any(c in msg for c in "àáâãäåæçèéêëìíîïñòóôõöøùúûüý") for msg in messages]
    features.a_caracteres_speciaux = [any(c in msg for c in "ɓɗŋɲɔɛ") for msg in messages]
    
    # N-grammes de caractères (signatures linguistiques)
    # Bigrams caractéristiques par langue
    bigrams_moore = ["aa", "ii", "uu", "gb", "kg", "ng"]
    bigrams_dioula = ["ni", "ka", "la", "an", "ɔn", "ɛn"]
    bigrams_fulfilde = ["ee", "aa", "ɓɓ", "ɗɗ", "ng", "mb"]
    
    for bigram in bigrams_moore
        features[!, Symbol("bg_moore_" * bigram)] = [count(bigram, lowercase(msg)) for msg in messages]
    end
    
    for bigram in bigrams_dioula  
        features[!, Symbol("bg_dioula_" * bigram)] = [count(bigram, lowercase(msg)) for msg in messages]
    end
    
    for bigram in bigrams_fulfilde
        features[!, Symbol("bg_fulfilde_" * bigram)] = [count(bigram, lowercase(msg)) for msg in messages]
    end
    
    # Mots caractéristiques par langue
    mots_cles = Dict(
        "moore" => ["yaa", "mba", "wend", "naab", "raab", "laafi"],
        "dioula" => ["tile", "sogoma", "kene", "mansa", "jamana"],
        "fulfilde" => ["jam", "jaraama", "laam", "renndo", "sukaa"]
    )
    
    for (langue, mots) in mots_cles
        for mot in mots
            features[!, Symbol("mot_" * langue * "_" * mot)] = [
                count(mot, lowercase(msg)) for msg in messages
            ]
        end
    end
    
    return features
end

# Extraction des features
X_text = extraire_features_textuelles(df_messages.message)

println("🔍 Features textuelles extraites :")
println("📊 Nombre de features : $(ncol(X_text))")
println("📝 Features : $(names(X_text)[1:10])...")  # Première 10 features
```

**🎯 Défi 3 :** Analysez quelles features sont les plus discriminantes entre les langues.

---

## 🎯 Phase 2: Classification de Langues

### Étape 4: Modèle de détection de langue
```julia
# Préparation des données pour classification de langue
y_langue = categorical(df_messages.langue)

# Division train/test
train_indices, test_indices = partition(eachindex(y_langue), 0.75, shuffle=true, rng=42)

X_train_lang = X_text[train_indices, :]
X_test_lang = X_text[test_indices, :]
y_train_lang = y_langue[train_indices]
y_test_lang = y_langue[test_indices]

println("📊 Division des données - Détection de langue :")
println("Train : $(length(train_indices)) messages")
println("Test : $(length(test_indices)) messages")

# Test de plusieurs modèles pour la détection de langue
modeles_langue = [
    ("Naive Bayes", MultinomialClassifier()),
    ("Logistic Regression", LogisticClassifier()),
    ("Decision Tree", DecisionTreeClassifier(max_depth=10))
]

resultats_langue = DataFrame()

for (nom_modele, modele) in modeles_langue
    println("\n🚀 Entraînement $nom_modele pour détection de langue...")
    
    # Entraînement
    machine_lang = machine(modele, X_train_lang, y_train_lang)
    fit!(machine_lang, verbosity=0)
    
    # Prédictions
    y_pred_train = predict_mode(machine_lang, X_train_lang)
    y_pred_test = predict_mode(machine_lang, X_test_lang)
    
    # Métriques
    accuracy_train = mean(y_pred_train .== y_train_lang)
    accuracy_test = mean(y_pred_test .== y_test_lang)
    
    println("Accuracy train : $(round(accuracy_train, digits=3))")
    println("Accuracy test : $(round(accuracy_test, digits=3))")
    
    # Matrice de confusion
    conf_matrix = confusion_matrix(y_pred_test, y_test_lang)
    println("Matrice de confusion :")
    println(conf_matrix)
    
    push!(resultats_langue, (
        modele = nom_modele,
        accuracy_train = accuracy_train,
        accuracy_test = accuracy_test,
        overfitting = accuracy_train - accuracy_test
    ))
end

println("\n📊 Résumé des performances - Détection de langue :")
println(resultats_langue)
```

**🎯 Défi 4 :** Quel modèle performe le mieux ? Y a-t-il de l'overfitting ?

---

### Étape 5: Analyse des erreurs de classification
```julia
# Analyse détaillée avec le meilleur modèle (supposons Logistic Regression)
best_model_lang = LogisticClassifier()
best_machine_lang = machine(best_model_lang, X_train_lang, y_train_lang)
fit!(best_machine_lang, verbosity=0)

y_pred_best = predict_mode(best_machine_lang, X_test_lang)

# Analyse des erreurs
function analyser_erreurs_classification(y_true, y_pred, messages_test, langues_test)
    erreurs = y_true .!= y_pred
    indices_erreurs = findall(erreurs)
    
    println("🔍 Analyse des erreurs de classification :")
    println("Nombre d'erreurs : $(sum(erreurs)) sur $(length(y_true))")
    
    if length(indices_erreurs) > 0
        println("\nExemples d'erreurs :")
        for i in indices_erreurs[1:min(5, length(indices_erreurs))]
            vraie_langue = y_true[i]
            pred_langue = y_pred[i]
            message = messages_test[i]
            
            println("Message : \"$message\"")
            println("Vraie langue : $vraie_langue | Prédite : $pred_langue")
            println("---")
        end
    end
    
    # Matrice de confusion détaillée
    conf_matrix = confusion_matrix(y_pred, y_true)
    return conf_matrix
end

messages_test = df_messages.message[test_indices]
conf_mat = analyser_erreurs_classification(y_test_lang, y_pred_best, messages_test, y_test_lang)
```

**🎯 Défi 5 :** Identifiez les patterns dans les erreurs. Quels types de messages sont mal classifiés ?

---

## 💭 Phase 3: Classification de Sentiment

### Étape 6: Modèle de détection de sentiment
```julia
# Classification de sentiment (positif/négatif/neutre)
y_sentiment = categorical(df_messages.sentiment)

# Division train/test pour sentiment
X_train_sent = X_text[train_indices, :]
X_test_sent = X_text[test_indices, :]
y_train_sent = y_sentiment[train_indices]
y_test_sent = y_sentiment[test_indices]

# Ajout de features spécifiques au sentiment
function extraire_features_sentiment(messages::Vector{String})
    features_sent = DataFrame()
    
    # Mots positifs/négatifs par langue
    mots_positifs = ["raab", "kene", "nisongoya", "renndo", "sukaa", "wend", "jaɓii"]
    mots_negatifs = ["biiga", "sukuru", "jugu", "tiiriya", "ɓernini", "haɓɓude", "ndaar"]
    
    features_sent.nb_mots_positifs = [
        sum(count(mot, lowercase(msg)) for mot in mots_positifs) for msg in messages
    ]
    
    features_sent.nb_mots_negatifs = [
        sum(count(mot, lowercase(msg)) for mot in mots_negatifs) for msg in messages
    ]
    
    features_sent.ratio_positif_negatif = [
        pos == 0 && neg == 0 ? 0.0 : pos / (pos + neg + 1) 
        for (pos, neg) in zip(features_sent.nb_mots_positifs, features_sent.nb_mots_negatifs)
    ]
    
    # Ponctuation émotionnelle
    features_sent.intensite_ponctuation = [
        count("!", msg) + count("?", msg) * 0.5 for msg in messages
    ]
    
    return features_sent
end

# Combinaison des features textuelles et sentiment
X_sent_features = extraire_features_sentiment(df_messages.message)
X_combined_train = hcat(X_train_sent, X_sent_features[train_indices, :])
X_combined_test = hcat(X_test_sent, X_sent_features[test_indices, :])

# Entraînement des modèles pour sentiment
modeles_sentiment = [
    ("Naive Bayes", MultinomialClassifier()),
    ("Logistic Regression", LogisticClassifier()),
    ("Decision Tree", DecisionTreeClassifier(max_depth=8))
]

resultats_sentiment = DataFrame()

for (nom_modele, modele) in modeles_sentiment
    println("\n🎭 Entraînement $nom_modele pour détection de sentiment...")
    
    # Entraînement
    machine_sent = machine(modele, X_combined_train, y_train_sent)
    fit!(machine_sent, verbosity=0)
    
    # Prédictions
    y_pred_sent_test = predict_mode(machine_sent, X_combined_test)
    
    # Métriques
    accuracy_sent = mean(y_pred_sent_test .== y_test_sent)
    
    println("Accuracy sentiment : $(round(accuracy_sent, digits=3))")
    
    # Métriques par classe
    for sentiment in ["positif", "negatif", "neutre"]
        indices_classe = y_test_sent .== sentiment
        if sum(indices_classe) > 0
            accuracy_classe = mean(y_pred_sent_test[indices_classe] .== y_test_sent[indices_classe])
            println("Accuracy $sentiment : $(round(accuracy_classe, digits=3))")
        end
    end
    
    push!(resultats_sentiment, (
        modele = nom_modele,
        accuracy_global = accuracy_sent
    ))
end

println("\n📊 Résumé des performances - Détection de sentiment :")
println(resultats_sentiment)
```

**🎯 Défi 6 :** Le sentiment est-il plus difficile à détecter que la langue ? Pourquoi ?

---

### Étape 7: Classification multi-tâche (langue + sentiment)
```julia
# Modèle qui prédit à la fois langue et sentiment
function classifier_multitache(X_train, y_train_lang, y_train_sent, X_test)
    # Modèle pour langue
    model_lang = LogisticClassifier()
    machine_lang = machine(model_lang, X_train, y_train_lang)
    fit!(machine_lang, verbosity=0)
    
    # Modèle pour sentiment
    model_sent = LogisticClassifier()
    machine_sent = machine(model_sent, X_train, y_train_sent)
    fit!(machine_sent, verbosity=0)
    
    # Prédictions
    pred_lang = predict_mode(machine_lang, X_test)
    pred_sent = predict_mode(machine_sent, X_test)
    
    return pred_lang, pred_sent, machine_lang, machine_sent
end

# Application de la classification multi-tâche
pred_lang_multi, pred_sent_multi, mach_lang, mach_sent = classifier_multitache(
    X_combined_train, y_train_lang, y_train_sent, X_combined_test
)

# Évaluation combinée
accuracy_lang_multi = mean(pred_lang_multi .== y_test_lang)
accuracy_sent_multi = mean(pred_sent_multi .== y_test_sent)

# Accuracy pour prédiction exacte des deux tâches
accuracy_both = mean((pred_lang_multi .== y_test_lang) .& (pred_sent_multi .== y_test_sent))

println("🎯 Performance multi-tâche :")
println("Accuracy langue : $(round(accuracy_lang_multi, digits=3))")
println("Accuracy sentiment : $(round(accuracy_sent_multi, digits=3))")
println("Accuracy les deux : $(round(accuracy_both, digits=3))")
```

**🎯 Défi 7 :** La performance multi-tâche est-elle satisfaisante pour une application réelle ?

---

## 📱 Phase 4: Application Pratique

### Étape 8: Système de modération automatique
```julia
# Fonction de modération de contenu
function moderer_message(message::String, machine_lang, machine_sent, seuil_confiance=0.7)
    # Extraction des features pour le nouveau message
    features_msg = extraire_features_textuelles([message])
    features_sent_msg = extraire_features_sentiment([message])
    features_combined = hcat(features_msg, features_sent_msg)
    
    # Prédictions avec probabilités
    prob_lang = predict(machine_lang, features_combined)
    prob_sent = predict(machine_sent, features_combined)
    
    # Langue prédite
    pred_lang = predict_mode(machine_lang, features_combined)[1]
    conf_lang = maximum([prob.prob_given_ref[2] for prob in prob_lang])
    
    # Sentiment prédit
    pred_sent = predict_mode(machine_sent, features_combined)[1]
    conf_sent = maximum([prob.prob_given_ref[2] for prob in prob_sent])
    
    # Décision de modération
    moderation_flags = []
    
    if conf_lang < seuil_confiance
        push!(moderation_flags, "langue_incertaine")
    end
    
    if conf_sent < seuil_confiance
        push!(moderation_flags, "sentiment_incertain")
    end
    
    if pred_sent == "negatif" && conf_sent > 0.8
        push!(moderation_flags, "contenu_potentiellement_negatif")
    end
    
    return Dict(
        "message" => message,
        "langue_predite" => pred_lang,
        "confiance_langue" => round(conf_lang, digits=3),
        "sentiment_predit" => pred_sent,
        "confiance_sentiment" => round(conf_sent, digits=3),
        "flags_moderation" => moderation_flags,
        "necessite_revision_humaine" => length(moderation_flags) > 0
    )
end

# Test du système de modération
messages_test_moderation = [
    "Yaa sooma naab tuum ka raab seb",  # Mooré positif
    "Mansa ka jamunadɔn jugu don wa",   # Dioula négatif
    "Jam tan dokotoor paggude men",     # Fulfuldé neutre
    "Hello comment allez-vous today"    # Message mixte (test)
]

println("🛡️ Test du système de modération :")
for msg in messages_test_moderation
    resultat = moderer_message(msg, mach_lang, mach_sent)
    println("\nMessage : \"$(resultat["message"])\"")
    println("Langue : $(resultat["langue_predite"]) (conf: $(resultat["confiance_langue"]))")
    println("Sentiment : $(resultat["sentiment_predit"]) (conf: $(resultat["confiance_sentiment"]))")
    println("Flags : $(resultat["flags_moderation"])")
    println("Révision humaine : $(resultat["necessite_revision_humaine"])")
end
```

**🎯 Défi 8 :** Testez le système avec vos propres messages dans les langues locales.

---

### Étape 9: Analyse de tendances linguistiques
```julia
# Fonction d'analyse de tendances pour un corpus de messages
function analyser_tendances_corpus(messages::Vector{String}, machine_lang, machine_sent)
    
    # Classification de tous les messages
    features_corpus = extraire_features_textuelles(messages)
    features_sent_corpus = extraire_features_sentiment(messages)
    features_combined_corpus = hcat(features_corpus, features_sent_corpus)
    
    pred_langues = predict_mode(machine_lang, features_combined_corpus)
    pred_sentiments = predict_mode(machine_sent, features_combined_corpus)
    
    # Statistiques générales
    stats_langues = countmap(pred_langues)
    stats_sentiments = countmap(pred_sentiments)
    
    println("📊 Analyse du corpus ($(length(messages)) messages) :")
    println("\n🗣️ Répartition des langues :")
    for (langue, count) in sort(collect(stats_langues), by=x->x[2], rev=true)
        pourcentage = round(count / length(messages) * 100, digits=1)
        println("  $langue : $count messages ($(pourcentage)%)")
    end
    
    println("\n💭 Répartition des sentiments :")
    for (sentiment, count) in sort(collect(stats_sentiments), by=x->x[2], rev=true)
        pourcentage = round(count / length(messages) * 100, digits=1)
        println("  $sentiment : $count messages ($(pourcentage)%)")
    end
    
    # Analyse croisée langue-sentiment
    println("\n🔄 Croisement langue-sentiment :")
    for langue in unique(pred_langues)
        indices_langue = pred_langues .== langue
        if sum(indices_langue) > 0
            sentiments_langue = pred_sentiments[indices_langue]
            stats_sent_langue = countmap(sentiments_langue)
            
            println("  $langue :")
            for (sentiment, count) in stats_sent_langue
                pourcentage = round(count / sum(indices_langue) * 100, digits=1)
                println("    $sentiment : $(pourcentage)%")
            end
        end
    end
    
    return Dict(
        "langues" => stats_langues,
        "sentiments" => stats_sentiments,
        "predictions_langue" => pred_langues,
        "predictions_sentiment" => pred_sentiments
    )
end

# Test sur notre corpus
resultats_tendances = analyser_tendances_corpus(df_messages.message, mach_lang, mach_sent)
```

**🎯 Défi 9 :** Quelle langue semble avoir le sentiment le plus positif dans votre corpus ?

---

### Étape 10: Détection de messages urgents/prioritaires
```julia
# Système de priorisation de messages
function detecter_urgence_message(message::String, machine_lang, machine_sent)
    
    # Mots-clés d'urgence par domaine
    mots_urgence = Dict(
        "sante" => ["dokotoor", "dɔgɔtɔrɔ", "tibo", "banani", "jaango", "bukone"],
        "securite" => ["police", "gendarme", "jɔrɔ", "haɓɓude", "danger"],
        "catastrophe" => ["feu", "ta", "flood", "banga", "accident"],
        "agriculture" => ["koose", "famine", "tanbsgo", "suka poor", "naab tuum"]
    )
    
    # Score d'urgence de base
    score_urgence = 0.0
    domaines_detectes = []
    
    message_lower = lowercase(message)
    
    # Détection par mots-clés
    for (domaine, mots) in mots_urgence
        for mot in mots
            if occursin(mot, message_lower)
                score_urgence += 1.0
                push!(domaines_detectes, domaine)
                break  # Un domaine par catégorie maximum
            end
        end
    end
    
    # Ajustement selon le sentiment
    features_msg = extraire_features_textuelles([message])
    features_sent_msg = extraire_features_sentiment([message])
    features_combined = hcat(features_msg, features_sent_msg)
    
    pred_sent = predict_mode(machine_sent, features_combined)[1]
    
    if pred_sent == "negatif"
        score_urgence += 0.5
    end
    
    # Ajustement selon la ponctuation
    if count("!", message) > 1
        score_urgence += 0.3
    end
    
    # Classification de priorité
    priorite = score_urgence >= 2.0 ? "HAUTE" :
              score_urgence >= 1.0 ? "MOYENNE" : "BASSE"
    
    return Dict(
        "message" => message,
        "score_urgence" => score_urgence,
        "priorite" => priorite,
        "domaines_detectes" => unique(domaines_detectes),
        "sentiment" => pred_sent,
        "necessite_attention_immediate" => score_urgence >= 2.0
    )
end

# Test du système de détection d'urgence
messages_urgence_test = [
    "Dokotoor ka wi mi jaɓii paggude hoore",      # Santé, positif
    "N biiga tibo ka poor sukuru naab tuum",      # Agriculture + santé, négatif  
    "Yaa sooma laafi bala wend puiri",            # Salutation normale
    "Dɔgɔtɔrɔ! Banani jugu don wa fasa!",         # Santé urgente !
    "Ta dɔn wa! Haɓɓude bee sukaaɓe!"             # Catastrophe !
]

println("🚨 Test de détection d'urgence :")
for msg in messages_urgence_test
    urgence = detecter_urgence_message(msg, mach_lang, mach_sent)
    println("\nMessage : \"$(urgence["message"])\"")
    println("Priorité : $(urgence["priorite"]) (score: $(urgence["score_urgence"]))")
    println("Domaines : $(urgence["domaines_detectes"])")
    println("Sentiment : $(urgence["sentiment"])")
    println("Attention immédiate : $(urgence["necessite_attention_immediate"])")
end
```

**🎯 Défi 10 :** Enrichissez le dictionnaire de mots d'urgence avec des termes spécifiques au contexte burkinabè.

---

### Étape 11: Interface de traitement en lot
```julia
# Fonction de traitement en lot pour analyse de réseaux sociaux
function traiter_corpus_reseaux_sociaux(messages::Vector{String}, machine_lang, machine_sent)
    
    println("🔄 Traitement en cours de $(length(messages)) messages...")
    
    # Traitement de tous les messages
    features_lot = extraire_features_textuelles(messages)
    features_sent_lot = extraire_features_sentiment(messages)
    features_combined_lot = hcat(features_lot, features_sent_lot)
    
    # Prédictions en lot
    pred_langues_lot = predict_mode(machine_lang, features_combined_lot)
    pred_sentiments_lot = predict_mode(machine_sent, features_combined_lot)
    prob_langues_lot = predict(machine_lang, features_combined_lot)
    prob_sentiments_lot = predict(machine_sent, features_combined_lot)
    
    # Création du rapport détaillé
    rapport = DataFrame(
        message = messages,
        langue_predite = pred_langues_lot,
        sentiment_predit = pred_sentiments_lot,
        confiance_langue = [maximum([p.prob_given_ref[2] for p in prob]) for prob in prob_langues_lot],
        confiance_sentiment = [maximum([p.prob_given_ref[2] for p in prob]) for prob in prob_sentiments_lot],
        longueur_mots = [length(split(msg)) for msg in messages],
        contient_urgence = [detecter_urgence_message(msg, machine_lang, machine_sent)["priorite"] != "BASSE" for msg in messages]
    )
    
    # Statistiques globales
    println("\n📊 Résultats du traitement :")
    println("Messages analysés : $(nrow(rapport))")
    println("Langues détectées : $(length(unique(rapport.langue_predite)))")
    println("Messages urgents/prioritaires : $(sum(rapport.contient_urgence))")
    
    # Top langues
    top_langues = sort(collect(countmap(rapport.langue_predite)), by=x->x[2], rev=true)
    println("\nTop 3 langues :")
    for (i, (langue, count)) in enumerate(top_langues[1:min(3, length(top_langues))])
        pourcentage = round(count / nrow(rapport) * 100, digits=1)
        println("$i. $langue : $count messages ($(pourcentage)%)")
    end
    
    # Distribution sentiment
    sentiment_dist = countmap(rapport.sentiment_predit)
    println("\nDistribution des sentiments :")
    for (sentiment, count) in sentiment_dist
        pourcentage = round(count / nrow(rapport) * 100, digits=1)
        println("$sentiment : $(pourcentage)%")
    end
    
    # Messages à faible confiance (nécessitent révision)
    low_confidence = sum((rapport.confiance_langue .< 0.7) .| (rapport.confiance_sentiment .< 0.7))
    println("\nMessages nécessitant révision humaine : $low_confidence ($(round(low_confidence/nrow(rapport)*100, digits=1))%)")
    
    return rapport
end

# Test avec un échantillon de messages
echantillon_messages = df_messages.message[1:50]  # Premier 50 messages
rapport_analyse = traiter_corpus_reseaux_sociaux(echantillon_messages, mach_lang, mach_sent)

# Sauvegarde du rapport (simulation)
println("\n💾 Rapport sauvegardé : rapport_analyse_$(Dates.today()).csv")
```

**🎯 Défi 11 :** Analysez les messages à faible confiance. Quels patterns observez-vous ?

---

### Étape 12: Évaluation de l'impact sociétal
```julia
# Analyse de l'impact potentiel du système
function evaluer_impact_societal()
    println("🌍 ÉVALUATION DE L'IMPACT SOCIÉTAL")
    println("=" * 50)
    
    # Métriques de performance du système
    accuracy_lang_finale = accuracy_lang_multi
    accuracy_sent_finale = accuracy_sent_multi
    
    println("📊 PERFORMANCE TECHNIQUE :")
    println("Précision détection langue : $(round(accuracy_lang_finale * 100, digits=1))%")
    println("Précision détection sentiment : $(round(accuracy_sent_finale * 100, digits=1))%")
    
    # Estimation de l'utilité
    println("\n🎯 APPLICATIONS POTENTIELLES :")
    applications = [
        "Modération automatique des réseaux sociaux",
        "Analyse de l'opinion publique multilingue", 
        "Système d'alerte précoce pour services d'urgence",
        "Support client multilingue automatisé",
        "Recherche en linguistique des langues nationales",
        "Préservation et documentation des langues locales"
    ]
    
    for (i, app) in enumerate(applications)
        println("$i. $app")
    end
    
    # Considérations éthiques
    println("\n⚠️ CONSIDÉRATIONS ÉTHIQUES :")
    considerations = [
        "Biais potentiel envers certaines variantes dialectales",
        "Risque de sur-modération de contenus légitimes",
        "Protection de la vie privée des utilisateurs",
        "Nécessité de révision humaine pour décisions importantes",
        "Impact sur l'emploi des modérateurs humains",
        "Représentativité équitable des différentes communautés"
    ]
    
    for (i, consideration) in enumerate(considerations)
        println("$i. $consideration")
    end
    
    # Recommandations d'amélioration
    println("\n🚀 RECOMMANDATIONS D'AMÉLIORATION :")
    recommandations = [
        "Collecter plus de données authentiques par locuteurs natifs",
        "Inclure plus de variantes dialectales et régionales",
        "Développer des mécanismes de feedback utilisateur",
        "Intégrer la détection de discours de haine spécifique au contexte",
        "Créer des interfaces en langues locales",
        "Établir des partenariats avec les communautés linguistiques"
    ]
    
    for (i, rec) in enumerate(recommandations)
        println("$i. $rec")
    end
    
    # Estimation économique
    println("\n💰 IMPACT ÉCONOMIQUE ESTIMÉ :")
    println("Réduction coûts modération : 40-60%")
    println("Amélioration temps de réponse : 80-90%")
    println("Accessibilité services numériques : +300%")
    
    println("\n" * "=" * 50)
end

# Exécution de l'évaluation
evaluer_impact_societal()
```

**🎯 Défi Final :** Proposez 3 améliorations concrètes pour rendre ce système plus adapté au contexte burkinabè.

---

## 🎯 Exercices Supplémentaires

### Exercice A: Détection de code-switching
```julia
# Développez un modèle pour détecter quand les utilisateurs mélangent les langues
```

### Exercice B: Classification fine par dialecte
```julia
# Affinez le modèle pour distinguer les variantes régionales (Mooré du Centre vs Nord)
```

### Exercice C: Détection d'émotion avancée
```julia
# Étendez la classification au-delà de positif/négatif (joie, colère, peur, tristesse)
```

### Exercice D: Modèle de génération de texte
```julia
# Créez un générateur simple de messages dans les langues locales
```

## 🏆 Points Clés Appris
- ✅ Création de corpus multilingues pour langues locales
- ✅ Extraction de features textuelles discriminantes
- ✅ Classification multi-classe pour détection de langue
- ✅ Analyse de sentiment en contexte multilingue
- ✅ Systèmes de modération automatique de contenu
- ✅ Détection d'urgence et priorisation de messages
- ✅ Traitement en lot pour analyse de réseaux sociaux
- ✅ Évaluation de l'impact sociétal des systèmes ML
- ✅ Considérations éthiques en NLP multilingue
- ✅ Applications pratiques pour le développement local

Ce système de classification multilingue ouvre de nombreuses possibilités pour améliorer la communication numérique au Burkina Faso et préserver les langues nationales dans l'ère digitale !