using LightGraphs

struct OrbitMap
    g::SimpleGraph
    idmap::Dict{String, Int}
end
function OrbitMap()
    g = SimpleGraph(1)
    idmap = Dict(["COM" => 1])

    OrbitMap(g, idmap)
end

hasvertex(o::OrbitMap, name::String) = haskey(o.idmap, name)

function addvertex!(o::OrbitMap, name::String)
    add_vertex!(o.g)
    o.idmap[name] = nv(o.g)
end

addedge!(o::OrbitMap, src::String, dst::String) = add_edge!(o.g, o.idmap[src], o.idmap[dst])

function mkgraph(orbits)
    orbitmap = OrbitMap()
    for (src, dst) in orbits
        !hasvertex(orbitmap, src) && addvertex!(orbitmap, src)
        !hasvertex(orbitmap, dst) && addvertex!(orbitmap, dst)
        addedge!(orbitmap, src, dst)
    end

    return orbitmap
end

function _orbittopair(x)
    p = split(x, ")")
    return String(p[1]) => String(p[2])
end

ndirectorbits(o::OrbitMap) = ne(o.g)
norbits(o::OrbitMap) = sum(gdistances(o.g, 1))
ntransfers(o::OrbitMap, src::Int, dst::Int) = length(a_star(o.g, src, dst)) - 2
ntransfers(o::OrbitMap, src::String, dst::String) = ntransfers(o, o.idmap[src], o.idmap[dst])

orbits = _orbittopair.(readlines("input.txt"))
# orbits = _orbittopair.(["COM)B",
#                         "B)C",
#                         "C)D",
#                         "D)E",
#                         "E)F",
#                         "B)G",
#                         "G)H",
#                         "D)I",
#                         "E)J",
#                         "J)K",
#                         "K)L",
#                         "K)YOU",
#                         "I)SAN"])
orbitmap = mkgraph(orbits)
println("Number of direct and indirect orbits: $(norbits(orbitmap))")
println("Minimum number of orbit transfers: $(ntransfers(orbitmap, "YOU", "SAN"))")