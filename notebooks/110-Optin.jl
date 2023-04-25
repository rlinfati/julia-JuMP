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
        Pkg.PackageSpec("Optim")
        Pkg.PackageSpec("JuMP")
        Pkg.PackageSpec("Ipopt")
        Pkg.PackageSpec("Plots")
    ])
    Pkg.status()
end

# ╔═╡ c349935f-7631-4fb5-a723-475798a596ec
using Optim

# ╔═╡ ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
using JuMP

# ╔═╡ dac312f0-28b6-4525-87ff-c50bab5edfaa
using Ipopt

# ╔═╡ 901a223f-d796-4c38-b379-c7ee01943e35
using Statistics

# ╔═╡ 7d414528-acbb-427c-9dc1-991624b5e8e0
using Plots

# ╔═╡ a108e20d-21df-4121-b8ad-a7489a5dfd54
begin
    using PlutoUI
    PlutoUI.TableOfContents()
end

# ╔═╡ a3da1074-7597-4928-b1a4-670729f15950
md"""
# Ajustar una curva
"""

# ╔═╡ c512cfba-fa37-4ed0-9b02-54a2e1e38212
md"""
## Generacion de Instancia
"""

# ╔═╡ 2c9491b7-18cf-4145-8ead-f8c3ad11dbff
n = 10

# ╔═╡ 452831e3-db50-46fa-afdf-da1a02ead9e7
error = 2.0

# ╔═╡ b10222ca-0c5b-408f-8e83-e1ad48f8febe
md"""
$y =  \frac{5}{9} (x - 32) + error$
"""

# ╔═╡ 6fe6c23b-1f1e-413f-b7c7-a5c9799ec8eb
x = sort(rand(-10:100, n))

# ╔═╡ a515afb5-bb7b-47a9-a749-284a7a70cc99
y = 5 / 9 .* (x .- 32) .+ error .* randn.()

# ╔═╡ 3d9327a1-10bf-40c6-8e74-74308bbb757a
-5 / 9 * 32, 5 / 9

# ╔═╡ 47b040e6-3914-4dce-bfd0-7d5782fd3180
begin
    plot(x, y, m = :c, mc = :red, legend = false, ls = :dash)
    xlabel!("°F")
    ylabel!("°C")
end

# ╔═╡ a88af8de-9885-4c7a-bf14-7461d74ed5ab
md"""
## Solucion desde estadistica
"""

# ╔═╡ 8269be24-2a95-499e-a8cd-4b126dc9db45
begin
    m1 = cov(x, y) / var(x) # same as (x.-mean(x))⋅(y.-mean(y))/sum(abs2,x.-mean(x))
    b1 = mean(y) - m1 * mean(x)
    b1, m1
end

# ╔═╡ df0124c3-3421-4375-af6c-93f647d86999
begin
    plot(x, y, m = :c, mc = :red, legend = false, ls = :dash)
    xlabel!("°F")
    ylabel!("°C")
    plot!(x -> m1 * x + b1, lw = 3, alpha = 0.7)
end

# ╔═╡ 2ff1bc90-0a6f-4c05-8ed1-f826993999b1
md"""
## Solución desde Algebra Lineal

$[1 \quad x] * [b \quad m]' = y$

"""

# ╔═╡ b605664f-ad6e-4b03-801f-9950e6a74006
sol2 = [one.(x) x] \ y

# ╔═╡ baa542e0-e707-4680-bf93-0fe114d20367
[one.(x) x] * sol2 - y

# ╔═╡ 2ce34304-2939-4555-9304-378f8a34b8b6
begin
    plot(x, y, m = :c, mc = :red, legend = false, ls = :dash)
    xlabel!("°F")
    ylabel!("°C")
    plot!(x -> sol2[2] * x + sol2[1], lw = 3, alpha = 0.7)
end

# ╔═╡ daae866e-8600-4a34-b219-9c535d7bc710
md"""
## Solución desde Optim
[Optim.jl Documentation](https://julianlsolvers.github.io/Optim.jl/stable/)

$$\min_{b,m} \sum_{i=1}^n  [ (b + m x_i) - y_i]^2$$

"""

# ╔═╡ d9897112-0320-4d57-b6f8-ab4c2f7ab158
begin
    f((b, m)) = sum((b + m * x[i] - y[i])^2 for i in 1:n)
    x0 = [0.0, 0.0]
    result = optimize(f, x0, GradientDescent(), autodiff = :forward)
    println(result)
    sol3 = result.minimizer
end

# ╔═╡ 90956681-cfda-4692-8b31-71bf1db0303b
begin
    plot(x, y, m = :c, mc = :red, legend = false, ls = :dash)
    xlabel!("°F")
    ylabel!("°C")
    plot!(x -> sol3[2] * x + sol3[1], lw = 3, alpha = 0.7)
end

# ╔═╡ c959003c-4d6e-46c2-b68d-ca843b30108b
md"""
## Solución desde JuMP
[JuMP.jl Documentation](https://jump.dev/JuMP.jl/stable/)

JuMP = Julia for Mathematical Programming
"""

# ╔═╡ c03d9603-8b82-420b-9e1b-a39ed5bdb53d
begin
    model = JuMP.Model()

    @variable(model, b)
    @variable(model, m)

    @objective(model, Min, sum((b + m * x[i] - y[i])^2 for i in 1:n))

    JuMP.set_optimizer(model, Ipopt.Optimizer)
    JuMP.set_optimizer_attribute(model, "print_level", 0)
    JuMP.optimize!(model)

    sol4 = JuMP.value.([b, m])
end

# ╔═╡ 8bd5fe00-0172-47cb-ab4e-d6b301029549
begin
    plot(x, y, m = :c, mc = :red, legend = false, ls = :dash)
    xlabel!("°F")
    ylabel!("°C")
    plot!(x -> sol4[2] * x + sol4[1], lw = 3, alpha = 0.7)
end

# ╔═╡ Cell order:
# ╠═ca2d345e-ac76-11ec-2164-8f36e66bc097
# ╠═c349935f-7631-4fb5-a723-475798a596ec
# ╠═ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
# ╠═dac312f0-28b6-4525-87ff-c50bab5edfaa
# ╠═901a223f-d796-4c38-b379-c7ee01943e35
# ╠═7d414528-acbb-427c-9dc1-991624b5e8e0
# ╠═a3da1074-7597-4928-b1a4-670729f15950
# ╠═c512cfba-fa37-4ed0-9b02-54a2e1e38212
# ╠═2c9491b7-18cf-4145-8ead-f8c3ad11dbff
# ╠═452831e3-db50-46fa-afdf-da1a02ead9e7
# ╠═b10222ca-0c5b-408f-8e83-e1ad48f8febe
# ╠═6fe6c23b-1f1e-413f-b7c7-a5c9799ec8eb
# ╠═a515afb5-bb7b-47a9-a749-284a7a70cc99
# ╠═3d9327a1-10bf-40c6-8e74-74308bbb757a
# ╠═47b040e6-3914-4dce-bfd0-7d5782fd3180
# ╠═a88af8de-9885-4c7a-bf14-7461d74ed5ab
# ╠═8269be24-2a95-499e-a8cd-4b126dc9db45
# ╠═df0124c3-3421-4375-af6c-93f647d86999
# ╠═2ff1bc90-0a6f-4c05-8ed1-f826993999b1
# ╠═b605664f-ad6e-4b03-801f-9950e6a74006
# ╠═baa542e0-e707-4680-bf93-0fe114d20367
# ╠═2ce34304-2939-4555-9304-378f8a34b8b6
# ╠═daae866e-8600-4a34-b219-9c535d7bc710
# ╠═d9897112-0320-4d57-b6f8-ab4c2f7ab158
# ╠═90956681-cfda-4692-8b31-71bf1db0303b
# ╠═c959003c-4d6e-46c2-b68d-ca843b30108b
# ╠═c03d9603-8b82-420b-9e1b-a39ed5bdb53d
# ╠═8bd5fe00-0172-47cb-ab4e-d6b301029549
# ╠═a108e20d-21df-4121-b8ad-a7489a5dfd54
