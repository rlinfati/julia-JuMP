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
        Pkg.PackageSpec("Ipopt")
        Pkg.PackageSpec("SCIP")
        Pkg.PackageSpec("PlutoUI")
    ])
    Pkg.status()
end

# ╔═╡ ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
using JuMP

# ╔═╡ ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
using Ipopt

# ╔═╡ c17f3c0d-f311-47b2-880a-c4acf8695374
using SCIP

# ╔═╡ 4d16271c-f24a-42c4-af86-7d99a753fa7f
using Statistics

# ╔═╡ 8267cb29-e308-4030-a5e8-8af579a90409
begin
    using PlutoUI
    PlutoUI.TableOfContents()
end

# ╔═╡ 76d17b3f-1309-462f-9a25-77cc306ff1f0
md"""
# Portfolio Optimization
"""

# ╔═╡ 419f8347-bde9-4a57-b676-25fb97e60028
md"""
## Generacion de Instancia
"""

# ╔═╡ 8a14c5b5-c03a-4af6-bc2c-ec4cc03ac7cf
stock_data = [
    93.043 51.826 1.063
    84.585 52.823 0.938
    111.453 56.477 1.000
    99.525 49.805 0.938
    95.819 50.287 1.438
    114.708 51.521 1.700
    111.515 51.531 2.540
    113.211 48.664 2.390
    104.942 55.744 3.120
    99.827 47.916 2.980
    91.607 49.438 1.900
    107.937 51.336 1.750
    115.590 55.081 1.800
]

# ╔═╡ bbb8eb6e-5b87-481c-b5ef-c516ba7bcf75
md"""
## Calculo de parametros
"""

# ╔═╡ 5830787c-f6da-4e56-a07c-d9867e216447
begin
    stock_returns = Array{Float64}(undef, 12, 3)
    for i in 1:12
        stock_returns[i, :] = (stock_data[i+1, :] .- stock_data[i, :]) ./ stock_data[i, :]
    end
    stock_returns
end

# ╔═╡ 55daa79c-57ed-4f7f-9933-82ac75d02573
r = Statistics.mean(stock_returns, dims = 1) |> vec

# ╔═╡ 660d13f9-d7b4-4f8d-86a3-7d9a28afa099
Q = Statistics.cov(stock_returns)

# ╔═╡ a0492a34-5047-4cb6-9d55-dfd3ec1667a4
md"""
## JuMP Model
"""

# ╔═╡ dda77b2b-c0a0-4ba7-bad0-5e779fb07a02
begin
    m = JuMP.Model()
    t, n = size(stock_returns)

    @variable(m, x[1:n] >= 0)
    @objective(m, Min, x' * Q * x)
    @constraint(m, sum(x) <= 1_000)
    @constraint(m, sum(r .* x) >= 50)

    JuMP.latex_formulation(m)
end

# ╔═╡ 668de117-3dda-42c8-975d-c34d796bdf19
md"""
## Parametros del Solver y Solución
"""

# ╔═╡ fb641ebc-03fb-4792-94e0-6820bbe82793
begin
    JuMP.set_optimizer(m, Ipopt.Optimizer)
    JuMP.optimize!(m)
end

# ╔═╡ 8b49b72d-e39d-4b26-b892-d2c55174814b
JuMP.solution_summary(m)

# ╔═╡ 2e4413a8-cb7f-4c13-9325-91dbd8a80228
md"""
## Solución del Solver
"""

# ╔═╡ 54034f8e-d846-45fc-ad0a-31920e40114c
xval = JuMP.value.(x)

# ╔═╡ 1b196e5e-25a1-40b6-821b-f2f3d7b52751
md"""
# MINLP Model, max number of stock
"""

# ╔═╡ 124109a5-f633-4fca-8f03-e29f54ff20ba
md"""
## JuMP Model
"""

# ╔═╡ 712f0c29-4e94-45b7-b4f2-9c0c0e9bef35
begin
    m2 = JuMP.copy(m)
    x2 = m2[:x]
    BigM = 9_999.9

    @variable(m2, y[1:n], Bin)
    @constraint(m2, x2 .<= BigM * y)
    @constraint(m2, sum(y) <= 2)

    JuMP.latex_formulation(m2)
end

# ╔═╡ 022fa150-7011-4b73-a215-c8868193461d
md"""
## Parametros del Solver y Solución
"""

# ╔═╡ d657d986-0cf5-48c8-af08-fd1ee48400d3
begin
    JuMP.set_optimizer(m2, SCIP.Optimizer)
    JuMP.set_optimizer_attribute(m2, "display/verblevel", 3)
    JuMP.set_optimizer_attribute(m2, "limits/time", 60)
    JuMP.optimize!(m2)
end

# ╔═╡ b608224f-b13f-4c93-b560-412086dffd92
JuMP.solution_summary(m2)

# ╔═╡ 44a6faa0-57cb-477b-b661-508a406e179b
md"""
## Solución del Solver
"""

# ╔═╡ 09013d14-12ff-4b13-a64a-37e894c0c4fa
xval2 = JuMP.value.(x2)

# ╔═╡ 04d6f3aa-1552-4c84-8a46-3d7897319ca7
yval2 = JuMP.value.(y)

# ╔═╡ Cell order:
# ╠═ca2d345e-ac76-11ec-2164-8f36e66bc097
# ╠═ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
# ╠═ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
# ╠═c17f3c0d-f311-47b2-880a-c4acf8695374
# ╠═4d16271c-f24a-42c4-af86-7d99a753fa7f
# ╠═76d17b3f-1309-462f-9a25-77cc306ff1f0
# ╠═419f8347-bde9-4a57-b676-25fb97e60028
# ╠═8a14c5b5-c03a-4af6-bc2c-ec4cc03ac7cf
# ╠═bbb8eb6e-5b87-481c-b5ef-c516ba7bcf75
# ╠═5830787c-f6da-4e56-a07c-d9867e216447
# ╠═55daa79c-57ed-4f7f-9933-82ac75d02573
# ╠═660d13f9-d7b4-4f8d-86a3-7d9a28afa099
# ╠═a0492a34-5047-4cb6-9d55-dfd3ec1667a4
# ╠═dda77b2b-c0a0-4ba7-bad0-5e779fb07a02
# ╠═668de117-3dda-42c8-975d-c34d796bdf19
# ╠═fb641ebc-03fb-4792-94e0-6820bbe82793
# ╠═8b49b72d-e39d-4b26-b892-d2c55174814b
# ╠═2e4413a8-cb7f-4c13-9325-91dbd8a80228
# ╠═54034f8e-d846-45fc-ad0a-31920e40114c
# ╠═1b196e5e-25a1-40b6-821b-f2f3d7b52751
# ╠═124109a5-f633-4fca-8f03-e29f54ff20ba
# ╠═712f0c29-4e94-45b7-b4f2-9c0c0e9bef35
# ╠═022fa150-7011-4b73-a215-c8868193461d
# ╠═d657d986-0cf5-48c8-af08-fd1ee48400d3
# ╠═b608224f-b13f-4c93-b560-412086dffd92
# ╠═44a6faa0-57cb-477b-b661-508a406e179b
# ╠═09013d14-12ff-4b13-a64a-37e894c0c4fa
# ╠═04d6f3aa-1552-4c84-8a46-3d7897319ca7
# ╠═8267cb29-e308-4030-a5e8-8af579a90409
