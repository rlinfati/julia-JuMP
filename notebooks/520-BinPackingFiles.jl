### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ c092f70c-d896-11ec-2f00-470b953f694e
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate()
    Pkg.add([Pkg.PackageSpec("PlutoUI")])
    Pkg.status()
end

# ╔═╡ d47f00ac-de50-4e7e-83c0-064ea622bea2
begin
    using PlutoUI
    PlutoUI.TableOfContents()
end

# ╔═╡ 123ed931-5360-4147-a04e-a03f855bbf8e
md"""
# Heuristic for Bin Packing
"""

# ╔═╡ 703d8f5f-8ac3-4a37-9cd3-8f58ba549ef6
function bppheur(c::Int, w::Vector{Int})
    sort!(w, rev = true)
    n = length(w)

    bin = [Int[]]

    for i in 1:n
        u = sum.(bin)
        while true
            id = argmax(u)
            if sum(bin[id]) + w[i] <= c
                push!(bin[id], w[i])
                break
            else
                u[id] = 0
            end
            if sum(u) == 0
                push!(bin, Int[])
                push!(bin[end], w[i])
                break
            end
        end
    end

    return bin
end

# ╔═╡ 4f46ba2b-4da4-4e13-b8bc-bd2af1dc5cef
function bppheur(instance::Function)
    c, w = instance()
    return bppheur(c, w)
end

# ╔═╡ 983cd410-9ca0-4a9a-8788-200e8bbe0eac
function readbpp(f::String)
    v = readlines(f)
    c = parse(Int, v[2])
    w = parse.(Int, v[3:end])
    @assert parse(Int, v[1]) == length(w)
    return c, w
end

# ╔═╡ 51637fd8-8d8f-4cc5-807c-b4a1a12a6264
function writbpp(f::String, c, w)
    open(f, "w") do io
        return writbpp(io, c, w)
    end
    return
end

# ╔═╡ 72be5452-4cbb-4ad2-9233-e77488a5c88c
function writbpp(io::IO, c, w)
    println(io, length(w))
    println(io, c)
    for wi in w
        println(io, wi)
    end
    flush(io)
    return
end

# ╔═╡ e62a6ef0-1d0a-420f-92c4-3efe6e2db523
function writebppsol(f::String, bin)
    open(f, "w") do io
        println(io, "#bin = ", length(bin))
        println(io, "#use = ", sum.(bin))
        return println(io, "bin = ", bin)
    end
    return
end

# ╔═╡ e606a1be-bfd4-437d-8151-3b42092c927e
md"""
## Generate fake instances
"""

# ╔═╡ be637fce-0476-45af-aa55-d22dea58e6d6
dirinput = mktempdir()

# ╔═╡ 27e2a4c8-ca71-4d1e-8923-0d34a84adf79
function instance01()
    w = [50, 3, 48, 53, 53, 4, 3, 41, 23, 20, 52, 49]
    c = 100
    return c, w
end

# ╔═╡ bc7d75ee-14de-4beb-918c-78809241189d
function instanceRNG(n::Int)
    w = rand(1:100, n)
    c = round(Int, sum(w) / 2)
    return c, w
end

# ╔═╡ 36dc012a-f8a1-481b-8485-35c29887708f
instanceRNG30a() = instanceRNG(30)

# ╔═╡ 2dfa0e8e-7597-406e-9795-61c22a97cc11
instanceRNG30b() = instanceRNG(30)

# ╔═╡ 24d9620b-a3b4-4091-a868-d4310622f561
instas = [
    instance01
    () -> instanceRNG(20)
    instanceRNG30a
    instanceRNG30b
]

# ╔═╡ 931c2269-1ba8-40a1-8275-54767f87a639
for inta in instas
    f1, io = mktemp(dirinput)
    c, w = inta()
    writbpp(io, c, w)
    mv(f1, f1 * ".bpp")
end

# ╔═╡ 36282a2a-16d5-40d6-9b11-d72b3d1fabb0
md"""
# Process Files
"""

# ╔═╡ 8facfa1d-0a31-45ef-b2b4-3937a2119824
diroutput = mkpath(joinpath(dirinput, "salida"))

# ╔═╡ 6cf9c03d-bacd-4902-a93f-e01dead74c36
for f in filter(x -> endswith(x, ".bpp"), readdir(dirinput))
    c, w = readbpp(joinpath(dirinput, f))
    bin = bppheur(c, w)
    println("file = ", f, "\t ub = ", length(bin), "\t lb = ", round(sum(w) / c, RoundUp))
    writebppsol(joinpath(diroutput, f * ".log"), bin)
end

# ╔═╡ 518040c6-6ab2-4836-9c80-c319626933a8
md"""
# Process Functions
"""

# ╔═╡ 8a5f1c8a-e52c-40d8-bf7d-10da7f1bb380
dirout = mkpath(joinpath(dirinput, "output"))

# ╔═╡ b08dacd3-d2f2-4f6a-a600-7cf64d1d5af9
for inta in instas
    c, w = inta()
    bin = bppheur(inta)
    println("insta = ", inta, "\t ub = ", length(bin), "\t lb = ", round(sum(w) / c, RoundUp))
    writebppsol(joinpath(dirout, string(inta) * ".log"), bin)
end

# ╔═╡ Cell order:
# ╠═c092f70c-d896-11ec-2f00-470b953f694e
# ╠═123ed931-5360-4147-a04e-a03f855bbf8e
# ╠═703d8f5f-8ac3-4a37-9cd3-8f58ba549ef6
# ╠═4f46ba2b-4da4-4e13-b8bc-bd2af1dc5cef
# ╠═983cd410-9ca0-4a9a-8788-200e8bbe0eac
# ╠═51637fd8-8d8f-4cc5-807c-b4a1a12a6264
# ╠═72be5452-4cbb-4ad2-9233-e77488a5c88c
# ╠═e62a6ef0-1d0a-420f-92c4-3efe6e2db523
# ╠═e606a1be-bfd4-437d-8151-3b42092c927e
# ╠═be637fce-0476-45af-aa55-d22dea58e6d6
# ╠═27e2a4c8-ca71-4d1e-8923-0d34a84adf79
# ╠═bc7d75ee-14de-4beb-918c-78809241189d
# ╠═36dc012a-f8a1-481b-8485-35c29887708f
# ╠═2dfa0e8e-7597-406e-9795-61c22a97cc11
# ╠═24d9620b-a3b4-4091-a868-d4310622f561
# ╠═931c2269-1ba8-40a1-8275-54767f87a639
# ╠═36282a2a-16d5-40d6-9b11-d72b3d1fabb0
# ╠═8facfa1d-0a31-45ef-b2b4-3937a2119824
# ╠═6cf9c03d-bacd-4902-a93f-e01dead74c36
# ╠═518040c6-6ab2-4836-9c80-c319626933a8
# ╠═8a5f1c8a-e52c-40d8-bf7d-10da7f1bb380
# ╠═b08dacd3-d2f2-4f6a-a600-7cf64d1d5af9
# ╠═d47f00ac-de50-4e7e-83c0-064ea622bea2
