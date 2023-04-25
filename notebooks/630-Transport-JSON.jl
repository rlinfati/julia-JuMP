### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ ca2d345e-ac76-11ec-2164-8f36e66bc097
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate()
    Pkg.add([
        Pkg.PackageSpec("JuMP")
        Pkg.PackageSpec("GLPK")
        Pkg.PackageSpec("JSON")
        Pkg.PackageSpec("PlutoUI")
    ])
    Pkg.status()
end

# ╔═╡ ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
using JuMP

# ╔═╡ ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
using GLPK

# ╔═╡ 4d16271c-f24a-42c4-af86-7d99a753fa7f
using JSON

# ╔═╡ ce53aaee-1c2a-457f-801b-99d680987124
begin
    using PlutoUI
    PlutoUI.TableOfContents()
end

# ╔═╡ 76d17b3f-1309-462f-9a25-77cc306ff1f0
md"""
# Transport Problem
"""

# ╔═╡ 4d280ca9-b971-4d17-baf5-850446630f2a
md"""
## Generación de Instancia
"""

# ╔═╡ 5830787c-f6da-4e56-a07c-d9867e216447
data = JSON.parse("""
{
    "plants": {
        "Seattle": {"capacity": 350},
        "San-Diego": {"capacity": 600}
    },
    "markets": {
        "New-York": {"demand": 300},
        "Chicago": {"demand": 300},
        "Topeka": {"demand": 300}
    },
    "distances": {
        "Seattle => New-York": 2.5,
        "Seattle => Chicago": 1.7,
        "Seattle => Topeka": 1.8,
        "San-Diego => New-York": 2.5,
        "San-Diego => Chicago": 1.8,
        "San-Diego => Topeka": 1.4
    }
}
""")

# ╔═╡ fb651ee7-b9e0-4c11-934b-1fc190e71b8a
md"""
## Modelo en JuMP
"""

# ╔═╡ 55daa79c-57ed-4f7f-9933-82ac75d02573
O = keys(data["plants"])

# ╔═╡ 660d13f9-d7b4-4f8d-86a3-7d9a28afa099
D = keys(data["markets"])

# ╔═╡ 3f5e6e89-fa10-4cfe-8715-4e8a6d923b78
distance(i::String, j::String) = data["distances"]["$(i) => $(j)"]

# ╔═╡ dda77b2b-c0a0-4ba7-bad0-5e779fb07a02
begin
    m = JuMP.Model()

    @variable(m, x[O, D] >= 0)

    @objective(m, Min, sum(distance(i, j) * x[i, j] for i in O, j in D))
    @constraint(m, [i in O], sum(x[i, :]) <= data["plants"][i]["capacity"])
    @constraint(m, [j in D], sum(x[:, j]) >= data["markets"][j]["demand"])

    length(O) + length(D) < 20 ? JuMP.latex_formulation(m) : nothing
end

# ╔═╡ 0c5cea8e-ec2c-42e4-9b53-cca423636d24
md"""
## Parametros del Solver y Solución
"""

# ╔═╡ fb641ebc-03fb-4792-94e0-6820bbe82793
begin
    JuMP.set_optimizer(m, GLPK.Optimizer)
    JuMP.set_optimizer_attribute(m, "msg_lev", GLP_MSG_ALL)
    JuMP.set_optimizer_attribute(m, "tm_lim", 60 * 1000)
    JuMP.optimize!(m)
end

# ╔═╡ 8b49b72d-e39d-4b26-b892-d2c55174814b
JuMP.solution_summary(m)

# ╔═╡ 2a9957f4-9d76-40d9-95b7-c4111482b769
md"""
## Solución del Solver
"""

# ╔═╡ 54034f8e-d846-45fc-ad0a-31920e40114c
xval = JuMP.value.(x)

# ╔═╡ 68b21139-7a01-432d-ae9f-338a5c397b54
Dict([((i, j), xval[i, j]) for i in O, j in D if xval[i, j] > eps()])

# ╔═╡ Cell order:
# ╠═ca2d345e-ac76-11ec-2164-8f36e66bc097
# ╠═ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
# ╠═ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
# ╠═4d16271c-f24a-42c4-af86-7d99a753fa7f
# ╠═76d17b3f-1309-462f-9a25-77cc306ff1f0
# ╠═4d280ca9-b971-4d17-baf5-850446630f2a
# ╠═5830787c-f6da-4e56-a07c-d9867e216447
# ╠═fb651ee7-b9e0-4c11-934b-1fc190e71b8a
# ╠═55daa79c-57ed-4f7f-9933-82ac75d02573
# ╠═660d13f9-d7b4-4f8d-86a3-7d9a28afa099
# ╠═3f5e6e89-fa10-4cfe-8715-4e8a6d923b78
# ╠═dda77b2b-c0a0-4ba7-bad0-5e779fb07a02
# ╠═0c5cea8e-ec2c-42e4-9b53-cca423636d24
# ╠═fb641ebc-03fb-4792-94e0-6820bbe82793
# ╠═8b49b72d-e39d-4b26-b892-d2c55174814b
# ╠═2a9957f4-9d76-40d9-95b7-c4111482b769
# ╠═54034f8e-d846-45fc-ad0a-31920e40114c
# ╠═68b21139-7a01-432d-ae9f-338a5c397b54
# ╠═ce53aaee-1c2a-457f-801b-99d680987124
