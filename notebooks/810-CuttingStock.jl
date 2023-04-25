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

# ╔═╡ 21d7b1b0-50c5-4922-a784-2d72eb95f5e8
begin
    using PlutoUI
    PlutoUI.TableOfContents()
end

# ╔═╡ c4a7baf8-3fae-4794-8df6-2df1e22245be
md"""
# Cutting Stock Problem
"""

# ╔═╡ 6458921c-42bf-4751-bc78-b72ad0fa0368
md"""
## Generacion de Instancia
"""

# ╔═╡ 5751108d-6a44-4d33-9386-5d811638c6f0
begin
    jumbo_ancho = 100.0
    jumbo_costo = 1.0

    bobina_ancho = Float64[45, 36, 31, 14]
    bobina_demanda = Float64[40, 50, 60, 80]
    bobina_n = length(bobina_ancho)

    @assert length(bobina_ancho) == length(bobina_demanda)
    @assert all(bobina_ancho .<= jumbo_ancho)
    nothing
end

# ╔═╡ 1a187419-c676-4f46-bb43-87af5646bd6c
md"""
## Slave problem
"""

# ╔═╡ 1d70a3da-b5d1-4d72-9175-a122e18dc781
function calculaPatron(
    n::Int,
    ancho::Array{Float64,1},
    maxancho::Float64,
    precioSombra::Array{Float64,1},
    jumbo_costo::Float64,
)
    @assert n == length(ancho)
    @assert n == length(precioSombra)

    mBobina = JuMP.Model(GLPK.Optimizer)
    @variable(mBobina, xx[1:n] >= 0, Int)
    @objective(mBobina, Min, jumbo_costo - sum(precioSombra .* xx))
    @constraint(mBobina, sum(ancho .* xx) <= maxancho)

    JuMP.optimize!(mBobina)

    patron = JuMP.value.(xx)
    rc = JuMP.objective_value(mBobina)

    println("* Problema Esclavo = mBobina")
    println("  z = ", rc)
    println("  Patron = ", patron)

    if rc >= -eps()
        return nothing
    end
    return patron
end

# ╔═╡ 10e93d99-708f-44f9-b50d-149a77f4c521
md"""
## Master problem
"""

# ╔═╡ c47d8551-2317-493c-a67a-0c892fa6dd82
begin
    patrones = [i == j ? 1 : 0 for i in 1:bobina_n, j in 1:bobina_n]
    patron_n = bobina_n

    mCSP = JuMP.Model(GLPK.Optimizer)
    @variable(mCSP, x[1:patron_n] >= 0)
    @objective(mCSP, Min, sum(jumbo_costo * x))
    @constraint(mCSP, r1[i in 1:bobina_n], sum(patrones[i, :] .* x) >= bobina_demanda[i])

    JuMP.optimize!(mCSP)
end

# ╔═╡ 9b960cac-fe88-473b-943c-98b50b458436
md"""
## Column Generation
"""

# ╔═╡ 46028570-c4ab-4cd8-9fd0-46772e9fb57c
while true
    println("* Problema Maestro = Cutting Stock Problema Relax")
    println("  z = ", JuMP.objective_value(mCSP))
    for j in 1:patron_n
        println("  Patron ", j, " = ", patrones[:, j], " usado ", JuMP.value(x[j]), " veces")
    end

    yval = JuMP.dual.(r1)
    println("  Dual Piezas = ", yval)

    nuevo_patron = calculaPatron(bobina_n, bobina_ancho, jumbo_ancho, yval, jumbo_costo)

    if nuevo_patron === nothing
        break
    end

    patron_n += 1
    patrones = [patrones nuevo_patron]

    newX = @variable(mCSP; base_name = "x[$patron_n]", lower_bound = 0)
    push!(x, newX)
    JuMP.set_objective_coefficient(mCSP, newX, jumbo_costo)
    JuMP.set_normalized_coefficient.(r1, newX, nuevo_patron)

    JuMP.optimize!(mCSP)
end

# ╔═╡ d9ac7079-3db4-456e-a150-05309f958a09
md"""
## Set Variable as Integer
"""

# ╔═╡ 7203e722-d5a8-4d0e-a408-b14509bea07d
begin
    JuMP.set_integer.(x)
    JuMP.optimize!(mCSP)
    println("* Problema Cutting Stock")
    println("  z = ", JuMP.objective_value(mCSP))
    for j in 1:patron_n
        println("  Patron ", j, " = ", patrones[:, j], " usado ", JuMP.value(x[j]), " veces")
    end
end

# ╔═╡ Cell order:
# ╠═ca2d345e-ac76-11ec-2164-8f36e66bc097
# ╠═ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
# ╠═ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
# ╠═c4a7baf8-3fae-4794-8df6-2df1e22245be
# ╠═6458921c-42bf-4751-bc78-b72ad0fa0368
# ╠═5751108d-6a44-4d33-9386-5d811638c6f0
# ╠═1a187419-c676-4f46-bb43-87af5646bd6c
# ╠═1d70a3da-b5d1-4d72-9175-a122e18dc781
# ╠═10e93d99-708f-44f9-b50d-149a77f4c521
# ╠═c47d8551-2317-493c-a67a-0c892fa6dd82
# ╠═9b960cac-fe88-473b-943c-98b50b458436
# ╠═46028570-c4ab-4cd8-9fd0-46772e9fb57c
# ╠═d9ac7079-3db4-456e-a150-05309f958a09
# ╠═7203e722-d5a8-4d0e-a408-b14509bea07d
# ╠═21d7b1b0-50c5-4922-a784-2d72eb95f5e8
