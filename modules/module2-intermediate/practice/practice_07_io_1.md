# 📊 Pratique 7.1 : Traitement de fichiers de notes d'étudiants

## 🎯 Mission
Créer un système complet pour lire, analyser et traiter des fichiers de notes du Lycée de Koudougou !

## 📋 Ce que vous allez apprendre
- Lire des fichiers CSV avec les notes des étudiants
- Traiter et valider les données importées
- Calculer des statistiques académiques
- Générer des rapports automatiques
- Gérer les erreurs de format de fichier

---

## 🏗️ Étape 1 : Création du fichier de données

Commençons par créer un fichier CSV avec des notes d'étudiants du Lycée de Koudougou :

```julia
using Dates

# Données des étudiants du Lycée de Koudougou
donnees_etudiants = [
    "Nom,Prenom,Classe,Mathematiques,Francais,Histoire_Geo,Sciences_Physiques,SVT,Anglais",
    "Ouédraogo,Aminata,Terminale_S,16.5,14.0,12.5,15.0,17.0,13.5",
    "Sawadogo,Ibrahim,Terminale_S,18.0,15.5,13.0,16.5,15.0,16.0",
    "Compaoré,Fatimata,Terminale_A,12.0,17.5,16.0,11.0,13.5,15.5",
    "Traoré,Boureima,Terminale_S,14.5,13.0,11.5,17.5,16.0,12.0",
    "Kaboré,Mariam,Premiere_A,15.0,16.0,14.5,12.5,14.0,17.0",
    "Sankara,Abdoulaye,Terminale_S,17.5,14.5,15.0,18.0,16.5,14.0",
    "Nikiema,Rasmata,Premiere_A,13.5,18.0,15.5,13.0,15.5,16.5",
    "Zongo,Mamadou,Terminale_A,11.5,16.5,17.0,10.0,12.0,14.5",
    "Ilboudo,Salimata,Premiere_S,16.0,15.0,13.5,16.5,17.5,15.5",
    "Ouattara,Moussa,Terminale_S,19.0,13.5,12.0,17.0,15.5,13.0"
]

# Créer le fichier CSV
open("notes_lycee_koudougou.csv", "w") do fichier
    for ligne in donnees_etudiants
        println(fichier, ligne)
    end
end

println("📁 Fichier 'notes_lycee_koudougou.csv' créé avec succès!")
println("📊 Données de $(length(donnees_etudiants)-1) étudiants enregistrées")
```

### 🎯 Défi 1 : Vérifiez le fichier créé
Affichez le contenu du fichier pour vérifier qu'il est bien formaté :

```julia
println("\n🎯 DÉFI 1 : Vérification du fichier")
println("📄 Contenu du fichier notes_lycee_koudougou.csv:")

if isfile("notes_lycee_koudougou.csv")
    open("notes_lycee_koudougou.csv", "r") do fichier
        numero_ligne = 1
        for ligne in eachline(fichier)
            if numero_ligne == 1
                println("📋 En-têtes: $ligne")
            else
                println("🎓 Ligne $numero_ligne: $ligne")
            end
            numero_ligne += 1
        end
    end
else
    println("❌ Fichier non trouvé!")
end
```

---

## 📚 Étape 2 : Structure pour les données d'étudiants

Créons des structures pour organiser nos données :

```julia
# Structure pour un étudiant avec ses notes
struct EtudiantAvecNotes
    nom::String
    prenom::String
    classe::String
    notes::Dict{String, Float64}
    
    function EtudiantAvecNotes(nom, prenom, classe, notes_dict)
        # Validation des notes (entre 0 et 20)
        for (matiere, note) in notes_dict
            if note < 0 || note > 20
                error("Note invalide pour $matiere: $note (doit être entre 0 et 20)")
            end
        end
        new(nom, prenom, classe, notes_dict)
    end
end

# Fonction pour calculer la moyenne d'un étudiant
function calculer_moyenne(etudiant::EtudiantAvecNotes)
    if isempty(etudiant.notes)
        return 0.0
    end
    
    total = sum(values(etudiant.notes))
    return round(total / length(etudiant.notes), digits=2)
end

# Fonction pour obtenir la mention
function obtenir_mention(moyenne::Float64)
    if moyenne >= 16.0
        return "Très Bien"
    elseif moyenne >= 14.0
        return "Bien"
    elseif moyenne >= 12.0
        return "Assez Bien"
    elseif moyenne >= 10.0
        return "Passable"
    else
        return "Insuffisant"
    end
end

# Fonction d'affichage d'un étudiant
function afficher_etudiant(etudiant::EtudiantAvecNotes)
    moyenne = calculer_moyenne(etudiant)
    mention = obtenir_mention(moyenne)
    
    println("👤 $(etudiant.prenom) $(etudiant.nom) - $(etudiant.classe)")
    println("   📊 Moyenne générale: $moyenne/20 - $mention")
    println("   📝 Détail des notes:")
    
    for (matiere, note) in sort(collect(etudiant.notes))
        println("      • $matiere: $note/20")
    end
end

# Test avec un étudiant exemple
notes_test = Dict(
    "Mathematiques" => 16.5,
    "Francais" => 14.0,
    "Histoire_Geo" => 12.5
)

etudiant_test = EtudiantAvecNotes("Ouédraogo", "Aminata", "Terminale_S", notes_test)
afficher_etudiant(etudiant_test)
```

---

## 📖 Étape 3 : Lecture et parsing du fichier CSV

Créons des fonctions pour lire et parser notre fichier de notes :

```julia
function lire_fichier_notes(nom_fichier::String)
    if !isfile(nom_fichier)
        error("❌ Fichier '$nom_fichier' non trouvé!")
    end
    
    etudiants = EtudiantAvecNotes[]
    matieres = String[]
    
    open(nom_fichier, "r") do fichier
        # Lire la première ligne (en-têtes)
        ligne_entetes = readline(fichier)
        entetes = split(ligne_entetes, ",")
        
        # Les 3 premiers sont Nom, Prenom, Classe
        # Le reste sont les matières
        matieres = String.(entetes[4:end])
        
        println("📋 Matières détectées: $(join(matieres, ", "))")
        
        # Lire les données des étudiants
        numero_ligne = 2
        for ligne in eachline(fichier)
            try
                donnees = split(ligne, ",")
                
                if length(donnees) < 4
                    println("⚠️  Ligne $numero_ligne ignorée (format incorrect)")
                    continue
                end
                
                nom = String(donnees[1])
                prenom = String(donnees[2])
                classe = String(donnees[3])
                
                # Parser les notes
                notes_dict = Dict{String, Float64}()
                for (i, note_str) in enumerate(donnees[4:end])
                    if i <= length(matieres)
                        try
                            note = parse(Float64, note_str)
                            notes_dict[matieres[i]] = note
                        catch
                            println("⚠️  Note invalide pour $(matieres[i]) ligne $numero_ligne: $note_str")
                        end
                    end
                end
                
                # Créer l'étudiant
                etudiant = EtudiantAvecNotes(nom, prenom, classe, notes_dict)
                push!(etudiants, etudiant)
                
                println("✅ Étudiant ajouté: $prenom $nom")
                
            catch e
                println("❌ Erreur ligne $numero_ligne: $e")
            end
            
            numero_ligne += 1
        end
    end
    
    return etudiants, matieres
end

# Test de lecture
println("\n📖 === LECTURE DU FICHIER ===")
etudiants_lycee, matieres_lycee = lire_fichier_notes("notes_lycee_koudougou.csv")

println("\n🎓 Résumé du chargement:")
println("   • Nombre d'étudiants: $(length(etudiants_lycee))")
println("   • Nombre de matières: $(length(matieres_lycee))")
```

### 🎯 Défi 2 : Validation des données
Vérifiez que toutes les données ont été correctement chargées :

```julia
println("\n🎯 DÉFI 2 : Validation des données chargées")

# Afficher tous les étudiants chargés
for (i, etudiant) in enumerate(etudiants_lycee)
    println("\n--- Étudiant $i ---")
    afficher_etudiant(etudiant)
end

# Statistiques de validation
total_notes = sum(length(e.notes) for e in etudiants_lycee)
println("\n📊 Statistiques de validation:")
println("   • Total de notes chargées: $total_notes")
println("   • Moyenne de notes par étudiant: $(round(total_notes/length(etudiants_lycee), digits=1))")

# Vérifier les classes présentes
classes_presentes = unique([e.classe for e in etudiants_lycee])
println("   • Classes présentes: $(join(classes_presentes, ", "))")
```

---

## 📊 Étape 4 : Analyse statistique des données

Créons des fonctions d'analyse approfondie :

```julia
# Fonction pour calculer les statistiques par matière
function statistiques_par_matiere(etudiants::Vector{EtudiantAvecNotes}, matieres::Vector{String})
    println("\n📈 === STATISTIQUES PAR MATIÈRE ===")
    
    for matiere in matieres
        notes_matiere = Float64[]
        
        # Collecter toutes les notes de cette matière
        for etudiant in etudiants
            if haskey(etudiant.notes, matiere)
                push!(notes_matiere, etudiant.notes[matiere])
            end
        end
        
        if !isempty(notes_matiere)
            moyenne = round(sum(notes_matiere) / length(notes_matiere), digits=2)
            note_min = minimum(notes_matiere)
            note_max = maximum(notes_matiere)
            
            # Calcul de l'écart-type
            variance = sum((note - moyenne)^2 for note in notes_matiere) / length(notes_matiere)
            ecart_type = round(sqrt(variance), digits=2)
            
            println("📚 $matiere:")
            println("   • Moyenne: $moyenne/20")
            println("   • Note min: $note_min/20")
            println("   • Note max: $note_max/20") 
            println("   • Écart-type: $ecart_type")
            println("   • Nombre d'étudiants: $(length(notes_matiere))")
        end
    end
end

# Fonction pour analyser les performances par classe
function statistiques_par_classe(etudiants::Vector{EtudiantAvecNotes})
    println("\n🏫 === STATISTIQUES PAR CLASSE ===")
    
    classes = unique([e.classe for e in etudiants])
    
    for classe in classes
        etudiants_classe = filter(e -> e.classe == classe, etudiants)
        moyennes_classe = [calculer_moyenne(e) for e in etudiants_classe]
        
        if !isempty(moyennes_classe)
            moyenne_classe = round(sum(moyennes_classe) / length(moyennes_classe), digits=2)
            meilleure_moyenne = maximum(moyennes_classe)
            plus_faible_moyenne = minimum(moyennes_classe)
            
            # Compter les mentions
            mentions = [obtenir_mention(m) for m in moyennes_classe]
            compte_mentions = Dict()
            for mention in ["Très Bien", "Bien", "Assez Bien", "Passable", "Insuffisant"]
                compte_mentions[mention] = count(m -> m == mention, mentions)
            end
            
            println("🎓 $classe ($(length(etudiants_classe)) étudiants):")
            println("   • Moyenne de classe: $moyenne_classe/20")
            println("   • Meilleure moyenne: $meilleure_moyenne/20")
            println("   • Plus faible moyenne: $plus_faible_moyenne/20")
            println("   • Répartition des mentions:")
            for (mention, count) in compte_mentions
                if count > 0
                    println("     - $mention: $count étudiant(s)")
                end
            end
        end
    end
end

# Fonction pour identifier les étudiants remarquables
function identifier_etudiants_remarquables(etudiants::Vector{EtudiantAvecNotes})
    println("\n⭐ === ÉTUDIANTS REMARQUABLES ===")
    
    # Calculer toutes les moyennes
    moyennes_avec_etudiants = [(calculer_moyenne(e), e) for e in etudiants]
    sort!(moyennes_avec_etudiants, by=x->x[1], rev=true)
    
    # Top 3 étudiants
    println("🥇 TOP 3 ÉTUDIANTS:")
    for (i, (moyenne, etudiant)) in enumerate(moyennes_avec_etudiants[1:min(3, length(moyennes_avec_etudiants))])
        mention = obtenir_mention(moyenne)
        println("   $i. $(etudiant.prenom) $(etudiant.nom) ($(etudiant.classe)) - $moyenne/20 ($mention)")
    end
    
    # Étudiants en difficulté (moyenne < 10)
    etudiants_difficulte = filter(e -> calculer_moyenne(e) < 10, etudiants)
    if !isempty(etudiants_difficulte)
        println("\n⚠️  ÉTUDIANTS EN DIFFICULTÉ (moyenne < 10):")
        for etudiant in etudiants_difficulte
            moyenne = calculer_moyenne(etudiant)
            println("   • $(etudiant.prenom) $(etudiant.nom) ($(etudiant.classe)) - $moyenne/20")
        end
    else
        println("\n✅ Aucun étudiant en difficulté majeure!")
    end
    
    # Étudiants excellents (moyenne ≥ 16)
    etudiants_excellents = filter(e -> calculer_moyenne(e) >= 16, etudiants)
    if !isempty(etudiants_excellents)
        println("\n🌟 ÉTUDIANTS EXCELLENTS (moyenne ≥ 16):")
        for etudiant in etudiants_excellents
            moyenne = calculer_moyenne(etudiant)
            println("   • $(etudiant.prenom) $(etudiant.nom) ($(etudiant.classe)) - $moyenne/20")
        end
    end
end

# Exécution des analyses
statistiques_par_matiere(etudiants_lycee, matieres_lycee)
statistiques_par_classe(etudiants_lycee)
identifier_etudiants_remarquables(etudiants_lycee)
```

### 🎯 Défi 3 : Analyse personnalisée
Trouvez des insights intéressants dans les données :

```julia
println("\n🎯 DÉFI 3 : Analyse personnalisée")

# Trouvez la matière la plus difficile (moyenne la plus faible)
moyennes_matieres = Dict{String, Float64}()

for matiere in matieres_lycee
    notes_matiere = Float64[]
    for etudiant in etudiants_lycee
        if haskey(etudiant.notes, matiere)
            push!(notes_matiere, etudiant.notes[matiere])
        end
    end
    
    if !isempty(notes_matiere)
        moyennes_matieres[matiere] = sum(notes_matiere) / length(notes_matiere)
    end
end

# Matière la plus difficile et la plus facile
matiere_difficile = ""
moyenne_min = 21.0
matiere_facile = ""
moyenne_max = -1.0

for (matiere, moyenne) in moyennes_matieres
    if moyenne < moyenne_min
        moyenne_min = moyenne
        matiere_difficile = matiere
    end
    if moyenne > moyenne_max
        moyenne_max = moyenne
        matiere_facile = matiere
    end
end

println("📉 Matière la plus difficile: $matiere_difficile (moyenne: $(round(moyenne_min, digits=2)))")
println("📈 Matière la plus facile: $matiere_facile (moyenne: $(round(moyenne_max, digits=2)))")

# Étudiants les plus réguliers (écart-type faible entre leurs notes)
println("\n🎯 Étudiants les plus réguliers:")
for etudiant in etudiants_lycee
    if length(etudiant.notes) >= 3  # Au moins 3 notes pour calculer la régularité
        notes_values = collect(values(etudiant.notes))
        moyenne_perso = sum(notes_values) / length(notes_values)
        variance = sum((note - moyenne_perso)^2 for note in notes_values) / length(notes_values)
        ecart_type = sqrt(variance)
        
        if ecart_type < 2.0  # Écart-type faible = régularité
            println("   • $(etudiant.prenom) $(etudiant.nom): écart-type $(round(ecart_type, digits=2))")
        end
    end
end
```

---

## 📄 Étape 5 : Génération de rapports

Créons des fonctions pour générer des rapports automatiques :

```julia
function generer_rapport_complet(etudiants::Vector{EtudiantAvecNotes}, matieres::Vector{String}, nom_fichier::String)
    open(nom_fichier, "w") do fichier
        # En-tête du rapport
        println(fichier, "=" ^ 60)
        println(fichier, "RAPPORT ACADÉMIQUE - LYCÉE DE KOUDOUGOU")
        println(fichier, "Date de génération: $(Dates.format(Dates.now(), "dd/mm/yyyy HH:MM"))")
        println(fichier, "=" ^ 60)
        
        # Statistiques générales
        println(fichier, "\n📊 STATISTIQUES GÉNÉRALES")
        println(fichier, "Nombre total d'étudiants: $(length(etudiants))")
        println(fichier, "Nombre de matières: $(length(matieres))")
        
        # Moyenne générale du lycée
        toutes_moyennes = [calculer_moyenne(e) for e in etudiants]
        moyenne_lycee = sum(toutes_moyennes) / length(toutes_moyennes)
        println(fichier, "Moyenne générale du lycée: $(round(moyenne_lycee, digits=2))/20")
        
        # Répartition par classe
        classes = unique([e.classe for e in etudiants])
        println(fichier, "\n📚 RÉPARTITION PAR CLASSE")
        for classe in classes
            nb_etudiants = count(e -> e.classe == classe, etudiants)
            println(fichier, "• $classe: $nb_etudiants étudiant(s)")
        end
        
        # Top 5 étudiants
        moyennes_triees = sort([(calculer_moyenne(e), e) for e in etudiants], by=x->x[1], rev=true)
        println(fichier, "\n🏆 TOP 5 ÉTUDIANTS")
        for (i, (moyenne, etudiant)) in enumerate(moyennes_triees[1:min(5, length(moyennes_triees))])
            mention = obtenir_mention(moyenne)
            println(fichier, "$i. $(etudiant.prenom) $(etudiant.nom) - $moyenne/20 ($mention)")
        end
        
        # Statistiques par matière (version simplifiée)
        println(fichier, "\n📈 MOYENNES PAR MATIÈRE")
        for matiere in matieres
            notes_matiere = [e.notes[matiere] for e in etudiants if haskey(e.notes, matiere)]
            if !isempty(notes_matiere)
                moyenne_matiere = sum(notes_matiere) / length(notes_matiere)
                println(fichier, "• $matiere: $(round(moyenne_matiere, digits=2))/20")
            end
        end
        
        # Pied de page
        println(fichier, "\n" * "=" ^ 60)
        println(fichier, "Rapport généré automatiquement par le système Julia")
        println(fichier, "Lycée de Koudougou - Burkina Faso")
    end
    
    println("📄 Rapport sauvegardé dans '$nom_fichier'")
end

# Générer le rapport
generer_rapport_complet(etudiants_lycee, matieres_lycee, "rapport_lycee_koudougou.txt")

# Afficher le rapport généré
println("\n📋 === CONTENU DU RAPPORT GÉNÉRÉ ===")
if isfile("rapport_lycee_koudougou.txt")
    contenu_rapport = read("rapport_lycee_koudougou.txt", String)
    println(contenu_rapport)
end
```

### 🎯 Défi 4 : Rapport personnalisé
Créez un rapport spécialisé pour les enseignants :

```julia
println("\n🎯 DÉFI 4 : Rapport pour les enseignants")

function generer_rapport_enseignants(etudiants::Vector{EtudiantAvecNotes}, matieres::Vector{String})
    # Associer chaque matière à un enseignant (simulation)
    enseignants = Dict(
        "Mathematiques" => "M. Compaoré Boukary",
        "Francais" => "Mme Ouédraogo Salimata", 
        "Histoire_Geo" => "M. Sawadogo Ibrahim",
        "Sciences_Physiques" => "Mme Traoré Aminata",
        "SVT" => "M. Kaboré Moussa",
        "Anglais" => "Mme Sankara Fatou"
    )
    
    for matiere in matieres
        if haskey(enseignants, matiere)
            enseignant = enseignants[matiere]
            
            println("\n📋 === RAPPORT POUR $enseignant ($matiere) ===")
            
            # Notes de ses étudiants
            notes_classe = Float64[]
            etudiants_avec_notes = []
            
            for etudiant in etudiants
                if haskey(etudiant.notes, matiere)
                    push!(notes_classe, etudiant.notes[matiere])
                    push!(etudiants_avec_notes, (etudiant, etudiant.notes[matiere]))
                end
            end
            
            if !isempty(notes_classe)
                moyenne_classe = round(sum(notes_classe) / length(notes_classe), digits=2)
                note_max = maximum(notes_classe)
                note_min = minimum(notes_classe)
                
                println("📊 Statistiques de votre classe:")
                println("   • Nombre d'étudiants: $(length(notes_classe))")
                println("   • Moyenne de classe: $moyenne_classe/20")
                println("   • Meilleure note: $note_max/20")
                println("   • Note la plus faible: $note_min/20")
                
                # Étudiants à encourager
                etudiants_excellents = filter(x -> x[2] >= 16, etudiants_avec_notes)
                if !isempty(etudiants_excellents)
                    println("\n🌟 Étudiants excellents à féliciter:")
                    for (etudiant, note) in etudiants_excellents
                        println("   • $(etudiant.prenom) $(etudiant.nom): $note/20")
                    end
                end
                
                # Étudiants en difficulté
                etudiants_difficulte = filter(x -> x[2] < 10, etudiants_avec_notes)
                if !isempty(etudiants_difficulte)
                    println("\n⚠️  Étudiants nécessitant un suivi:")
                    for (etudiant, note) in etudiants_difficulte
                        println("   • $(etudiant.prenom) $(etudiant.nom): $note/20")
                    end
                else
                    println("\n✅ Aucun étudiant en difficulté majeure!")
                end
            end
        end
    end
end

generer_rapport_enseignants(etudiants_lycee, matieres_lycee)
```

---

## 🏅 Récapitulatif des points

Calculons votre score pour cette pratique :

```julia
println("\n🏅 === RÉCAPITULATIF ===")
score_total = 0

# Points pour création et lecture du fichier
if isfile("notes_lycee_koudougou.csv")
    score_total += 20
    println("✅ Fichier CSV créé: +20 points")
end

# Points pour chargement des données
if @isdefined(etudiants_lycee) && length(etudiants_lycee) > 0
    score_total += 25
    println("✅ Données chargées ($(length(etudiants_lycee)) étudiants): +25 points")
end

# Points pour calculs statistiques
if @isdefined(moyennes_matieres) && !isempty(moyennes_matieres)
    score_total += 25
    println("✅ Analyses statistiques réalisées: +25 points")
end

# Points pour génération de rapport
if isfile("rapport_lycee_koudougou.txt")
    score_total += 20
    println("✅ Rapport généré: +20 points")
end

# Points pour rapport enseignants
if @isdefined(enseignants)
    score_total += 15
    println("✅ Rapport enseignants créé: +15 points")
end

# Points pour gestion d'erreurs et validation
score_total += 15
println("✅ Gestion d'erreurs et validation: +15 points")

println("\n🎯 SCORE TOTAL: $(score_total)/120 points")

if score_total >= 100
    println("🥇 Excellent! Vous maîtrisez le traitement de fichiers!")
elseif score_total >= 80
    println("🥈 Très bien! Bon niveau en analyse de données!")
elseif score_total >= 60
    println("🥉 Bien! Continuez à pratiquer!")
else
    println("📚 Révisez les concepts et recommencez!")
end
```

---

## 🎓 Ce que vous avez appris

1. ✅ **Lecture de fichiers CSV** ligne par ligne avec validation
2. ✅ **Structures de données** pour organiser l'information
3. ✅ **Calculs statistiques** (moyennes, écart-types, classements)
4. ✅ **Analyse de données** pour identifier des tendances
5. ✅ **Génération de rapports** automatiques
6. ✅ **Gestion d'erreurs** pour des données incohérentes

## 🚀 Prochaine étape

Dans la pratique suivante, nous sauvegarderons l'état d'un jeu complet avec fichiers JSON !

📊 **Félicitations, vous êtes maintenant un(e) analyste de données scolaires expert(e) !**