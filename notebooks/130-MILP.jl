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

# ╔═╡ 2736db23-a6eb-4b89-ab96-b71f9445f074
begin
    using PlutoUI
    PlutoUI.TableOfContents()
end

# ╔═╡ 76d17b3f-1309-462f-9a25-77cc306ff1f0
md"""
# Modelos de Programación Lineal Entera
"""

# ╔═╡ 5751108d-6a44-4d33-9386-5d811638c6f0
begin
    m = JuMP.Model()

    n = 4
    c = rand(1:100, n, n)

    @variable(m, x[1:n, 1:n] >= 0, Int)
    @objective(m, Min, sum(c .* x))
    @constraint(m, ai[j in 1:n], sum(x[:, j]) == 1)
    @constraint(m, aj[i in 1:n], sum(x[i, :]) == 1)

    JuMP.latex_formulation(m)
end

# ╔═╡ 0c5cea8e-ec2c-42e4-9b53-cca423636d24
md"""
## Solucion con JuMP
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

# ╔═╡ c89a9a9e-b463-4e94-9501-ad3fe1a99101
begin
    @show JuMP.result_count(m)

    @show JuMP.termination_status(m)
    @show JuMP.primal_status(m)
    @show JuMP.dual_status(m)
    @show JuMP.objective_value(m)
    @show JuMP.objective_bound(m)
    @show JuMP.relative_gap(m)

    @show JuMP.solve_time(m)

    nothing
end

# ╔═╡ f220f4eb-b3ce-4ac0-b902-54a1fd4b4b31
xval = JuMP.value.(x)

# ╔═╡ cc1c2666-83fa-4355-9454-78e818d929ec
md"""
## Comparación de sumatorias
"""

# ╔═╡ 716dfd62-7e13-4207-86fe-811b75d9182f
@time sum(c .* x)

# ╔═╡ cf82583c-144d-4344-bdef-178b3821d0b7
@time sum(c[i, j] * x[i, j] for i in 1:n, j in 1:n)

# ╔═╡ 99f91710-725b-4a09-a990-e83e59e5b18a
@time sum(c[i, j] * x[i, j] for i in 1:n for j in 1:n)

# ╔═╡ a0c1d56a-aac7-43fa-a721-79e0c2e2aca7
@time sum(x[:, 2])

# ╔═╡ 1253c0cc-e28f-426f-9cf2-4e70404ae4ea
@time sum(x[i, 2] for i in 1:n)

# ╔═╡ 6c3d6071-eb17-446c-a772-b59c1424cb2b
md"""
## Comparacion de extraccion de valores
"""

# ╔═╡ d64c965c-c8c2-43ec-8cd5-8bdc0129773e
begin
    # warn-up
    JuMP.value.(x) .≈ 1.0
    round.(Int, JuMP.value.(x))
    round.(Bool, JuMP.value.(x))
    nothing
end

# ╔═╡ e9983cb6-43b9-468a-8c70-c12e09d901cb
@time JuMP.value.(x)

# ╔═╡ be2177b3-4468-4fcb-a156-fa84aeb3c676
@time JuMP.value.(x) .≈ 1.0

# ╔═╡ 54034f8e-d846-45fc-ad0a-31920e40114c
@time round.(Int, JuMP.value.(x))

# ╔═╡ 41a557a1-6328-490b-806c-3945acf7a69d
@time round.(Bool, JuMP.value.(x))

# ╔═╡ Cell order:
# ╠═ca2d345e-ac76-11ec-2164-8f36e66bc097
# ╠═ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
# ╠═ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
# ╠═76d17b3f-1309-462f-9a25-77cc306ff1f0
# ╠═5751108d-6a44-4d33-9386-5d811638c6f0
# ╠═0c5cea8e-ec2c-42e4-9b53-cca423636d24
# ╠═fb641ebc-03fb-4792-94e0-6820bbe82793
# ╠═8b49b72d-e39d-4b26-b892-d2c55174814b
# ╠═c89a9a9e-b463-4e94-9501-ad3fe1a99101
# ╠═f220f4eb-b3ce-4ac0-b902-54a1fd4b4b31
# ╠═cc1c2666-83fa-4355-9454-78e818d929ec
# ╠═716dfd62-7e13-4207-86fe-811b75d9182f
# ╠═cf82583c-144d-4344-bdef-178b3821d0b7
# ╠═99f91710-725b-4a09-a990-e83e59e5b18a
# ╠═a0c1d56a-aac7-43fa-a721-79e0c2e2aca7
# ╠═1253c0cc-e28f-426f-9cf2-4e70404ae4ea
# ╠═6c3d6071-eb17-446c-a772-b59c1424cb2b
# ╠═d64c965c-c8c2-43ec-8cd5-8bdc0129773e
# ╠═e9983cb6-43b9-468a-8c70-c12e09d901cb
# ╠═be2177b3-4468-4fcb-a156-fa84aeb3c676
# ╠═54034f8e-d846-45fc-ad0a-31920e40114c
# ╠═41a557a1-6328-490b-806c-3945acf7a69d
# ╠═2736db23-a6eb-4b89-ab96-b71f9445f074
