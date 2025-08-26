using DataFrames
using CSV

main_path = "/Users/rskalmogo/teaching/julia-programming/class/julia-course/modules/module3-ml/theory"


df_members = CSV.read("$main_path/membres.csv", DataFrame)


# Données sur la production agricole au Burkina Faso
df_production = DataFrame(
    region=["Centre", "Nord", "Sud-Ouest", "Est", "Boucle du Mouhoun"],
    mil_tonnes=[45000, 38000, 52000, 41000, 48000],
    sorgho_tonnes=[35000, 42000, 28000, 39000, 44000],
    mais_tonnes=[28000, 25000, 35000, 30000, 32000],
    population=[2500000, 1800000, 950000, 1200000, 1650000]
)

#CSV.write("$main_path/production.csv", df_production)


