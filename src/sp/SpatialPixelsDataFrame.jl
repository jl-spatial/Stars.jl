abstract type AbstractSpatial end
abstract type AbstractSpatialPoints <: AbstractSpatial end 


mutable struct Spatial{B<:bbox, P} <: AbstractSpatial
    bbox::B
    proj::P
end

mutable struct SpatialPoints{C<:AbstractArray{<:Real, 2}, B<:bbox, P} <: AbstractSpatialPoints
    coords::C
    bbox::B
    proj::P
    # spatial::Spatial
end

"""
    SpatialPixelsDataFrame{
        T<:AbstractArray{<:Real, 2}, 
        C<:AbstractArray{<:Real, 2}, B<:bbox, P}  <: AbstractSpatialPoints
    
    SpatialPixelsDataFrame(data::AbstractArray{<:Real, 2}, coords::AbstractArray{<:Real, 2}, b::bbox, proj = 4326)

# Usage
`SpatialPixelsDataFrame(data, coords, bbox, proj)`
"""
Base.@kwdef mutable struct SpatialPixelsDataFrame{
    T<:AbstractArray{<:Real, 2}, 
    C<:AbstractArray{<:Real, 2},
    B<:bbox, P}  <: AbstractSpatialPoints

    data::T
    coords::C
    bbox::B
    proj::P = 4326
end

# SpatialPixelsDataFrame(data::AbstractArray{<:Real, 2}, 
#     coords::AbstractArray{<:Real, 2}, b::bbox, proj = 4326) = 
#     SpatialPixelsDataFrame(data, coords, b, proj)

st_bbox(sp::AbstractSpatial) = sp.bbox
st_proj(sp::AbstractSpatial) = sp.proj
st_coords(sp::AbstractSpatialPoints) = sp.coords


export Spatial, SpatialPoints, SpatialPixelsDataFrame, 
    st_bbox, st_proj, st_coords
