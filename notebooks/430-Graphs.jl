### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ 36184f24-de30-11ec-3a6f-6962a488690c
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate()
    Pkg.add(
        [
            Pkg.PackageSpec("Graphs")
            Pkg.PackageSpec("GraphPlot")
            Pkg.PackageSpec("SimpleWeightedGraphs")
            Pkg.PackageSpec("MetaGraphs")
            Pkg.PackageSpec("PlutoUI")
        ],
    )
    Pkg.status()
end

# ╔═╡ d83f600a-2b47-4a1d-a8c4-7fa8fe84ae1f
using Graphs

# ╔═╡ b3c1b45e-f1cf-407c-94d5-cbd41bd60241
using GraphPlot

# ╔═╡ 9ac0de36-6e62-474e-b563-bc170b861603
using SimpleWeightedGraphs

# ╔═╡ 801d336f-8f8a-474c-925b-587a850cb004
using MetaGraphs

# ╔═╡ 257e75dc-b908-4ac1-a8fc-568989470273
begin
    using PlutoUI
    PlutoUI.TableOfContents()
end

# ╔═╡ e10b0b33-cd8e-4664-99de-1da3bf289043
md"""
# Graphs
"""

# ╔═╡ a7aa982c-cb05-4c05-ab45-8047290406a0
md"""
## SimpleGraph
"""

# ╔═╡ 6f322974-57c1-46dd-b595-ca59ed75bb21
begin
    G = SimpleDiGraph(3) # SimpleGraph vs SimpleDiGraph
    add_edge!(G, 1, 2)
    add_edge!(G, 1, 3)
    add_edge!(G, 2, 3)
    add_vertex!(G)
    add_edge!(G, 4, 3)
    add_edge!(G, 4, 2)
    add_edge!(G, 4, 4)
    G
end

# ╔═╡ 685e9f8f-866b-4aec-8b22-f1060375ca87
nv(G), ne(G)

# ╔═╡ c462883a-dcf0-4861-9e57-612b9166147b
neighbors(G, 2)

# ╔═╡ 4faf7048-fd7c-4d79-b0ad-f58b49c3cb58
has_self_loops(G)

# ╔═╡ 3999f1cf-e4bf-4dff-82e2-d5498d000361
is_directed(G)

# ╔═╡ d5b56c88-68ea-49bb-b626-acc17cdce81f
adjacency_matrix(G)

# ╔═╡ 79c5f4c6-5e06-4433-8475-77d8da1b7b13
SimpleDiGraph([
    0 1 1 0
    0 0 1 0
    0 0 0 0
    0 1 1 1
]) == G

# ╔═╡ 36d0d903-38b3-4710-a59f-11541640a23a
gplot(G, nodelabel = 1:nv(G), edgelabel = 'a':1:'a'+ne(G)-1)

# ╔═╡ 030152d9-e7da-4ff4-88ce-ed7a066a4b1b
for e in edges(G)
    u, v = src(e), dst(e)
    println("edge $u - $v")
end

# ╔═╡ 2fccff30-b9e6-4283-b991-d826bc6b7f19
md"""
## WeightedGraphs
"""

# ╔═╡ ca890c2d-10dd-4dcc-89b9-c4ce1f3c85ef
begin
    sources = [1, 1, 2]
    destinations = [2, 3, 3]
    weight = [0.5, 2.0, 0.8]
    wg = SimpleWeightedGraph(sources, destinations, weight)
    # SimpleWeightedGraph vs SimpleWeightedDiGraph
    # NOTA: los pesos van en el orden interno del grafo
end

# ╔═╡ 409ae0b5-6cbd-4395-a77c-cd2207f074d7
adjacency_matrix(wg)

# ╔═╡ 28ab4099-d2b8-4312-9de2-19e34cb9e3f1
gplot(wg, nodelabel = 1:nv(wg), edgelabel = weight)

# ╔═╡ 46b463e5-4bbf-4743-8149-a0599129ddf6
md"""
## MetaGraphs / MetaDiGraph
"""

# ╔═╡ e41b3feb-5cb7-4ad0-b74a-dccd9fa86b5a
begin
    mg = MetaGraph(path_graph(5), 3.0) # MetaGraph vs MetaDiGraph
    set_prop!(mg, :description, "This is a metagraph.")
    set_prop!(mg, 1, :name, "John")
    set_props!(mg, 2, Dict(:name => "Susan", :id => 123))
    set_prop!(mg, Edge(1, 2), :action, "knows")
    mg
end

# ╔═╡ 5382ba88-ffe8-44b7-a110-ba69396d0742
props(mg, 1)

# ╔═╡ d2c773c5-3f3a-4beb-a1c9-1790fe2f98af
props(mg, Edge(1, 2))

# ╔═╡ 1d2c4edd-07d2-41ff-8d0e-2df252666a48
get_prop(mg, 2, :name)

# ╔═╡ 40c679c9-8b35-4057-858f-cb10d8f935dd
md"""
## Shortest Path Dijkstra
"""

# ╔═╡ 0c83ca24-06f6-4d44-ba65-10c9fbec2e18
dijkstra_shortest_paths(wg, 1)

# ╔═╡ e7ae65fa-cf39-4b7b-bffd-42b24582e174
enumerate_paths(dijkstra_shortest_paths(wg, 1), 3)

# ╔═╡ b876354e-6b69-4afd-95c4-f8ad4484d81e
md"""
## Shortest Path Floyd
"""

# ╔═╡ cd4fcf4f-0e5e-42b9-909d-71cc198dc1a0
floyd_warshall_shortest_paths(wg)

# ╔═╡ 897d5869-c3cf-485e-b256-e6503784023f
enumerate_paths(floyd_warshall_shortest_paths(wg), 1, 3)

# ╔═╡ b9c28d11-8428-4d44-9169-e98f28dc8bed
md"""
## Graph coloring
"""

# ╔═╡ d594b53a-c414-41da-9313-ccad869b9bff
g = random_regular_graph(10, 3)

# ╔═╡ 5bfc0508-43f9-4808-b4c4-b18bc446ee88
gplot(g, nodelabel = 1:nv(g))

# ╔═╡ 5dd40219-461c-477f-a067-77e715db871f
greedy_color(g)

# ╔═╡ Cell order:
# ╠═36184f24-de30-11ec-3a6f-6962a488690c
# ╠═d83f600a-2b47-4a1d-a8c4-7fa8fe84ae1f
# ╠═b3c1b45e-f1cf-407c-94d5-cbd41bd60241
# ╠═9ac0de36-6e62-474e-b563-bc170b861603
# ╠═801d336f-8f8a-474c-925b-587a850cb004
# ╠═e10b0b33-cd8e-4664-99de-1da3bf289043
# ╠═a7aa982c-cb05-4c05-ab45-8047290406a0
# ╠═6f322974-57c1-46dd-b595-ca59ed75bb21
# ╠═685e9f8f-866b-4aec-8b22-f1060375ca87
# ╠═c462883a-dcf0-4861-9e57-612b9166147b
# ╠═4faf7048-fd7c-4d79-b0ad-f58b49c3cb58
# ╠═3999f1cf-e4bf-4dff-82e2-d5498d000361
# ╠═d5b56c88-68ea-49bb-b626-acc17cdce81f
# ╠═79c5f4c6-5e06-4433-8475-77d8da1b7b13
# ╠═36d0d903-38b3-4710-a59f-11541640a23a
# ╠═030152d9-e7da-4ff4-88ce-ed7a066a4b1b
# ╠═2fccff30-b9e6-4283-b991-d826bc6b7f19
# ╠═ca890c2d-10dd-4dcc-89b9-c4ce1f3c85ef
# ╠═409ae0b5-6cbd-4395-a77c-cd2207f074d7
# ╠═28ab4099-d2b8-4312-9de2-19e34cb9e3f1
# ╠═46b463e5-4bbf-4743-8149-a0599129ddf6
# ╠═e41b3feb-5cb7-4ad0-b74a-dccd9fa86b5a
# ╠═5382ba88-ffe8-44b7-a110-ba69396d0742
# ╠═d2c773c5-3f3a-4beb-a1c9-1790fe2f98af
# ╠═1d2c4edd-07d2-41ff-8d0e-2df252666a48
# ╠═40c679c9-8b35-4057-858f-cb10d8f935dd
# ╠═0c83ca24-06f6-4d44-ba65-10c9fbec2e18
# ╠═e7ae65fa-cf39-4b7b-bffd-42b24582e174
# ╠═b876354e-6b69-4afd-95c4-f8ad4484d81e
# ╠═cd4fcf4f-0e5e-42b9-909d-71cc198dc1a0
# ╠═897d5869-c3cf-485e-b256-e6503784023f
# ╠═b9c28d11-8428-4d44-9169-e98f28dc8bed
# ╠═d594b53a-c414-41da-9313-ccad869b9bff
# ╠═5bfc0508-43f9-4808-b4c4-b18bc446ee88
# ╠═5dd40219-461c-477f-a067-77e715db871f
# ╠═257e75dc-b908-4ac1-a8fc-568989470273
