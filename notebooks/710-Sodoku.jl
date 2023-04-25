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
        Pkg.PackageSpec("PlutoUI")
    ])
    Pkg.status()
end

# ╔═╡ ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
using JuMP

# ╔═╡ ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
using GLPK

# ╔═╡ 2d397b08-f4bb-4c21-9a0e-9dee77539076
begin
    using PlutoUI
    PlutoUI.TableOfContents()
end

# ╔═╡ 4bbf7e75-566d-4f4d-9fba-44d6def871de
md"""
# MIP as Sodoku Generator
"""

# ╔═╡ 1d70a3da-b5d1-4d72-9175-a122e18dc781
begin
    m = JuMP.Model()

    @variable(m, x[i in 1:9, j in 1:9, k in 1:9], Bin)

    @constraint(m, r1[j in 1:9, k in 1:9], sum(x[:, j, k]) == 1)
    @constraint(m, r2[i in 1:9, k in 1:9], sum(x[i, :, k]) == 1)
    @constraint(m, r3[i in 1:9, j in 1:9], sum(x[i, j, :]) == 1)

    @constraint(m, r4[r in 0:2, s in 0:2, k in 1:9], sum(x[i+3r, j+3s, k] for i in 1:3, j in 1:3) == 1)

    nothing
end

# ╔═╡ 62b7c333-0ad8-4048-b5ed-d074c43a8db6
md"""
## Parametros del Solver y Solución
"""

# ╔═╡ a16e54d1-ef42-47dc-8d74-d6445c42c428
begin
    JuMP.set_optimizer(m, GLPK.Optimizer)
    JuMP.set_optimizer_attribute(m, "msg_lev", GLP_MSG_ALL)
    JuMP.set_optimizer_attribute(m, "tm_lim", 60 * 1000)
    JuMP.optimize!(m)
end

# ╔═╡ c837b5d2-76ca-4741-a254-6d72c37cbe5e
JuMP.solution_summary(m)

# ╔═╡ c6e59b64-6c9a-4bce-bb55-6b7aacb194ef
md"""
## Solución del Solver
"""

# ╔═╡ 1a1b23fe-fb4b-4e40-b1b3-59d995e0e27c
xval = round.(Int, JuMP.value.(x))

# ╔═╡ 67fbbeeb-4dfd-489b-a12f-0ac51cb2691a
sol = [sum(k * xval[i, j, k] for k in 1:9) for i in 1:9, j in 1:9]

# ╔═╡ d6b18576-5098-4046-a4c2-b06546ad17f6
md"""
# MIP as Sodoku Solver
"""

# ╔═╡ 0d054bb8-23ce-43b0-ac52-405dbde9092e
md"""
## Generacion de Instancia
"""

# ╔═╡ ddc96a6e-8b22-433d-a8e9-de2f36c9b5c4
parSol = [
    5 3 0 0 7 0 0 0 0
    6 0 0 1 9 5 0 0 0
    0 9 8 0 0 0 0 6 0
    8 0 0 0 6 0 0 0 3
    4 0 0 8 0 3 0 0 1
    7 0 0 0 2 0 0 0 6
    0 6 0 0 0 0 2 8 0
    0 0 0 4 1 9 0 0 5
    0 0 0 0 8 0 0 7 9
]

# ╔═╡ c9673c2d-0f91-48e2-be2b-9c72819823cc
md"""
## Modify JuMP Model
"""

# ╔═╡ 7de1d0e2-ca5a-438b-bf31-5a25e44e10ce
begin
    m2 = JuMP.copy(m)
    x2 = m2[:x]
    for i in 1:9, j in 1:9
        if parSol[i, j] != 0
            JuMP.fix(x2[i, j, parSol[i, j]], 1)
        end
    end
end

# ╔═╡ c3ae47c5-262c-4a72-8987-40771e0d6f7b
md"""
## Parametros del Solver y Solución
"""

# ╔═╡ 3abea7e9-fd9d-402e-9429-f03f24019a2e
begin
    JuMP.set_optimizer(m2, GLPK.Optimizer)
    JuMP.set_optimizer_attribute(m2, "msg_lev", GLP_MSG_ALL)
    JuMP.set_optimizer_attribute(m2, "tm_lim", 60 * 1000)
    JuMP.optimize!(m2)
end

# ╔═╡ 0da56218-4059-4d24-8a33-cec0f7cad36e
JuMP.solution_summary(m2)

# ╔═╡ 97217fbb-e7ce-4145-87d9-883acfc5298d
md"""
## Solución del Solver
"""

# ╔═╡ 834a2d2a-023e-4c11-8078-ef4c050a5d16
begin
    xval2 = round.(Int, JuMP.value.(x2))
    sol2 = [sum(k * xval2[i, j, k] for k in 1:9) for i in 1:9, j in 1:9]
end

# ╔═╡ Cell order:
# ╠═ca2d345e-ac76-11ec-2164-8f36e66bc097
# ╠═ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
# ╠═ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
# ╠═4bbf7e75-566d-4f4d-9fba-44d6def871de
# ╠═1d70a3da-b5d1-4d72-9175-a122e18dc781
# ╠═62b7c333-0ad8-4048-b5ed-d074c43a8db6
# ╠═a16e54d1-ef42-47dc-8d74-d6445c42c428
# ╠═c837b5d2-76ca-4741-a254-6d72c37cbe5e
# ╠═c6e59b64-6c9a-4bce-bb55-6b7aacb194ef
# ╠═1a1b23fe-fb4b-4e40-b1b3-59d995e0e27c
# ╠═67fbbeeb-4dfd-489b-a12f-0ac51cb2691a
# ╠═d6b18576-5098-4046-a4c2-b06546ad17f6
# ╠═0d054bb8-23ce-43b0-ac52-405dbde9092e
# ╠═ddc96a6e-8b22-433d-a8e9-de2f36c9b5c4
# ╠═c9673c2d-0f91-48e2-be2b-9c72819823cc
# ╠═7de1d0e2-ca5a-438b-bf31-5a25e44e10ce
# ╠═c3ae47c5-262c-4a72-8987-40771e0d6f7b
# ╠═3abea7e9-fd9d-402e-9429-f03f24019a2e
# ╠═0da56218-4059-4d24-8a33-cec0f7cad36e
# ╠═97217fbb-e7ce-4145-87d9-883acfc5298d
# ╠═834a2d2a-023e-4c11-8078-ef4c050a5d16
# ╠═2d397b08-f4bb-4c21-9a0e-9dee77539076
