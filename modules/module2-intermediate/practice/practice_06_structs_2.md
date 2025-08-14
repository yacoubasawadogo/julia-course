# 🏪 Pratique 6.2 : Système d'inventaire avec structures Produit

## 🎯 Mission
Créer un système complet de gestion d'inventaire pour un magasin au Burkina Faso !

## 📋 Ce que vous allez apprendre
- Créer une structure `Produit` immutable
- Utiliser une structure `Magasin` mutable pour l'inventaire
- Implémenter des opérations commerciales (vente, achat, réapprovisionnement)
- Gérer les calculs de prix et les promotions

---

## 🏗️ Étape 1 : Structure de base d'un Produit

Commençons par créer notre structure pour représenter un produit :

```julia
# Structure immutable pour un produit
struct Produit
    nom::String
    prix_unitaire::Int          # en FCFA
    categorie::String
    origine::String
    code_produit::String
    
    # Constructeur avec génération automatique de code
    function Produit(nom::String, prix::Int, categorie::String, origine::String)
        # Génération automatique du code produit
        code = uppercase(nom[1:min(3, length(nom))]) * 
               uppercase(categorie[1:min(2, length(categorie))]) * 
               string(rand(100:999))
        new(nom, prix, categorie, origine, code)
    end
end

# Structure mutable pour les stocks
mutable struct Stock
    produit::Produit
    quantite::Int
    seuil_alerte::Int    # Alerte si stock faible
    
    function Stock(produit::Produit, quantite::Int, seuil::Int = 10)
        new(produit, quantite, seuil)
    end
end

# Test de base
println("🏪 === CRÉATION DE PRODUITS ===")
tomate = Produit("Tomates fraîches", 800, "Légumes", "Koudougou")
pagne = Produit("Pagne Faso Dan Fani", 25000, "Textile", "Ouagadougou")

println("Produit 1: $(tomate.nom) - $(tomate.prix_unitaire) FCFA")
println("Code: $(tomate.code_produit), Origine: $(tomate.origine)")
println("Produit 2: $(pagne.nom) - $(pagne.prix_unitaire) FCFA")
println("Code: $(pagne.code_produit), Origine: $(pagne.origine)")
```

### 🎯 Défi 1 : Créez vos produits locaux
Créez 3 produits typiques du Burkina Faso :

```julia
println("\n🎯 DÉFI 1 : Créez 3 produits burkinabè")

# Suggestions de produits
produits_suggestions = [
    ("Mil", 600, "Céréales", "Sahel"),
    ("Karité", 2000, "Cosmétique", "Centre-Ouest"),
    ("Calebasse", 1500, "Artisanat", "Sud-Ouest"),
    ("Coton", 1200, "Textile", "Hauts-Bassins"),
    ("Sésame", 800, "Graines", "Nord"),
    ("Arachides", 700, "Légumineuses", "Centre")
]

mes_produits = Produit[]

for i in 1:3
    println("\n📦 Produit $(i):")
    print("Nom du produit (ou tapez 'aide' pour voir les suggestions): ")
    nom_input = readline()
    
    if nom_input == "aide"
        println("💡 Suggestions:")
        for (j, (nom, prix, cat, orig)) in enumerate(produits_suggestions)
            println("   $(j). $(nom) - $(prix) FCFA ($(cat), $(orig))")
        end
        print("Choisissez un numéro ou tapez votre propre nom: ")
        choix = readline()
        
        try
            index = parse(Int, choix)
            if 1 <= index <= length(produits_suggestions)
                nom, prix, categorie, origine = produits_suggestions[index]
                produit = Produit(nom, prix, categorie, origine)
                push!(mes_produits, produit)
                println("✅ Produit créé: $(produit.nom)")
                continue
            end
        catch
            # Si ce n'est pas un nombre, on utilise comme nom
            nom_input = choix
        end
    end
    
    # Création manuelle
    print("Prix unitaire (FCFA): ")
    prix = parse(Int, readline())
    print("Catégorie: ")
    categorie = readline()
    print("Région d'origine: ")
    origine = readline()
    
    produit = Produit(nom_input, prix, categorie, origine)
    push!(mes_produits, produit)
    println("✅ Produit créé: $(produit.nom) ($(produit.code_produit))")
end

println("\n📋 Vos produits créés:")
for (i, p) in enumerate(mes_produits)
    println("$(i). $(p.nom) - $(p.prix_unitaire) FCFA [$(p.code_produit)]")
end
```

---

## 🏬 Étape 2 : Structure du Magasin

Créons maintenant la structure principale pour gérer notre magasin :

```julia
mutable struct Magasin
    nom::String
    ville::String
    stocks::Vector{Stock}
    caisse::Int                 # Argent en caisse (FCFA)
    ventes_jour::Int           # Chiffre d'affaires du jour
    
    function Magasin(nom::String, ville::String, capital_initial::Int = 500000)
        new(nom, ville, Stock[], capital_initial, 0)
    end
end

# Fonction pour ajouter un produit au stock
function ajouter_stock!(magasin::Magasin, produit::Produit, quantite::Int, seuil::Int = 10)
    # Vérifier si le produit existe déjà
    for stock in magasin.stocks
        if stock.produit.code_produit == produit.code_produit
            stock.quantite += quantite
            println("📦 Réapprovisionnement: +$(quantite) $(produit.nom)")
            println("Stock total: $(stock.quantite) unités")
            return
        end
    end
    
    # Nouveau produit
    nouveau_stock = Stock(produit, quantite, seuil)
    push!(magasin.stocks, nouveau_stock)
    println("✅ Nouveau produit ajouté: $(produit.nom) ($(quantite) unités)")
end

# Fonction pour afficher l'inventaire
function afficher_inventaire(magasin::Magasin)
    println("\n🏪 === INVENTAIRE $(magasin.nom) - $(magasin.ville) ===")
    println("💰 Caisse: $(magasin.caisse) FCFA")
    println("📊 Ventes du jour: $(magasin.ventes_jour) FCFA")
    println("📦 Stock ($(length(magasin.stocks)) produits):")
    
    if isempty(magasin.stocks)
        println("   Aucun produit en stock")
        return
    end
    
    for (i, stock) in enumerate(magasin.stocks)
        p = stock.produit
        alerte = stock.quantite <= stock.seuil_alerte ? " ⚠️ STOCK FAIBLE" : ""
        println("   $(i). $(p.nom) - $(p.prix_unitaire) FCFA")
        println("      Stock: $(stock.quantite) unités [$(p.code_produit)]$(alerte)")
    end
end

# Créons notre magasin
println("\n🏬 === CRÉATION DU MAGASIN ===")
mon_magasin = Magasin("Boutique Burkina", "Ouagadougou")

# Ajoutons nos produits créés
for produit in mes_produits
    quantite_initiale = rand(20:100)
    ajouter_stock!(mon_magasin, produit, quantite_initiale)
end

afficher_inventaire(mon_magasin)
```

### 🎯 Défi 2 : Réapprovisionnement
Gérez le réapprovisionnement de votre magasin :

```julia
println("\n🎯 DÉFI 2 : Réapprovisionnement")

# Produits populaires au Burkina Faso
produits_populaires = [
    Produit("Riz parfumé", 1000, "Céréales", "Importé"),
    Produit("Huile de tournesol", 2500, "Alimentaire", "Local"),
    Produit("Savon de karité", 800, "Hygiène", "Ouagadougou"),
    Produit("Thé Ataya", 500, "Boissons", "Traditionnellement"),
    Produit("Bissap séché", 1200, "Boissons", "Bobo-Dioulasso")
]

println("🚚 Livraison de nouveaux produits disponible!")
println("Produits disponibles pour commande:")

for (i, p) in enumerate(produits_populaires)
    println("$(i). $(p.nom) - $(p.prix_unitaire) FCFA ($(p.origine))")
end

println("\nVotre caisse: $(mon_magasin.caisse) FCFA")

while true
    print("\nQuel produit commander? (numéro, 'stock' pour voir l'inventaire, 'q' pour quitter): ")
    choix = readline()
    
    if choix == "q"
        break
    elseif choix == "stock"
        afficher_inventaire(mon_magasin)
        continue
    end
    
    try
        index = parse(Int, choix)
        if 1 <= index <= length(produits_populaires)
            produit = produits_populaires[index]
            
            print("Quantité à commander: ")
            quantite = parse(Int, readline())
            
            # Coût d'achat (70% du prix de vente)
            cout_achat = Int(round(produit.prix_unitaire * 0.7))
            cout_total = cout_achat * quantite
            
            println("💰 Coût total: $(cout_total) FCFA ($(cout_achat) FCFA/unité)")
            
            if cout_total <= mon_magasin.caisse
                print("Confirmer l'achat? (o/n): ")
                if lowercase(readline()) == "o"
                    mon_magasin.caisse -= cout_total
                    ajouter_stock!(mon_magasin, produit, quantite)
                    println("✅ Commande effectuée!")
                end
            else
                println("❌ Fonds insuffisants! Manque: $(cout_total - mon_magasin.caisse) FCFA")
            end
        else
            println("❌ Numéro invalide!")
        end
    catch
        println("❌ Veuillez entrer un numéro valide!")
    end
end
```

---

## 🛒 Étape 3 : Système de vente

Implémentons un système de vente complet :

```julia
# Fonction pour vendre un produit
function vendre_produit!(magasin::Magasin, code_produit::String, quantite::Int)
    # Chercher le produit
    for stock in magasin.stocks
        if stock.produit.code_produit == code_produit
            if stock.quantite >= quantite
                # Vente possible
                prix_total = stock.produit.prix_unitaire * quantite
                stock.quantite -= quantite
                magasin.caisse += prix_total
                magasin.ventes_jour += prix_total
                
                println("✅ Vente: $(quantite) x $(stock.produit.nom)")
                println("💰 Total: $(prix_total) FCFA")
                
                # Alerte stock faible
                if stock.quantite <= stock.seuil_alerte
                    println("⚠️  ALERTE: Stock faible pour $(stock.produit.nom) ($(stock.quantite) restants)")
                end
                
                return true
            else
                println("❌ Stock insuffisant! Disponible: $(stock.quantite)")
                return false
            end
        end
    end
    println("❌ Produit non trouvé!")
    return false
end

# Fonction pour afficher les produits disponibles à la vente
function afficher_catalogue_vente(magasin::Magasin)
    println("\n🛒 === CATALOGUE DE VENTE ===")
    disponibles = filter(s -> s.quantite > 0, magasin.stocks)
    
    if isempty(disponibles)
        println("Aucun produit disponible à la vente")
        return
    end
    
    for (i, stock) in enumerate(disponibles)
        p = stock.produit
        println("$(i). $(p.nom) - $(p.prix_unitaire) FCFA")
        println("   Code: $(p.code_produit), Stock: $(stock.quantite) unités")
    end
end

# Test du système de vente
println("\n🛒 === SIMULATION DE VENTES ===")
afficher_catalogue_vente(mon_magasin)
```

### 🎯 Défi 3 : Servir des clients
Simulez des ventes à différents clients :

```julia
println("\n🎯 DÉFI 3 : Servir des clients")

clients_typiques = [
    ("Aminata Ouédraogo", "mère de famille"),
    ("Ibrahim Sawadogo", "étudiant"),
    ("Fatou Compaoré", "commerçante"),
    ("Boureima Traoré", "agriculteur"),
    ("Mariam Kaboré", "fonctionnaire")
]

for (nom_client, profil) in clients_typiques
    println("\n👤 Client: $(nom_client) ($(profil))")
    afficher_catalogue_vente(mon_magasin)
    
    if isempty(filter(s -> s.quantite > 0, mon_magasin.stocks))
        println("💔 Plus de produits en stock! Fermez le magasin.")
        break
    end
    
    print("Entrez le code produit à vendre (ou 'suivant' pour client suivant): ")
    code = readline()
    
    if code == "suivant"
        println("👋 $(nom_client) part sans rien acheter")
        continue
    end
    
    print("Quantité souhaitée: ")
    try
        quantite = parse(Int, readline())
        if vendre_produit!(mon_magasin, code, quantite)
            println("😊 $(nom_client) repart satisfait(e)!")
        else
            println("😔 $(nom_client) repart déçu(e)...")
        end
    catch
        println("❌ Quantité invalide! Client perdu...")
    end
    
    # Mise à jour de l'inventaire
    println("\n📊 État actuel:")
    println("Caisse: $(mon_magasin.caisse) FCFA")
    println("Ventes du jour: $(mon_magasin.ventes_jour) FCFA")
end
```

---

## 🎁 Étape 4 : Système de promotions

Ajoutons un système de promotions pour booster les ventes :

```julia
# Structure pour les promotions
struct Promotion
    nom::String
    description::String
    reduction_pourcent::Int
    produits_eligibles::Vector{String}  # Codes produits
    date_fin::String
end

# Fonction pour appliquer une promotion
function appliquer_promotion(prix_original::Int, promotion::Promotion)
    prix_reduit = Int(round(prix_original * (100 - promotion.reduction_pourcent) / 100))
    return prix_reduit
end

# Créons des promotions
promotions_actives = [
    Promotion(
        "Semaine du Textile", 
        "15% de réduction sur tous les textiles", 
        15, 
        String[], 
        "31 Décembre"
    ),
    Promotion(
        "Produits Locaux", 
        "20% sur les produits 100% burkinabè", 
        20, 
        String[], 
        "15 Janvier"
    )
]

# Fonction pour calculer le prix avec promotion
function calculer_prix_final(magasin::Magasin, code_produit::String, quantite::Int)
    for stock in magasin.stocks
        if stock.produit.code_produit == code_produit
            prix_unitaire = stock.produit.prix_unitaire
            
            # Vérifier les promotions applicables
            for promo in promotions_actives
                # Promotion textile
                if promo.nom == "Semaine du Textile" && stock.produit.categorie == "Textile"
                    prix_unitaire = appliquer_promotion(prix_unitaire, promo)
                    println("🎁 Promotion appliquée: $(promo.nom) (-$(promo.reduction_pourcent)%)")
                    break
                end
                
                # Promotion produits locaux
                if promo.nom == "Produits Locaux" && 
                   stock.produit.origine in ["Ouagadougou", "Bobo-Dioulasso", "Koudougou", "Local", "Centre-Ouest", "Sahel"]
                    prix_unitaire = appliquer_promotion(prix_unitaire, promo)
                    println("🎁 Promotion appliquée: $(promo.nom) (-$(promo.reduction_pourcent)%)")
                    break
                end
            end
            
            return prix_unitaire * quantite, prix_unitaire
        end
    end
    return 0, 0
end

println("\n🎁 === PROMOTIONS ACTIVES ===")
for promo in promotions_actives
    println("🏷️  $(promo.nom): $(promo.description)")
    println("   Valable jusqu'au $(promo.date_fin)")
end
```

### 🎯 Défi 4 : Vente avec promotions
Testez votre système de promotions :

```julia
println("\n🎯 DÉFI 4 : Vente avec promotions")
println("🛍️  Testez les promotions sur vos produits!")

afficher_catalogue_vente(mon_magasin)

while true
    print("\nCode produit pour test de promotion (ou 'q' pour quitter): ")
    code = readline()
    
    if code == "q"
        break
    end
    
    print("Quantité: ")
    try
        quantite = parse(Int, readline())
        prix_total, prix_unitaire = calculer_prix_final(mon_magasin, code, quantite)
        
        if prix_total > 0
            println("💰 Prix final: $(prix_total) FCFA ($(prix_unitaire) FCFA/unité)")
            
            print("Confirmer la vente? (o/n): ")
            if lowercase(readline()) == "o"
                # Simuler la vente avec le prix promotionnel
                for stock in mon_magasin.stocks
                    if stock.produit.code_produit == code && stock.quantite >= quantite
                        stock.quantite -= quantite
                        mon_magasin.caisse += prix_total
                        mon_magasin.ventes_jour += prix_total
                        println("✅ Vente confirmée!")
                        break
                    end
                end
            end
        else
            println("❌ Produit non trouvé!")
        end
    catch
        println("❌ Quantité invalide!")
    end
end
```

---

## 📊 Étape 5 : Rapport de fin de journée

Créons un rapport complet des activités :

```julia
function generer_rapport_journee(magasin::Magasin)
    println("\n📊 === RAPPORT DE FIN DE JOURNÉE ===")
    println("🏪 Magasin: $(magasin.nom) - $(magasin.ville)")
    println("📅 Date: $(Dates.today())")
    
    println("\n💰 FINANCES:")
    println("   Caisse actuelle: $(magasin.caisse) FCFA")
    println("   Ventes du jour: $(magasin.ventes_jour) FCFA")
    
    println("\n📦 INVENTAIRE:")
    total_produits = length(magasin.stocks)
    produits_en_stock = count(s -> s.quantite > 0, magasin.stocks)
    produits_faible_stock = count(s -> s.quantite <= s.seuil_alerte && s.quantite > 0, magasin.stocks)
    produits_rupture = count(s -> s.quantite == 0, magasin.stocks)
    
    println("   Total produits référencés: $(total_produits)")
    println("   Produits disponibles: $(produits_en_stock)")
    println("   Produits en stock faible: $(produits_faible_stock)")
    println("   Produits en rupture: $(produits_rupture)")
    
    if produits_faible_stock > 0
        println("\n⚠️  ALERTES STOCK:")
        for stock in magasin.stocks
            if stock.quantite <= stock.seuil_alerte && stock.quantite > 0
                println("   - $(stock.produit.nom): $(stock.quantite) unités")
            end
        end
    end
    
    if produits_rupture > 0
        println("\n🚫 RUPTURES:")
        for stock in magasin.stocks
            if stock.quantite == 0
                println("   - $(stock.produit.nom)")
            end
        end
    end
    
    # Valeur totale du stock
    valeur_stock = sum(s.produit.prix_unitaire * s.quantite for s in magasin.stocks)
    println("\n💎 Valeur totale du stock: $(valeur_stock) FCFA")
    
    # Recommandations
    println("\n💡 RECOMMANDATIONS:")
    if magasin.ventes_jour > 50000
        println("   🎉 Excellente journée de vente!")
    elseif magasin.ventes_jour > 20000
        println("   👍 Bonne journée de vente")
    else
        println("   📈 Pensez à améliorer la promotion des produits")
    end
    
    if produits_faible_stock > 3
        println("   🚚 Réapprovisionnement urgent nécessaire")
    end
    
    if magasin.caisse > 1000000
        println("   🏦 Pensez à déposer l'excédent de caisse à la banque")
    end
end

# Générer le rapport
generer_rapport_journee(mon_magasin)
```

---

## 🏅 Récapitulatif des points

Calculons votre score pour cette pratique :

```julia
println("\n🏅 === RÉCAPITULATIF ===")
score_total = 0

# Points pour création de produits
if @isdefined(mes_produits) && length(mes_produits) >= 3
    score_total += 25
    println("✅ Création de 3 produits: +25 points")
end

# Points pour gestion du magasin
if @isdefined(mon_magasin)
    score_total += 20
    println("✅ Création du magasin: +20 points")
end

# Points pour réapprovisionnement
if length(mon_magasin.stocks) > length(mes_produits)
    score_total += 20
    println("✅ Réapprovisionnement effectué: +20 points")
end

# Points pour ventes
if mon_magasin.ventes_jour > 0
    score_total += 25
    println("✅ Ventes réalisées: +25 points")
end

# Points pour utilisation des promotions
if mon_magasin.ventes_jour > 50000
    score_total += 15
    println("✅ Bonnes ventes (promotions utilisées): +15 points")
end

# Points pour rapport complet
score_total += 15
println("✅ Rapport de fin de journée: +15 points")

println("\n🎯 SCORE TOTAL: $(score_total)/120 points")

if score_total >= 100
    println("🥇 Excellent! Vous êtes un(e) vrai(e) gestionnaire!")
elseif score_total >= 80
    println("🥈 Très bien! Bon sens commercial!")
elseif score_total >= 60
    println("🥉 Bien! Vous progressez en gestion!")
else
    println("📚 Révisez les concepts et recommencez!")
end
```

---

## 🎓 Ce que vous avez appris

1. ✅ **Structures immutables** pour des données fixes (Produit)
2. ✅ **Structures mutables** pour des données qui évoluent (Stock, Magasin)
3. ✅ **Constructeurs personnalisés** avec génération automatique de codes
4. ✅ **Gestion de collections** de structures complexes
5. ✅ **Logique métier** complète avec calculs et validations
6. ✅ **Système de rapports** et d'alertes automatiques

## 🚀 Prochaine étape

Dans l'exercice suivant, nous construirons un système complet de gestion d'étudiants avec toutes ces compétences !

🏪 **Félicitations, vous êtes maintenant un(e) expert(e) en gestion d'inventaire burkinabè !**