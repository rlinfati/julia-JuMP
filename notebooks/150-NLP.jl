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
        Pkg.PackageSpec("Plots")
        Pkg.PackageSpec("PlutoUI")
    ])
    Pkg.status()
end

# ╔═╡ ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
using JuMP

# ╔═╡ c384ad42-abbc-4e4a-aeec-9d3a6505f7aa
using Ipopt

# ╔═╡ 7d414528-acbb-427c-9dc1-991624b5e8e0
using Plots

# ╔═╡ 0d7320df-f4b4-41e8-9919-1edcd899e97e
begin
    using PlutoUI
    PlutoUI.TableOfContents()
end

# ╔═╡ 68f3a4b0-45ab-4c44-83bf-511570cfdc74
md"""
# Modelo de Programación No Lineal No Convexa 
$f(x) = x^3$
"""

# ╔═╡ 0c4bd17b-ddda-44ec-befc-426cf5cc25a9
begin
    m = JuMP.Model()

    @variable(m, x >= -1_000)
    @NLobjective(m, Min, x^3)

    JuMP.latex_formulation(m)
end

# ╔═╡ 870fc9f3-49a7-4533-9b28-e4723172bb28
plot(x -> x^3, -10_000, 10_000)

# ╔═╡ f208e024-4015-41e7-afcb-0b6ef9c01b31
md"""
## Ipopt
"""

# ╔═╡ dda77b2b-c0a0-4ba7-bad0-5e779fb07a02
begin
    JuMP.set_optimizer(m, Ipopt.Optimizer)
    JuMP.set_optimizer_attribute(m, "print_level", 3)
    JuMP.optimize!(m)
end

# ╔═╡ 9cbef049-6a4d-4a84-b592-9a59f094afd8
JuMP.solution_summary(m)

# ╔═╡ 210796a2-b697-4c2c-b0af-efa887712e80
JuMP.value.(x)

# ╔═╡ Cell order:
# ╠═ca2d345e-ac76-11ec-2164-8f36e66bc097
# ╠═ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
# ╠═c384ad42-abbc-4e4a-aeec-9d3a6505f7aa
# ╠═7d414528-acbb-427c-9dc1-991624b5e8e0
# ╠═68f3a4b0-45ab-4c44-83bf-511570cfdc74
# ╠═0c4bd17b-ddda-44ec-befc-426cf5cc25a9
# ╠═870fc9f3-49a7-4533-9b28-e4723172bb28
# ╠═f208e024-4015-41e7-afcb-0b6ef9c01b31
# ╠═dda77b2b-c0a0-4ba7-bad0-5e779fb07a02
# ╠═9cbef049-6a4d-4a84-b592-9a59f094afd8
# ╠═210796a2-b697-4c2c-b0af-efa887712e80
# ╠═0d7320df-f4b4-41e8-9919-1edcd899e97e
