### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try
            Base.loaded_modules[Base.PkgId(
                Base.UUID("6e696c72-6542-2067-7265-42206c756150"),
                "AbstractPlutoDingetjes",
            )].Bonds.initial_value
        catch
            b -> missing
        end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ ca2d345e-ac76-11ec-2164-8f36e66bc097
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate()
    Pkg.add([
        Pkg.PackageSpec("JuMP")
        Pkg.PackageSpec("GLPK")
        Pkg.PackageSpec("Plots")
        Pkg.PackageSpec("PlutoUI")
    ])
    Pkg.status()
end

# ╔═╡ 3cf93033-c7f6-4f1b-8b0c-b3010bd270c7
using LinearAlgebra

# ╔═╡ ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
using JuMP

# ╔═╡ ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
using GLPK

# ╔═╡ ecf4bf57-9815-4ac3-a155-e238eb41a72a
using Plots

# ╔═╡ b182e8e4-6b11-41e2-8cde-5f912c799aa5
begin
    using PlutoUI
    PlutoUI.TableOfContents()
end

# ╔═╡ 76d17b3f-1309-462f-9a25-77cc306ff1f0
md"""
# Modelos de Programación Lineal

Empresas Collao S.A. se dedica a la fabricacion de computadores y celulares, las cuales puede vender a $3.000 y $5.000 pesos respectivamente.

Los computadores deben pasar por la planta 1, donde son creadas las piezas, necesitando de tres horas de trabajo; luego deben ir a ensamble en la planta 3, donde requieren de 3 horas de trabajo.

Los celulares deben pasar por la planta 2, donde son creadas las piezas, necesitando de dos horas de trabajo; luego deben ir a ensamble en la planta 3, donde requieren de 2 horas de trabajo.

En las plantas 1, 2, y 3 existe una disponibilidad de 4, 12, y 18 horas de trabajo.

Empresas Collao S.A. busca determinar la mejor combinación de productos a fabricar para maximizar su utilidad
"""

# ╔═╡ 5751108d-6a44-4d33-9386-5d811638c6f0
begin
    m = JuMP.Model()

    @variable(m, x[1:2] >= 0)

    @objective(m, Max, 3 * x[1] + 5 * x[2])

    @constraint(m, r1, 1 * x[1] <= 4)
    @constraint(m, r2, 2 * x[2] <= 12)
    @constraint(m, r3, 3 * x[1] + 2 * x[2] <= 18)

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
    @show JuMP.dual_objective_value(m)

    @show JuMP.solve_time(m)

    nothing
end

# ╔═╡ 9ceafe98-dda3-4cd6-a04e-3a174a23ace1
xval = JuMP.value.(x)

# ╔═╡ bcef0edc-75e6-476b-a5c4-3c1f32ef6a50
md"""
## Solucion Grafica
"""

# ╔═╡ b740735f-bf35-4bbf-8f6f-d24bf9c324fc
md"""
r1 = $( @bind s1 PlutoUI.CheckBox(true) )
r2 = $( @bind s2 PlutoUI.CheckBox(true) )
r3 = $( @bind s3 PlutoUI.CheckBox(true) )
rf = $( @bind s4 PlutoUI.CheckBox(false) )
sb = $( @bind s5 PlutoUI.CheckBox(false) )
"""

# ╔═╡ b87e51c3-d336-4d5f-83a2-e0fc64115164
begin
    p = Plots.plot()
    Plots.xlims!(0, 7)
    Plots.ylims!(0, 10)

    t = range(0, 7, length = 100)
    f1 = 4 * one.(t)
    f2(t) = 12 / 2
    f3(t) = 18 / 2 - 3 / 2 * t

    s1 && Plots.plot!([(0, 0), (4, 0), (4, 10), (0, 10)], fill = (0, 0.3), label = "x_1 <= 4")
    s2 && Plots.plot!(f2, 0, 7, fill = (0, 0.3), label = "2*x_2 <= 12")
    s3 && Plots.plot!(f3, 0, 6, fill = (0, 0.3), label = "3*x_1+2*x_2 <= 18")

    rf = Plots.Shape([(0, 0), (4, 0), (4, 3), (2, 6), (0, 6), (0, 0)])
    s4 && Plots.plot!(rf, fill = (0, 0.7), label = "Region Factible")

    s5 && Plots.annotate!(0, 0, "z(0,0)=0", :left)
    s5 && Plots.annotate!(4, 0, "z(4,0)=12", :left)
    s5 && Plots.annotate!(4, 3, "z(4,3)=27", :left)
    s5 && Plots.annotate!(2, 6, "z(2,6)=36", :left)
    s5 && Plots.annotate!(0, 6, "z(0,6)=30", :left)
    p
end

# ╔═╡ 8fc5037e-eb67-4552-9413-9cb637416e8f
md"""
## Tableau Simplex (Primal)
"""

# ╔═╡ b9dcb9e7-b24f-44b4-8ffe-5fddf3f7b2f7
function nextSimplex(xx, c, A, b)
    nn = length(c)
    mm = length(b)

    cc = vcat(c, zeros(mm))
    AA = hcat(A, LinearAlgebra.I(mm)) |> Matrix
    bb = b

    cb = cc[xx]
    BB = AA[:, xx]
    rc = hcat(cb' * inv(BB) * A - c', cb' * inv(BB))' |> Vector

    zobj = cb' * inv(BB) * b
    xvar = xx
    xval = inv(BB) * b

    println("rc   = ", rc)
    println("zobj = ", zobj)
    println("xvar = ", xvar)
    println("xval = ", xval)
    println()

    vin = argmin(rc)
    if rc[vin] > -eps()
        return
    end

    AAA = hcat(inv(BB) * A, inv(BB))
    bbb = inv(BB) * b
    bAcol = [(bbb[i] / AAA[i, vin], i) for i in 1:mm if AAA[i, vin] > eps()]

    nout = bAcol[argmin(bAcol)][2]
    vout = 0

    for i in eachindex(xx)
        if xx[i]
            nout -= 1
        end
        if nout == 0
            vout = i
            break
        end
    end

    xx[vin] = true
    xx[vout] = false

    return xx
end

# ╔═╡ d414c318-5311-4295-a0df-81aa990f13f6
begin
    c = [3, 5]
    A = [
        1 0
        0 2
        3 2
    ]
    b = [
        4
        12
        18
    ]

    xx = vcat(falses(length(c)), trues(length(b)))
end

# ╔═╡ 35fa1e02-4652-4e2d-88ba-8b8876a7f039
while true
    xx = nextSimplex(xx, c, A, b)
    if xx === nothing
        break
    end
end

# ╔═╡ e1b21fa5-c0b0-492f-9a47-3fda7729b3be
md"""
## Dualidad con JuMP
"""

# ╔═╡ ae26d6a4-25c0-4807-ac4a-4c3d4a439c39
begin
    @show JuMP.dual.([r1, r2, r3])
    @show JuMP.shadow_price.([r1, r2, r3])

    @show JuMP.reduced_cost.(x)
    nothing
end

# ╔═╡ a2db0ef9-c3bd-4012-bee3-777378498b52
md"""
## Sensibilidad con JuMP
"""

# ╔═╡ 7e123efd-f2d5-418b-bfee-ec474ed122d9
report = JuMP.lp_sensitivity_report(m)

# ╔═╡ a43f4e19-50e5-4100-a7e4-fc9b7920a410
JuMP.lp_sensitivity_report(m).objective

# ╔═╡ f89e9e74-7398-4a4e-9bf8-e71e79ae25e2
JuMP.lp_sensitivity_report(m).rhs

# ╔═╡ 95f5f964-84a6-4e0d-9929-44abaf27f0b2
for i in JuMP.all_variables(m)
    xval = JuMP.value(i)
    dx_lo, dx_hi = report[i]
    fo = JuMP.objective_function(m)
    c = JuMP.coefficient(fo, i)
    rc = JuMP.reduced_cost(i)
    println("$i=$xval \t -> rc = $rc \t Δ: ($dx_lo, $dx_hi) \t -> α: ($(c+dx_lo):$(c+dx_hi))")
end

# ╔═╡ 0c97e0cb-3ba6-49cc-a318-72a830e32460
for i in list_of_constraint_types(m)
    if i[1] == VariableRef
        continue
    end

    for j in JuMP.all_constraints(m, i[1], i[2])
        ys = JuMP.shadow_price(j)
        b = JuMP.normalized_rhs(j)

        dRHS_lo, dRHS_hi = report[j]
        println("$j \t -> shadow_price: $ys \t -> Δ: ($dRHS_lo, $dRHS_hi) \t -> α: ($(b+dRHS_lo):$(b+dRHS_hi))")
    end
end

# ╔═╡ 7d40baf1-cef6-4129-9d25-d3fedd5d9562
md"""
## Extraer coeficientes con JuMP
"""

# ╔═╡ 1b7e7126-2058-4754-af0f-1f86cfed99e3
xvar = JuMP.all_variables(m)

# ╔═╡ 267520c0-6c60-44a5-8be0-091f54ce7716
JuMP.list_of_constraint_types(m)

# ╔═╡ a448257f-7a83-48cd-a420-b6efc87d2a48
JuMP.all_constraints.(m, JuMP.AffExpr, JuMP.MOI.LessThan{Float64})

# ╔═╡ 661fdbd3-e224-449d-8d27-933e33957929
JuMP.normalized_rhs.([r1, r2, r3])

# ╔═╡ e1951570-5b4e-4701-b97b-c00ee37f62f0
JuMP.normalized_coefficient.(r1, xvar)

# ╔═╡ d04f1f77-6a2d-4146-aef9-47048a81e279
JuMP.normalized_coefficient.([r1, r2, r3], x[1])

# ╔═╡ 610bd411-2542-4dc3-87f2-b1c9c33fe41c
JuMP.objective_function(m)

# ╔═╡ 0cd96605-4629-43f5-9c5d-53df48f5c5f4
md"""
## Escribir y Leer el modelo con JuMP
"""

# ╔═╡ 8fe050e4-3364-44b3-8174-6e910f0b8f4d
begin
    path, io = mktemp()
    JuMP.write_to_file(m, path, format = JuMP.MOI.FileFormats.FORMAT_LP)
    JuMP.read_from_file(path, format = JuMP.MOI.FileFormats.FORMAT_LP)
end

# ╔═╡ 1e313e3d-790a-4480-8fc7-f87515c7a86e
md"""
## Modelo en utf-8
"""

# ╔═╡ 65bd0a30-2648-48a1-a9d9-fcacc785ded9
begin
    ㊭ = JuMP.Model()

    @variable(㊭, 💻 >= 0)
    @variable(㊭, 📱 >= 0)

    @objective(㊭, Max, 3💻 + 5📱)

    @constraint(㊭, 💻 <= 4)
    @constraint(㊭, 2📱 <= 12)
    @constraint(㊭, 3💻 + 2📱 <= 18)

    JuMP.latex_formulation(㊭)
end

# ╔═╡ cff115f7-6ba9-456b-bd33-d2705fd3e36b
md"""
## modelo PL con conjuntos
"""

# ╔═╡ 0063d4cf-e3ea-4a25-8d08-87b83f627968
animales = ["perro", "gato", "pollo", "vaca", "chancho"]

# ╔═╡ 58d6bba8-697c-465b-b4ac-5930e2412b1d
let
    m = JuMP.Model()

    @variable(m, x[animales] >= 0)
    @objective(m, Max, sum(x[j] for j in animales if 'a' in j))
    @constraint(m, sum(x) <= 123)

    JuMP.latex_formulation(m)
end

# ╔═╡ f814b8dc-1a88-431c-a520-8006234efecf
md"""
## modelo PL con diccionarios
"""

# ╔═╡ 58c4e3e2-b8b8-4c65-9221-8e0d06b189c9
pesoAnimales = Dict("perro" => 20.0, "gato" => 5.0, "pollo" => 2.0, "vaca" => 720.0, "chancho" => 150.0)

# ╔═╡ 1c1cccbf-16e9-4ec9-8bf1-6e8441b61cc0
let
    m = JuMP.Model()

    @variable(m, x[eachindex(pesoAnimales)] >= 0)
    @objective(m, Max, sum(x))
    @constraint(m, sum(v * x[k] for (k, v) in pesoAnimales) <= 123)

    JuMP.latex_formulation(m)
end

# ╔═╡ Cell order:
# ╠═ca2d345e-ac76-11ec-2164-8f36e66bc097
# ╠═3cf93033-c7f6-4f1b-8b0c-b3010bd270c7
# ╠═ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
# ╠═ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
# ╠═ecf4bf57-9815-4ac3-a155-e238eb41a72a
# ╠═76d17b3f-1309-462f-9a25-77cc306ff1f0
# ╠═5751108d-6a44-4d33-9386-5d811638c6f0
# ╠═0c5cea8e-ec2c-42e4-9b53-cca423636d24
# ╠═fb641ebc-03fb-4792-94e0-6820bbe82793
# ╠═8b49b72d-e39d-4b26-b892-d2c55174814b
# ╠═c89a9a9e-b463-4e94-9501-ad3fe1a99101
# ╠═9ceafe98-dda3-4cd6-a04e-3a174a23ace1
# ╠═bcef0edc-75e6-476b-a5c4-3c1f32ef6a50
# ╠═b740735f-bf35-4bbf-8f6f-d24bf9c324fc
# ╠═b87e51c3-d336-4d5f-83a2-e0fc64115164
# ╠═8fc5037e-eb67-4552-9413-9cb637416e8f
# ╠═b9dcb9e7-b24f-44b4-8ffe-5fddf3f7b2f7
# ╠═d414c318-5311-4295-a0df-81aa990f13f6
# ╠═35fa1e02-4652-4e2d-88ba-8b8876a7f039
# ╠═e1b21fa5-c0b0-492f-9a47-3fda7729b3be
# ╠═ae26d6a4-25c0-4807-ac4a-4c3d4a439c39
# ╠═a2db0ef9-c3bd-4012-bee3-777378498b52
# ╠═7e123efd-f2d5-418b-bfee-ec474ed122d9
# ╠═a43f4e19-50e5-4100-a7e4-fc9b7920a410
# ╠═f89e9e74-7398-4a4e-9bf8-e71e79ae25e2
# ╠═95f5f964-84a6-4e0d-9929-44abaf27f0b2
# ╠═0c97e0cb-3ba6-49cc-a318-72a830e32460
# ╠═7d40baf1-cef6-4129-9d25-d3fedd5d9562
# ╠═1b7e7126-2058-4754-af0f-1f86cfed99e3
# ╠═267520c0-6c60-44a5-8be0-091f54ce7716
# ╠═a448257f-7a83-48cd-a420-b6efc87d2a48
# ╠═661fdbd3-e224-449d-8d27-933e33957929
# ╠═e1951570-5b4e-4701-b97b-c00ee37f62f0
# ╠═d04f1f77-6a2d-4146-aef9-47048a81e279
# ╠═610bd411-2542-4dc3-87f2-b1c9c33fe41c
# ╠═0cd96605-4629-43f5-9c5d-53df48f5c5f4
# ╠═8fe050e4-3364-44b3-8174-6e910f0b8f4d
# ╠═1e313e3d-790a-4480-8fc7-f87515c7a86e
# ╠═65bd0a30-2648-48a1-a9d9-fcacc785ded9
# ╠═cff115f7-6ba9-456b-bd33-d2705fd3e36b
# ╠═0063d4cf-e3ea-4a25-8d08-87b83f627968
# ╠═58d6bba8-697c-465b-b4ac-5930e2412b1d
# ╠═f814b8dc-1a88-431c-a520-8006234efecf
# ╠═58c4e3e2-b8b8-4c65-9221-8e0d06b189c9
# ╠═1c1cccbf-16e9-4ec9-8bf1-6e8441b61cc0
# ╠═b182e8e4-6b11-41e2-8cde-5f912c799aa5
