# This script is modified from: 
#   `https://github.com/evetion/GeoArrays.jl/blob/master/src/geoarray.jl`
# Copyright (c) 2018 Maarten Pronk, MIT license

include("DataTypes.jl")


# abstract type AbstractSpatial end
# abstract type AbstractSpatialPoints <: AbstractSpatial end 
abstract type AbstractGeoArray{T,N} <: AbstractArray{T,N} end
# abstract type AbstractGeoArray{T,N,D,A} <: AbstractDimensionalArray{T,N,D,A} end

const RealOrMissing = Union{Missing,Real}

"""
    GeoArray{T<:Union{Missing, Real}} <: AbstractArray{T, 3}
    GeoArray(A::AbstractArray{T, 3})

Construct a GeoArray from any Array. A default `AffineMap` and `CRS` will be generated.

# Examples
```julia-repl
julia> GeoArray(rand(10,10,1))
10x10x1 Array{Float64, 3} with AffineMap([1.0 0.0; 0.0 1.0], [0.0, 0.0]) and undefined CRS
```
"""
mutable struct GeoArray{T<:RealOrMissing,N} <: AbstractGeoArray{T,N}
    A::AbstractArray{T,N}
    f::AffineMap
    crs::WellKnownText{GeoFormatTypes.CRS, <:String}
end

# no crs in this version
GeoArray(A::AbstractArray{<:RealOrMissing}) = 
    GeoArray(A, geotransform_to_affine(SVector(0.,1.,0.,0.,0.,1.)), "")

GeoArray(A::AbstractArray{<:RealOrMissing}, f::AffineMap, crs::String = WGS84_wkt) = 
    GeoArray(A, f, crs2wkt(crs))

function GeoArray(A::AbstractArray{<:RealOrMissing, 3}, 
    x::AbstractRange, y::AbstractRange, args...)

    size(A)[1:2] != (length(x), length(y)) && 
        error("Size of `GeoArray` $(size(A)) does not match size of (x,y): $((length(x),length(y))). Note that this function takes *center coordinates*.")
    f = unitrange_to_affine(x, y)
    GeoArray(A, f, args...)
end

GeoArray(A::AbstractArray{<:RealOrMissing, 2}, args...) = 
    GeoArray(reshape(A, size(A)..., 1), args...)

function GeoArray(A::AbstractArray{<:RealOrMissing, 3}, b::bbox; proj = 4326)
    ga = GeoArray(A)
    st_bbox!(ga, b)
    st_crs!(ga, proj)
    ga
end

GeoArray(fn::AbstractString, bands = nothing) = st_read(fn, bands)
GeoArray(ga::GeoArray; vals::AbstractArray{<:RealOrMissing}) = GeoArray(vals, ga.f, ga.crs)


"""
- rast(fn::AbstractString, bands = nothing): construct `GeoArray` object from file
- rast(ga::GeoArray; vals::AbstractArray{T}): Reconstruct `GeoArray` object
"""
rast = GeoArray

export rast

include("st_[.jl")
include("st_Ops.jl")
