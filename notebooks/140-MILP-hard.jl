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

# ╔═╡ 061ee62a-2203-4d54-8daa-9792d5980088
begin
    using PlutoUI
    PlutoUI.TableOfContents()
end

# ╔═╡ 57876bd7-eebe-41f6-a5d5-bb75b38f2211
md"""
# Modelo PLE Dificil
"""

# ╔═╡ 5751108d-6a44-4d33-9386-5d811638c6f0
begin
    m = JuMP.Model()

    @variable(m, x1 >= 1, Int)
    @variable(m, x2 >= 0, Int)
    @variable(m, x3 >= 0, Int)

    @objective(m, Min, x1)
    @constraint(m, r1, 12345 * x1 == 23456 * x2 + 34567 * x3)

    JuMP.latex_formulation(m)
end

# ╔═╡ a6eee931-889a-4bb1-993a-831a091c0eb7
md"""
## Solucion con JuMP
"""

# ╔═╡ c47d8551-2317-493c-a67a-0c892fa6dd82
begin
    JuMP.set_optimizer(m, GLPK.Optimizer)
    JuMP.set_optimizer_attribute(m, "msg_lev", GLP_MSG_ALL)
    JuMP.set_optimizer_attribute(m, "tm_lim", 15 * 1000)

    JuMP.optimize!(m)
end

# ╔═╡ 1865a2ca-50cf-49e0-b483-5346f84ce306
JuMP.solution_summary(m)

# ╔═╡ cf52cb9a-a2d9-4b58-8e58-a8b4f279d21a
JuMP.value.([x1, x2, x3])

# ╔═╡ 396eab5a-a879-4080-9e99-7fc6e8975519
md"""
## JuMP + Callback Heuristic
"""

# ╔═╡ 6de37475-c535-4f19-a039-1b1f87b4e044
mh = JuMP.copy(m)

# ╔═╡ 46028570-c4ab-4cd8-9fd0-46772e9fb57c
function myCallbackHeuristic(cb_data)
    x = JuMP.all_variables(mh)
    x_val = JuMP.callback_value.(cb_data, x)

    if x_val[1] <= 17284.0 + eps()
        return
    end

    ret = callback_node_status(cb_data, mh)
    println("** myCallbackHeuristic node_status = $(ret)")

    x_vals = [17284.0, 1.0, 6172.0]
    ret = JuMP.MOI.submit(mh, JuMP.MOI.HeuristicSolution(cb_data), x, x_vals)
    println("** myCallbackHeuristic status = $(ret)")
    return
end

# ╔═╡ db2273b6-b8b2-450a-8413-cf2ba3a65f36
begin
    JuMP.set_optimizer(mh, GLPK.Optimizer)
    JuMP.set_optimizer_attribute(mh, "msg_lev", GLP_MSG_ALL)
    JuMP.set_optimizer_attribute(mh, "tm_lim", 15 * 1000)

    JuMP.MOI.set(mh, JuMP.MOI.HeuristicCallback(), myCallbackHeuristic)

    JuMP.optimize!(mh)
end

# ╔═╡ f0985fc1-b292-4688-9875-07ed56158cda
md"""
## JuMP + Callback LazyConstraint
"""

# ╔═╡ ce4aeb75-7686-4db1-9284-92f89addbbde
ml = JuMP.copy(m)

# ╔═╡ da2f7d82-8ed0-47f1-95e9-92fbbd127b66
function myCallbackLazyConstraint(cb_data)
    x = JuMP.all_variables(ml)
    x_val = JuMP.callback_value.(cb_data, x)

    if x_val[1] >= 17284.0 - eps(Float16)
        return
    end

    ret = callback_node_status(cb_data, ml)
    println("** myCallbackLazyConstraint node_status = $(ret)")

    con = @build_constraint(x[3] == 6172.0)
    ret = JuMP.MOI.submit(ml, JuMP.MOI.LazyConstraint(cb_data), con)
    println("** myCallbackLazyConstraint status = $(ret)")
    return
end

# ╔═╡ 171093e1-342d-40ef-bebf-f575d5bd553a
begin
    JuMP.set_optimizer(ml, GLPK.Optimizer)
    JuMP.set_optimizer_attribute(ml, "msg_lev", GLP_MSG_ALL)
    JuMP.set_optimizer_attribute(ml, "tm_lim", 15 * 1000)

    JuMP.MOI.set(ml, JuMP.MOI.LazyConstraintCallback(), myCallbackLazyConstraint)

    JuMP.optimize!(ml)
end

# ╔═╡ 33fbe0c7-20b6-4deb-8e9a-35926d524234
md"""
## JuMP + Callback UserCut
"""

# ╔═╡ 7aa50b2c-dea5-4d0c-bfa5-a2692080a859
mc = JuMP.copy(m)

# ╔═╡ f3210cbd-dffc-46ae-abac-17691942a472
function myCallbackUserCut(cb_data)
    x = JuMP.all_variables(mc)
    x_val = JuMP.callback_value.(cb_data, x)

    if x_val[1] >= 17284.0 - eps(Float16)
        return
    end

    ret = callback_node_status(cb_data, mc)
    println("** myCallbackUserCut node_status = $(ret)")

    con = @build_constraint(x[3] >= 6172.0)
    ret = JuMP.MOI.submit(mc, JuMP.MOI.UserCut(cb_data), con)
    println("** myCallbackUserCut status = $(ret)")
    return
end

# ╔═╡ fb641ebc-03fb-4792-94e0-6820bbe82793
begin
    JuMP.set_optimizer(mc, GLPK.Optimizer)
    JuMP.set_optimizer_attribute(mc, "msg_lev", GLP_MSG_ALL)
    JuMP.set_optimizer_attribute(mc, "tm_lim", 15 * 1000)

    JuMP.MOI.set(mc, JuMP.MOI.UserCutCallback(), myCallbackUserCut)

    JuMP.optimize!(mc)
end

# ╔═╡ Cell order:
# ╠═ca2d345e-ac76-11ec-2164-8f36e66bc097
# ╠═ca2d347e-ac76-11ec-01ab-61d4b5dd60ba
# ╠═ca2d3486-ac76-11ec-2609-c5cacd5e1fa4
# ╠═57876bd7-eebe-41f6-a5d5-bb75b38f2211
# ╠═5751108d-6a44-4d33-9386-5d811638c6f0
# ╠═a6eee931-889a-4bb1-993a-831a091c0eb7
# ╠═c47d8551-2317-493c-a67a-0c892fa6dd82
# ╠═1865a2ca-50cf-49e0-b483-5346f84ce306
# ╠═cf52cb9a-a2d9-4b58-8e58-a8b4f279d21a
# ╠═396eab5a-a879-4080-9e99-7fc6e8975519
# ╠═6de37475-c535-4f19-a039-1b1f87b4e044
# ╠═46028570-c4ab-4cd8-9fd0-46772e9fb57c
# ╠═db2273b6-b8b2-450a-8413-cf2ba3a65f36
# ╠═f0985fc1-b292-4688-9875-07ed56158cda
# ╠═ce4aeb75-7686-4db1-9284-92f89addbbde
# ╠═da2f7d82-8ed0-47f1-95e9-92fbbd127b66
# ╠═171093e1-342d-40ef-bebf-f575d5bd553a
# ╠═33fbe0c7-20b6-4deb-8e9a-35926d524234
# ╠═7aa50b2c-dea5-4d0c-bfa5-a2692080a859
# ╠═f3210cbd-dffc-46ae-abac-17691942a472
# ╠═fb641ebc-03fb-4792-94e0-6820bbe82793
# ╠═061ee62a-2203-4d54-8daa-9792d5980088
