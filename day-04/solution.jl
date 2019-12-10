const inputmin = 134564
const inputmax = 585159

_inttoarr(x) = reverse(digits(x))
_arrtoint(x) = sum([reverse(x)[k] * base^(k - 1) for k in 1:length(x)])

hasdouble(x) = any(i -> x[i] == x[i + 1], 1:(length(x) - 1))
isascending(x) = foldl((p, i) -> p && (x[i] <= x[i + 1]), 1:(length(x) - 1); init = true)
function isvalid(x)
    xarr = _inttoarr(x)
    return hasdouble(xarr) && isascending(xarr)
end

nvalid = sum(isvalid.(inputmin:inputmax))
println("Number of valid passwords: $nvalid")

doubleoccurences(x) = any(map(d -> count(x .== d), 0:9) .== 2)
function isvalid2(x)
    xarr = _inttoarr(x)
    return isascending(xarr) && doubleoccurences(xarr)
end

nvalid = sum(isvalid2.(inputmin:inputmax))
println("Number of valid passwords: $nvalid")