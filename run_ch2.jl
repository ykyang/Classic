using Test

using Dash, DashHtmlComponents, DashCoreComponents, DashBootstrapComponents
using PlotlyJS
using DataFrames

using Classic
#cc = Classic


function run_astar()
    maze = cc.new_maze(10, 10, (1,1), (10,10), 0.2)

    # create functions for bfs()
    is_goal(pt)     = cc.is_goal(maze.goal, pt)
    next_points(pt) = cc.next_points(maze.grid, pt)
    heuristic(pt)   = cc.manhattan_distance(pt, maze.goal)

    node = cc.a_star((1,1), is_goal, next_points, heuristic)

    if isnothing(node)
        println("Path not found")
        display(maze.grid) # print the unsovled maze
    else
        cc.mark_path!(maze.grid, node, start=maze.start, goal=maze.goal)
        display(maze.grid) # print the maze and the path
    end
end

function run_bfs()
    maze = cc.new_maze(10, 10, (1,1), (10,10), 0.2)

    # create functions for bfs()
    is_goal(pt)     = cc.is_goal(maze.goal, pt)
    next_points(pt) = cc.next_points(maze.grid, pt)

    node = cc.bfs((1,1), is_goal, next_points)

    if isnothing(node)
        println("Path not found")
        display(maze.grid) # print the unsovled maze
    else
        cc.mark_path!(maze.grid, node, start=maze.start, goal=maze.goal)
        display(maze.grid) # print the maze and the path
    end
end

function run_cell()
    x = cc.EMPTY
    y = cc.START

    println("x = $(string(x)), y = $(string(y))")
end

"""
    run_dfs()

Use depth-first search to solve a maze.
"""
function run_dfs()
    maze = cc.new_maze() #new_maze(10,10, [1,1], [10,10], 0.2)
    #@show maze
    #display(maze.grid)

    #node = ch2.Node()
    #locations = ch2.successors(maze.grid, (2,2))
    #@show locations

    # pass this to dfs(..., successors)
    successors(here) = cc.successors(maze.grid, here)
    # pass this to dfs(..., goal_test, ...)
    is_goal(here) = cc.is_goal(maze.goal, here)

    node = cc.dfs((1,1), is_goal, successors)
    if isnothing(node)
        println("Path not found")
        display(maze.grid)
    else
        cc.mark_path!(maze.grid, node, start=maze.start, goal=maze.goal)
        #@show maze
        display(maze.grid)
    end
    #@show node
end

function run_bfs_gui()
    maze = new_maze(50, 50, (1,1), (50,50), 0.2)

    # create functions for bfs()
    is_goal(pt)     = Classic.is_goal(maze.goal, pt)
    next_points(pt) = Classic.next_points(maze.grid, pt)

    node = bfs((1,1), is_goal, next_points)

    if isnothing(node)
        println("Path not found")
        display(maze.grid) # print the unsovled maze
    else
        mark_path!(maze.grid, node, start=maze.start, goal=maze.goal)
        display(maze.grid) # print the maze and the path
    end

    app = dash(external_stylesheets=[dbc_themes.SPACELAB])

    navbar = dbc_navbarsimple([
        dbc_dropdownmenu([
            dbc_dropdownmenuitem("BFS", href="#bfs", external_link=true),
            # dbc_dropdownmenuitem("", href="", external_link=true),
        ],
        in_navbar=true, label="Section", caret=true, direction="left"),
    ], 
    sticky="top", expand=true, brand="WDVG", brand_href="https://www.wdvgco.com",
    )
    content =[
        dbc_container([
            dbc_badge("Line: $(@__LINE__)", color="info", className="ml-1"),
            dcc_graph(
                figure = Plot(bfs_heatmap(maze)...),
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

function bfs_heatmap(maze::Maze)
    start = maze.start
    goal = maze.goal
    z = convert(Matrix{Int64}, maze.grid)
    # z =  [[1, 20, 30], [20, 1, 60], [30, 60, 1]]
    # z = hcat(z...)

    # Normalize color scale
    # Details at
    # https://community.plotly.com/t/colors-for-discrete-ranges-in-heatmaps/7780/10
    colorscale = [
        [0, "rgb(250,250,250)"],
        [1/4, "rgb(0,0,0)"],
        [2/4, "rgb(250, 75, 0)"],
        [3/4, "rgb(250, 75, 0)"],
        [4/4, "rgb(0, 250, 100)"],
    ]

    traces = Vector{AbstractTrace}([
        heatmap(
            z = z,
            zmin = 0,
            zmax = 4,
            colorscale = colorscale,
            showscale = false,
        )
    ])
    layout = Layout(
        title = "Solve maze with BFS",
        xaxis = Dict(
            :ticks => "",
            :showticklabels => false,
        ),
        yaxis = Dict(
            :ticks => "",
            :showticklabels => false,
        ),
        annotations = [],
    )
    annotations = layout["annotations"] # shortcut
    annotation = Dict(
        :x => start[1] - 1,
        :y => start[2] - 1 ,
        :text => "", #"S",
        #:showtext => false,
        :showarrow => false,
    )
    push!(annotations, annotation)
    annotation = Dict(
        :x => goal[1] - 1,
        :y => goal[2] - 1,
        :text => "", #"G",
        :showarrow => false,
    )
    push!(annotations, annotation)

    return traces, layout
end

#run_astar()
#run_cell()
#run_dfs()
#run_bfs()

run_bfs_gui()

nothing

#A = test_manhattan_distance()
#A # Test.Pass or not
