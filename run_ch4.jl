include("Classic.jl")

using Test 

import .Classic
cc = Classic

function init!(g::cc.Graph{V,E}) where {V,E<:cc.Edge}
    cities = Vector{String}(["Seattle", "San Francisco",  
    "Los Angeles", "Riverside", "Phoenix", "Chicago", "Boston",
    "New York", "Atlanta", "Miami", "Dallas", "Houston", "Detroit",
    "Philadelphia", "Washington",
    ])
    
    append!(g,cities)

    cc.add!(g, "Seattle", "Chicago")
    cc.add!(g, "Seattle","San Francisco")
    cc.add!(g, "San Francisco", "Riverside")
    cc.add!(g, "San Francisco", "Los Angeles")
    cc.add!(g, "Los Angeles", "Riverside")
    cc.add!(g, "Los Angeles", "Phoenix")
    cc.add!(g, "Riverside", "Phoenix")
    cc.add!(g, "Riverside", "Chicago")
    cc.add!(g, "Phoenix", "Houston")
    cc.add!(g, "Dallas", "Chicago")
    cc.add!(g, "Dallas", "Atlanta")
    cc.add!(g, "Dallas", "Houston")
    cc.add!(g, "Houston", "Atlanta")
    cc.add!(g, "Houston", "Miami")
    cc.add!(g, "Atlanta", "Chicago")
    cc.add!(g, "Atlanta", "Washington")
    cc.add!(g, "Atlanta", "Miami")
    cc.add!(g, "Miami", "Washington")
    cc.add!(g, "Chicago", "Detroit")
    cc.add!(g, "Detroit", "Boston")
    cc.add!(g, "Detroit", "Washington")
    cc.add!(g, "Detroit", "Washington")
    cc.add!(g, "Detroit", "New York")
    cc.add!(g, "Boston", "New York")
    cc.add!(g, "New York", "Philadelphia")
    cc.add!(g, "Philadelphia", "Washington")

    return cities
end

function run_UnweightedGraph()
    g = cc.UnweightedGraph{String,cc.Edge}()
    cities = init!(g)
    @test length(cities) == length(g.vertices)
    @test length(cities) == length(g.edges_lists)
   
    for edges in g.edges_lists
        @test !isempty(edges)
    end

    show(g)

    is_goal(pt) = cc.is_goal("Miami", pt)
    neighbor_of(v) = cc.neighbor_of(g, v)

    node = cc.bfs("Boston", is_goal, neighbor_of)
    
    println("Shortest route: $(cc.node_to_path(node))")

    nothing
end

run_UnweightedGraph()
