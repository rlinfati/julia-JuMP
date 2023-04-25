### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ e7262522-ac65-11ec-0633-1d82420161db
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

# ╔═╡ e726254a-ac65-11ec-2f4c-1bead54e006a
using JuMP

# ╔═╡ a28468d5-b6fd-42d1-856f-4b9a8198a4fa
using GLPK

# ╔═╡ e6902e75-32f3-4c61-b564-24ce502f7025
using Plots

# ╔═╡ bb4218e4-06f0-482b-9ab6-55fedd51d429
using Random

# ╔═╡ 6e4cc9ff-4d96-4ef6-a35b-9f5ed393e5fa
begin
    using PlutoUI
    PlutoUI.TableOfContents()
end

# ╔═╡ 66bea84e-7574-494c-abcf-eb8d092e778c
md"""
# Vehicle Routing Problem
"""

# ╔═╡ 4e21d0be-afd3-4e02-84a4-f4a39a2d712f
md"""
## Lectura/Generacion de Instancia
"""

# ╔═╡ 11adffc1-3afe-4f9f-af42-963cbbea30ab
n = 10

# ╔═╡ f9cb6029-062b-436e-968b-9e8e4dd7b8f6
begin
    Random.seed!(1234)
    X = rand(n) * 1_000.0
    Y = rand(n) * 1_000.0
    q = [0, round.(Int, rand(n - 1) * 100)...]
    nK = round(Int, log(n), RoundUp)
    Q = round(Int, sum(q) / log(n))
    n < 15 ? [1:n X Y q] : nothing
end

# ╔═╡ 2d6673cd-7903-4eb1-95c1-c433e15bc2cd
sum(q), Q, nK

# ╔═╡ 72b74a0b-e001-445f-9c65-995c69854951
md"""
### Calculo de matriz de costos
"""

# ╔═╡ c2a2b9e2-170f-44eb-be42-ea3219836e91
begin
    c = [sqrt((X[i] - X[j])^2 + (Y[i] - Y[j])^2) for i in 1:n, j in 1:n]
    n < 15 ? c : nothing
end

# ╔═╡ 249acea1-9778-4e03-9a7e-5636054c3f06
md"""
## Modelo MTZ - 3-index
"""

# ╔═╡ 1c4fc711-8e65-4b77-894c-aeb6d9b08dc3
begin
    m3 = JuMP.Model()

    @variable(m3, xx[1:n, 1:n, 1:nK], Bin)
    @variable(m3, uu[1:n] >= 0) # Miller-Tucker-Zemlin formulation

    @objective(m3, Min, sum(c[:, :] .* sum(xx[:, :, k] for k in 1:nK)))

    @constraint(m3, m3r0[l in 1:n, k in 1:nK], xx[l, l, k] == 0) # FIX
    @constraint(m3, m3r1[j in 2:n], sum(xx[:, j, :]) == 1)
    @constraint(m3, m3r2[i in 2:n], sum(xx[i, :, :]) == 1)
    @constraint(m3, m3r3[k in 1:nK], sum(xx[:, 1, k]) <= 1)
    @constraint(m3, m3r4[k in 1:nK], sum(xx[1, :, k]) <= 1)
    @constraint(m3, m3r5[l in 2:n, k in 1:nK], sum(xx[:, l, k]) == sum(xx[l, :, k]))

    # SEC Miller-Tucker-Zemlin formulation
    @constraint(m3, m3r6, uu[1] == 0)
    @constraint(m3, m3r7[i in 1:n], q[i] <= uu[i] <= Q)
    @constraint(m3, m3r8[i in 1:n, j in 2:n, k in 1:nK], uu[i] + q[j] <= uu[j] + Q * (1 - xx[i, j, k]))

    n < 11 ? JuMP.latex_formulation(m3) : nothing
end

# ╔═╡ a1abd97e-b818-4be1-b7b9-9a6ee786072e
md"""
### Parametros del Solver y Solución
"""

# ╔═╡ 67816b3c-bbd5-4c3e-9ec2-c27b92aaa3a5
begin
    JuMP.set_optimizer(m3, GLPK.Optimizer)
    JuMP.set_optimizer_attribute(m3, "msg_lev", GLP_MSG_ALL)
    JuMP.set_optimizer_attribute(m3, "tm_lim", 60 * 1000)
    JuMP.optimize!(m3)
end

# ╔═╡ bfd49ab7-a63c-4fed-bd72-6c6ce80a845b
JuMP.solution_summary(m3)

# ╔═╡ f4c18b5d-eba2-4de7-80be-55e25b36c539
md"""
## Modelo MTZ - 2-index
"""

# ╔═╡ 53ce78d2-d784-4ecb-9cd8-ffd082947fbe

# ╔═╡ 3f77731c-9b9e-4ac2-bd91-cc7f8e528faf
begin
    m = JuMP.Model()

    @variable(m, x[1:n, 1:n], Bin)
    @variable(m, u[1:n] >= 0) # Miller-Tucker-Zemlin formulation

    @objective(m, Min, sum(c .* x))

    @constraint(m, r0[l in 1:n], x[l, l] == 0) # FIX
    @constraint(m, r1[j in 2:n], sum(x[:, j]) == 1)
    @constraint(m, r2[i in 2:n], sum(x[i, :]) == 1)
    @constraint(m, r3, sum(x[:, 1]) <= nK)
    @constraint(m, r4, sum(x[1, :]) <= nK)

    # SEC Miller-Tucker-Zemlin formulation
    @constraint(m, r5, u[1] == 0)
    @constraint(m, r6[i in 1:n], q[i] <= u[i] <= Q)
    @constraint(m, r8[i in 1:n, j in 2:n], u[i] + q[j] <= u[j] + Q * (1 - x[i, j]))

    n < 11 ? JuMP.latex_formulation(m) : nothing
end

# ╔═╡ 2edd33de-ebd4-484c-a45b-3fe7c6beb597
md"""
### Parametros del Solver y Solución
"""

# ╔═╡ d1b599d9-da3a-4070-90dc-e63532951fd6
begin
    JuMP.set_optimizer(m, GLPK.Optimizer)
    JuMP.set_optimizer_attribute(m, "msg_lev", GLP_MSG_ALL)
    JuMP.set_optimizer_attribute(m, "tm_lim", 15 * 1000)
    JuMP.optimize!(m)
end

# ╔═╡ fc925cdf-ffd8-45ad-a7a9-4c11228fac02
JuMP.solution_summary(m)

# ╔═╡ 21cc515d-d381-445f-a23a-4bc75c81e38c
md"""
### Solución del Solver
"""

# ╔═╡ 2fd0b79d-4740-45aa-a63d-95d2fb41ad81
xval = JuMP.value.(x) .≈ 1.0

# ╔═╡ 9f5687fd-4e49-4d0f-9a15-501cd4978ad4
uval = JuMP.value.(u)

# ╔═╡ ddd6790a-7597-4983-909d-41c11b24110c
md"""
### Solución gráfica
"""

# ╔═╡ c806912b-8bec-4d41-a7f3-0c7654a4ed53
begin
    tours = []
    for _ in 1:nK
        tour = Int[1]
        while true
            id = argmax(xval[tour[end], :])
            xval[tour[end], id] = 0
            push!(tour, id)
            if tour[end] == 1
                break
            end
        end
        if [1, 1] == tour
            continue
        end
        push!(tours, tour)
    end
    tours
end

# ╔═╡ 67d9beae-18c1-4b5a-9d4b-835e5d93e9f1
for k in eachindex(tours)
    println("r", k, ": ", sum(q[tours[k]]), " <= ", Q)
end

# ╔═╡ 4a86c9d9-bd2b-4e2a-a67f-eeeeafb485b2
begin
    zval = 0.0
    for k in eachindex(tours)
        for i in 1:length(tours[k])-1
            zval += c[tours[k][i], tours[k][i+1]]
        end
    end
    zval, JuMP.objective_value(m)
end

# ╔═╡ c2c05477-7c33-480f-b88f-c173487a4a4c
begin
    p = plot(legend = false)
    scatter!(X, Y, color = :blue)
    for i in 1:n
        annotate!(X[i], Y[i], text("$i", :top))
    end

    for tour in tours
        plot!(X[tour], Y[tour], palette = :rainbow)
    end
    p
end

# ╔═╡ Cell order:
# ╠═e7262522-ac65-11ec-0633-1d82420161db
# ╠═e726254a-ac65-11ec-2f4c-1bead54e006a
# ╠═a28468d5-b6fd-42d1-856f-4b9a8198a4fa
# ╠═e6902e75-32f3-4c61-b564-24ce502f7025
# ╠═bb4218e4-06f0-482b-9ab6-55fedd51d429
# ╠═66bea84e-7574-494c-abcf-eb8d092e778c
# ╠═4e21d0be-afd3-4e02-84a4-f4a39a2d712f
# ╠═11adffc1-3afe-4f9f-af42-963cbbea30ab
# ╠═f9cb6029-062b-436e-968b-9e8e4dd7b8f6
# ╠═2d6673cd-7903-4eb1-95c1-c433e15bc2cd
# ╠═72b74a0b-e001-445f-9c65-995c69854951
# ╠═c2a2b9e2-170f-44eb-be42-ea3219836e91
# ╠═249acea1-9778-4e03-9a7e-5636054c3f06
# ╠═1c4fc711-8e65-4b77-894c-aeb6d9b08dc3
# ╠═a1abd97e-b818-4be1-b7b9-9a6ee786072e
# ╠═67816b3c-bbd5-4c3e-9ec2-c27b92aaa3a5
# ╠═bfd49ab7-a63c-4fed-bd72-6c6ce80a845b
# ╠═f4c18b5d-eba2-4de7-80be-55e25b36c539
# ╟─53ce78d2-d784-4ecb-9cd8-ffd082947fbe
# ╠═3f77731c-9b9e-4ac2-bd91-cc7f8e528faf
# ╠═2edd33de-ebd4-484c-a45b-3fe7c6beb597
# ╠═d1b599d9-da3a-4070-90dc-e63532951fd6
# ╠═fc925cdf-ffd8-45ad-a7a9-4c11228fac02
# ╠═21cc515d-d381-445f-a23a-4bc75c81e38c
# ╠═2fd0b79d-4740-45aa-a63d-95d2fb41ad81
# ╠═9f5687fd-4e49-4d0f-9a15-501cd4978ad4
# ╠═ddd6790a-7597-4983-909d-41c11b24110c
# ╠═c806912b-8bec-4d41-a7f3-0c7654a4ed53
# ╠═67d9beae-18c1-4b5a-9d4b-835e5d93e9f1
# ╠═4a86c9d9-bd2b-4e2a-a67f-eeeeafb485b2
# ╠═c2c05477-7c33-480f-b88f-c173487a4a4c
# ╠═6e4cc9ff-4d96-4ef6-a35b-9f5ed393e5fa
