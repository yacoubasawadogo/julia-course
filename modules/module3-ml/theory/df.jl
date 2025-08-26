using DataFrames
using Statistics
using CSV

#main_path = "/Users/rskalmogo/teaching/julia-programming/class/julia-course/modules/module3-ml/theory"


#df_members = CSV.read("$main_path/membres.csv", DataFrame)


# Données sur la production agricole au Burkina Faso
#= df_production = DataFrame(
    region=["Centre", "Nord", "Sud-Ouest", "Est", "Boucle du Mouhoun"],
    mil_tonnes=[45000, 38000, 52000, 41000, 48000],
    sorgho_tonnes=[35000, 42000, 28000, 39000, 44000],
    mais_tonnes=[28000, 25000, 35000, 30000, 32000],
    population=[2500000, 1800000, 950000, 1200000, 1650000]
) =#

#CSV.write("$main_path/production.csv", df_production)
#= 
groupes_region = groupby(df_production, :region)
result = combine(groupes_region, :mil_tonnes => mean => :production_moyenne_mil) =#
#println(result)

#= stats_par_region = combine(groupes_region,
    :mil_tonnes => mean => :prod_moyenne_mil,
    :sorgho_tonnes => maximum => :prod_max_sor,
    :mais_tonnes => minimum => :prod_min_mais,
    :population => sum => :population_totale
)
 =#
#println(stats_par_region)

## Groupement multiple
#= df_multi_annees = DataFrame(
    region=repeat(["Centre", "Nord", "Sud-Ouest"], 3),
    annee=repeat([2021, 2022, 2023], inner=3),
    production_mais=[45000, 38000, 52000, 47000, 40000, 54000, 49000, 42000, 56000],
    production_mil=[35000, 28000, 42000, 37000, 30000, 44000, 39000, 32000, 46000],
) =#


#println(df_multi_annees)

#= multi_group = groupby(df_multi_annees, [:region, :annee])

stats_region_annee = combine(multi_group,
    [:production_mais, :production_mil] => ((x, y) -> x .+ y) => :production_totale)

println(stats_region_annee)
 =#

df_production = DataFrame(
    region=["Centre", "Nord", "Sud-Ouest", "Est", "Boucle du Mouhoun"],
    mil_tonnes=[missing, 38000, 52000, 41000, 48000],
    sorgho_tonnes=[35000, 42000, 28000, missing, 44000],
    mais_tonnes=[28000, 25000, 35000, 30000, 32000],
    population=[2500000, 1800000, 950000, 1200000, 1650000]
)

df_coordonnees = DataFrame(
    region=["Centre", "Nord", "Sud-Ouest", "Est"],
    latitude=[12.3714, 13.5000, 11.1800, 11.7833],
    longitude=[-1.5197, -2.0000, -3.2000, 0.5333],
    chef_lieu=["Ouagadougou", "Ouahigouya", "Gaoua", "Fada N'Gourma"]
)

# Jointure interne (inner join)
df_complet_innerjoin = innerjoin(df_production, df_coordonnees, on=:region)
#= 
println(df_complet_innerjoin) =#

def_leftjoin = leftjoin(df_production, df_coordonnees, on=:region)
#= 
println(def_leftjoin) =#

df_coordonnees2 = DataFrame(
    region=["Centre", "Nord", "Sud-Ouest", "Est", "Inexistante"],
    latitude=[12.3714, 13.5000, 11.1800, 11.7833, 1],
    longitude=[-1.5197, -2.0000, -3.2000, 0.5333, 1],
    chef_lieu=["Ouagadougou", "Ouahigouya", "Gaoua", "Fada N'Gourma", "Inconnu"]
)

df_outer = outerjoin(df_production, df_coordonnees2, on=:region)

println(df_outer)

println(dropmissing(df_outer))