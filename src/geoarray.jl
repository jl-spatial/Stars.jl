# @references:
# 1. `https://github.com/evetion/GeoArrays.jl/blob/master/src/geoarray.jl`

# using Stars
# methods(GeoArray)

abstract type AbstractGeoArray{T,N} <: AbstractArray{T,N} end
# abstract type AbstractGeoArray{T,N,D,A} <: AbstractDimensionalArray{T,N,D,A} end

const RealOrMissing = Union{Missing,Real}

"""
    GeoArray{T<:Union{Missing, Real}} <: AbstractArray{T, 3}
    GeoArray(A::AbstractArray{T, 3})

Construct a GeoArray from any Array. A default `AffineMap` and `CRS` will be generated.

# Arguments

- `A`: An AbstractArray, at least 2d Array


# Examples
```julia
ga = GeoArray(rand(10,10,1))
GeoArray(rand(10,10))

GeoArray(ga, vals = ga.A)                        # copy `f` and `crs` from `ga`
GeoArray(rand(10,10), 1:10, 2:11)        # define coordinate by `x` and `y`
GeoArray(rand(7, 4), bbox([70, 15, 140, 55]...)) # define coordinate by `bbox`

# 4-d array
ga = GeoArray(rand(10, 10, 2, 3))
GeoArray(ga, vals = ga.A)
```
"""
Base.@kwdef mutable struct GeoArray{T<:RealOrMissing,N} <: AbstractGeoArray{T,N}
    A::AbstractArray{T,N}
    f::AffineMap = default_affinemap
    crs::WellKnownText = crs2wkt("")
end

GeoArray(A::AbstractArray{<:RealOrMissing}, f::AffineMap, crs::AbstractString) = 
    GeoArray(A, f, crs2wkt(crs))

# # `A`: 
GeoArray(A::AbstractArray{<:RealOrMissing}, f::AffineMap = default_affinemap) = 
    GeoArray(A, f, crs2wkt(""))

GeoArray(A::AbstractArray{<:RealOrMissing, 2}, f::AffineMap, crs::WellKnownText = crs2wkt("")) = 
    GeoArray(reshape(A, size(A)..., 1), f, crs)

# # also suit for high-dimension
function GeoArray(A::AbstractArray{<:RealOrMissing}, 
    x::AbstractRange, y::AbstractRange, args...)

    if size(A)[1:2] != (length(x), length(y))
        # Note that this function takes *center coordinates*.
        error("Size of `GeoArray` $(size(A)) does not match size of (x,y): $((length(x), length(y))).")
    end
    f = unitrange_to_affine(x, y)
    GeoArray(A, f, args...)
end

function GeoArray(A::AbstractArray{<:RealOrMissing}, b::bbox; proj = 4326)
    ga = GeoArray(A)
    st_bbox!(ga, b)
    st_crs!(ga, proj)
    ga
end

GeoArray(fn::AbstractString, bands = nothing) = st_read(fn, bands)

GeoArray(ga::AbstractGeoArray; vals::AbstractArray{<:RealOrMissing}) = begin
    GeoArray(vals, ga.f, ga.crs)
end

# """
# - rast(fn::AbstractString, bands = nothing): construct `GeoArray` object from file
# """
rast = GeoArray
export GeoArray, rast

include("st_[.jl")
include("st_Ops.jl")
