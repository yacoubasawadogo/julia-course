# Méthode 2 : Ligne par ligne (plus efficace pour gros fichiers)
# Méthode 3 : Ajout à un fichier existant (mode "a")
open("/Users/rskalmogo/teaching/julia-programming/class/julia-course/modules/module2-intermediate/theory/rapport.txt", "a") do fichier
    println(fichier, "")
    println(fichier, "Note ajoutée plus tard...")
end

etudiants = [
    ("Aminata Ouédraogo", 17, "Première A", "Ouagadougou"),
    ("Ibrahim Sawadogo", 16, "Première A", "Koudougou"),
    ("Fatimata Compaoré", 18, "Terminale S", "Bobo-Dioulasso"),
    ("Boureima Traoré", 17, "Terminale S", "Banfora"),
    ("Mariam Kaboré", 16, "Première A", "Ouahigouya")
]

# Écriture CSV
open("/Users/rskalmogo/teaching/julia-programming/class/julia-course/modules/module2-intermediate/theory/etudiants.csv", "w") do fichier
    # En-têtes
    println(fichier, "Nom,Age,Classe,Ville")

    # Données
    for (nom, age, classe, ville) in etudiants
        println(fichier, "$nom,$age,$classe,$ville")
    end
end

println("✅ Fichier CSV créé!")