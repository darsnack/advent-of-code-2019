include("../utils/intcode.jl")

function runexamples1()
    programs = [
        [1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50],
        [1, 0, 0, 0, 99],
        [2, 3, 0, 3, 99],
        [2, 4, 4, 5, 99, 0],
        [1, 1, 1, 4, 99, 5, 6, 0, 99]
    ]
    outputs = [
        [3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50],
        [2, 0, 0, 0, 99],
        [2, 3, 0, 6, 99],
        [2, 4, 4, 5, 99, 9801],
        [30, 1, 1, 4, 2, 5, 6, 0, 99]
    ]

    result = true
    println("Testing...")
    for (i, (program, output)) in enumerate(zip(programs, outputs))
        print("  running Program $i")
        intcode!(program)
        if any(program .!= output)
            println(": failed")
            result = false
        else
            println(": passed")
        end
    end

    return result
end

if runexamples1()
    println("...passed\n")
else
    println("...failed")
    exit(1)
end

origprogram = parse.(Int, split(readline("input.txt"), ","))
program = copy(origprogram)
program[_postoidx(1)] = 12
program[_postoidx(2)] = 2
intcode!(program)
println("Postion 0: $(program[_postoidx(0)])")

for i in 0:99
    for j in 0:99
        program .= origprogram
        program[_postoidx(1)] = i
        program[_postoidx(2)] = j
        intcode!(program)
        if program[_postoidx(0)] == 19690720
            println("100 * noun + verb: $(100 * i + j)")
            break
        end
    end
end