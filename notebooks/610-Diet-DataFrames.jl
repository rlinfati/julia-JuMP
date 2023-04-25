### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ e7262522-ac65-11ec-0633-1d82420161db
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate()
    Pkg.add([
        Pkg.PackageSpec("JuMP")
        Pkg.PackageSpec("GLPK")
        Pkg.PackageSpec("DataFrames")
        Pkg.PackageSpec("PlutoUI")
    ])
    Pkg.status()
end

# ╔═╡ e726254a-ac65-11ec-2f4c-1bead54e006a
using JuMP

# ╔═╡ a28468d5-b6fd-42d1-856f-4b9a8198a4fa
using GLPK

# ╔═╡ e75ea348-10fd-4ed6-b258-c7dd398bb26f
using DataFrames

# ╔═╡ 318d621d-4158-4aee-8ff1-100cdb4925d9
begin
    using PlutoUI
    PlutoUI.TableOfContents()
end

# ╔═╡ 66bea84e-7574-494c-abcf-eb8d092e778c
md"""
# The Diet Problem
"""

# ╔═╡ 5fae7b57-3e98-4793-8163-81e21eb1c536
md"""
## Generación de Instancia
"""

# ╔═╡ f9cb6029-062b-436e-968b-9e8e4dd7b8f6
foods = DataFrames.DataFrame(
    [
        "hamburger" 2.49 410 24 26 730
        "chicken" 2.89 420 32 10 1190
        "hot dog" 1.50 560 20 32 1800
        "fries" 1.89 380 4 19 270
        "macaroni" 2.09 320 12 10 930
        "pizza" 1.99 320 15 12 820
        "salad" 2.49 320 31 12 1230
        "milk" 0.89 100 8 2.5 125
        "ice cream" 1.59 330 8 10 180
    ],
    ["name", "cost", "calories", "protein", "fat", "sodium"],
)

# ╔═╡ 72b74a0b-e001-445f-9c65-995c69854951
limits = DataFrames.DataFrame(
    [
        "calories" 1800 2200
        "protein" 91 Inf
        "fat" 0 65
        "sodium" 0 1779
    ],
    ["name", "min", "max"],
)

# ╔═╡ fe63dd19-00de-4785-b3bc-413609f0f9e7
md"""
## Modelo en JuMP
"""

# ╔═╡ 3f77731c-9b9e-4ac2-bd91-cc7f8e528faf
begin
    m = JuMP.Model()

    @variable(m, x[foods.name] >= 0)
    @objective(m, Min, sum(food["cost"] * x[food["name"]] for food in eachrow(foods)))

    for limit in eachrow(limits)
        intake = @expression(m, sum(food[limit["name"]] * x[food["name"]] for food in eachrow(foods)))
        @constraint(m, limit.min <= intake <= limit.max)
    end

    nrow(foods) + ncol(foods) < 20 ? JuMP.latex_formulation(m) : nothing
end

# ╔═╡ 6f243129-5719-4ac8-aea1-28a662dccc1f
md"""
## Parametros del Solver y Solución
"""

# ╔═╡ d1b599d9-da3a-4070-90dc-e63532951fd6
begin
    JuMP.set_optimizer(m, GLPK.Optimizer)
    JuMP.set_optimizer_attribute(m, "msg_lev", GLP_MSG_ALL)
    JuMP.set_optimizer_attribute(m, "tm_lim", 60 * 1000)
    JuMP.optimize!(m)
end

# ╔═╡ fc925cdf-ffd8-45ad-a7a9-4c11228fac02
JuMP.solution_summary(m)

# ╔═╡ c9e6e9f7-db19-4e1b-b705-4afc81b73f67
md"""
## Solución del Solver
"""

# ╔═╡ 2fd0b79d-4740-45aa-a63d-95d2fb41ad81
xval = JuMP.value.(x)

# ╔═╡ 8a14706e-0ac6-475d-b162-3046c33eaa44
Dict([(food, xval[food]) for food in foods.name])

# ╔═╡ Cell order:
# ╠═e7262522-ac65-11ec-0633-1d82420161db
# ╠═e726254a-ac65-11ec-2f4c-1bead54e006a
# ╠═a28468d5-b6fd-42d1-856f-4b9a8198a4fa
# ╠═e75ea348-10fd-4ed6-b258-c7dd398bb26f
# ╠═66bea84e-7574-494c-abcf-eb8d092e778c
# ╠═5fae7b57-3e98-4793-8163-81e21eb1c536
# ╠═f9cb6029-062b-436e-968b-9e8e4dd7b8f6
# ╠═72b74a0b-e001-445f-9c65-995c69854951
# ╠═fe63dd19-00de-4785-b3bc-413609f0f9e7
# ╠═3f77731c-9b9e-4ac2-bd91-cc7f8e528faf
# ╠═6f243129-5719-4ac8-aea1-28a662dccc1f
# ╠═d1b599d9-da3a-4070-90dc-e63532951fd6
# ╠═fc925cdf-ffd8-45ad-a7a9-4c11228fac02
# ╠═c9e6e9f7-db19-4e1b-b705-4afc81b73f67
# ╠═2fd0b79d-4740-45aa-a63d-95d2fb41ad81
# ╠═8a14706e-0ac6-475d-b162-3046c33eaa44
# ╠═318d621d-4158-4aee-8ff1-100cdb4925d9
