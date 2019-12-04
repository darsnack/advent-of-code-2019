_masstofuel(mass) = Int(floor(mass / 3) - 2)
function computefuel(x)
    fuel = _masstofuel(x)
    return (fuel <= 0) ? zero(fuel) : computefuel(fuel) + fuel
end

function runexamples1()
    masses = [12, 14, 1969, 100756]
    fuels = [2, 2, 654, 33583]

    println("Testing...")
    testresults = true
    for (mass, fuel) in zip(masses, fuels)
        result = _masstofuel(mass) == fuel
        println("  mass = $mass, fuel = $fuel: $(result ? "correct" : "wrong")")
        testresults &= result
    end

    return testresults
end

function runexamples2()
    masses = [12, 14, 1969, 100756]
    fuels = [2, 2, 966, 50346]

    println("Testing...")
    testresults = true
    for (mass, fuel) in zip(masses, fuels)
        result = computefuel(mass) == fuel
        println("  mass = $mass, fuel = $fuel: $(result ? "correct" : "wrong (result = $(computefuel(mass)))")")
        testresults &= result
    end

    return testresults
end

if runexamples1()
    println("...passed\n")
else
    println("...failed")
    exit(1)
end

if runexamples2()
    println("...passed\n")
else
    println("...failed")
    exit(1)
end

totalfuel = 0
@time for line in eachline("input.txt")
    global totalfuel += computefuel(parse(Int, line))
end
println("Total fuel required: $totalfuel")