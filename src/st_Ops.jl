# Copyright (c) 2018 Maarten Pronk, MIT license
# @references
# 1. `https://github.com/evetion/GeoArrays.jl/blob/master/src/geoarray.jl`

# Base.IndexStyle(::Type{T}) where {T<:AbstractGeoArray} = IndexLinear()
# Base.iterate(ga::AbstractGeoArray) = iterate(ga.A)
# Base.length(ga::AbstractGeoArray) = length(ga.A)
# Base.parent(ga::AbstractGeoArray) = ga.A
# Base.map(f, ga::AbstractGeoArray) = AbstractGeoArray(map(f, ga.A), ga.f, ga.crs)
# Base.convert(::Type{Array{T, 3}}, A::AbstractGeoArray{T}) where {T} = convert(Array{T,3}, ga.A)
Base.size(ga::AbstractGeoArray) = size(ga.A)
Base.eltype(::Type{AbstractGeoArray{T}}) where {T} = T

Base.show(io::IO, ::MIME"text/plain", ga::AbstractGeoArray) = show(io, ga)
function Base.show(io::IO, ga::AbstractGeoArray)
    crs = GeoFormatTypes.val(ga.crs)
    wkt = length(crs) == 0 ? "undefined CRS" : "CRS $crs"
    print(io, "$(join(size(ga), "x")) $(typeof(ga.A)) with $(ga.f) and $(wkt)")
end

## OPERATIONS ------------------------------------------------------------------
"""
Check whether two `GeoArrays`s `a` and `b` are geographically equal, 
although not necessarily in content.
"""
function equals(a::AbstractGeoArray, b::AbstractGeoArray)
    size(a) == size(b) && a.f == b.f && a.crs == b.crs
end

function Base.:-(a::AbstractGeoArray, b::AbstractGeoArray)
    equals(a, b) || throw(DimensionMismatch("Can't operate on non-geographic-equal `AbstractGeoArray`s"))
    GeoArray(a.A .- b.A, a.f, a.crs)
end

function Base.:+(a::AbstractGeoArray, b::AbstractGeoArray)
    equals(a, b) || throw(DimensionMismatch("Can't operate on non-geographic-equal `AbstractGeoArray`s"))
    GeoArray(a.A .+ b.A, a.f, a.crs)
end

function Base.:*(a::AbstractGeoArray, b::AbstractGeoArray)
    equals(a, b) || throw(DimensionMismatch("Can't operate on non-geographic-equal `AbstractGeoArray`s"))
    GeoArray(a.A .* b.A, a.f, a.crs)
end

function Base.:/(a::AbstractGeoArray, b::AbstractGeoArray)
    equals(a, b) || throw(DimensionMismatch("Can't operate on non-geographic-equal `AbstractGeoArray`s"))
    GeoArray(a.A ./ b.A, a.f, a.crs)
end

Base.:+(a::AbstractGeoArray, b::Real) = GeoArray(a.A + b, a.f, a.crs)
Base.:-(a::AbstractGeoArray, b::Real) = GeoArray(a.A - b, a.f, a.crs)
Base.:*(a::AbstractGeoArray, b::Real) = GeoArray(a.A * b, a.f, a.crs)
Base.:/(a::AbstractGeoArray, b::Real) = GeoArray(a.A / b, a.f, a.crs)

export -,+,*,/


## Math OPERATIONS -------------------------------------------------------------
function Base.:sum(ga::AbstractGeoArray, dims = 3)
    arr = sum(ga.A, dims = dims)
    GeoArray(arr, ga.f, ga.crs)
end

function Base.:maximum(ga::AbstractGeoArray, dims = 3)
    arr = maximum(ga.A, dims = dims)
    GeoArray(arr, ga.f, ga.crs)
end

function Base.:minimum(ga::AbstractGeoArray, dims = 3)
    arr = minimum(ga.A, dims = dims)
    GeoArray(arr, ga.f, ga.crs)
end

function Statistics.:mean(ga::AbstractGeoArray, dims = 3)
    arr = mean(ga.A; dims = dims)
    GeoArray(arr, ga.f, ga.crs)
end

export sum, mean, maximum, minimum
