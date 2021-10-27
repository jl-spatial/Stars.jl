## This script is modified from: 
##   `https://github.com/evetion/GeoArrays.jl/blob/master/src/crs.jl`
## Copyright (c) 2018 Maarten Pronk, MIT license

# # Coordinates and indices
# abstract type AbstractStrategy end
# """
# - Center()

#     Strategy to use in functions like `indices` and `coords`, in which
#     it will use the center of the raster cells to do coordinate conversion.

# - Vertex()

#     Strategy to use in functions like `indices` and `coords`, in which
#     it will use the top left vertex of the raster cells to do coordinate conversion.
# """
# struct Center <: AbstractStrategy
#     offset::Float64
#     Center() = new(0.5)
# end

# struct Vertex <: AbstractStrategy
#     offset::Float64
#     Vertex() = new(1.0)
# end

# """
#     indices(ga::GeoArray, p::SVector{2,<:AbstractFloat}, strategy::AbstractStrategy)

# Retrieve logical indices of the cell represented by coordinates `p`.
# `strategy` can be used to define whether the coordinates represent the center (`Center`) or the top left corner (`Vertex`) of the cell.
# See `coords` for the inverse function.
# """
# function indices(ga::GeoArray, p::SVector{2,<:AbstractFloat}, strategy::AbstractStrategy)
#     round.(Int, inv(ga.f)(p) .+ strategy.offset)::SVector{2,Int}
# end
# indices(ga::GeoArray, p::Vector{<:AbstractFloat}, strategy::AbstractStrategy=Center()) = indices(ga, SVector{2}(p), strategy)
# indices(ga::GeoArray, p::Tuple{<:AbstractFloat,<:AbstractFloat}, strategy::AbstractStrategy=Center()) = indices(ga, SVector{2}(p), strategy)

# # Getindex and setindex! with floats
# """
#     getindex(ga::GeoArray, I::SVector{2,<:AbstractFloat})
# Index a GeoArray with `AbstractFloat`s to automatically get the value at that coordinate, using the function `indices`.
# A `BoundsError` is raised if the coordinate falls outside the bounds of the raster.
# # Examples
# ```julia-repl
# julia> ga[3.0,3.0]
# 1-element Vector{Float64}:
#  0.5630767850028582
# ```
# """
# function Base.getindex(ga::GeoArray, I::SVector{2,<:AbstractFloat})
#     (i, j) = indices(ga, I, Center())
#     ga[i, j, :]
# end
# Base.getindex(ga::GeoArray, I::Vararg{<:AbstractFloat,2}) = getindex(ga, SVector{2}(I))

# function Base.setindex!(ga::GeoArray, v, I::SVector{2,AbstractFloat})
#     i, j = indices(ga, I, Center())
#     ga.A[i, j, :] .= v
# end
# Getindex
"""
    getindex(ga::GeoArray, i::AbstractRange, j::AbstractRange, k::Union{Colon,AbstractRange,Integer})
Index a GeoArray with `AbstractRange`s to get a cropped GeoArray with the correct `AffineMap` set.
# Examples
```julia-repl
julia> ga[2:3,2:3,1]
2x2x1 Array{Float64, 3} with AffineMap([1.0 0.0; 0.0 1.0], [1.0, 1.0]) and undefined CRS
```
"""
function Base.getindex(ga::GeoArray, i::AbstractRange, j::AbstractRange, 
    k::Union{Colon,AbstractRange,Integer} = :)
    
    A = @view ga.A[i, j, k]
    x, y = first(i) - 1, first(j) - 1
    t = ga.f(SVector(x, y))
    
    GeoArray(A, AffineMap(ga.f.linear, t), ga.crs)
end

function Base.getindex(ga::GeoArray, ::Colon, ::Colon, k::Union{Colon,AbstractRange,Integer} = :)
    println("d")
    rast(ga, vals = @view(ga.A[:, :, k]))
end

# Base.getindex(ga::GeoArray, I::Vararg{<:Integer,2}) = begin
#     getindex(ga.A, I..., :)
# end
# Base.getindex(ga::GeoArray, I::Vararg{<:Integer,3}) = begin
#     println("d3", I)
#     getindex(ga.A, I...)
# end
Base.setindex!(ga::GeoArray, v, I::Vararg{<:AbstractFloat,2}) = setindex!(ga, v, SVector{2}(I))
Base.setindex!(ga::GeoArray, v, I::Vararg{Union{<:Integer,<:AbstractRange{<:Integer}},2}) = setindex!(ga.A, v, I..., :)
Base.setindex!(ga::GeoArray, v, I::Vararg{Union{<:Integer,<:AbstractRange{<:Integer}},3} ) = setindex!(ga.A, v, I...)
