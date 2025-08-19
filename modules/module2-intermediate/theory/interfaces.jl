abstract type Calculable end

# Méthodes requises pour l'interface
function calculer_valeur(obj::Calculable)
    #error("calculer_valeur doit être implémentée pour $(typeof(obj))")
    return 0
end

function est_valide(obj::Calculable)
    error("est_valide doit être implémentée pour $(typeof(obj))")
end

# Implémentations concrètes
struct FactureElectricite <: Calculable
    consommation_kwh::Float64
    tarif_kwh::Float64
    frais_fixes::Float64
end

struct FactureEau <: Calculable
    consommation_m3::Float64
    tarif_m3::Float64
    abonnement::Float64
end

struct FactureTelephone <: Calculable
    minutes_utilisees::Int
    cout_minute::Float64
    forfait_mensuel::Float64
end

# Implémentation de l'interface
function calculer_valeur(facture::FactureElectricite)
    return facture.consommation_kwh * facture.tarif_kwh + facture.frais_fixes
end

function calculer_valeur(facture::FactureEau)
    return facture.consommation_m3 * facture.tarif_m3 + facture.abonnement
end

function calculer_valeur(facture::FactureTelephone)
    cout_communication = facture.minutes_utilisees * facture.cout_minute
    return max(cout_communication, facture.forfait_mensuel)
end

function est_valide(facture::FactureElectricite)
    return facture.consommation_kwh >= 0 && facture.tarif_kwh > 0
end

function est_valide(facture::FactureEau)
    return facture.consommation_m3 >= 0 && facture.tarif_m3 > 0
end

function est_valide(facture::FactureTelephone)
    return facture.minutes_utilisees >= 0 && facture.cout_minute >= 0
end

# Fonction générique utilisant l'interface
function traiter_facture(facture::Calculable)
    if !est_valide(facture)
        println("❌ Facture invalide: $(typeof(facture))")
        return nothing
    end

    montant = calculer_valeur(facture)
    println("✅ $(typeof(facture)): $(round(Int, montant)) FCFA")
    return montant
end

# Tests
factures = [
    FactureElectricite(150.5, 85.0, 2500.0),  # SONABEL
    FactureEau(25.3, 180.0, 1500.0),          # ONEA
    FactureTelephone(420, 45.0, 5000.0)      # Orange/Moov
]

total_factures = 0
for facture in factures
    montant = traiter_facture(facture)
    if montant !== nothing
        global total_factures += montant
    end
end

println("\n💰 Total des factures: $(round(Int, total_factures)) FCFA")