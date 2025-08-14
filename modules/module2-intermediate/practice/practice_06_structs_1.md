# 🎮 Pratique 6.1 : Créer une structure Joueur pour un jeu

## 🎯 Mission
Créer un système de jeu inspiré des héros du Burkina Faso avec des structures personnalisées !

## 📋 Ce que vous allez apprendre
- Créer une structure `Joueur` avec des propriétés
- Utiliser des constructeurs personnalisés
- Modifier des structures mutables
- Créer des méthodes pour interagir avec vos structures

---

## 🚀 Étape 1 : Structure de base d'un Joueur

Commençons par créer notre première structure pour représenter un joueur :

```julia
# Créez une structure mutable pour un joueur
mutable struct Joueur
    nom::String
    points::Int
    niveau::Int
    vie::Int
    ville_origine::String
    
    # Constructeur par défaut pour nouveau joueur
    function Joueur(nom::String, ville::String)
        new(nom, 0, 1, 100, ville)
    end
end

# Test de base
println("🎮 === CRÉATION DE JOUEURS ===")
joueur1 = Joueur("Oumarou Kanazoé", "Ouagadougou")
println("Joueur créé: $(joueur1.nom) de $(joueur1.ville_origine)")
println("Points: $(joueur1.points), Niveau: $(joueur1.niveau), Vie: $(joueur1.vie)")
```

### 🎯 Défi 1 : Créez votre joueur
Créez un joueur avec votre nom (ou un nom burkinabè) et votre ville :

```julia
println("\n🎯 DÉFI 1 : Créez votre joueur")
print("Entrez le nom du joueur: ")
nom_joueur = readline()
print("Entrez la ville d'origine: ")
ville_joueur = readline()

mon_joueur = Joueur(nom_joueur, ville_joueur)
println("✅ Joueur créé: $(mon_joueur.nom) de $(mon_joueur.ville_origine)")
```

---

## 🏆 Étape 2 : Système de progression

Créons des fonctions pour faire évoluer nos joueurs :

```julia
# Fonction pour gagner des points
function gagner_points!(joueur::Joueur, points::Int)
    joueur.points += points
    println("🎉 $(joueur.nom) gagne $(points) points! Total: $(joueur.points)")
    
    # Système de niveau automatique
    nouveau_niveau = div(joueur.points, 100) + 1
    if nouveau_niveau > joueur.niveau
        joueur.niveau = nouveau_niveau
        println("⭐ NIVEAU UP! $(joueur.nom) passe au niveau $(joueur.niveau)!")
        
        # Bonus de vie pour chaque niveau
        joueur.vie += 20
        println("💚 Bonus de vie! Vie actuelle: $(joueur.vie)")
    end
end

# Fonction pour subir des dégâts
function subir_degats!(joueur::Joueur, degats::Int)
    joueur.vie -= degats
    println("💥 $(joueur.nom) subit $(degats) dégâts. Vie restante: $(joueur.vie)")
    
    if joueur.vie <= 0
        println("💀 $(joueur.nom) est KO!")
        return false
    end
    return true
end

# Test des fonctions
println("\n🎮 === TEST DES FONCTIONS ===")
gagner_points!(joueur1, 150)
gagner_points!(joueur1, 200)
subir_degats!(joueur1, 30)
```

### 🎯 Défi 2 : Mini-quête
Faites jouer votre joueur à une mini-quête :

```julia
println("\n🎯 DÉFI 2 : Mini-quête")
println("🗺️  $(mon_joueur.nom) part en quête depuis $(mon_joueur.ville_origine)!")

quetes = [
    ("Aider au marché de Ouagadougou", 50),
    ("Livrer un message à Bobo-Dioulasso", 75),
    ("Protéger un village contre les bandits", 120),
    ("Retrouver un objet perdu à Koudougou", 90)
]

for (i, (description, recompense)) in enumerate(quetes)
    println("\n📋 Quête $(i): $(description)")
    print("Accepter cette quête? (o/n): ")
    reponse = readline()
    
    if lowercase(reponse) == "o"
        println("⚔️  En cours...")
        sleep(1)  # Simulation du temps de quête
        
        # Chance de succès basée sur le niveau
        chance_succes = min(0.7 + (mon_joueur.niveau * 0.1), 0.95)
        
        if rand() < chance_succes
            println("✅ Quête réussie!")
            gagner_points!(mon_joueur, recompense)
        else
            println("❌ Quête échouée!")
            subir_degats!(mon_joueur, 15)
        end
    else
        println("⏭️  Quête ignorée")
    end
    
    if mon_joueur.vie <= 0
        println("💀 Fin de l'aventure pour $(mon_joueur.nom)...")
        break
    end
end
```

---

## 🏪 Étape 3 : Système d'inventaire

Ajoutons un inventaire à notre joueur :

```julia
# Nouvelle version avec inventaire
mutable struct JoueurAvance
    nom::String
    points::Int
    niveau::Int
    vie::Int
    ville_origine::String
    inventaire::Vector{String}
    argent::Int  # en FCFA
    
    function JoueurAvance(nom::String, ville::String)
        new(nom, 0, 1, 100, ville, String[], 10000)  # 10,000 FCFA de départ
    end
end

# Fonction pour acheter un objet
function acheter_objet!(joueur::JoueurAvance, objet::String, prix::Int)
    if joueur.argent >= prix
        joueur.argent -= prix
        push!(joueur.inventaire, objet)
        println("🛒 $(joueur.nom) achète $(objet) pour $(prix) FCFA")
        println("💰 Argent restant: $(joueur.argent) FCFA")
        return true
    else
        println("💸 Pas assez d'argent! Il vous faut $(prix - joueur.argent) FCFA de plus")
        return false
    end
end

# Fonction pour afficher l'inventaire
function afficher_inventaire(joueur::JoueurAvance)
    println("\n🎒 === INVENTAIRE DE $(joueur.nom) ===")
    println("💰 Argent: $(joueur.argent) FCFA")
    
    if isempty(joueur.inventaire)
        println("📦 Inventaire vide")
    else
        println("📦 Objets:")
        for (i, objet) in enumerate(joueur.inventaire)
            println("   $(i). $(objet)")
        end
    end
end

# Test du système avancé
println("\n🎮 === SYSTÈME AVANCÉ ===")
hero = JoueurAvance("Aminata Traoré", "Banfora")
afficher_inventaire(hero)
```

### 🎯 Défi 3 : Shopping au marché
Simulons un shopping au Grand Marché de Ouagadougou :

```julia
println("\n🎯 DÉFI 3 : Shopping au Grand Marché")
println("🏪 Bienvenue au Grand Marché de Ouagadougou!")

marche = [
    ("Pagne Faso Dan Fani", 8000),
    ("Calebasse traditionnelle", 3000),
    ("Bijoux en bronze", 5000),
    ("Masque traditionnel", 12000),
    ("Instrument de musique (Djembé)", 15000),
    ("Sandales en cuir", 4000)
]

println("\n🛍️  Articles disponibles:")
for (i, (objet, prix)) in enumerate(marche)
    println("$(i). $(objet) - $(prix) FCFA")
end

afficher_inventaire(hero)

while true
    print("\nQuel article voulez-vous acheter? (numéro ou 'q' pour quitter): ")
    choix = readline()
    
    if choix == "q"
        break
    end
    
    try
        index = parse(Int, choix)
        if 1 <= index <= length(marche)
            objet, prix = marche[index]
            acheter_objet!(hero, objet, prix)
        else
            println("❌ Numéro invalide!")
        end
    catch
        println("❌ Veuillez entrer un numéro valide!")
    end
    
    afficher_inventaire(hero)
end
```

---

## 🎯 Étape 4 : Système de combat

Créons un petit système de combat entre joueurs :

```julia
function combat!(joueur1::JoueurAvance, joueur2::JoueurAvance)
    println("\n⚔️  === COMBAT ENTRE $(joueur1.nom) ET $(joueur2.nom) ===")
    
    round = 1
    while joueur1.vie > 0 && joueur2.vie > 0
        println("\n🥊 Round $(round)")
        
        # Attaque du joueur 1
        degats1 = rand(10:20) + joueur1.niveau * 2
        joueur2.vie -= degats1
        println("$(joueur1.nom) attaque pour $(degats1) dégâts!")
        println("Vie de $(joueur2.nom): $(max(0, joueur2.vie))")
        
        if joueur2.vie <= 0
            break
        end
        
        # Attaque du joueur 2
        degats2 = rand(10:20) + joueur2.niveau * 2
        joueur1.vie -= degats2
        println("$(joueur2.nom) contre-attaque pour $(degats2) dégâts!")
        println("Vie de $(joueur1.nom): $(max(0, joueur1.vie))")
        
        round += 1
        sleep(1)  # Pause dramatique
    end
    
    # Déterminer le vainqueur
    if joueur1.vie > 0
        println("🏆 $(joueur1.nom) remporte le combat!")
        gagner_points!(joueur1, 100)
        return joueur1
    else
        println("🏆 $(joueur2.nom) remporte le combat!")
        gagner_points!(joueur2, 100)
        return joueur2
    end
end

# Créons deux adversaires
guerrier1 = JoueurAvance("Naaba Oubri", "Ouagadougou")
guerrier2 = JoueurAvance("Samori Touré", "Bobo-Dioulasso")

# Donnons-leur quelques niveaux
gagner_points!(guerrier1, 250)
gagner_points!(guerrier2, 180)

# COMBAT!
vainqueur = combat!(guerrier1, guerrier2)
```

---

## 🏅 Récapitulatif des points

Calculons votre score pour cette pratique :

```julia
println("\n🏅 === RÉCAPITULATIF ===")
score_total = 0

# Points pour création de joueur
if @isdefined(mon_joueur)
    score_total += 20
    println("✅ Création de joueur: +20 points")
end

# Points pour quêtes réussies
if mon_joueur.points > 0
    score_total += min(mon_joueur.points ÷ 10, 50)
    println("✅ Quêtes réussies: +$(min(mon_joueur.points ÷ 10, 50)) points")
end

# Points pour shopping
if @isdefined(hero) && !isempty(hero.inventaire)
    score_total += length(hero.inventaire) * 5
    println("✅ Objets achetés: +$(length(hero.inventaire) * 5) points")
end

# Points pour combat
if @isdefined(vainqueur)
    score_total += 30
    println("✅ Combat terminé: +30 points")
end

println("\n🎯 SCORE TOTAL: $(score_total)/120 points")

if score_total >= 100
    println("🥇 Excellent! Vous maîtrisez les structures!")
elseif score_total >= 70
    println("🥈 Très bien! Bon travail avec les structures!")
elseif score_total >= 40
    println("🥉 Bien! Continuez à pratiquer!")
else
    println("📚 Révisez la théorie et recommencez!")
end
```

---

## 🎓 Ce que vous avez appris

1. ✅ **Créer des structures mutables** avec `mutable struct`
2. ✅ **Utiliser des constructeurs** pour initialiser proprement
3. ✅ **Modifier les propriétés** d'une structure mutable
4. ✅ **Créer des méthodes** qui opèrent sur vos structures
5. ✅ **Organiser des données complexes** de manière logique

## 🚀 Prochaine étape

Dans la pratique suivante, nous créerons un système d'inventaire complet pour un magasin avec des structures `Produit` !

🎮 **Félicitations, vous êtes maintenant un(e) architecte de données burkinabè !**