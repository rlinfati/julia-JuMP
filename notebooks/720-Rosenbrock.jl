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
        Pkg.PackageSpec("PlutoUI")
    ])
    Pkg.status()
end

# ╔═╡ ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
using JuMP

# ╔═╡ ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
using Ipopt

# ╔═╡ 883faa8b-956a-4707-b2e1-a8c15584dff6
begin
    using PlutoUI
    PlutoUI.TableOfContents()
end

# ╔═╡ 76d17b3f-1309-462f-9a25-77cc306ff1f0
md"""
# Rosenbrock function
"""

# ╔═╡ dda77b2b-c0a0-4ba7-bad0-5e779fb07a02
begin
    m = JuMP.Model()

    @variable(m, x)
    @variable(m, y)
    @NLobjective(m, Min, (1 - x)^2 + 100 * (y - x^2)^2)

    JuMP.latex_formulation(m)
end

# ╔═╡ c47d8551-2317-493c-a67a-0c892fa6dd82
md"""
## Solución del Solver
"""

# ╔═╡ fb641ebc-03fb-4792-94e0-6820bbe82793
begin
    JuMP.set_optimizer(m, Ipopt.Optimizer)
    JuMP.optimize!(m)
end

# ╔═╡ 8b49b72d-e39d-4b26-b892-d2c55174814b
JuMP.solution_summary(m)

# ╔═╡ 49142319-810d-46b5-973b-20c6834ffb8d
md"""
## Solución del Solver
"""

# ╔═╡ 54034f8e-d846-45fc-ad0a-31920e40114c
xval = JuMP.value.([x, y])

# ╔═╡ Cell order:
# ╠═ca2d345e-ac76-11ec-2164-8f36e66bc097
# ╠═ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
# ╠═ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
# ╠═76d17b3f-1309-462f-9a25-77cc306ff1f0
# ╠═dda77b2b-c0a0-4ba7-bad0-5e779fb07a02
# ╠═c47d8551-2317-493c-a67a-0c892fa6dd82
# ╠═fb641ebc-03fb-4792-94e0-6820bbe82793
# ╠═8b49b72d-e39d-4b26-b892-d2c55174814b
# ╠═49142319-810d-46b5-973b-20c6834ffb8d
# ╠═54034f8e-d846-45fc-ad0a-31920e40114c
# ╠═883faa8b-956a-4707-b2e1-a8c15584dff6
