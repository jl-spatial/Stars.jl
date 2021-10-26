struct bbox
    xmin::Float64
    ymin::Float64
    xmax::Float64
    ymax::Float64
end

bbox(;xmin, ymin, xmax, ymax) = bbox(xmin, ymin, xmax, ymax)


# This script is modified from: 
#   `https://github.com/evetion/GeoArrays.jl/blob/master/src/crs.jl`
# Copyright (c) 2018 Maarten Pronk, MIT license

"""
    GeoArray{T <: Union{Real,Union{Missing,Real}}} <: AbstractArray{T,3}

A GeoArray is an AbstractArray, an AffineMap for calculating coordinates based
on the axes and a CRS definition to interpret these coordinates into in the real
world. It's three dimensional and can be seen as a stack (3D) of 2D geospatial
rasters (bands), the dimensions are :x, :y, and :bands. The AffineMap and CRS
(coordinates) only operate on the :x and :y dimensions.
"""
mutable struct GeoArray{T<:Union{Real, Union{Missing, Real}}} <: AbstractArray{T, 3}
    A::AbstractArray{T, 3}
    f::AffineMap
    crs::WellKnownText{GeoFormatTypes.CRS, <:String}
end
