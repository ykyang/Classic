using Test

using Dash, DashHtmlComponents, DashCoreComponents, DashBootstrapComponents
using PlotlyJS
using DataFrames

using Classic

function run_resistivity_gui(io::IO)
    V = Tuple{Int64,Int64} # Vertex type
    i_count = 50
    k_count = 50
    plate = Matrix{Float64}(undef, i_count, k_count) # resistivity
    plate .= 100 # omh-m
    plate[10:30, 1:10] .= 1

    plate_graph = WeightedGraph{V, WeightedEdge}()
    vertices = Vector{V}()
    for i = 1:i_count
        for k = 1:k_count
            push!(vertices, (i,k))
        end
    end

    append!(plate_graph, vertices)
    A = 1.0 # cross section area
    for i = 1:i_count # horizontal connection
        for k = 1:k_count-1
            resistance = 0.5*(plate[i,k] + plate[i,k+1])*A/1.0 # 1.0 is the distance
            
            add!(plate_graph, (i,k), (i,k+1), resistance)
        end
    end
    for i = 1:i_count-1 # vertical connection
        for k = 1:k_count
            resistance = 0.5*(plate[i,k] + plate[i+1,k])*A/1.0 # 1.0 is the distance
            
            add!(plate_graph, (i,k), (i+1,k), resistance)
        end
    end

    #@show plate_graph
    dijkstra_result = dijkstra(plate_graph, (1,1))
    @test DijkstraResult == typeof(dijkstra_result)
    #println(io, dijkstra_result)
    # Dict{V,Float64}
    distance_db = distances_to_distance_db(plate_graph, dijkstra_result.distances)
    @test Dict{V,Float64} == typeof(distance_db)

    #println(io, distance_db)

    # shortest distance from start to each point
    distance_m = Matrix{Float64}(undef, i_count, k_count)
    for distance in distance_db
        #@test Pair{V,Float64} == typeof(distance)
        distance_m[distance[1]...] = distance[2]
    end

    app = dash(external_stylesheets=[dbc_themes.SPACELAB])

    navbar = dbc_navbarsimple([
        dbc_dropdownmenu([
            dbc_dropdownmenuitem("Resistivity", href="#resistivity", external_link=true),
            dbc_dropdownmenuitem("Resistance", href="#resistance", external_link=true),
            # dbc_dropdownmenuitem("", href="", external_link=true),
        ],
        in_navbar=true, label="Section", caret=true, direction="left"),
    ], 
    sticky="top", expand=true, brand="WDVG", brand_href="https://www.wdvgco.com",
    )
    content =[
        dbc_container([html_h3("Resistivity", id="resistivity"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(resistivity_heatmap(plate)...),
                config = Dict(),
            )
        ], className="p-3 my-2 border rounded"),
        dbc_container([html_h3("Resistance", id="resistance"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(resistance_heatmap(distance_m)...),
                config = Dict(),
            )
        ], className="p-3 my-2 border rounded"),
    ]
    pushfirst!(content, navbar)
    app.layout = dbc_container(content)

    run_server(
        app, 
        "0.0.0.0", 
        8055, 
        debug=true, # enables hot reload and more
    )
   
end

function resistivity_heatmap(distance_m::Matrix{Float64})
    traces = Vector{AbstractTrace}([
        heatmap(
            z = distance_m,
        )
    ])
    layout = Layout(
        #width = 600,
        #height = 200,
    )

    return traces, layout
end

function resistance_heatmap(distance_m::Matrix{Float64})
    traces = Vector{AbstractTrace}([
        heatmap(
            z = distance_m,
        )
    ])
    layout = Layout(
        #width = 600,
        #height = 200,
    )

    return traces, layout
end

io = devnull
io = stdout

run_resistivity_gui(io)

nothing


