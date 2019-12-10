include("../utils/intcode.jl")

println("Part 1:")
origprogram = parse.(Int, split(readline("input.txt"), ","))
intcode!(copy(origprogram))

println("Part 2:")
intcode!(origprogram)