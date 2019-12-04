_postoidx(pos) = pos + 1
function _opcode(x)
    if x == 1
        return :add
    elseif x == 2
        return :mul
    elseif x == 99
        return :halt
    else
        @warn "Unknown opcode: $x"
        exit(1)
    end
end

function intcode!(program, position = 1)
    opcode = _opcode(program[position])
    if opcode == :add
        result = program[_postoidx(program[position + 1])] + program[_postoidx(program[position + 2])]
        dst = _postoidx(program[position + 3])
        program[dst] = result
    elseif opcode == :mul
        result = program[_postoidx(program[position + 1])] * program[_postoidx(program[position + 2])]
        dst = _postoidx(program[position + 3])
        program[dst] = result
    elseif opcode == :halt
        return nothing
    end

    intcode!(program, position + 4)
end