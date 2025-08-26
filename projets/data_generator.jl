# 🔧 Générateur de Données pour Projets Julia - Burkina Faso
# Ce module fournit des fonctions pour générer des données test réalistes
# avec des noms, lieux et contextes burkinabè authentiques

using Random, Dates, CSV, DataFrames

module BurkinaDataGenerator
    
    using Random, Dates, DataFrames, CSV
    
    # ========================================
    # BANQUE DE DONNÉES BURKINABÈ
    # ========================================
    
    # Noms de famille courants au Burkina Faso
    const NOMS_FAMILLE = [
        "OUEDRAOGO", "KABORE", "SAWADOGO", "COMPAORE", "ZONGO", 
        "TRAORE", "ILBOUDO", "DIALLO", "OUATTARA", "BONKOUNGOU",
        "NIKIEMA", "TAPSOBA", "ZOUNGRANA", "BAMOGO", "BELEM",
        "COULIBALY", "KONATE", "SANOU", "SANON", "SOME",
        "YAMEOGO", "ZEBA", "TIENDREBEOGO", "NACOULMA", "KAGAMBEGA"
    ]
    
    # Prénoms masculins burkinabè
    const PRENOMS_HOMMES = [
        "Adama", "Ibrahim", "Moussa", "Ousmane", "Ali", "Seydou",
        "Yacouba", "Abdoulaye", "Hamidou", "Boureima", "Dramane",
        "Karim", "Lassina", "Souleymane", "Issaka", "Rasmané",
        "Daouda", "Salif", "Amadou", "Arouna", "Boubacar",
        "Mamadou", "Idrissa", "Zakaria", "Modibo", "Sibiri"
    ]
    
    # Prénoms féminins burkinabè
    const PRENOMS_FEMMES = [
        "Fatimata", "Mariam", "Aminata", "Aïcha", "Salamata",
        "Rasmata", "Bibata", "Awa", "Djénéba", "Kadiatou",
        "Rokia", "Safiatou", "Fatoumata", "Adama", "Assétou",
        "Maimouna", "Ramata", "Alimata", "Zenabou", "Habibou",
        "Rachida", "Nafi", "Poko", "Salimata", "Brigitte"
    ]
    
    # Villes et régions du Burkina Faso
    const VILLES = Dict(
        "Centre" => ["Ouagadougou", "Ziniaré", "Kombissiri", "Koubri", "Tanghin-Dassouri"],
        "Hauts-Bassins" => ["Bobo-Dioulasso", "Orodara", "Banfora", "Toussiana", "Karangasso"],
        "Centre-Ouest" => ["Koudougou", "Réo", "Léo", "Sapouy", "Nanoro"],
        "Nord" => ["Ouahigouya", "Yako", "Gourcy", "Titao", "Séguénéga"],
        "Sahel" => ["Dori", "Djibo", "Gorom-Gorom", "Sebba", "Aribinda"],
        "Est" => ["Fada N'Gourma", "Diapaga", "Pama", "Bogandé", "Gayéri"],
        "Boucle du Mouhoun" => ["Dédougou", "Nouna", "Tougan", "Boromo", "Solenzo"],
        "Cascades" => ["Banfora", "Sindou", "Niangoloko", "Mangodara", "Soubakaniédougou"],
        "Centre-Est" => ["Tenkodogo", "Koupéla", "Pouytenga", "Garango", "Zabré"],
        "Centre-Nord" => ["Kaya", "Kongoussi", "Boulsa", "Pissila", "Tougouri"],
        "Centre-Sud" => ["Manga", "Pô", "Kombissiri", "Tiébélé", "Guiba"],
        "Plateau-Central" => ["Ziniaré", "Zorgho", "Boussé", "Mogtédo", "Méguet"],
        "Sud-Ouest" => ["Gaoua", "Diébougou", "Batié", "Dano", "Kampti"]
    )
    
    # Quartiers de Ouagadougou
    const QUARTIERS_OUAGA = [
        "Gounghin", "Pissy", "Tanghin", "Somgandé", "Cissin",
        "Wemtenga", "Dassasgho", "Patte d'Oie", "Ouaga 2000",
        "Bassinko", "Rimkieta", "Kossodo", "Saaba", "Kilwin",
        "Zogona", "Koulouba", "Nonsin", "Karpala", "Bendogo"
    ]
    
    # Produits agricoles locaux avec prix réalistes (FCFA/kg)
    const PRODUITS_AGRICOLES = [
        (nom="Mil", categorie="Céréales", unite="kg", prix_min=250, prix_max=400),
        (nom="Sorgho blanc", categorie="Céréales", unite="kg", prix_min=300, prix_max=450),
        (nom="Sorgho rouge", categorie="Céréales", unite="kg", prix_min=280, prix_max=420),
        (nom="Maïs", categorie="Céréales", unite="kg", prix_min=200, prix_max=350),
        (nom="Riz paddy", categorie="Céréales", unite="kg", prix_min=400, prix_max=600),
        (nom="Riz décortiqué", categorie="Céréales", unite="kg", prix_min=600, prix_max=900),
        (nom="Fonio", categorie="Céréales", unite="kg", prix_min=500, prix_max=800),
        (nom="Arachides coques", categorie="Légumineuses", unite="kg", prix_min=400, prix_max=700),
        (nom="Arachides décortiquées", categorie="Légumineuses", unite="kg", prix_min=600, prix_max=1000),
        (nom="Niébé blanc", categorie="Légumineuses", unite="kg", prix_min=450, prix_max=750),
        (nom="Niébé rouge", categorie="Légumineuses", unite="kg", prix_min=400, prix_max=700),
        (nom="Sésame", categorie="Oléagineux", unite="kg", prix_min=800, prix_max=1500),
        (nom="Beurre de karité", categorie="Oléagineux", unite="kg", prix_min=2000, prix_max=3500),
        (nom="Noix de karité", categorie="Oléagineux", unite="kg", prix_min=150, prix_max=300),
        (nom="Coton graine", categorie="Cultures de rente", unite="kg", prix_min=250, prix_max=350),
        (nom="Tomates", categorie="Maraîchage", unite="kg", prix_min=300, prix_max=800),
        (nom="Oignons", categorie="Maraîchage", unite="kg", prix_min=400, prix_max=900),
        (nom="Choux", categorie="Maraîchage", unite="kg", prix_min=200, prix_max=500),
        (nom="Haricot vert", categorie="Maraîchage", unite="kg", prix_min=600, prix_max=1200),
        (nom="Gombo", categorie="Maraîchage", unite="kg", prix_min=350, prix_max=700),
        (nom="Aubergine", categorie="Maraîchage", unite="kg", prix_min=300, prix_max=600),
        (nom="Mangues", categorie="Fruits", unite="kg", prix_min=200, prix_max=500),
        (nom="Oranges", categorie="Fruits", unite="kg", prix_min=300, prix_max=600),
        (nom="Bananes", categorie="Fruits", unite="kg", prix_min=400, prix_max=700),
        (nom="Papayes", categorie="Fruits", unite="kg", prix_min=250, prix_max=500)
    ]
    
    # Lignes de bus SOTRACO de Ouagadougou
    const LIGNES_BUS = [
        (numero="L1", nom="Ouaga2000-Centre", depart="Ouaga2000", arrivee="Place Nations Unies", distance_km=12),
        (numero="L2", nom="Tanghin-Gounghin", depart="Tanghin", arrivee="Gounghin", distance_km=8),
        (numero="L3", nom="Pissy-Patte d'Oie", depart="Pissy", arrivee="Patte d'Oie", distance_km=10),
        (numero="L4", nom="Somgandé-Centre", depart="Somgandé", arrivee="Marché Central", distance_km=9),
        (numero="L5", nom="Kossodo-Université", depart="Kossodo", arrivee="Université Ouaga I", distance_km=11),
        (numero="L6", nom="Saaba-Centre", depart="Saaba", arrivee="Place Naaba Koom", distance_km=15),
        (numero="L7", nom="Bassinko-Wemtenga", depart="Bassinko", arrivee="Wemtenga", distance_km=7),
        (numero="L8", nom="Rimkieta-Centre", depart="Rimkieta", arrivee="Rond-point Nations", distance_km=13),
        (numero="L9", nom="Cissin-Dassasgho", depart="Cissin", arrivee="Dassasgho", distance_km=6),
        (numero="L10", nom="Bendogo-Zogona", depart="Bendogo", arrivee="Zogona", distance_km=14),
        (numero="L11", nom="Kilwin-Koulouba", depart="Kilwin", arrivee="Koulouba", distance_km=8),
        (numero="L12", nom="Nonsin-Centre", depart="Nonsin", arrivee="Gare Routière", distance_km=10),
        (numero="L13", nom="Karpala-Marché", depart="Karpala", arrivee="Grand Marché", distance_km=11),
        (numero="L14", nom="Signonghin-Centre", depart="Signonghin", arrivee="Place Mogho Naaba", distance_km=9),
        (numero="L15", nom="Tampouy-Ouaga2000", depart="Tampouy", arrivee="Ouaga2000", distance_km=16)
    ]
    
    # ========================================
    # FONCTIONS DE GÉNÉRATION
    # ========================================
    
    """
    Génère une personne avec nom, prénom et informations de localisation
    """
    function generer_personne(; avec_telephone=false, avec_email=false)
        sexe = rand(["H", "F"])
        prenom = sexe == "H" ? rand(PRENOMS_HOMMES) : rand(PRENOMS_FEMMES)
        nom = rand(NOMS_FAMILLE)
        region = rand(collect(keys(VILLES)))
        ville = rand(VILLES[region])
        
        result = (nom=nom, prenom=prenom, sexe=sexe, ville=ville, region=region)
        
        if avec_telephone
            # Numéros burkinabè : 70, 71, 72, 76, 77, 78, etc.
            prefixe = rand([70, 71, 72, 73, 74, 75, 76, 77, 78, 79])
            numero = string(prefixe) * lpad(rand(0:999999), 6, '0')
            result = merge(result, (telephone=numero,))
        end
        
        if avec_email
            email = lowercase(prenom) * "." * lowercase(nom) * "@" * rand(["gmail.com", "yahoo.fr", "outlook.com", "fasomail.bf"])
            result = merge(result, (email=email,))
        end
        
        return result
    end
    
    """
    Génère les membres d'une coopérative agricole
    """
    function generer_membres_cooperative(n::Int=50)
        membres = DataFrame()
        
        for i in 1:n
            personne = generer_personne(avec_telephone=true)
            date_adhesion = Date(2020, 1, 1) + Day(rand(0:1460))  # 4 ans
            parts_sociales = rand(1:10)
            statut = rand(["Actif", "Actif", "Actif", "Actif", "Inactif"])  # 80% actifs
            
            push!(membres, (
                id=i,
                nom=personne.nom,
                prenom=personne.prenom,
                sexe=personne.sexe,
                village=personne.ville,
                region=personne.region,
                telephone=personne.telephone,
                date_adhesion=date_adhesion,
                parts_sociales=parts_sociales,
                statut=statut
            ))
        end
        
        return membres
    end
    
    """
    Génère l'inventaire de produits agricoles
    """
    function generer_produits_agricoles()
        produits = DataFrame()
        
        for (i, produit) in enumerate(PRODUITS_AGRICOLES)
            stock_initial = produit.categorie == "Céréales" ? rand(1000:5000) : rand(100:1000)
            prix_actuel = rand(produit.prix_min:50:produit.prix_max)
            
            push!(produits, (
                id=i,
                nom=produit.nom,
                categorie=produit.categorie,
                unite=produit.unite,
                prix_unitaire=prix_actuel,
                stock_actuel=stock_initial,
                stock_minimum=div(stock_initial, 10)
            ))
        end
        
        return produits
    end
    
    """
    Génère des transactions de coopérative agricole
    """
    function generer_transactions_cooperative(n::Int=500, nb_membres::Int=50)
        transactions = DataFrame()
        date_debut = Date(2023, 1, 1)
        date_fin = Date(2023, 12, 31)
        
        for i in 1:n
            date = date_debut + Day(rand(0:364))
            membre_id = rand(1:nb_membres)
            produit = rand(PRODUITS_AGRICOLES)
            produit_id = findfirst(p -> p.nom == produit.nom, PRODUITS_AGRICOLES)
            type_transaction = rand(["Achat", "Vente", "Vente", "Vente"])  # Plus de ventes
            
            # Quantités réalistes selon le produit
            if produit.categorie == "Céréales"
                quantite = rand(50:50:2000)
            elseif produit.categorie == "Oléagineux"
                quantite = rand(5:5:100)
            elseif produit.categorie == "Fruits"
                quantite = rand(20:10:200)
            else
                quantite = rand(10:10:500)
            end
            
            prix_unitaire = rand(produit.prix_min:50:produit.prix_max)
            
            # Variation saisonnière des prix
            mois = month(date)
            if mois in 11:2  # Période de récolte
                prix_unitaire = round(Int, prix_unitaire * 0.8)
            elseif mois in 6:8  # Période de soudure
                prix_unitaire = round(Int, prix_unitaire * 1.3)
            end
            
            montant = quantite * prix_unitaire
            
            push!(transactions, (
                id=i,
                date=date,
                membre_id=membre_id,
                produit_id=produit_id,
                produit_nom=produit.nom,
                categorie=produit.categorie,
                type=type_transaction,
                quantite=quantite,
                prix_unitaire=prix_unitaire,
                montant_total=montant
            ))
        end
        
        return sort!(transactions, :date)
    end
    
    """
    Génère les données de lignes de bus SOTRACO
    """
    function generer_lignes_bus()
        lignes = DataFrame()
        
        for (i, ligne) in enumerate(LIGNES_BUS)
            duree_min = round(Int, ligne.distance_km * 3.5)  # ~17 km/h en moyenne
            tarif = ligne.distance_km <= 10 ? 200 : 250  # FCFA
            
            push!(lignes, (
                id=i,
                numero=ligne.numero,
                nom=ligne.nom,
                depart=ligne.depart,
                arrivee=ligne.arrivee,
                distance_km=ligne.distance_km,
                duree_min=duree_min,
                tarif_fcfa=tarif,
                nb_arrets=rand(8:20)
            ))
        end
        
        return lignes
    end
    
    """
    Génère les arrêts de bus
    """
    function generer_arrets_bus(n::Int=50)
        arrets = DataFrame()
        lieux_importants = [
            "Place Nations Unies", "Marché Central", "Université Ouaga I",
            "CHU Yalgado", "Gare Routière", "Rond-point Nations",
            "Place Naaba Koom", "Grand Marché", "Stade Municipal",
            "Mairie Centrale", "SONABEL", "ONEA", "Poste Centrale",
            "Banque Centrale", "Assemblée Nationale", "Présidence"
        ]
        
        # Ajouter les lieux importants
        for (i, lieu) in enumerate(lieux_importants)
            lat = 12.3 + rand() * 0.1
            lon = -1.5 + rand() * 0.1
            lignes_desservies = join(rand(1:15, rand(2:4)), ",")
            
            push!(arrets, (
                id=i,
                nom=lieu,
                latitude=round(lat, digits=4),
                longitude=round(lon, digits=4),
                zone=rand(["Centre", "Nord", "Sud", "Est", "Ouest"]),
                lignes_ids=lignes_desservies,
                abrite=rand([true, true, false])  # 66% abrités
            ))
        end
        
        # Ajouter des arrêts de quartier
        for i in (length(lieux_importants)+1):n
            quartier = rand(QUARTIERS_OUAGA)
            lat = 12.3 + rand() * 0.1
            lon = -1.5 + rand() * 0.1
            lignes_desservies = join(rand(1:15, rand(1:3)), ",")
            
            push!(arrets, (
                id=i,
                nom="Arrêt " * quartier,
                latitude=round(lat, digits=4),
                longitude=round(lon, digits=4),
                zone=rand(["Centre", "Nord", "Sud", "Est", "Ouest"]),
                lignes_ids=lignes_desservies,
                abrite=rand([true, false, false])  # 33% abrités
            ))
        end
        
        return arrets
    end
    
    """
    Génère les données de fréquentation des bus
    """
    function generer_frequentation_bus(jours::Int=30)
        frequentation = DataFrame()
        date_debut = Date(2024, 1, 1)
        id = 1
        
        for jour in 0:(jours-1)
            date = date_debut + Day(jour)
            jour_semaine = dayofweek(date)
            
            # Heures de pointe différentes selon le jour
            if jour_semaine <= 5  # Jours ouvrables
                heures_pointe = [6:9, 12:14, 17:20]
            else  # Weekend
                heures_pointe = [8:11, 15:18]
            end
            
            for ligne in 1:15
                for heure in 6:21
                    for minute in [0, 30]  # Toutes les 30 minutes
                        est_heure_pointe = any(h -> heure in h, heures_pointe)
                        
                        if est_heure_pointe
                            montees = rand(8:25)
                            descentes = rand(5:20)
                            occupation = rand(60:95)
                        else
                            montees = rand(2:10)
                            descentes = rand(1:8)
                            occupation = rand(20:50)
                        end
                        
                        # Variation selon la ligne
                        if ligne in [1, 2, 3]  # Lignes principales
                            montees = round(Int, montees * 1.3)
                            occupation = min(100, round(Int, occupation * 1.2))
                        end
                        
                        arret_id = rand(1:50)
                        
                        push!(frequentation, (
                            id=id,
                            date=date,
                            heure=string(lpad(heure, 2, '0')) * ":" * string(lpad(minute, 2, '0')),
                            ligne_id=ligne,
                            arret_id=arret_id,
                            montees=montees,
                            descentes=descentes,
                            occupation_pct=occupation
                        ))
                        
                        id += 1
                    end
                end
            end
        end
        
        return frequentation
    end
    
    """
    Génère les membres d'une tontine
    """
    function generer_membres_tontine(n::Int=25)
        membres = DataFrame()
        
        for i in 1:n
            personne = generer_personne(avec_telephone=true, avec_email=true)
            quartier = rand(QUARTIERS_OUAGA)
            date_inscription = Date(2023, 1, rand(1:15))
            profession = rand([
                "Commerçant(e)", "Fonctionnaire", "Enseignant(e)",
                "Artisan(e)", "Couturier(ère)", "Coiffeur(se)",
                "Mécanicien", "Infirmier(ère)", "Comptable"
            ])
            
            push!(membres, (
                id=i,
                nom=personne.nom,
                prenom=personne.prenom,
                sexe=personne.sexe,
                telephone=personne.telephone,
                email=personne.email,
                quartier=quartier,
                profession=profession,
                date_inscription=date_inscription,
                statut="Actif"
            ))
        end
        
        return membres
    end
    
    """
    Génère les cotisations de tontine
    """
    function generer_cotisations_tontine(nb_membres::Int=25, mois::Int=12)
        cotisations = DataFrame()
        montant_cotisation = 10000  # 10,000 FCFA par mois
        cotisation_id = 1
        
        for mois_num in 1:mois
            date_limite = Date(2023, mois_num, 5)
            
            for membre_id in 1:nb_membres
                # Simulation de retards aléatoires
                retard_prob = 0.2
                a_retard = rand() < retard_prob
                
                if a_retard
                    retard_jours = rand(1:20)
                    statut = retard_jours > 15 ? "Retard" : "Payé"
                    penalite = retard_jours > 7 ? (retard_jours - 7) * 100 : 0
                else
                    retard_jours = 0
                    statut = "Payé"
                    penalite = 0
                end
                
                date_paiement = date_limite + Day(retard_jours)
                
                push!(cotisations, (
                    id=cotisation_id,
                    membre_id=membre_id,
                    date_paiement=date_paiement,
                    montant=montant_cotisation,
                    penalite=penalite,
                    montant_total=montant_cotisation + penalite,
                    mois_concerne="2023-$(lpad(mois_num, 2, '0'))",
                    statut=statut,
                    retard_jours=retard_jours
                ))
                
                cotisation_id += 1
            end
        end
        
        return cotisations
    end
    
    """
    Génère les tirages de tontine
    """
    function generer_tirages_tontine(nb_membres::Int=25, mois::Int=12)
        tirages = DataFrame()
        beneficiaires_deja_tires = Set{Int}()
        
        for tour in 1:min(mois, nb_membres)
            candidats = setdiff(1:nb_membres, beneficiaires_deja_tires)
            
            if !isempty(candidats)
                beneficiaire = rand(candidats)
                push!(beneficiaires_deja_tires, beneficiaire)
                
                date_tirage = Date(2023, tour, 28)
                montant_recu = 10000 * nb_membres  # Cotisation × nombre de membres
                
                push!(tirages, (
                    id=tour,
                    date=date_tirage,
                    beneficiaire_id=beneficiaire,
                    montant_recu=montant_recu,
                    numero_tour=tour,
                    presents=nb_membres - rand(0:2),  # Quelques absents parfois
                    mode_tirage="Tirage au sort"
                ))
            end
        end
        
        return tirages
    end
    
    """
    Génère des données météorologiques réalistes pour le Burkina Faso
    """
    function generer_meteo_burkina(annee::Int=2023, regions::Vector{String}=["Centre", "Hauts-Bassins", "Sahel", "Est", "Nord"])
        meteo = DataFrame()
        date_debut = Date(annee, 1, 1)
        date_fin = Date(annee, 12, 31)
        
        for jour in date_debut:Day(1):date_fin
            mois = month(jour)
            jour_annee = dayofyear(jour)
            
            for region in regions
                # Modèle climatique réaliste du Burkina Faso
                if region == "Sahel"
                    # Zone sahélienne : plus chaud et sec
                    if mois in 6:9  # Saison des pluies
                        temp_min = 24 + rand() * 4
                        temp_max = 35 + rand() * 5
                        pluie_prob = 0.35
                        pluie_max = 30
                    elseif mois in 12:2  # Saison froide
                        temp_min = 15 + rand() * 5
                        temp_max = 33 + rand() * 4
                        pluie_prob = 0.0
                        pluie_max = 0
                    else  # Saison chaude
                        temp_min = 22 + rand() * 4
                        temp_max = 40 + rand() * 5
                        pluie_prob = 0.02
                        pluie_max = 5
                    end
                elseif region in ["Centre", "Centre-Est", "Centre-Nord", "Centre-Ouest", "Centre-Sud"]
                    # Zone soudano-sahélienne
                    if mois in 5:10  # Saison des pluies
                        temp_min = 22 + rand() * 4
                        temp_max = 30 + rand() * 5
                        pluie_prob = 0.45
                        pluie_max = 60
                    elseif mois in 12:2  # Saison froide
                        temp_min = 16 + rand() * 4
                        temp_max = 32 + rand() * 3
                        pluie_prob = 0.0
                        pluie_max = 0
                    else  # Saison chaude
                        temp_min = 20 + rand() * 5
                        temp_max = 38 + rand() * 4
                        pluie_prob = 0.05
                        pluie_max = 5
                    end
                else  # Hauts-Bassins, Cascades (Zone soudanienne)
                    # Plus humide et moins chaud
                    if mois in 5:10  # Saison des pluies
                        temp_min = 20 + rand() * 4
                        temp_max = 28 + rand() * 5
                        pluie_prob = 0.55
                        pluie_max = 80
                    elseif mois in 12:2  # Saison froide
                        temp_min = 15 + rand() * 4
                        temp_max = 30 + rand() * 3
                        pluie_prob = 0.02
                        pluie_max = 2
                    else  # Saison chaude
                        temp_min = 18 + rand() * 5
                        temp_max = 35 + rand() * 4
                        pluie_prob = 0.08
                        pluie_max = 10
                    end
                end
                
                # Génération des valeurs
                precipitation = rand() < pluie_prob ? rand() * pluie_max : 0.0
                precipitation = round(precipitation, digits=1)
                
                # Humidité corrélée avec précipitations
                if precipitation > 0
                    humidite = 60 + rand() * 35
                else
                    humidite = 20 + rand() * 30
                end
                
                # Vent (Harmattan en saison sèche)
                if mois in 12:3
                    vent = 15 + rand() * 25  # Harmattan fort
                else
                    vent = 5 + rand() * 15
                end
                
                # Ensoleillement (heures)
                if precipitation > 10
                    ensoleillement = 3 + rand() * 4
                else
                    ensoleillement = 7 + rand() * 4
                end
                
                push!(meteo, (
                    date=jour,
                    region=region,
                    temp_min=round(temp_min, digits=1),
                    temp_max=round(temp_max, digits=1),
                    temp_moy=round((temp_min + temp_max) / 2, digits=1),
                    precipitation_mm=precipitation,
                    humidite_pct=round(Int, humidite),
                    vent_kmh=round(Int, vent),
                    ensoleillement_h=round(ensoleillement, digits=1)
                ))
            end
        end
        
        return meteo
    end
    
    """
    Génère des données de rendements agricoles historiques
    """
    function generer_rendements_agricoles(annees::Int=5)
        rendements = DataFrame()
        cultures = ["Mil", "Sorgho", "Maïs", "Riz", "Coton", "Arachides", "Niébé", "Sésame"]
        regions = ["Centre", "Hauts-Bassins", "Boucle du Mouhoun", "Est", "Nord"]
        
        for annee in 2019:(2019 + annees - 1)
            for region in regions
                for culture in cultures
                    # Surface cultivée (hectares)
                    if culture in ["Mil", "Sorgho"]
                        surface = rand(5000:20000)
                    elseif culture == "Coton"
                        surface = region == "Hauts-Bassins" ? rand(10000:30000) : rand(2000:10000)
                    else
                        surface = rand(1000:8000)
                    end
                    
                    # Rendement moyen (tonnes/hectare) réaliste
                    rendement_base = Dict(
                        "Mil" => 0.9,
                        "Sorgho" => 1.0,
                        "Maïs" => 1.8,
                        "Riz" => 2.5,
                        "Coton" => 1.1,
                        "Arachides" => 0.8,
                        "Niébé" => 0.6,
                        "Sésame" => 0.4
                    )[culture]
                    
                    # Variation selon région et année
                    variation = 0.7 + rand() * 0.6  # Entre 70% et 130%
                    rendement = rendement_base * variation
                    
                    production = surface * rendement
                    
                    push!(rendements, (
                        annee=annee,
                        region=region,
                        culture=culture,
                        surface_ha=surface,
                        production_tonnes=round(Int, production),
                        rendement_t_ha=round(rendement, digits=2)
                    ))
                end
            end
        end
        
        return rendements
    end
    
    """
    Génère les personnages pour le RPG Mossi
    """
    function generer_personnages_rpg()
        personnages = DataFrame([
            (id=1, nom="Naaba Oubri", titre="Fondateur de l'Empire Mossi", 
             sante_max=100, force=85, sagesse=90, charisme=95, 
             lieu_origine="Gambaga", type="Héros", niveau=20),
            
            (id=2, nom="Princesse Yennenga", titre="Mère des Mossi", 
             sante_max=100, force=90, sagesse=85, charisme=88, 
             lieu_origine="Royaume Dagomba", type="Héros", niveau=18),
            
            (id=3, nom="Naaba Zombre", titre="Roi de Ouagadougou", 
             sante_max=100, force=80, sagesse=88, charisme=92, 
             lieu_origine="Ouagadougou", type="Héros", niveau=17),
            
            (id=4, nom="Naaba Kango", titre="Roi de Yatenga", 
             sante_max=95, force=88, sagesse=75, charisme=85, 
             lieu_origine="Ouahigouya", type="Héros", niveau=16),
            
            (id=5, nom="Mogho Naaba", titre="Empereur des Mossi", 
             sante_max=120, force=75, sagesse=95, charisme=100, 
             lieu_origine="Ouagadougou", type="Héros", niveau=25),
            
            (id=6, nom="Tansoba", titre="Chef de guerre", 
             sante_max=90, force=95, sagesse=60, charisme=70, 
             lieu_origine="Tenkodogo", type="Guerrier", niveau=15),
            
            (id=7, nom="Bendré", titre="Maître tambourinaire", 
             sante_max=70, force=50, sagesse=80, charisme=90, 
             lieu_origine="Manga", type="Sage", niveau=12),
            
            (id=8, nom="Rimsoum", titre="Gardien des traditions", 
             sante_max=75, force=60, sagesse=95, charisme=85, 
             lieu_origine="Kokologho", type="Sage", niveau=14),
            
            (id=9, nom="Wango", titre="Marchand mystérieux", 
             sante_max=60, force=40, sagesse=70, charisme=80, 
             lieu_origine="Bobo-Dioulasso", type="Marchand", niveau=10),
            
            (id=10, nom="Zoungrana", titre="Forgeron légendaire", 
             sante_max=80, force=85, sagesse=75, charisme=60, 
             lieu_origine="Koudougou", type="Artisan", niveau=13)
        ])
        
        return personnages
    end
    
    """
    Génère les quêtes pour le RPG
    """
    function generer_quetes_rpg()
        quetes = DataFrame([
            (id=1, nom="Le Trésor de Naaba", 
             description="Retrouvez le trésor caché dans le palais royal de Ouagadougou",
             lieu="Palais Royal", difficulte="Facile", 
             recompense_xp=100, objet_recompense="Amulette royale", prerequis="Aucun"),
            
            (id=2, nom="La Sagesse des Anciens", 
             description="Consultez les sages de Manéga pour obtenir leur bénédiction",
             lieu="Manéga", difficulte="Moyen", 
             recompense_xp=150, objet_recompense="Livre ancien", prerequis="Niveau 3"),
            
            (id=3, nom="Les Masques de Boulsa", 
             description="Récupérez les masques sacrés volés au village de Boulsa",
             lieu="Boulsa", difficulte="Moyen", 
             recompense_xp=200, objet_recompense="Masque Wango", prerequis="Quête 1"),
            
            (id=4, nom="La Bataille de Koumbri", 
             description="Défendez le village de Koumbri contre les envahisseurs",
             lieu="Koumbri", difficulte="Difficile", 
             recompense_xp=300, objet_recompense="Épée de Naaba", prerequis="Niveau 5"),
            
            (id=5, nom="Le Pèlerinage de Yennenga", 
             description="Suivez les traces de la princesse Yennenga jusqu'à Gambaga",
             lieu="Route Gambaga", difficulte="Difficile", 
             recompense_xp=400, objet_recompense="Arc de Yennenga", prerequis="Quête 2 et 3"),
            
            (id=6, nom="Les Crocodiles Sacrés", 
             description="Apaisez les crocodiles sacrés de Sabou",
             lieu="Sabou", difficulte="Moyen", 
             recompense_xp=180, objet_recompense="Écaille sacrée", prerequis="Niveau 4"),
            
            (id=7, nom="Le Festival des Masques", 
             description="Participez au festival des masques de Dédougou",
             lieu="Dédougou", difficulte="Facile", 
             recompense_xp=120, objet_recompense="Masque de danse", prerequis="Aucun"),
            
            (id=8, nom="L'Initiation Mossi", 
             description="Complétez les rites d'initiation traditionnels",
             lieu="Village sacré", difficulte="Expert", 
             recompense_xp=500, objet_recompense="Titre de Naaba", prerequis="Toutes les quêtes")
        ])
        
        return quetes
    end
    
    # ========================================
    # FONCTION PRINCIPALE D'EXPORT
    # ========================================
    
    """
    Exporte toutes les données pour un projet spécifique
    """
    function exporter_donnees_projet(projet::String, dossier_sortie::String)
        
        if !isdir(dossier_sortie)
            mkdir(dossier_sortie)
        end
        
        println("📊 Génération des données pour : $projet")
        
        if projet == "cooperative"
            # Générer toutes les données de la coopérative
            membres = generer_membres_cooperative(50)
            CSV.write(joinpath(dossier_sortie, "membres.csv"), membres)
            println("✅ membres.csv généré ($(nrow(membres)) lignes)")
            
            produits = generer_produits_agricoles()
            CSV.write(joinpath(dossier_sortie, "produits.csv"), produits)
            println("✅ produits.csv généré ($(nrow(produits)) lignes)")
            
            transactions = generer_transactions_cooperative(500, 50)
            CSV.write(joinpath(dossier_sortie, "transactions.csv"), transactions)
            println("✅ transactions.csv généré ($(nrow(transactions)) lignes)")
            
        elseif projet == "transport"
            # Générer les données de transport
            lignes = generer_lignes_bus()
            CSV.write(joinpath(dossier_sortie, "lignes_bus.csv"), lignes)
            println("✅ lignes_bus.csv généré ($(nrow(lignes)) lignes)")
            
            arrets = generer_arrets_bus(50)
            CSV.write(joinpath(dossier_sortie, "arrets.csv"), arrets)
            println("✅ arrets.csv généré ($(nrow(arrets)) lignes)")
            
            frequentation = generer_frequentation_bus(30)
            CSV.write(joinpath(dossier_sortie, "frequentation.csv"), frequentation)
            println("✅ frequentation.csv généré ($(nrow(frequentation)) lignes)")
            
        elseif projet == "tontine"
            # Générer les données de tontine
            membres = generer_membres_tontine(25)
            CSV.write(joinpath(dossier_sortie, "membres_tontine.csv"), membres)
            println("✅ membres_tontine.csv généré ($(nrow(membres)) lignes)")
            
            cotisations = generer_cotisations_tontine(25, 12)
            CSV.write(joinpath(dossier_sortie, "cotisations.csv"), cotisations)
            println("✅ cotisations.csv généré ($(nrow(cotisations)) lignes)")
            
            tirages = generer_tirages_tontine(25, 12)
            CSV.write(joinpath(dossier_sortie, "tirages.csv"), tirages)
            println("✅ tirages.csv généré ($(nrow(tirages)) lignes)")
            
        elseif projet == "prevision"
            # Générer les données météo et agricoles
            meteo = generer_meteo_burkina(2023)
            CSV.write(joinpath(dossier_sortie, "meteo_historique.csv"), meteo)
            println("✅ meteo_historique.csv généré ($(nrow(meteo)) lignes)")
            
            rendements = generer_rendements_agricoles(5)
            CSV.write(joinpath(dossier_sortie, "rendements_agricoles.csv"), rendements)
            println("✅ rendements_agricoles.csv généré ($(nrow(rendements)) lignes)")
            
        elseif projet == "rpg"
            # Générer les données du RPG
            personnages = generer_personnages_rpg()
            CSV.write(joinpath(dossier_sortie, "personnages.csv"), personnages)
            println("✅ personnages.csv généré ($(nrow(personnages)) lignes)")
            
            quetes = generer_quetes_rpg()
            CSV.write(joinpath(dossier_sortie, "quetes.csv"), quetes)
            println("✅ quetes.csv généré ($(nrow(quetes)) lignes)")
            
        else
            error("Projet non reconnu : $projet")
        end
        
        println("\n🎉 Génération terminée avec succès !")
    end
    
end  # module

# ========================================
# UTILISATION DU MODULE
# ========================================

# Pour utiliser ce module :
# 1. include("data_generator.jl")
# 2. using .BurkinaDataGenerator
# 3. BurkinaDataGenerator.exporter_donnees_projet("cooperative", "data/")

# Ou pour générer des données spécifiques :
# membres = BurkinaDataGenerator.generer_membres_cooperative(100)
# CSV.write("mes_membres.csv", membres)