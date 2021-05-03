# Classic Computer Science Problems in Julia
This is the driver repository for [`Classic.jl`](https://github.com/ykyang/Classic.jl) which follows the book [Classic Computer Science Problems in Java](https://livebook.manning.com/book/classic-computer-science-problems-in-java) and translated into Julia.

## Setup
```julia
julia> using Pkg
julia> Pkg.add(PackageSpec(url="https://ykyang@github.com/ykyang/Classic.jl.git", rev="main"), preserve=PRESERVE_DIRECT)
julia> Pkg.instantiate()
```
To work on `Classic.jl` package
```
(sim_data) pkg> develop --local Classic
```
Restore `Classic` (remove `dev/Classic/`) which is unregistered by
```
Pkg.add(PackageSpec(url="https://ykyang@github.com/ykyang/Classic.jl.git", rev="main"), preserve=PRESERVE_DIRECT)
```
For a registered package this is done by the `free` command.


## Breadth-first search
`bfs_heatmap(maze)` plots a maze solved by BFS.

![BFS](assets/solve_maze_with_bfs_50x50.png)

A more dense maze.

![BFS](assets/solve_maze_with_bfs_50x50_dense.png)