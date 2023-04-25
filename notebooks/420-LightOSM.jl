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
        Pkg.PackageSpec("LightOSM")
        Pkg.PackageSpec("PlutoUI")
    ])
    Pkg.status()
end

# ╔═╡ ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
using LightOSM

# ╔═╡ 004865c1-f9a7-4473-957e-2ff64f4f6abf
begin
    using PlutoUI
    PlutoUI.TableOfContents()
end

# ╔═╡ 58c2ea61-c9b4-4454-b74f-6c3f8af51ec7
md"""
# Funciones para LightOSM
"""

# ╔═╡ debc168b-0078-4dde-a032-75cefa00d119
md"""
## Extraer lat/lon desde Direcciones

Usar [nominatim](https://nominatim.openstreetmap.org/)
"""

# ╔═╡ c89a9a9e-b463-4e94-9501-ad3fe1a99101
function getlatlon(dir::String)::GeoLocation
    q = LightOSM.nominatim_polygon_query(dir)
    j = LightOSM.nominatim_request(q)
    d = LightOSM.JSON.parse(j)

    println(d[1]["display_name"])
    lat = parse(Float64, d[1]["lat"])
    lon = parse(Float64, d[1]["lon"])

    return GeoLocation(lat, lon)
end

# ╔═╡ 57ad6660-e76a-4352-85cf-8cc1b59e885b
md"""
## Extraer nodo desde lat/lon
"""

# ╔═╡ 20831585-091a-4a29-8e40-745dd3bf272c
function buscanodo(g::OSMGraph{U,T,W}, points::Vector{GeoLocation})::Vector{T} where {U,T,W}
    x = LightOSM.nearest_node(g, points)
    for i in eachindex(points)
        println("nodo= ", x[1][i][1], " dista= ", x[2][i][1])
    end
    return vcat(x[1]...)
end

# ╔═╡ 602b38e5-cff9-4389-b727-fac8770149d7
md"""
## Calcular distancias
"""

# ╔═╡ 3379eb73-1360-4bbd-95da-e7c1dc73a9e0
function distreal(g::OSMGraph{U,T,W}, o::T, d::T)::Float64 where {U,T,W}
    if o == d
        return 0.0
    end
    ruta = LightOSM.shortest_path(g, o, d)
    distx = LightOSM.weights_from_path(g, ruta)
    return sum(distx)
end

# ╔═╡ 71756490-9791-4d32-b91a-c0b9a956e1ca
function distgeo(g::OSMGraph{U,T,W}, o::T, d::T)::Float64 where {U,T,W}
    disth = LightOSM.distance(g.nodes[o], g.nodes[d], :haversine)
    return disth
end

# ╔═╡ 37e65847-2510-438b-b9a6-721f42e54868
md"""
# Ejemplo de uso de LightOSM
"""

# ╔═╡ 978c804a-65f7-4d46-a185-e0c051972bfe
md"""
## Cargar Mapa de Concepcion
"""

# ╔═╡ d57e66cd-5931-4ec6-9506-d8badc7cf678
g = LightOSM.graph_from_download(:place_name, weight_type = :distance, place_name = "Concepción, Chile")

# ╔═╡ 8213fcc2-a1aa-47fd-9342-2d4fcb0c87c5
md"""
## Buscar nodos desde direcciones
"""

# ╔═╡ 0c5cea8e-ec2c-42e4-9b53-cca423636d24
dire = [
    "Plaza Belgica, Concepcion, Chile"
    "Plaza de la Independencia, Concepcion, Chile"
    "Mall Plaza, Concepcion, Chile"
    "Collao 1202, Concepcion, Chile"
]

# ╔═╡ c9c6575a-07ca-44df-b678-0f3064f05078
latlon = getlatlon.(dire)

# ╔═╡ 21e781b8-2ca0-4c91-91c8-9787552bbc1c
puntos = buscanodo(g, latlon)

# ╔═╡ 6b236a95-0b54-4649-8abb-4ce6d9aaa6fd
md"""
## Calcular distancia real
"""

# ╔═╡ 388f3029-efcc-40ba-8844-895ee3d346e1
dista = [distreal(g, o, d) for o in puntos, d in puntos]

# ╔═╡ e1adff78-c1cb-4dec-88f0-8a83adef58a1
md"""
## Calcular distancia Haversine
"""

# ╔═╡ 3c56e61a-b9d0-49d1-ba7c-83f7e503d049
disth = [distgeo(g, o, d) for o in puntos, d in puntos]

# ╔═╡ c119f81d-c870-417b-9f0a-07c5440cd15c
md"""
## Calcular distancia Euclidiana
"""

# ╔═╡ 2f63ed19-730f-4230-92d1-9d9429f0fa2f
diste = [sqrt((i.lat - j.lat)^2 + (i.lon - j.lon)^2) for i in latlon, j in latlon]

# ╔═╡ a2075e7c-8b65-4ba8-9152-741bb4c01851
md"""
## Diferencias de distancias
"""

# ╔═╡ eede4794-a506-4677-bdda-982bb86b3201
dista - disth

# ╔═╡ d8e909df-f6ee-47f8-98c2-9794229003a6
disth ./ diste

# ╔═╡ Cell order:
# ╠═ca2d345e-ac76-11ec-2164-8f36e66bc097
# ╠═ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
# ╠═58c2ea61-c9b4-4454-b74f-6c3f8af51ec7
# ╠═debc168b-0078-4dde-a032-75cefa00d119
# ╠═c89a9a9e-b463-4e94-9501-ad3fe1a99101
# ╠═57ad6660-e76a-4352-85cf-8cc1b59e885b
# ╠═20831585-091a-4a29-8e40-745dd3bf272c
# ╠═602b38e5-cff9-4389-b727-fac8770149d7
# ╠═3379eb73-1360-4bbd-95da-e7c1dc73a9e0
# ╠═71756490-9791-4d32-b91a-c0b9a956e1ca
# ╠═37e65847-2510-438b-b9a6-721f42e54868
# ╠═978c804a-65f7-4d46-a185-e0c051972bfe
# ╠═d57e66cd-5931-4ec6-9506-d8badc7cf678
# ╠═8213fcc2-a1aa-47fd-9342-2d4fcb0c87c5
# ╠═0c5cea8e-ec2c-42e4-9b53-cca423636d24
# ╠═c9c6575a-07ca-44df-b678-0f3064f05078
# ╠═21e781b8-2ca0-4c91-91c8-9787552bbc1c
# ╠═6b236a95-0b54-4649-8abb-4ce6d9aaa6fd
# ╠═388f3029-efcc-40ba-8844-895ee3d346e1
# ╠═e1adff78-c1cb-4dec-88f0-8a83adef58a1
# ╠═3c56e61a-b9d0-49d1-ba7c-83f7e503d049
# ╠═c119f81d-c870-417b-9f0a-07c5440cd15c
# ╠═2f63ed19-730f-4230-92d1-9d9429f0fa2f
# ╠═a2075e7c-8b65-4ba8-9152-741bb4c01851
# ╠═eede4794-a506-4677-bdda-982bb86b3201
# ╠═d8e909df-f6ee-47f8-98c2-9794229003a6
# ╠═004865c1-f9a7-4473-957e-2ff64f4f6abf
