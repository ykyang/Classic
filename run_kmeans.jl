using Dash, DashHtmlComponents, DashCoreComponents, DashBootstrapComponents
using PlotlyJS
using DataFrames

using Classic

function run_kmeans_governor(k=2)::KMeans
    pointvec = Vector{Governor}()
    begin # add data
        push!(pointvec, Governor(-86.79113, 72, "Alabama"))
        #push!(pointvec, Governor(-152.404419, 66, "Alaska"))
        push!(pointvec, Governor(-111.431221, 53, "Arizona"))
        push!(pointvec, Governor(-92.373123, 66, "Arkansas"))
        push!(pointvec, Governor(-119.681564, 79, "California"))
        push!(pointvec, Governor(-105.311104, 65, "Colorado"))
        push!(pointvec, Governor(-72.755371, 61, "Connecticut"))
        push!(pointvec, Governor(-75.507141, 61, "Delaware"))
        push!(pointvec, Governor(-81.686783, 64, "Florida"))
        push!(pointvec, Governor(-83.643074, 74, "Georgia"))
        #push!(pointvec, Governor(-157.498337, 60, "Hawaii"))
        push!(pointvec, Governor(-114.478828, 75, "Idaho"))
        push!(pointvec, Governor(-88.986137, 60, "Illinois"))
        push!(pointvec, Governor(-86.258278, 49, "Indiana"))
        push!(pointvec, Governor(-93.210526, 57, "Iowa"))
        push!(pointvec, Governor(-96.726486, 60, "Kansas"))
        push!(pointvec, Governor(-84.670067, 50, "Kentucky"))
        push!(pointvec, Governor(-91.867805, 50, "Louisiana"))
        push!(pointvec, Governor(-69.381927, 68, "Maine"))
        push!(pointvec, Governor(-76.802101, 61, "Maryland"))
        push!(pointvec, Governor(-71.530106, 60, "Massachusetts"))
        push!(pointvec, Governor(-84.536095, 58, "Michigan"))
        push!(pointvec, Governor(-93.900192, 70, "Minnesota"))
        push!(pointvec, Governor(-89.678696, 62, "Mississippi"))
        push!(pointvec, Governor(-92.288368, 43, "Missouri"))
        push!(pointvec, Governor(-110.454353, 51, "Montana"))
        push!(pointvec, Governor(-98.268082, 52, "Nebraska"))
        push!(pointvec, Governor(-117.055374, 53, "Nevada"))
        push!(pointvec, Governor(-71.563896, 42, "New Hampshire"))
        push!(pointvec, Governor(-74.521011, 54, "New Jersey"))
        push!(pointvec, Governor(-106.248482, 57, "New Mexico"))
        push!(pointvec, Governor(-74.948051, 59, "New York"))
        push!(pointvec, Governor(-79.806419, 60, "North Carolina"))
        push!(pointvec, Governor(-99.784012, 60, "North Dakota"))
        push!(pointvec, Governor(-82.764915, 65, "Ohio"))
        push!(pointvec, Governor(-96.928917, 62, "Oklahoma"))
        push!(pointvec, Governor(-122.070938, 56, "Oregon"))
        push!(pointvec, Governor(-77.209755, 68, "Pennsylvania"))
        push!(pointvec, Governor(-71.51178, 46, "Rhode Island"))
        push!(pointvec, Governor(-80.945007, 70, "South Carolina"))
        push!(pointvec, Governor(-99.438828, 64, "South Dakota"))
        push!(pointvec, Governor(-86.692345, 58, "Tennessee"))
        push!(pointvec, Governor(-97.563461, 59, "Texas"))
        push!(pointvec, Governor(-111.862434, 70, "Utah"))
        push!(pointvec, Governor(-72.710686, 58, "Vermont"))
        push!(pointvec, Governor(-78.169968, 60, "Virginia"))
        push!(pointvec, Governor(-121.490494, 66, "Washington"))
        push!(pointvec, Governor(-80.954453, 66, "West Virginia"))
        push!(pointvec, Governor(-89.616508, 49, "Wisconsin"))
        push!(pointvec, Governor(-107.30249, 55, "Wyoming"))
    end

    #println(io, pointvec)
    kmeans = KMeans(k, pointvec)
    run!(kmeans, 100)

    return kmeans
end
function run_kmeans_governor_gui(io::IO)
    cluster_count = 4
    kmeans = run_kmeans_governor(cluster_count)
    traces_original = Vector{AbstractTrace}()
    for i in 1:cluster_count
        x = slice_original(kmeans.clustervec[i].pointvec,1)
        y = slice_original(kmeans.clustervec[i].pointvec,2)
        t = slice_state(kmeans.clustervec[i].pointvec)
        push!(
            traces_original, 
            scatter(
                x=x,y=y,
                mode="markers",
                text = t,
            )
        )
    end
    traces_derived = Vector{AbstractTrace}()
    for i in 1:cluster_count
        x = slice_derived(kmeans.clustervec[i].pointvec,1)
        y = slice_derived(kmeans.clustervec[i].pointvec,2)
        t = slice_state(kmeans.clustervec[i].pointvec)
        push!(
            traces_derived, 
            scatter(
                x=x,y=y,
                mode="markers",
                text = t,
            )
        )
    end

    x1 = slice_original(kmeans.clustervec[1].pointvec,1)
    y1 = slice_original(kmeans.clustervec[1].pointvec,2)
    x2 = slice_original(kmeans.clustervec[2].pointvec,1)
    y2 = slice_original(kmeans.clustervec[2].pointvec,2)
    t1 = slice_state(kmeans.clustervec[1].pointvec)
    t2 = slice_state(kmeans.clustervec[2].pointvec)

    x3 = slice_derived(kmeans.clustervec[1].pointvec,1)
    y3 = slice_derived(kmeans.clustervec[1].pointvec,2)
    x4 = slice_derived(kmeans.clustervec[2].pointvec,1)
    y4 = slice_derived(kmeans.clustervec[2].pointvec,2)

    app = dash(external_stylesheets=[dbc_themes.SPACELAB])
    content = [
        dbc_container([html_h3("Clustering of governors", id="kmeans_governor_original"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(traces_original, Layout()),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded"),
        dbc_container([html_h3("Clustering of governors", id="kmeans_governor_derived"),
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(traces_derived, Layout()),
                config = Dict(),
            ),
        ], className="p-3 my-2 border rounded"),
    ] 

    app.layout = dbc_container(content)

    run_server(
        app, 
        "0.0.0.0", 
        8055, 
        debug=true, # enables hot reload and more
    )
end

io = stdout
io = devnull

run_kmeans_governor_gui(io)

nothing