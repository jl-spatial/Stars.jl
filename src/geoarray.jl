# This script is modified from: 
#   `https://github.com/evetion/GeoArrays.jl/blob/master/src/geoarray.jl`
# Copyright (c) 2018 Maarten Pronk, MIT license

include("DataTypes.jl")



# This script is modified from: 
#   `https://github.com/evetion/GeoArrays.jl/blob/master/src/crs.jl`
# Copyright (c) 2018 Maarten Pronk, MIT license


crs2wkt(crs::AbstractString = "") = GFT.WellKnownText(GFT.CRS(), crs)

# abstract type AbstractGeoArray{T,N,D,A} <: AbstractDimensionalArray{T,N,D,A} end
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
mutable struct GeoArray{T<:Union{Missing, Real}} <: AbstractArray{T, 3}
    A::AbstractArray{T, 3}
    f::AffineMap
    crs::WellKnownText{GeoFormatTypes.CRS, <:String}
end

# no crs in this version
GeoArray(A::AbstractArray{T, 3}) where T<:Union{Missing, Real} = 
    GeoArray(A, geotransform_to_affine(SVector(0.,1.,0.,0.,0.,1.)), "")

GeoArray(A::AbstractArray{T, 3}, f::AffineMap, crs::String = WGS84_wkt) where T<:Union{Missing, Real} = begin
    # if crs == ""; crs = WGS84_wkt; end
    GeoArray(A, f, crs2wkt(crs))
end

function GeoArray(A::AbstractArray{T, 3}, x::AbstractRange, y::AbstractRange, args...) where T<:Union{Missing, Real}
    size(A)[1:2] != (length(x), length(y)) && 
        error("Size of `GeoArray` $(size(A)) does not match size of (x,y): $((length(x),length(y))). Note that this function takes *center coordinates*.")
    f = unitrange_to_affine(x, y)
    GeoArray(A, f, args...)
end

GeoArray(A::AbstractArray{T, 2}, args...) where T<:Union{Missing, Real} = 
    GeoArray(reshape(A, size(A)..., 1), args...)



include("st_[.jl")
include("st_Ops.jl")
