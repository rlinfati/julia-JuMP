### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ 00afa180-ac4b-11ec-06c5-87c2e45a34bc
begin
    import Pkg
    Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true
    Pkg.activate()
    Pkg.add([Pkg.PackageSpec("PlutoUI")])
    Pkg.status()
end

# ╔═╡ d98ab148-1397-4a53-ab2b-b1b399f3dfe1
begin
    using PlutoUI
    PlutoUI.TableOfContents()
end

# ╔═╡ d9f1d475-8e5c-4c27-8c19-26c3812ff99e
md"""
# Primeros pasos en Julia
"""

# ╔═╡ 00839514-e5dd-455b-aec1-487a2fbd77fd
md"""
## Variables (de programación)
"""

# ╔═╡ da2b00b0-a21e-4428-9f71-a35fb5ac3585
x = 3

# ╔═╡ 9af9cf8c-2d84-4f3f-a466-3e290eaf25c3
md"""
De forma predeterminada, Julia muestra el resultado de la última operación. (Puede suprimir la salida agregando `;` (un punto y coma) al final.
"""

# ╔═╡ 097b47e7-969f-4a45-998c-f47f0072d832
y = 2x

# ╔═╡ c00f8154-e5b7-4e28-ace7-5d07fb552cea
md"""
Podemos obtener qué tipo de datos es una variable usando `typeof`
"""

# ╔═╡ c4f41f7a-c053-4fee-8049-1983c7471a04
"Hola Mundo";

# ╔═╡ d893a1ea-78b3-4349-b85d-fb44cd1401c6
println("Hello, World!")

# ╔═╡ 8fe031fa-92b2-4483-8a90-a53f726a63b7
@show "Hola Mundo"

# ╔═╡ 680f263d-8dbe-480b-9dc6-773128a37502
typeof(y)

# ╔═╡ ff2cc0cb-ce22-4e8f-8efa-cbec80e4d3af
typeof(1 + -2)

# ╔═╡ 52889dc5-abe1-49b5-9803-7105c389d3b5
typeof(1.2 - 2.3)

# ╔═╡ 0ae41766-2562-44e0-84f3-4af9acfaaf8e
typeof(pi)

# ╔═╡ a5b9c354-a7c2-4e7d-8df2-7ed953cc0f95
typeof(π)

# ╔═╡ 8c5ec749-932a-44a8-a53a-099f37fe53d7
typeof(2 + 3im)

# ╔═╡ 9bd51d8b-b894-4fac-b428-29d0015fb179
typeof(2.0 + 3.0im)

# ╔═╡ a2e8d157-83f1-4da4-ab5f-e730f8d033f4
typeof("This is Julia")

# ╔═╡ dd358d52-6053-4d0f-aca9-ff0bcd7852dd
typeof([1, 2])

# ╔═╡ 71afab5f-2430-430c-8383-0c07154ec267
typeof([1 2])

# ╔═╡ f2934b8a-5baf-4e8c-bdd3-1db5b127205b
typeof([1 2; 3 4])

# ╔═╡ c5215177-478d-4cdb-9184-18a0cab0f913
typeof(("a", 3, 4.213, :hola, 'a'))

# ╔═╡ b279ea7c-0d45-496f-a446-7ce52f75b974
typeof(("a", 'b'))

# ╔═╡ a14bb8c5-a5d8-44dd-814c-6fa9cb3b28f8
typeof(("a" => 3))

# ╔═╡ b726d3a9-82cc-425c-a46f-6ecc10e7c142
typeof(Dict("a" => 3))

# ╔═╡ 409a4115-6945-4098-9ea9-4fb32e6df8c8
md"""
## Ciclos `For`
"""

# ╔═╡ 6c8326bd-3a49-4976-beab-c8eec9df028e
md"""
Use `for` para recorrer un conjunto de valores"
"""

# ╔═╡ 96389d6e-c6ba-4362-a748-dabd77f87ff4
begin
    s = 0
    for i in 1:10
        s += i # Equivalente a s = s + i
    end
    s
end

# ╔═╡ 43d4cee8-a06f-4537-91ea-08d1e56e1af0
md"""
Aquí, `1:10` es un **rango** que representa los números del 1 al 10"
"""

# ╔═╡ 96ce4e55-aecf-4411-9481-bb0a0e08ee8d
typeof(1:10)

# ╔═╡ d2b7aca9-656e-46fd-84b0-66838f47208b
md"""
Arriba usamos un bloque `begin` para definir más de una linea de codigo por celda 

Abajo usaremos un bloque `let` para definir una nueva variable **local** `s2`.
Pero los bloques de código como este suelen ser mejores dentro de las funciones, por lo que pueden reutilizarse. Por ejemplo, podríamos reescribir lo anterior de las siguiente maneras:
"""

# ╔═╡ e872f7cb-315a-44bf-968e-18e0215437ee
s

# ╔═╡ 99f471cf-38df-410c-9568-e7e71e0422f2
let
    # Ejemplo no recomendado, ver siguiente cuadro
    s2 = 0
    for i in 1:10
        s2 += i # Equivalente a s = s + i
    end
    s2
end

# ╔═╡ e1f24e16-1a9b-431e-9b48-6bfcf23b80ea
s2

# ╔═╡ cc8b5e24-cfae-4cc6-8f22-1db7ac5a2976
function mysum(n)
    s = 0
    for i in 1:n
        s += i
    end
    return s
end

# ╔═╡ 66f070df-42e7-45dc-85cb-8fd7a7f58f23
mysum(10)

# ╔═╡ cb9d71dd-0f64-499b-bc57-e0a5edf8b0fc
md"""
## Condicional: `if`
"""

# ╔═╡ 73b989bd-9a56-4109-81ce-48f0b0568d88
md"""
Podemos evaluar si una condición es verdadera o falsa simplemente escribiendo la condición
"""

# ╔═╡ fa4aae9a-2170-4ceb-9df7-d1b8f1d3bb9e
a = 3

# ╔═╡ 46d7a3a6-9fa1-4101-b95f-8cd1f3c71eb2
a < 5

# ╔═╡ 09ad02f7-f451-406d-8390-6cbf6f0baa57
md"""
Vemos que las condiciones tienen un valor booleano (`true` o `false`).
Luego podemos usar `if` para controlar lo que hacemos en función de ese valor
"""

# ╔═╡ 5b6020f9-ae64-4848-a302-d6194de10366
if a < 5
    "pequeño"
else
    "grande"
end

# ╔═╡ 05a9d3dc-15d3-439d-8c40-d7470510dd18
md"""
Tenga en cuenta que `if` también devuelve el último valor que se evaluó, en este caso, el texto `"pequeño"` o `"grande"`. Dado que Pluto es reactivo, cambiar la definición de `a` anterior hará que esto se produzca automáticamente al ser reevaluado!
"""

# ╔═╡ 7fc7b4f3-b821-48cc-8717-9f64f2d56296
a < 5 ? "pequeño" : "grande"

# ╔═╡ c4ee2829-f0db-4b92-a2ef-c609e455c5d9
md"""
## Ejemplo de `for` e `if`
"""

# ╔═╡ 9fdea952-30f9-4b54-b9e5-82f59fb496c8
for i in 0:3:15
    if i < 5
        println("$i is less than 5")
    elseif i < 10
        println("$i is less than 10")
    else
        if i == 12
            println("the value is 12")
        else
            println("$i is bigger than 10")
        end
    end
end

# ╔═╡ d2cfe345-6f06-4629-91c5-f23ab9702eaf
typeof(0:3:15)

# ╔═╡ a2b957fc-a4eb-4924-9144-0ee2d41f8d00
dump(0:3:15)

# ╔═╡ 99bd23c8-1c17-4e0d-a8ed-497cc3772fef
md"""
## Vectores - *Array* 1D
"""

# ╔═╡ 9d6772dd-2855-4ef5-becc-2740596e3e7f
md"""
Podemos hacer un 'Vector' (*array* unidimensional) usando corchetes"
"""

# ╔═╡ cbcce4f8-bc6a-40dd-845c-7c104a1b691e
v = [1, 2, 3]

# ╔═╡ df58fe75-1840-48af-93ef-19711fe21402
typeof(v)

# ╔═╡ afd2dace-6dc7-4ae8-a1b8-5a923046cb21
md"""
El `1` en el tipo muestra que se trata de un *array* 1D. Accedemos a los elementos usando corchetes
"""

# ╔═╡ 4b69f45c-b8ee-4da7-9b73-0c937ba2914c
v[2]

# ╔═╡ 57faa819-727c-449d-aa89-025b2b49e50a
v[2] = 10

# ╔═╡ 7ded1673-8e0a-47f9-80df-bf6a50b38a7d
v

# ╔═╡ 98ab3250-af68-4c07-a5e4-9adedaeb7e59
md"""
Tenga en cuenta que Pluto no actualiza automáticamente las celdas cuando modifica elementos de un *array*, pero el valor cambia
"""

# ╔═╡ 3f6ae998-a6a9-47cb-9cc6-b775a8a6fe0c
md"""
Una buena manera de crear un `Vector` siguiendo un cierto patrón es usar una **comprensión de array**
"""

# ╔═╡ ca4ddeb9-fe7e-4a99-8128-aca078cd1668
v2 = [i^2 for i in 1:10]

# ╔═╡ 1e56b1b1-a6fa-4147-bc9f-f19b24970fe9
[i^2 for i in 1:10 if i > 5]

# ╔═╡ 0b144761-4a1f-490f-aa65-0b6a47b50e78
[i for i in 1:10 if isodd(i)]

# ╔═╡ 47252371-80d8-45e2-a7ce-14c7fadebdb7
vv = [
    1.0
    2.0
    30
]

# ╔═╡ 9f4d5f25-318e-4bd4-b937-6c542a8fa83c
md"""
## Matrices - *Array* 2D
"""

# ╔═╡ b10c0774-b777-4762-838c-0e70317ebfe7
md"""
También podemos hacer matrices pequeñas (*array* 2D) con corchetes
"""

# ╔═╡ 4a5ed822-5a4c-4115-b160-401853797b96
M = [1 2; 3 4]

# ╔═╡ fb1c5de5-5a5a-48be-bfa4-a11df3aee404
M2 = [
    1 2
    3 4
]

# ╔═╡ 5c087f35-d1d6-4b56-a714-a472c5e97460
typeof(M)

# ╔═╡ cb7551ae-ecfe-4001-8d1b-4acf5a05e59f
md"""
El `2` en el tipo muestra que se trata de un *array* 2D. Accedemos a los elementos usando corchetes
"""

# ╔═╡ 160004cd-7c10-435c-9d3e-3504e14b7f42
M[1, 2]

# ╔═╡ 5c4458b5-19b9-4ad4-9293-bdd6312db04e
M[3]

# ╔═╡ 245cec84-efc9-4881-9dcc-e2f156a1768c
M[:]

# ╔═╡ 34b64acd-e7c8-4033-b584-1a99d3ef6891
md"""
Sin embargo, esto no funcionará para matrices más grandes. Para eso podemos usar `zeros`
"""

# ╔═╡ d655eda1-bec2-424a-962e-e334fed0e73d
zeros(2, 3)

# ╔═╡ 418ce889-fcec-438c-b4dc-5738cdff8837
zeros(Int, 3, 4)

# ╔═╡ cc2da42b-1a73-4b50-91f5-61a2823f1544
zeros(Int, 3, 4, 5)

# ╔═╡ fb193693-865a-4031-8d2a-1427babb5692
md"""
Luego podemos completar los valores que queremos manipulando los elementos con un ciclo `for`
"""

# ╔═╡ 6b65e22b-f728-40cb-9844-2fbbe9f3ef75
md"""
Una buena alternativa para crear matrices siguiendo un cierto patrón es una *comprensión de matriz* con un bucle *doble* `for`
"""

# ╔═╡ 7d6eb550-ef6c-4da5-9303-52b1a59f71bc
[i + j for i in 1:5, j in 1:6]

# ╔═╡ 6ca6a14f-5fb8-4f98-bc08-004dc112cc0d
[i * j for i in 1:5, j in 5:10]

# ╔═╡ e5e7fe5e-7bbc-423b-b9a4-92d2ef683607
[i * j for i in 1:5 for j in 5:10]

# ╔═╡ c92afd8a-9396-4fb5-b8f0-bc98ae12d813
md"""
## Sistema de ecuaciones
"""

# ╔═╡ 738e3ac2-d033-4cdd-9e16-81ec3bb12e1d
A = [1 2; 3 4]

# ╔═╡ 0569d975-5217-4c90-8dab-15e6c54f5fb4
b = [5, 6]

# ╔═╡ e714094e-8d5c-4323-811d-130adf5ffbab
xx = A \ b

# ╔═╡ 1484c270-0d08-4356-8b71-4fff87b259be
inv(A) * b

# ╔═╡ fbe1c054-3087-4c1f-9339-540d1631545b
A * xx == b

# ╔═╡ c9b7a2b2-5e60-4d6d-9c0a-36dc7be59e82
A'

# ╔═╡ 6211a777-80ab-464e-b05c-b53d4e717d37
A^2

# ╔═╡ 483b2416-eed1-44f3-bec5-e1de01262b0b
md"""
## Punto Flotante
"""

# ╔═╡ f2a9c774-3652-4347-afe9-85ae202b8543
sin(2π / 3) == √3 / 2

# ╔═╡ 844252d4-f13d-457d-8687-72c0a203ea01
sin(2π / 3)

# ╔═╡ 916847e9-76dd-4e1e-b627-ee706cc2f4eb
√3 / 2

# ╔═╡ 6b4e4bc9-e118-4c26-b9a9-264c125d3953
sin(2π / 3) ≈ √3 / 2

# ╔═╡ 2334a88a-6d9c-4099-9181-826af42a8e02
eps()

# ╔═╡ 0f5a63ac-3e2c-4916-ad09-289eb2035865
md"""
## Punto Flotante 2.0
"""

# ╔═╡ 9a1546a8-c346-4c3c-939f-c70e166ed7cd
function f(T::Type)::T
    a::T = 0.1
    b::T = 0.2
    return a + b
end

# ╔═╡ c41b0783-ff37-47b5-85bb-3ed69aa488ac
md"""
## Tuplas
"""

# ╔═╡ 891d32df-b85f-448f-96e6-c89c16ac3329
t1 = ("hello", 1.2, :foo)

# ╔═╡ 20ceca4b-026c-408a-af11-50814db1291b
t2 = (word = "hello", num = 1.2, sym = :foo)

# ╔═╡ 99e8c835-f03a-4346-9131-8491b1710473
t2[3]

# ╔═╡ 746ec674-d8cb-41a6-98d1-37e474c980d5
t2.num

# ╔═╡ 4384276b-ca41-47cb-a3d2-b59d47b10fc4
md"""
## Funciones
"""

# ╔═╡ 125c3c89-1653-4f02-acd9-c1f24ad9d855
md"""
Podemos usar una función abreviada de una línea para funciones simples
"""

# ╔═╡ 3846c242-8f0f-429d-bc31-7adf4b1c3845
f(x) = 2 + x

# ╔═╡ e8e66b77-a6aa-40b5-9ad9-150cb06fa875
f(Float64)

# ╔═╡ a9988ae3-aa0d-44db-b9f2-6530e9c9cd5e
f(Float32)

# ╔═╡ 927bad29-1984-4de3-9e66-2d3b2aa36b29
f(Float16)

# ╔═╡ 129a9437-3e6a-4069-9e18-1f842015be0e
f(BigFloat)

# ╔═╡ 68987d7f-0947-4e49-9b57-9196592bcdee
md"""
Escribiendo el nombre de la función proporciona información sobre la función. Para llamarlo debemos usar paréntesis
"""

# ╔═╡ f2d7a38a-1d0c-4cb5-a09e-6e680e010cc2
f

# ╔═╡ fcd82aeb-db9f-4c47-a85b-213f669e5394
f(10)

# ╔═╡ 9c93475a-23c0-4909-84d2-e8feaf49dd28
md"""
Para funciones más largas usamos la siguiente sintaxis con la palabra clave `function` y `end`
"""

# ╔═╡ 8873ebaa-7b2f-4ed4-82a7-db0e0dde01da
function g(x, y)
    z = x + y
    return z^2
end

# ╔═╡ e5fff741-03d2-491c-85f4-7fc4ce857b7a
g(1, 2)

# ╔═╡ 38c3501c-72fd-4da7-8772-e45e6c0846c8
md"""
## Funciones y Polimorfismo
"""

# ╔═╡ 1d7044ae-2532-443d-a286-40946869d60e
h(x) = "h(x)"

# ╔═╡ 95def389-54b8-4276-b124-d57098d5902d
h(x::Float64) = "h(x) Float64"

# ╔═╡ 3f8c4c38-3aec-40b1-825f-1b46b2233c7b
h(x::Int) = "h(x) Int"

# ╔═╡ 8508ede4-e9be-4ff3-99e0-8f0a76b9e55c
h(π)

# ╔═╡ 6bae7322-d5c1-4061-ada6-a125b36ad0c5
h(3)

# ╔═╡ 5d2e3f0a-7cba-4919-aec5-19f285307f01
h(3.14)

# ╔═╡ 1265aef1-d299-4504-99ee-f868af6901c6
md"""
## Funciones y parametros
"""

# ╔═╡ 3d3dd3ad-cdcb-4445-90e1-22271ff2b7aa
printrl(x, prefix = "value:") = println("$prefix $x")

# ╔═╡ 8b822173-5eb4-4fa0-adb1-fd4d60b33bd4
printrl(1.234)

# ╔═╡ 4dadcefb-545c-4451-b2a1-5e00a3449edc
printrl(1.234, "valor de x =")

# ╔═╡ 576f37f0-71b5-4679-9952-272e7d7a96ae
mult(x; y = 2.0) = x * y

# ╔═╡ 36c1262d-de53-4bc8-bb49-b78c45d3a56b
mult(4.0)

# ╔═╡ 0ecbc720-d7f5-4b0c-9d2d-aabd958d26c7
mult(4.0; y = 5.0)

# ╔═╡ 23263fdf-31ec-4258-9ddd-71aa025dc168
md"""
## Funciones y parametros 2.0
"""

# ╔═╡ 85a870e2-b9dc-4534-a791-de20d8b46f2d
function l(x = 10, y = 20)
    @show "l(x=10,y=20)"
    return x, y
end

# ╔═╡ aca58192-8755-493b-adb9-be3926488b2c
function l(x = 10; y = 20)
    @show "l(x=10;y=20)"
    return x, y
end

# ╔═╡ ba42804f-2dbc-4a3b-9f1a-a55546152aca
methods(l)

# ╔═╡ 98ddb4ad-2e27-4c32-a895-9ef08f1304e7
l()

# ╔═╡ 8c4449f8-2d82-4f60-8899-b4e95186aba3
l(5, 15)

# ╔═╡ 71612bad-a14b-43e7-b4d9-dc07676a351e
l(5, y = 15)

# ╔═╡ 0938af0c-b09e-47d2-bcf6-f404c4515646
md"""
## Funciones y Punteros
"""

# ╔═╡ 7b44b8e8-14d4-4b20-89fe-47c6300fff45
function ejmplof(a, b, c)
    a .+= 100
    b += 1
    c[] += 1
    return
end

# ╔═╡ be535097-1edf-4d3e-bc49-c662cfeef457
begin
    var1 = [10, 20, 30]
    var2 = 10
    var3 = Ref{Int}(10)
    ejmplof(var1, var2, var3)
end

# ╔═╡ 91d2d9c3-c4db-4b55-b999-848bc96e167d
var1

# ╔═╡ 34e2d939-46a3-43ff-9613-b9d9d4a5af4d
var2

# ╔═╡ 713617be-62a7-46c9-9b8c-641659645a1c
var3

# ╔═╡ a91f55ee-7997-4aa6-99c7-d54c21dd1413
var3[]

# ╔═╡ Cell order:
# ╠═00afa180-ac4b-11ec-06c5-87c2e45a34bc
# ╠═d9f1d475-8e5c-4c27-8c19-26c3812ff99e
# ╠═00839514-e5dd-455b-aec1-487a2fbd77fd
# ╠═da2b00b0-a21e-4428-9f71-a35fb5ac3585
# ╠═9af9cf8c-2d84-4f3f-a466-3e290eaf25c3
# ╠═097b47e7-969f-4a45-998c-f47f0072d832
# ╠═c00f8154-e5b7-4e28-ace7-5d07fb552cea
# ╠═c4f41f7a-c053-4fee-8049-1983c7471a04
# ╠═d893a1ea-78b3-4349-b85d-fb44cd1401c6
# ╠═8fe031fa-92b2-4483-8a90-a53f726a63b7
# ╠═680f263d-8dbe-480b-9dc6-773128a37502
# ╠═ff2cc0cb-ce22-4e8f-8efa-cbec80e4d3af
# ╠═52889dc5-abe1-49b5-9803-7105c389d3b5
# ╠═0ae41766-2562-44e0-84f3-4af9acfaaf8e
# ╠═a5b9c354-a7c2-4e7d-8df2-7ed953cc0f95
# ╠═8c5ec749-932a-44a8-a53a-099f37fe53d7
# ╠═9bd51d8b-b894-4fac-b428-29d0015fb179
# ╠═a2e8d157-83f1-4da4-ab5f-e730f8d033f4
# ╠═dd358d52-6053-4d0f-aca9-ff0bcd7852dd
# ╠═71afab5f-2430-430c-8383-0c07154ec267
# ╠═f2934b8a-5baf-4e8c-bdd3-1db5b127205b
# ╠═c5215177-478d-4cdb-9184-18a0cab0f913
# ╠═b279ea7c-0d45-496f-a446-7ce52f75b974
# ╠═a14bb8c5-a5d8-44dd-814c-6fa9cb3b28f8
# ╠═b726d3a9-82cc-425c-a46f-6ecc10e7c142
# ╠═409a4115-6945-4098-9ea9-4fb32e6df8c8
# ╠═6c8326bd-3a49-4976-beab-c8eec9df028e
# ╠═96389d6e-c6ba-4362-a748-dabd77f87ff4
# ╠═43d4cee8-a06f-4537-91ea-08d1e56e1af0
# ╠═96ce4e55-aecf-4411-9481-bb0a0e08ee8d
# ╠═d2b7aca9-656e-46fd-84b0-66838f47208b
# ╠═e872f7cb-315a-44bf-968e-18e0215437ee
# ╠═99f471cf-38df-410c-9568-e7e71e0422f2
# ╠═e1f24e16-1a9b-431e-9b48-6bfcf23b80ea
# ╠═cc8b5e24-cfae-4cc6-8f22-1db7ac5a2976
# ╠═66f070df-42e7-45dc-85cb-8fd7a7f58f23
# ╠═cb9d71dd-0f64-499b-bc57-e0a5edf8b0fc
# ╠═73b989bd-9a56-4109-81ce-48f0b0568d88
# ╠═fa4aae9a-2170-4ceb-9df7-d1b8f1d3bb9e
# ╠═46d7a3a6-9fa1-4101-b95f-8cd1f3c71eb2
# ╠═09ad02f7-f451-406d-8390-6cbf6f0baa57
# ╠═5b6020f9-ae64-4848-a302-d6194de10366
# ╠═05a9d3dc-15d3-439d-8c40-d7470510dd18
# ╠═7fc7b4f3-b821-48cc-8717-9f64f2d56296
# ╠═c4ee2829-f0db-4b92-a2ef-c609e455c5d9
# ╠═9fdea952-30f9-4b54-b9e5-82f59fb496c8
# ╠═d2cfe345-6f06-4629-91c5-f23ab9702eaf
# ╠═a2b957fc-a4eb-4924-9144-0ee2d41f8d00
# ╠═99bd23c8-1c17-4e0d-a8ed-497cc3772fef
# ╠═9d6772dd-2855-4ef5-becc-2740596e3e7f
# ╠═cbcce4f8-bc6a-40dd-845c-7c104a1b691e
# ╠═df58fe75-1840-48af-93ef-19711fe21402
# ╠═afd2dace-6dc7-4ae8-a1b8-5a923046cb21
# ╠═4b69f45c-b8ee-4da7-9b73-0c937ba2914c
# ╠═57faa819-727c-449d-aa89-025b2b49e50a
# ╠═7ded1673-8e0a-47f9-80df-bf6a50b38a7d
# ╠═98ab3250-af68-4c07-a5e4-9adedaeb7e59
# ╠═3f6ae998-a6a9-47cb-9cc6-b775a8a6fe0c
# ╠═ca4ddeb9-fe7e-4a99-8128-aca078cd1668
# ╠═1e56b1b1-a6fa-4147-bc9f-f19b24970fe9
# ╠═0b144761-4a1f-490f-aa65-0b6a47b50e78
# ╠═47252371-80d8-45e2-a7ce-14c7fadebdb7
# ╠═9f4d5f25-318e-4bd4-b937-6c542a8fa83c
# ╠═b10c0774-b777-4762-838c-0e70317ebfe7
# ╠═4a5ed822-5a4c-4115-b160-401853797b96
# ╠═fb1c5de5-5a5a-48be-bfa4-a11df3aee404
# ╠═5c087f35-d1d6-4b56-a714-a472c5e97460
# ╠═cb7551ae-ecfe-4001-8d1b-4acf5a05e59f
# ╠═160004cd-7c10-435c-9d3e-3504e14b7f42
# ╠═5c4458b5-19b9-4ad4-9293-bdd6312db04e
# ╠═245cec84-efc9-4881-9dcc-e2f156a1768c
# ╠═34b64acd-e7c8-4033-b584-1a99d3ef6891
# ╠═d655eda1-bec2-424a-962e-e334fed0e73d
# ╠═418ce889-fcec-438c-b4dc-5738cdff8837
# ╠═cc2da42b-1a73-4b50-91f5-61a2823f1544
# ╠═fb193693-865a-4031-8d2a-1427babb5692
# ╠═6b65e22b-f728-40cb-9844-2fbbe9f3ef75
# ╠═7d6eb550-ef6c-4da5-9303-52b1a59f71bc
# ╠═6ca6a14f-5fb8-4f98-bc08-004dc112cc0d
# ╠═e5e7fe5e-7bbc-423b-b9a4-92d2ef683607
# ╠═c92afd8a-9396-4fb5-b8f0-bc98ae12d813
# ╠═738e3ac2-d033-4cdd-9e16-81ec3bb12e1d
# ╠═0569d975-5217-4c90-8dab-15e6c54f5fb4
# ╠═e714094e-8d5c-4323-811d-130adf5ffbab
# ╠═1484c270-0d08-4356-8b71-4fff87b259be
# ╠═fbe1c054-3087-4c1f-9339-540d1631545b
# ╠═c9b7a2b2-5e60-4d6d-9c0a-36dc7be59e82
# ╠═6211a777-80ab-464e-b05c-b53d4e717d37
# ╠═483b2416-eed1-44f3-bec5-e1de01262b0b
# ╠═f2a9c774-3652-4347-afe9-85ae202b8543
# ╠═844252d4-f13d-457d-8687-72c0a203ea01
# ╠═916847e9-76dd-4e1e-b627-ee706cc2f4eb
# ╠═6b4e4bc9-e118-4c26-b9a9-264c125d3953
# ╠═2334a88a-6d9c-4099-9181-826af42a8e02
# ╠═0f5a63ac-3e2c-4916-ad09-289eb2035865
# ╠═9a1546a8-c346-4c3c-939f-c70e166ed7cd
# ╠═e8e66b77-a6aa-40b5-9ad9-150cb06fa875
# ╠═a9988ae3-aa0d-44db-b9f2-6530e9c9cd5e
# ╠═927bad29-1984-4de3-9e66-2d3b2aa36b29
# ╠═129a9437-3e6a-4069-9e18-1f842015be0e
# ╠═c41b0783-ff37-47b5-85bb-3ed69aa488ac
# ╠═891d32df-b85f-448f-96e6-c89c16ac3329
# ╠═20ceca4b-026c-408a-af11-50814db1291b
# ╠═99e8c835-f03a-4346-9131-8491b1710473
# ╠═746ec674-d8cb-41a6-98d1-37e474c980d5
# ╠═4384276b-ca41-47cb-a3d2-b59d47b10fc4
# ╠═125c3c89-1653-4f02-acd9-c1f24ad9d855
# ╠═3846c242-8f0f-429d-bc31-7adf4b1c3845
# ╠═68987d7f-0947-4e49-9b57-9196592bcdee
# ╠═f2d7a38a-1d0c-4cb5-a09e-6e680e010cc2
# ╠═fcd82aeb-db9f-4c47-a85b-213f669e5394
# ╠═9c93475a-23c0-4909-84d2-e8feaf49dd28
# ╠═8873ebaa-7b2f-4ed4-82a7-db0e0dde01da
# ╠═e5fff741-03d2-491c-85f4-7fc4ce857b7a
# ╠═38c3501c-72fd-4da7-8772-e45e6c0846c8
# ╠═1d7044ae-2532-443d-a286-40946869d60e
# ╠═95def389-54b8-4276-b124-d57098d5902d
# ╠═3f8c4c38-3aec-40b1-825f-1b46b2233c7b
# ╠═8508ede4-e9be-4ff3-99e0-8f0a76b9e55c
# ╠═6bae7322-d5c1-4061-ada6-a125b36ad0c5
# ╠═5d2e3f0a-7cba-4919-aec5-19f285307f01
# ╠═1265aef1-d299-4504-99ee-f868af6901c6
# ╠═3d3dd3ad-cdcb-4445-90e1-22271ff2b7aa
# ╠═8b822173-5eb4-4fa0-adb1-fd4d60b33bd4
# ╠═4dadcefb-545c-4451-b2a1-5e00a3449edc
# ╠═576f37f0-71b5-4679-9952-272e7d7a96ae
# ╠═36c1262d-de53-4bc8-bb49-b78c45d3a56b
# ╠═0ecbc720-d7f5-4b0c-9d2d-aabd958d26c7
# ╠═23263fdf-31ec-4258-9ddd-71aa025dc168
# ╠═85a870e2-b9dc-4534-a791-de20d8b46f2d
# ╠═aca58192-8755-493b-adb9-be3926488b2c
# ╠═ba42804f-2dbc-4a3b-9f1a-a55546152aca
# ╠═98ddb4ad-2e27-4c32-a895-9ef08f1304e7
# ╠═8c4449f8-2d82-4f60-8899-b4e95186aba3
# ╠═71612bad-a14b-43e7-b4d9-dc07676a351e
# ╠═0938af0c-b09e-47d2-bcf6-f404c4515646
# ╠═7b44b8e8-14d4-4b20-89fe-47c6300fff45
# ╠═be535097-1edf-4d3e-bc49-c662cfeef457
# ╠═91d2d9c3-c4db-4b55-b999-848bc96e167d
# ╠═34e2d939-46a3-43ff-9613-b9d9d4a5af4d
# ╠═713617be-62a7-46c9-9b8c-641659645a1c
# ╠═a91f55ee-7997-4aa6-99c7-d54c21dd1413
# ╠═d98ab148-1397-4a53-ab2b-b1b399f3dfe1
