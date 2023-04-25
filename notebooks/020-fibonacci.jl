### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ ca2d345e-ac76-11ec-2164-8f36e66bc097
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate()
    Pkg.add([Pkg.PackageSpec("PlutoUI")])
    Pkg.status()
end

# ╔═╡ bb093d3f-c528-42b8-81b6-2248caea82ef
begin
    using PlutoUI
    PlutoUI.TableOfContents()
end

# ╔═╡ f2e2e89d-58f4-4cc2-b162-6720ab9d38e6
md"""
# Fibonacci
"""

# ╔═╡ ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
n = 40

# ╔═╡ 26d0dda4-f5fa-42e5-a7be-a0954f0db231
md"""
## Fibonacci exponencial
"""

# ╔═╡ 58c2ea61-c9b4-4454-b74f-6c3f8af51ec7
function fib_recursive(n::Int)
    if n == 1 || n == 0
        return n
    end
    return fib_recursive(n - 1) + fib_recursive(n - 2)
end

# ╔═╡ c47d8551-2317-493c-a67a-0c892fa6dd82
@timev fib_recursive(n)

# ╔═╡ 71974dc5-d253-426e-8f24-4d05dc2ed967
md"""
## Fibonacci lineal
"""

# ╔═╡ 0c5cea8e-ec2c-42e4-9b53-cca423636d24
function fib_iterative(n::Int)
    x = 0
    y = 1
    z = 1
    for _ in 1:n
        x = y
        y = z
        z = x + y
    end
    return x
end

# ╔═╡ 8b49b72d-e39d-4b26-b892-d2c55174814b
@timev fib_iterative(n)

# ╔═╡ 6472b894-d073-4a51-a87d-b9b6f948b545
md"""
## Fibonacci logaritmico
"""

# ╔═╡ c89a9a9e-b463-4e94-9501-ad3fe1a99101
function fib_matrix(n::Int)
    if n == 0
        return 0
    end
    F = [1 1; 1 0]^(n - 1)
    return F[1, 1]
end

# ╔═╡ 886ec68e-3134-40fd-bf61-4346e12caa25
@timev fib_matrix(n)

# ╔═╡ ae216f03-b47d-4a38-9af8-67cc22655081
md"""
## Fibonacci constante
"""

# ╔═╡ 70dbab2e-0520-4f51-bd01-b902e420cbc4
function fib_magic(n::Int)
    ϕ = (1 + √5) / 2.0
    return round(Int, ϕ^n / √5)
end

# ╔═╡ c96fd875-b1f7-4115-8b0c-f1454343fe35
@timev fib_magic(n)

# ╔═╡ Cell order:
# ╠═ca2d345e-ac76-11ec-2164-8f36e66bc097
# ╠═f2e2e89d-58f4-4cc2-b162-6720ab9d38e6
# ╠═ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
# ╠═26d0dda4-f5fa-42e5-a7be-a0954f0db231
# ╠═58c2ea61-c9b4-4454-b74f-6c3f8af51ec7
# ╠═c47d8551-2317-493c-a67a-0c892fa6dd82
# ╠═71974dc5-d253-426e-8f24-4d05dc2ed967
# ╠═0c5cea8e-ec2c-42e4-9b53-cca423636d24
# ╠═8b49b72d-e39d-4b26-b892-d2c55174814b
# ╠═6472b894-d073-4a51-a87d-b9b6f948b545
# ╠═c89a9a9e-b463-4e94-9501-ad3fe1a99101
# ╠═886ec68e-3134-40fd-bf61-4346e12caa25
# ╠═ae216f03-b47d-4a38-9af8-67cc22655081
# ╠═70dbab2e-0520-4f51-bd01-b902e420cbc4
# ╠═c96fd875-b1f7-4115-8b0c-f1454343fe35
# ╠═bb093d3f-c528-42b8-81b6-2248caea82ef
