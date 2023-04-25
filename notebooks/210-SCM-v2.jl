### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ 36184f24-de30-11ec-3a6f-6962a488690c
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

# ╔═╡ 3a3bf26c-0e98-4d2e-8a41-bf810d19d31b
using JuMP

# ╔═╡ 478ba342-7945-4a58-b31f-e24cfe3286e7
using GLPK

# ╔═╡ 547bd60c-1c22-4ee1-a5f5-65fe7b4cd3be
begin
    using PlutoUI
    PlutoUI.TableOfContents()
end

# ╔═╡ 2d31ecaf-cdd3-4940-8a99-c331762f80d4
md"""
# Supply Chain Management
"""

# ╔═╡ 1aa7de14-489d-45cc-a19f-f083a826f3e4
md"""
## Generacion de Instancia
"""

# ╔═╡ ece63d10-d3bc-49f3-8e58-080b7d3e0bbf
begin
    nE1 = 2 # proveedores
    nE2 = 3 # fabricas
    nE3 = 1 # distribuidores
    nE4 = 1 # minoristas
    nE5 = 2 # clientes

    nMP = 3 # materias primas

    # costo del ciclo de adquisicion
    c12 = [
        1 2 3
        2 1 3
    ]

    # costo del ciclo de fabricaicon
    c23 = [
        1
        1
        1
    ]

    # costo del ciclo de reabastecimiento
    c34 = [1]

    # costo del ciclo de pedido
    c45 = [2 3]

    # oferta en los proveedores de cada materia prima
    oferta = [
        100 200 300
        150 300 450
    ]

    # demanda de cada uno de los clientes
    demanda = [
        75
        25
    ]

    # composicion de materia prima del producto final
    mezcla = [2 3 4]

    nothing
end

# ╔═╡ 4729443f-8d32-402d-b212-24a6ed974e1d
md"""
## Modelo con JuMP
"""

# ╔═╡ 44597fa9-e99c-4278-8e4d-9351e162d3f0
begin
    m = JuMP.Model()

    @variable(m, x12mp[1:nE1, 1:nE2, 1:nMP] >= 0)
    @variable(m, x12f[1:nE2] >= 0)
    @variable(m, x23[1:nE2, 1:nE3] >= 0)
    @variable(m, x34[1:nE3, 1:nE4] >= 0)
    @variable(m, x45[1:nE4, 1:nE5] >= 0)

    @objective(
        m,
        Min,
        sum(c12 .* sum(x12mp[:, :, i] for i in 1:nMP)) + sum(c23 .* x23) + sum(c34 .* x34) + sum(c45 .* x45)
    )

    @constraint(m, r01[i in 1:nE1, k in 1:nMP], sum(x12mp[i, :, k]) <= oferta[i, k])
    @constraint(m, r10[j in 1:nE2, k in 1:nMP], sum(x12mp[:, j, k]) == mezcla[k] * x12f[j])

    @constraint(m, r02[j in 1:nE2], x12f[j] == sum(x23[j, :]))

    @constraint(m, r3[j in 1:nE3], sum(x23[:, j]) == sum(x34[j, :]))
    @constraint(m, r4[j in 1:nE4], sum(x34[:, j]) == sum(x45[j, :]))
    @constraint(m, r5[j in 1:nE5], sum(x45[:, j]) >= demanda[j])

    JuMP.latex_formulation(m)
end

# ╔═╡ 9c14f498-0dc2-4f4a-8d98-8f38041b0bbf
md"""
## Parametros del Solver y Solución
"""

# ╔═╡ 6ebd1e6a-a97a-4519-a54c-3a8c91b6415c
begin
    JuMP.set_optimizer(m, GLPK.Optimizer)
    JuMP.set_optimizer_attribute(m, "msg_lev", GLP_MSG_ALL)
    JuMP.set_optimizer_attribute(m, "tm_lim", 60 * 1000)
    JuMP.optimize!(m)
end

# ╔═╡ c595be02-18c9-44f0-924e-6e9cbf37b61f
JuMP.solution_summary(m)

# ╔═╡ 335f10e2-821f-4a7c-9cb3-696f9c86dbd5
md"""
## Solución del Solver
"""

# ╔═╡ ebad38a8-a78d-404f-b75f-6e90954e497d
JuMP.value.(x12mp)

# ╔═╡ afe59531-cad0-4e40-ac30-e79c0eda32f6
JuMP.value.(x12f)

# ╔═╡ 4dfc5104-9579-4f69-bbb9-24b2cea90cd2
JuMP.value.(x23)

# ╔═╡ b29bfe14-7527-479d-b2f5-09d9998c0212
JuMP.value.(x34)

# ╔═╡ a20e2166-1b8b-422b-893f-c05344b64ec2
JuMP.value.(x45)

# ╔═╡ 4075e30e-4dec-4e91-82d2-4b42ae47fc1d
JuMP.dual.(r01)

# ╔═╡ d1c40ff6-4ce8-44fc-814e-509b9c8fc023
JuMP.dual.(r10)

# ╔═╡ 2f820464-b236-4013-bbfa-a802e392f8ee
JuMP.dual.(r02)

# ╔═╡ 50438444-f086-45ff-90d7-92d3e0b85e50
JuMP.dual.(r3)

# ╔═╡ f4b13a28-8eeb-495b-ab9d-490f05fc5bd0
JuMP.dual.(r4)

# ╔═╡ e54193eb-97d5-44e8-b2cb-64d3fd87c7ac
JuMP.dual.(r5)

# ╔═╡ Cell order:
# ╠═36184f24-de30-11ec-3a6f-6962a488690c
# ╠═3a3bf26c-0e98-4d2e-8a41-bf810d19d31b
# ╠═478ba342-7945-4a58-b31f-e24cfe3286e7
# ╠═2d31ecaf-cdd3-4940-8a99-c331762f80d4
# ╠═1aa7de14-489d-45cc-a19f-f083a826f3e4
# ╠═ece63d10-d3bc-49f3-8e58-080b7d3e0bbf
# ╠═4729443f-8d32-402d-b212-24a6ed974e1d
# ╠═44597fa9-e99c-4278-8e4d-9351e162d3f0
# ╠═9c14f498-0dc2-4f4a-8d98-8f38041b0bbf
# ╠═6ebd1e6a-a97a-4519-a54c-3a8c91b6415c
# ╠═c595be02-18c9-44f0-924e-6e9cbf37b61f
# ╠═335f10e2-821f-4a7c-9cb3-696f9c86dbd5
# ╠═ebad38a8-a78d-404f-b75f-6e90954e497d
# ╠═afe59531-cad0-4e40-ac30-e79c0eda32f6
# ╠═4dfc5104-9579-4f69-bbb9-24b2cea90cd2
# ╠═b29bfe14-7527-479d-b2f5-09d9998c0212
# ╠═a20e2166-1b8b-422b-893f-c05344b64ec2
# ╠═4075e30e-4dec-4e91-82d2-4b42ae47fc1d
# ╠═d1c40ff6-4ce8-44fc-814e-509b9c8fc023
# ╠═2f820464-b236-4013-bbfa-a802e392f8ee
# ╠═50438444-f086-45ff-90d7-92d3e0b85e50
# ╠═f4b13a28-8eeb-495b-ab9d-490f05fc5bd0
# ╠═e54193eb-97d5-44e8-b2cb-64d3fd87c7ac
# ╠═547bd60c-1c22-4ee1-a5f5-65fe7b4cd3be
