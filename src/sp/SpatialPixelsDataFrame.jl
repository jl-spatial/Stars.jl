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

mutable struct SpatialPixelsDataFrame{
    T<:AbstractArray{<:Real, 2}, 
    C<:AbstractArray{<:Real, 2}, B<:bbox, P}  <: AbstractSpatialPoints

    data::T
    coords::C
    bbox::B
    proj::P
end

st_bbox(sp::AbstractSpatial) = sp.bbox
st_proj(sp::AbstractSpatial) = sp.proj
st_coords(sp::AbstractSpatialPoints) = sp.coords


export Spatial, SpatialPoints, SpatialPixelsDataFrame, 
    st_bbox, st_proj, st_coords
