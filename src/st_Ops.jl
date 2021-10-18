## OPERATIONS ------------------------------------------------------------------
"""Check whether two `GeoArrays`s `a` and `b` are
geographically equal, although not necessarily in content."""
function equals(a::GeoArray, b::GeoArray)
    size(a) == size(b) && a.f == b.f && a.crs == b.crs
end

function Base.:-(a::GeoArray, b::GeoArray)
    equals(a, b) || throw(DimensionMismatch("Can't operate on non-geographic-equal `GeoArray`s"))
    GeoArray(a.A .- b.A, a.f, a.crs)
end

function Base.:+(a::GeoArray, b::GeoArray)
    equals(a, b) || throw(DimensionMismatch("Can't operate on non-geographic-equal `GeoArray`s"))
    GeoArray(a.A .+ b.A, a.f, a.crs)
end

function Base.:*(a::GeoArray, b::GeoArray)
    equals(a, b) || throw(DimensionMismatch("Can't operate on non-geographic-equal `GeoArray`s"))
    GeoArray(a.A .* b.A, a.f, a.crs)
end

function Base.:/(a::GeoArray, b::GeoArray)
    equals(a, b) || throw(DimensionMismatch("Can't operate on non-geographic-equal `GeoArray`s"))
    GeoArray(a.A ./ b.A, a.f, a.crs)
end

Base.:+(a::GeoArray, b::Real) = GeoArray(a.A + b, a.f, a.crs)
Base.:-(a::GeoArray, b::Real) = GeoArray(a.A - b, a.f, a.crs)
Base.:*(a::GeoArray, b::Real) = GeoArray(a.A * b, a.f, a.crs)
Base.:/(a::GeoArray, b::Real) = GeoArray(a.A / b, a.f, a.crs)


## Math OPERATIONS -------------------------------------------------------------
function Base.:sum(ga::GeoArray, dims = 3)
    arr = sum(ga.A, dims = dims)
    GeoArray(arr, ga.f, ga.crs)
end

function Statistics.:mean(ga::GeoArray, dims = 3)
    arr = mean(ga.A; dims = dims)
    GeoArray(arr, ga.f, ga.crs)
end

function Base.:maximum(ga::GeoArray, dims = 3)
    arr = maximum(ga.A, dims = dims)
    GeoArray(arr, ga.f, ga.crs)
end

function Base.:minimum(ga::GeoArray, dims = 3)
    arr = minimum(ga.A, dims = dims)
    GeoArray(arr, ga.f, ga.crs)
end


export sum, mean, maximum, minimum
