struct Etudiant
    nom::String
    age::Int
    niveau::String

    # Constructeur avec validation
    function Etudiant(nom::String, age::Int, niveau::String)
        if age < 16
            error("L'âge minimum est 16 ans")
        end
        if !(niveau in ["Première", "Terminale", "Université"])
            error("Niveau non reconnu")
        end
        new(nom, age, niveau)
    end
end

# Utilisation
#fatima = Etudiant("Fatima Sawadogo", 18, "Terminale")  # ✅ OK
#println(fatima)
#jeune = Etudiant("Ali", 15, "Première")  # ❌ Erreur !
#println(jeune)

mutable struct Guerrier
    nom::String
    vie::Int
    force::Int
    defense::Int
    arme::String
    origine::String
end

# Constructeur pour guerriers traditionnels
function Guerrier(nom::String, origine::String)
    armes_traditionnelles = ["Lance", "Arc", "Épée", "Bouclier"]
    arme = rand(armes_traditionnelles)

    Guerrier(nom, 100, rand(10:20), rand(5:15), arme, origine)
end

# Création de guerriers
yennenga = Guerrier("Princesse Yennenga", "Tenkodogo")
samori = Guerrier("Samori Touré", "Bobo-Dioulasso")

println("⚔️  $(yennenga.nom) de $(yennenga.origine)")
println("💪 Force: $(yennenga.force), Défense: $(yennenga.defense)")
println("🗡️  Arme: $(yennenga.arme)")

# Fonction de combat
function attaquer!(attaquant::Guerrier, defenseur::Guerrier)
    degats = max(1, attaquant.force - defenseur.defense)
    defenseur.vie -= degats

    println("$(attaquant.nom) attaque $(defenseur.nom) avec $(attaquant.arme)!")
    println("💥 Dégâts: $(degats), Vie restante: $(defenseur.vie)")
end

# Combat !
attaquer!(yennenga, samori)

struct Point{T}
    x::T
    y::T
end

struct Person
    name::String
end

function computeDistance(p1::Point{T}, p2::Point{T}) where T<:Int
    return abs((p1.x - p2.x)) + abs((p1.y - p2.y))
end

println(computeDistance(Point(1, 1), Point(1, 1)))
println(computeDistance(Point(-1, -1), Point(1, 1)))
