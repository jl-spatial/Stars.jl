# This script is modified from: 
#   `https://github.com/evetion/GeoArrays.jl/blob/master/src/geoarray.jl`
# Copyright (c) 2018 Maarten Pronk, MIT license

# Base.IndexStyle(::Type{T}) where {T<:GeoArray} = IndexLinear()
# Base.iterate(ga::GeoArray) = iterate(ga.A)
# Base.length(ga::GeoArray) = length(ga.A)
# Base.parent(ga::GeoArray) = ga.A
# Base.map(f, ga::GeoArray) = GeoArray(map(f, ga.A), ga.f, ga.crs)
# Base.convert(::Type{Array{T, 3}}, A::GeoArray{T}) where {T} = convert(Array{T,3}, ga.A)
Base.size(ga::GeoArray) = size(ga.A)
Base.eltype(::Type{GeoArray{T}}) where {T} = T

Base.show(io::IO, ::MIME"text/plain", ga::GeoArray) = show(io, ga)
function Base.show(io::IO, ga::GeoArray)
    crs = GeoFormatTypes.val(ga.crs)
    wkt = length(crs) == 0 ? "undefined CRS" : "CRS $crs"
    print(io, "$(join(size(ga), "x")) $(typeof(ga.A)) with $(ga.f) and $(wkt)")
end

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

export -,+,*,/


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
