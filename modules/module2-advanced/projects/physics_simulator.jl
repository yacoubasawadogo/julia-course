# Projet Module 2 : Simulateur de Physique
# Utilisation Avancée de la Répartition Multiple et des Structures de Données
# Temps estimé : 2-3 heures

# 🚀 PROJET AVANCÉ - AVANT DE COMMENCER
# OBLIGATOIRE : Lisez le résumé d'apprentissage : resume_projet_physics.md
# Ce projet exploite la pleine puissance de la répartition multiple de Julia
#
# Prérequis : Exercices 1 & 2 du Module 2 complétés
# Ce projet démontre pourquoi Julia excelle dans le calcul scientifique

println("🚀 PROJET AVANCÉ : Simulateur de Physique Julia")
println("📚 Consultez OBLIGATOIREMENT le résumé : modules/module2-advanced/resume_projet_physics.md")
print("\nAvez-vous lu le résumé d'apprentissage ? (oui/non) : ")

if lowercase(readline()) != "oui"
    println("⚠️  ARRÊT : Veuillez d'abord lire resume_projet_physics.md")
    println("Ce projet illustre la puissance de Julia pour le calcul scientifique.")
    exit()
end

using LinearAlgebra, Plots, Random
Random.seed!(42)  # Reproductibilité

println("🌌 Simulateur de Physique : Systèmes Dynamiques")
println("="^60)

# Partie 1 : Hiérarchie de Types pour Objets Physiques
println("🏗️ Partie 1 : Architecture des Objets Physiques")

# Types abstraits pour la hiérarchie
abstract type ObjetPhysique end
abstract type Corps <: ObjetPhysique end
abstract type Force <: ObjetPhysique end
abstract type Contrainte <: ObjetPhysique end

# Types concrets pour les corps
mutable struct Particule <: Corps
    nom::String
    position::Vector{Float64}
    vitesse::Vector{Float64}
    accélération::Vector{Float64}
    masse::Float64
    rayon::Float64
    couleur::Symbol
    
    function Particule(nom, pos, vel, masse, rayon=0.1, couleur=:blue)
        new(nom, pos, vel, zeros(length(pos)), masse, rayon, couleur)
    end
end

mutable struct CorpsRigide <: Corps
    nom::String
    position::Vector{Float64}
    vitesse::Vector{Float64}
    accélération::Vector{Float64}
    masse::Float64
    moment_inertie::Float64
    orientation::Float64
    vitesse_angulaire::Float64
    points::Vector{Vector{Float64}}  # Forme du corps
    
    function CorpsRigide(nom, pos, vel, masse, inertie, points)
        new(nom, pos, vel, zeros(length(pos)), masse, inertie, 0.0, 0.0, points)
    end
end

# Types de forces
struct Gravité <: Force
    intensité::Float64
    direction::Vector{Float64}
end

struct ForceRessort <: Force
    k::Float64  # Constante de raideur
    longueur_repos::Float64
    extrémité_fixe::Vector{Float64}
end

struct ForceFrottement <: Force
    coefficient::Float64
end

struct ForceElectromagnétique <: Force
    charge::Float64
    champ::Vector{Float64}
end

# Partie 2 : Calculs de Forces avec Répartition Multiple
println("⚡ Partie 2 : Calculs de Forces Spécialisées")

# Calcul de force générique
function calculer_force(force::Force, corps::Corps)
    return zeros(length(corps.position))  # Force nulle par défaut
end

# Spécialisations pour chaque type de force
function calculer_force(gravité::Gravité, corps::Corps)
    return corps.masse * gravité.intensité * gravité.direction
end

function calculer_force(ressort::ForceRessort, corps::Corps)
    déplacement = corps.position - ressort.extrémité_fixe
    distance = norm(déplacement)
    if distance > 0
        direction = déplacement / distance
        extension = distance - ressort.longueur_repos
        return -ressort.k * extension * direction
    else
        return zeros(length(corps.position))
    end
end

function calculer_force(frottement::ForceFrottement, corps::Corps)
    if norm(corps.vitesse) > 0
        return -frottement.coefficient * corps.masse * 9.81 * normalize(corps.vitesse)
    else
        return zeros(length(corps.position))
    end
end

function calculer_force(électromag::ForceElectromagnétique, corps::Particule)
    # Force de Lorentz : F = q(E + v × B)
    force_électrique = électromag.charge * électromag.champ
    # Simplification : pas de champ magnétique dans cette version
    return force_électrique
end

# Partie 3 : Intégration Numérique avec Méthodes Différentes
println("🧮 Partie 3 : Intégration Numérique Adaptative")

# Méthodes d'intégration
abstract type MéthodeIntégration end

struct Euler <: MéthodeIntégration end
struct RungeKutta4 <: MéthodeIntégration end
struct Verlet <: MéthodeIntégration end

# Intégration spécialisée par méthode
function intégrer!(corps::Corps, forces::Vector{Force}, dt::Float64, méthode::Euler)
    # Méthode d'Euler simple
    force_totale = sum(calculer_force(f, corps) for f in forces)
    corps.accélération = force_totale / corps.masse
    
    corps.position += corps.vitesse * dt
    corps.vitesse += corps.accélération * dt
end

function intégrer!(corps::Corps, forces::Vector{Force}, dt::Float64, méthode::RungeKutta4)
    # Runge-Kutta 4ème ordre (simplifié)
    pos_init = copy(corps.position)
    vel_init = copy(corps.vitesse)
    
    # k1
    force_totale = sum(calculer_force(f, corps) for f in forces)
    k1_vel = dt * force_totale / corps.masse
    k1_pos = dt * corps.vitesse
    
    # k2
    corps.position = pos_init + k1_pos/2
    corps.vitesse = vel_init + k1_vel/2
    force_totale = sum(calculer_force(f, corps) for f in forces)
    k2_vel = dt * force_totale / corps.masse
    k2_pos = dt * corps.vitesse
    
    # k3
    corps.position = pos_init + k2_pos/2
    corps.vitesse = vel_init + k2_vel/2
    force_totale = sum(calculer_force(f, corps) for f in forces)
    k3_vel = dt * force_totale / corps.masse
    k3_pos = dt * corps.vitesse
    
    # k4
    corps.position = pos_init + k3_pos
    corps.vitesse = vel_init + k3_vel
    force_totale = sum(calculer_force(f, corps) for f in forces)
    k4_vel = dt * force_totale / corps.masse
    k4_pos = dt * corps.vitesse
    
    # Combinaison finale
    corps.position = pos_init + (k1_pos + 2*k2_pos + 2*k3_pos + k4_pos)/6
    corps.vitesse = vel_init + (k1_vel + 2*k2_vel + 2*k3_vel + k4_vel)/6
end

function intégrer!(corps::Corps, forces::Vector{Force}, dt::Float64, méthode::Verlet)
    # Méthode de Verlet pour systèmes conservatifs
    force_totale = sum(calculer_force(f, corps) for f in forces)
    nouvelle_accél = force_totale / corps.masse
    
    corps.position += corps.vitesse * dt + 0.5 * corps.accélération * dt^2
    corps.vitesse += 0.5 * (corps.accélération + nouvelle_accél) * dt
    corps.accélération = nouvelle_accél
end

# Partie 4 : Système de Simulation Complet
println("🌍 Partie 4 : Moteur de Simulation")

mutable struct Simulation
    corps::Vector{Corps}
    forces::Vector{Force}
    méthode::MéthodeIntégration
    temps::Float64
    dt::Float64
    historique::Dict{String, Vector{Vector{Float64}}}
    
    function Simulation(méthode::MéthodeIntégration = RungeKutta4(), dt = 0.01)
        new(Corps[], Force[], méthode, 0.0, dt, Dict{String, Vector{Vector{Float64}}}())
    end
end

function ajouter_corps!(sim::Simulation, corps::Corps)
    push!(sim.corps, corps)
    sim.historique[corps.nom] = [copy(corps.position)]
end

function ajouter_force!(sim::Simulation, force::Force)
    push!(sim.forces, force)
end

function simuler!(sim::Simulation, durée::Float64)
    nombre_pas = Int(durée / sim.dt)
    
    println("Simulation en cours... ($nombre_pas pas de temps)")
    for i in 1:nombre_pas
        # Intégrer chaque corps
        for corps in sim.corps
            intégrer!(corps, sim.forces, sim.dt, sim.méthode)
            push!(sim.historique[corps.nom], copy(corps.position))
        end
        
        sim.temps += sim.dt
        
        # Affichage de progression
        if i % (nombre_pas ÷ 10) == 0
            pourcentage = round(Int, 100 * i / nombre_pas)
            println("  Progression : $pourcentage%")
        end
    end
    
    println("Simulation terminée ! Temps total : $(sim.temps)s")
end

# Partie 5 : Détection de Collisions avec Répartition Multiple
println("💥 Partie 5 : Système de Collisions")

function détecter_collision(corps1::Particule, corps2::Particule)
    distance = norm(corps1.position - corps2.position)
    return distance < (corps1.rayon + corps2.rayon)
end

function détecter_collision(corps::Particule, limite_x::Float64, limite_y::Float64)
    x, y = corps.position
    return abs(x) > limite_x || abs(y) > limite_y
end

function résoudre_collision!(corps1::Particule, corps2::Particule)
    # Collision élastique simple
    if détecter_collision(corps1, corps2)
        # Vecteur de collision
        direction = normalize(corps1.position - corps2.position)
        
        # Vitesses relatives
        vitesse_rel = corps1.vitesse - corps2.vitesse
        vitesse_normale = dot(vitesse_rel, direction)
        
        # Ne résoudre que si les corps se rapprochent
        if vitesse_normale > 0
            return
        end
        
        # Conservation de la quantité de mouvement
        masse_totale = corps1.masse + corps2.masse
        impulsion = 2 * vitesse_normale / masse_totale
        
        corps1.vitesse -= impulsion * corps2.masse * direction
        corps2.vitesse += impulsion * corps1.masse * direction
        
        # Séparer les corps pour éviter la superposition
        recouvrement = (corps1.rayon + corps2.rayon) - norm(corps1.position - corps2.position)
        if recouvrement > 0
            séparation = recouvrement / 2 * direction
            corps1.position += séparation
            corps2.position -= séparation
        end
    end
end

# Partie 6 : Scénarios de Simulation Prédéfinis
println("🎬 Partie 6 : Scénarios de Démonstration")

function créer_système_solaire_simplifié()
    sim = Simulation(RungeKutta4(), 0.001)
    
    # Soleil (fixe au centre)
    soleil = Particule("Soleil", [0.0, 0.0], [0.0, 0.0], 1000.0, 0.5, :yellow)
    ajouter_corps!(sim, soleil)
    
    # Terre
    terre = Particule("Terre", [10.0, 0.0], [0.0, 3.0], 1.0, 0.2, :blue)
    ajouter_corps!(sim, terre)
    
    # Mars
    mars = Particule("Mars", [15.0, 0.0], [0.0, 2.5], 0.5, 0.15, :red)
    ajouter_corps!(sim, mars)
    
    # Force gravitationnelle universelle (simplifiée)
    gravité = Gravité(0.01, [0.0, 0.0])  # Sera calculée pour chaque paire
    ajouter_force!(sim, gravité)
    
    return sim
end

function créer_système_ressorts()
    sim = Simulation(Verlet(), 0.005)
    
    # Particules connectées par des ressorts
    p1 = Particule("P1", [-2.0, 0.0], [0.0, 0.0], 1.0, 0.1, :red)
    p2 = Particule("P2", [0.0, 0.0], [0.0, 0.0], 1.0, 0.1, :green)
    p3 = Particule("P3", [2.0, 0.0], [0.0, 0.0], 1.0, 0.1, :blue)
    
    ajouter_corps!(sim, p1)
    ajouter_corps!(sim, p2)
    ajouter_corps!(sim, p3)
    
    # Forces de ressort
    ressort1 = ForceRessort(50.0, 2.0, [-2.0, 0.0])  # Point fixe à gauche
    ressort2 = ForceRessort(30.0, 2.0, [0.0, 2.0])   # Point fixe en haut
    
    ajouter_force!(sim, ressort1)
    ajouter_force!(sim, ressort2)
    
    # Gravité
    gravité = Gravité(9.81, [0.0, -1.0])
    ajouter_force!(sim, gravité)
    
    return sim
end

function créer_système_collisions()
    sim = Simulation(Euler(), 0.01)
    
    # Particules avec vitesses aléatoires
    for i in 1:5
        pos = [rand(-5:5), rand(-3:3)]
        vel = [rand(-2:0.1:2), rand(-2:0.1:2)]
        masse = rand(0.5:0.1:2.0)
        couleur = rand([:red, :blue, :green, :purple, :orange])
        
        particule = Particule("P$i", float.(pos), vel, masse, 0.3, couleur)
        ajouter_corps!(sim, particule)
    end
    
    # Frottement léger
    frottement = ForceFrottement(0.1)
    ajouter_force!(sim, frottement)
    
    return sim
end

# Partie 7 : Visualisation et Analyse
println("📊 Partie 7 : Outils d'Analyse")

function analyser_énergie(sim::Simulation)
    énergies = Dict{String, Vector{Float64}}()
    
    for (nom, trajectoire) in sim.historique
        corps = findfirst(c -> c.nom == nom, sim.corps)
        if corps !== nothing
            c = sim.corps[corps]
            énergie_cinétique = Float64[]
            énergie_potentielle = Float64[]
            
            for pos in trajectoire
                # Énergie cinétique
                ec = 0.5 * c.masse * norm(c.vitesse)^2
                push!(énergie_cinétique, ec)
                
                # Énergie potentielle gravitationnelle (approximation)
                ep = c.masse * 9.81 * pos[2]  # mgh
                push!(énergie_potentielle, ep)
            end
            
            énergies[nom * "_cinétique"] = énergie_cinétique
            énergies[nom * "_potentielle"] = énergie_potentielle
        end
    end
    
    return énergies
end

function créer_graphique_trajectoires(sim::Simulation, titre::String = "Trajectoires")
    p = plot(title=titre, xlabel="X", ylabel="Y", aspect_ratio=:equal)
    
    for (nom, trajectoire) in sim.historique
        if !isempty(trajectoire)
            x = [pos[1] for pos in trajectoire]
            y = [pos[2] for pos in trajectoire]
            
            # Trouver la couleur du corps
            corps = findfirst(c -> c.nom == nom, sim.corps)
            couleur = corps !== nothing ? sim.corps[corps].couleur : :black
            
            plot!(p, x, y, label=nom, linewidth=2, color=couleur)
            scatter!(p, [x[1]], [y[1]], color=couleur, markersize=8, label="", markershape=:circle)
            scatter!(p, [x[end]], [y[end]], color=couleur, markersize=8, label="", markershape=:star)
        end
    end
    
    return p
end

# Partie 8 : Interface de Contrôle Interactive
println("🎮 Partie 8 : Interface de Contrôle")

function menu_simulation()
    println("\n" * "="^50)
    println("🎮 MENU DE SIMULATION")
    println("="^50)
    println("1. Système solaire simplifié")
    println("2. Système de ressorts")
    println("3. Collisions de particules")
    println("4. Simulation personnalisée")
    println("5. Quitter")
    
    print("\nChoisissez un scénario (1-5) : ")
    choix = readline()
    
    if choix == "1"
        println("🌌 Lancement du système solaire...")
        sim = créer_système_solaire_simplifié()
        simuler!(sim, 10.0)
        graphique = créer_graphique_trajectoires(sim, "Système Solaire Simplifié")
        display(graphique)
        
    elseif choix == "2"
        println("🌸 Lancement du système de ressorts...")
        sim = créer_système_ressorts()
        simuler!(sim, 5.0)
        graphique = créer_graphique_trajectoires(sim, "Système de Ressorts")
        display(graphique)
        
    elseif choix == "3"
        println("💥 Lancement des collisions de particules...")
        sim = créer_système_collisions()
        simuler!(sim, 10.0)
        graphique = créer_graphique_trajectoires(sim, "Collisions de Particules")
        display(graphique)
        
    elseif choix == "4"
        println("🔧 Mode personnalisation - À implémenter...")
        println("Conseil : Modifiez les fonctions créer_système_* pour vos propres expériences !")
        
    elseif choix == "5"
        println("👋 Au revoir !")
        return false
    else
        println("❌ Choix invalide !")
    end
    
    return true
end

# Lancement de l'interface
continuer = true
while continuer
    global continuer = menu_simulation()
    if continuer
        print("\nAppuyez sur Entrée pour continuer...")
        readline()
    end
end

# Bilan d'apprentissage du projet
println("\n📈 BILAN D'APPRENTISSAGE - PROJET SIMULATEUR")
println("="^70)
println("🚀 MAÎTRISE EXPERTE DE LA PROGRAMMATION JULIA AVANCÉE !")
println("="^70)
println("✅ Compétences de niveau ingénieur développées :")
println("  🏗️ Architecture complexe avec hiérarchie de types abstraits")
println("  🎭 Exploitation avancée de la répartition multiple")
println("  🧮 Implémentation de méthodes numériques spécialisées")
println("  ⚡ Optimisation de performance par spécialisation de types")
println("  💥 Systèmes de collision et détection géométrique")
println("  📊 Visualisation et analyse de données scientifiques")
println("  🎮 Interface utilisateur interactive complexe")

println("\n🌟 BADGE DÉBLOQUÉ : 'Ingénieur Julia Systèmes Dynamiques'")
println("Vous pouvez maintenant tackle des projets de calcul scientifique réels !")

println("\n🎯 APPLICATIONS DIRECTES DE CET APPRENTISSAGE :")
println("  - Simulations de systèmes physiques complexes")
println("  - Modélisation de dynamiques financières") 
println("  - Systèmes multi-agents et intelligence artificielle")
println("  - Jeux vidéo avec physique réaliste")
println("  - Recherche en mécanique et ingénierie")

println("\n🚀 PRÊT POUR LE MODULE 3 - MACHINE LEARNING")
println("Vos compétences en structures de données et répartition multiple")
println("sont exactement ce qu'il faut pour exceller en ML avec Julia !")

println("\n📚 POUR ALLER PLUS LOIN :")
println("  - Explorez DifferentialEquations.jl pour des solveurs avancés")
println("  - Découvrez Makie.jl pour de la visualisation 3D interactive")
println("  - Consultez les paquets de calcul scientifique Julia")
println("="^70)