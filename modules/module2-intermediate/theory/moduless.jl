module MathsBurkina
export aire_cercle, aire_rectangle, convertir_fcfa_euro

# Constantes locales au module
const PI_BURKINABE = 3.14159
const TAUX_CHANGE_EURO = 655.957  # 1 EUR = 655.957 FCFA (approximatif)

# Fonction publique (exportée)
function aire_cercle(rayon)
    return PI_BURKINABE * rayon^2
end

# Fonction publique
function aire_rectangle(longueur, largeur)
    return longueur * largeur
end

# Fonction publique pour conversion monétaire
function convertir_fcfa_euro(fcfa)
    return fcfa / TAUX_CHANGE_EURO
end

# Fonction privée (non exportée)
function fonction_interne()
    println("Ceci est privé au module")
end

end  # fin du module

using .MathsBurkina

superficie = aire_cercle(5)
prix_euros = convertir_fcfa_euro(100000)  # 100,000 FCFA en euros