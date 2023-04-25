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
        Pkg.PackageSpec("Distributions")
        Pkg.PackageSpec("Plots")
        Pkg.PackageSpec("PlutoUI")
    ])
    Pkg.status()
end

# ╔═╡ 3a3bf26c-0e98-4d2e-8a41-bf810d19d31b
using Distributions

# ╔═╡ 921250b2-b216-49be-9ca5-47a4a27e6e52
using Plots

# ╔═╡ fe362e7d-3c4c-4f7a-9bd5-e1c2b2b253bc
begin
    using PlutoUI
    PlutoUI.TableOfContents()
end

# ╔═╡ e763f27d-f6fc-4ab4-90ba-0130ec11e38d
md"""
# Distribuciones
"""

# ╔═╡ 2d3f5748-f8df-4012-a2db-963dfdca8786
md"""
## Distribución Normal
"""

# ╔═╡ d7318d85-2b16-473c-a366-f3f7156a9008
begin
    dn = Distributions.Normal(0.0, 1.0)
    xn = rand(dn, 100_000)
    @show mean(xn)
    @show std(xn)
    @show var(xn)
    plot(xn, seriestype = :hist)
end

# ╔═╡ 3d2b0875-3117-4039-90ae-0cbc7373998a
Distributions.fit_mle(Normal, xn)

# ╔═╡ 990d137c-6a39-4c3b-86f9-02b51daf509e
Distributions.quantile(dn, 0.5000), Distributions.quantile(dn, 0.9772), Distributions.quantile(dn, 0.9986)

# ╔═╡ f4bc0fce-1038-47a1-987a-87af0507a44f
Distributions.cdf(dn, 0.0), Distributions.cdf(dn, 2.0), Distributions.cdf(dn, 3.0)

# ╔═╡ 10b40e42-cf7c-4626-9f53-3c40f132c8f4
md"""
## Distribución Exponencial
"""

# ╔═╡ 66819aef-dacd-4ffd-9bc5-348fadd959a9
begin
    de = Distributions.Exponential(1.0)
    xe = rand(de, 100_000)
    @show mean(xe)
    @show std(xe)
    @show var(xe)
    plot(xe, seriestype = :hist)
end

# ╔═╡ 2288ba3b-3665-4432-8d43-1be0964620d0
md"""
## Distribución Poisson
"""

# ╔═╡ 9413e192-fd55-454b-9d89-665e7186f4ec
begin
    dp = Distributions.Poisson(1.0)
    xp = rand(dp, 100_000)
    @show mean(xp)
    @show std(xp)
    @show var(xp)
    plot(xp, seriestype = :hist)
end

# ╔═╡ ef6a54bd-417e-4aa2-ba27-661624bfe9b2
md"""
## Distribución Chi Square
"""

# ╔═╡ 543ab4d7-2fa0-4d3c-b200-98b2a2590484
begin
    dc = Distributions.Chisq(30)
    xc = rand(dc, 100_000)
    @show mean(xc)
    @show std(xc)
    @show var(xc)
    plot(xc, seriestype = :hist)
end

# ╔═╡ 5171e1a1-4e1b-4624-a2f6-f2320a9ceed5
md"""
# Proceso Aleatorio
"""

# ╔═╡ 642bf6df-0d5c-4c87-83a0-3f0207c73ef8
begin
    p2 = 0.5
    x2 = [5; zeros(200)]

    for i in eachindex(x2)
        if i == length(x2)
            continue
        end
        sube = x2[i] + (x2[i] < 10)
        baja = x2[i] - (x2[i] > 0)
        x2[i+1] = rand() < p2 ? sube : baja
    end
    [0:length(x2)-1 x2]
end

# ╔═╡ d370aa37-a15e-4c15-982f-5e68b045862b
plot(x2; ylims = (0, 11))

# ╔═╡ 6e7f3973-bfa1-4c55-8ea0-0f3b77625834
md"""
# Cola M/M/1
"""

# ╔═╡ 15e9f747-75de-41f5-995c-19a6c599f7ea
begin
    λ = 1 / 45
    μ = 1 / 20
    nothing
end

# ╔═╡ ca324be3-9cf6-4a69-b6c9-4d75bf203b29
begin
    local ρ = λ / μ
    local W = inv(μ - λ)
    local Wq = ρ * W
    ρ, W, Wq
end

# ╔═╡ ea07145c-ca89-4df9-a6f7-51dd890fea8b
n = 1e3

# ╔═╡ 69ea79f5-8c61-4344-99b0-ea98393a014b
begin
    din = Distributions.Exponential(1 / λ)
    dout = Distributions.Exponential(1 / μ)

    sum_rout = 0.0
    sum_w = 0.0
    diff_t = 0.0

    tin = 0.0
    tout = 0.0

    for _ in 1:n
        rin = rand(din)
        rout = rand(dout)

        sum_rout += rout
        sum_w += max(0.0, tout - tin - rin)

        tin += rin
        tout = max(tin, tout) + rout

        diff_t += tout - tin
    end

    local ρ = sum_rout / tout
    local W = diff_t / n
    local Wq = sum_w / n

    ρ, W, Wq
end

# ╔═╡ Cell order:
# ╠═36184f24-de30-11ec-3a6f-6962a488690c
# ╠═3a3bf26c-0e98-4d2e-8a41-bf810d19d31b
# ╠═921250b2-b216-49be-9ca5-47a4a27e6e52
# ╠═e763f27d-f6fc-4ab4-90ba-0130ec11e38d
# ╠═2d3f5748-f8df-4012-a2db-963dfdca8786
# ╠═d7318d85-2b16-473c-a366-f3f7156a9008
# ╠═3d2b0875-3117-4039-90ae-0cbc7373998a
# ╠═990d137c-6a39-4c3b-86f9-02b51daf509e
# ╠═f4bc0fce-1038-47a1-987a-87af0507a44f
# ╠═10b40e42-cf7c-4626-9f53-3c40f132c8f4
# ╠═66819aef-dacd-4ffd-9bc5-348fadd959a9
# ╠═2288ba3b-3665-4432-8d43-1be0964620d0
# ╠═9413e192-fd55-454b-9d89-665e7186f4ec
# ╠═ef6a54bd-417e-4aa2-ba27-661624bfe9b2
# ╠═543ab4d7-2fa0-4d3c-b200-98b2a2590484
# ╠═5171e1a1-4e1b-4624-a2f6-f2320a9ceed5
# ╠═642bf6df-0d5c-4c87-83a0-3f0207c73ef8
# ╠═d370aa37-a15e-4c15-982f-5e68b045862b
# ╠═6e7f3973-bfa1-4c55-8ea0-0f3b77625834
# ╠═15e9f747-75de-41f5-995c-19a6c599f7ea
# ╠═ca324be3-9cf6-4a69-b6c9-4d75bf203b29
# ╠═ea07145c-ca89-4df9-a6f7-51dd890fea8b
# ╠═69ea79f5-8c61-4344-99b0-ea98393a014b
# ╠═fe362e7d-3c4c-4f7a-9bd5-e1c2b2b253bc
