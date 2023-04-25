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
        Pkg.PackageSpec("Plots")
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

# ╔═╡ 921250b2-b216-49be-9ca5-47a4a27e6e52
using Plots

# ╔═╡ e763f27d-f6fc-4ab4-90ba-0130ec11e38d
using PlutoUI

# ╔═╡ Cell order:
# ╠═36184f24-de30-11ec-3a6f-6962a488690c
# ╠═3a3bf26c-0e98-4d2e-8a41-bf810d19d31b
# ╠═478ba342-7945-4a58-b31f-e24cfe3286e7
# ╠═921250b2-b216-49be-9ca5-47a4a27e6e52
# ╠═e763f27d-f6fc-4ab4-90ba-0130ec11e38d
