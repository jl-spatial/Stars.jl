# Copyright (c) 2018 Maarten Pronk, MIT license
# @references
# 1. `https://github.com/evetion/GeoArrays.jl/blob/master/src/geoarray.jl`
import Base.==


# Base.IndexStyle(::Type{T}) where {T<:AbstractGeoArray} = IndexLinear()
# Base.convert(::Type{Array{T, 3}}, A::AbstractGeoArray{T}) where {T} = convert(Array{T,3}, ga.A)
Base.iterate(ga::AbstractGeoArray) = iterate(ga.A)
Base.length(ga::AbstractGeoArray) = length(ga.A)
Base.parent(ga::AbstractGeoArray) = ga.A
Base.map(f, ga::AbstractGeoArray) = GeoArray(map(f, ga.A), ga.f, ga.crs) # ?
Base.size(ga::AbstractGeoArray) = size(ga.A)
Base.eltype(::Type{AbstractGeoArray{T}}) where {T} = T

Base.show(io::IO, ::MIME"text/plain", ga::AbstractGeoArray) = show(io, ga)
function Base.show(io::IO, ga::AbstractGeoArray)
    crs = GeoFormatTypes.val(ga.crs)
    wkt = length(crs) == 0 ? "undefined CRS" : "CRS $crs"
    print(io, "size  : $(join(size(ga), "x")) $(typeof(ga.A))")
    print(io, "\nextent: $(st_bbox(ga)) [xmin, ymin, xmax, ymax]")
    print(io, "\nnames : $(ga.names)")
    print(io, "\naffine: $(ga.f)")
    print(io, "\ncrs   : $(wkt)")
    print(io, "\ntime  : $(ga.time)")
end

## OPERATIONS ------------------------------------------------------------------
"""
Check whether two `GeoArrays`s `a` and `b` are geographically equal, 
although not necessarily in content.
"""
function equals(a::AbstractGeoArray, b::AbstractGeoArray)
    size(a) == size(b) && a.f == b.f && a.crs == b.crs
end

function ==(a::AbstractGeoArray, b::AbstractGeoArray)
    size(a) == size(b) && a.f == b.f && a.crs == b.crs
end

function ==(a::AbstractGeoArray, b::Real)
    GeoArray(a, vals=a.A .== b)
end


function Base.:-(a::AbstractGeoArray, b::AbstractGeoArray)
    equals(a, b) || throw(DimensionMismatch("Can't operate on non-geographic-equal `AbstractGeoArray`s"))
    GeoArray(a, vals=a.A .- b.A)
end

function Base.:+(a::AbstractGeoArray, b::AbstractGeoArray)
    equals(a, b) || throw(DimensionMismatch("Can't operate on non-geographic-equal `AbstractGeoArray`s"))
    GeoArray(a, vals=a.A .+ b.A)
end

function Base.:*(a::AbstractGeoArray, b::AbstractGeoArray)
    equals(a, b) || throw(DimensionMismatch("Can't operate on non-geographic-equal `AbstractGeoArray`s"))
    GeoArray(a, vals=a.A .* b.A)
end

function Base.:/(a::AbstractGeoArray, b::AbstractGeoArray)
    equals(a, b) || throw(DimensionMismatch("Can't operate on non-geographic-equal `AbstractGeoArray`s"))
    GeoArray(a, vals=a.A ./ b.A)
end

Base.:+(a::AbstractGeoArray, b::Real) = GeoArray(a, vals=a.A + b)
Base.:-(a::AbstractGeoArray, b::Real) = GeoArray(a, vals=a.A - b)
Base.:*(a::AbstractGeoArray, b::Real) = GeoArray(a, vals=a.A * b)
Base.:/(a::AbstractGeoArray, b::Real) = GeoArray(a, vals=a.A / b)

Base.isless(a::Real, ga::AbstractGeoArray) = rast(ga, vals=ga.A .> a)

export -, +, *, /, isless, equals, isequal, ==


## Math OPERATIONS -------------------------------------------------------------
function Base.:sum(ga::AbstractGeoArray, dims=3)
    arr = sum(ga.A, dims=dims)
    GeoArray(arr, ga.f, ga.crs)
end

function Base.:maximum(ga::AbstractGeoArray, dims=3)
    arr = maximum(ga.A, dims=dims)
    GeoArray(arr, ga.f, ga.crs)
end

function Base.:minimum(ga::AbstractGeoArray, dims=3)
    arr = minimum(ga.A, dims=dims)
    GeoArray(arr, ga.f, ga.crs)
end

function Statistics.:mean(ga::AbstractGeoArray, dims=3)
    arr = mean(ga.A; dims=dims)
    GeoArray(arr, ga.f, ga.crs)
end

export sum, mean, maximum, minimum
