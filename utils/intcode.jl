_postoidx(pos) = pos + 1

abstract type Instruction end

struct Add <: Instruction
    src₁::Int
    src₂::Int
    dst::Int
end
(i::Add)() = i.src₁ + i.src₂
function store!(program, i::Add, result)
    program[_postoidx(i.dst)] = result
end
increment(::Add, ip) = ip + 4

struct Mult <: Instruction
    src₁::Int
    src₂::Int
    dst::Int
end
(i::Mult)() = i.src₁ * i.src₂
function store!(program, i::Mult, result)
    program[_postoidx(i.dst)] = result
end
increment(::Mult, ip) = ip + 4

struct Input <: Instruction
    dst::Int
end
function (i::Input)()
    print("Enter an input: ")
    return parse(Int, readline())
end
function store!(program, i::Input, result)
    program[_postoidx(i.dst)] = result
end
increment(::Input, ip) = ip + 2

struct Output <: Instruction
    src::Int
end
function (i::Output)()
    println("Output: $(i.src)")
end
increment(::Output, ip) = ip + 2

struct JumpIfTrue <: Instruction
    src::Int
    dst::Int
end
(::JumpIfTrue)() = return nothing
increment(i::JumpIfTrue, ip) = (i.src != 0) ? _postoidx(i.dst) : ip + 3

struct JumpIfFalse <: Instruction
    src::Int
    dst::Int
end
(::JumpIfFalse)() = return nothing
increment(i::JumpIfFalse, ip) = (i.src == 0) ? _postoidx(i.dst) : ip + 3

struct LessThan <: Instruction
    src₁::Int
    src₂::Int
    dst::Int
end
(i::LessThan)() = (i.src₁ < i.src₂) ? 1 : 0
function store!(program, i::LessThan, result)
    program[_postoidx(i.dst)] = result
end
increment(::LessThan, ip) = ip + 4

struct Equal <: Instruction
    src₁::Int
    src₂::Int
    dst::Int
end
(i::Equal)() = (i.src₁ == i.src₂) ? 1 : 0
function store!(program, i::Equal, result)
    program[_postoidx(i.dst)] = result
end
increment(::Equal, ip) = ip + 4

struct Halt <: Instruction end
(::Halt)() = return nothing
increment(::Halt) = error("Cannot read past a halt instruction.")

# catch-alls
store!(program, i::T, result) where {T<:Instruction} = return nothing

_getparam(program, position, mode) = (mode == 1) ? program[position] : program[_postoidx(program[position])]

function _parseinstruction(program, position)
    opcode = digits(program[position]; pad = 5)

    if opcode[1:2] == [1, 0]
        src₁ = _getparam(program, position + 1, opcode[3])
        src₂ = _getparam(program, position + 2, opcode[4])
        dst = program[position + 3]
        return Add(src₁, src₂, dst)
    elseif opcode[1:2] == [2, 0]
        src₁ = _getparam(program, position + 1, opcode[3])
        src₂ = _getparam(program, position + 2, opcode[4])
        dst = program[position + 3]
        return Mult(src₁, src₂, dst)
    elseif opcode[1:2] == [3, 0]
        dst = program[position + 1]
        return Input(dst)
    elseif opcode[1:2] == [4, 0]
        src = _getparam(program, position + 1, opcode[3])
        return Output(src)
    elseif opcode[1:2] == [5, 0]
        src = _getparam(program, position + 1, opcode[3])
        dst = _getparam(program, position + 2, opcode[4])
        return JumpIfTrue(src, dst)
    elseif opcode[1:2] == [6, 0]
        src = _getparam(program, position + 1, opcode[3])
        dst = _getparam(program, position + 2, opcode[4])
        return JumpIfFalse(src, dst)
    elseif opcode[1:2] == [7, 0]
        src₁ = _getparam(program, position + 1, opcode[3])
        src₂ = _getparam(program, position + 2, opcode[4])
        dst = program[position + 3]
        return LessThan(src₁, src₂, dst)
    elseif opcode[1:2] == [8, 0]
        src₁ = _getparam(program, position + 1, opcode[3])
        src₂ = _getparam(program, position + 2, opcode[4])
        dst = program[position + 3]
        return Equal(src₁, src₂, dst)
    elseif opcode[1:2] == [9, 9]
        return Halt()
    else
        error("Unrecognized opcode: $opcode")
    end
end

function intcode!(program, position = 1)
    instr = _parseinstruction(program, position)
    (typeof(instr) == Halt) && return nothing
    result = instr()
    store!(program, instr, result)
    position = increment(instr, position)

    intcode!(program, position)
end