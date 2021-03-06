## This script is modified from: 
##   `https://github.com/evetion/GeoArrays.jl/blob/master/src/crs.jl`
## Copyright (c) 2018 Maarten Pronk, MIT license

const TypeINDEX = Union{Colon,AbstractRange,Integer}
"""
    getindex(ga::AbstractGeoArray, i::AbstractRange, j::AbstractRange, k::TypeINDEX = :)
    TypeINDEX = Union{Colon,AbstractRange,Integer}

Index a `AbstractGeoArray` with `AbstractRange`s to get a cropped
AbstractGeoArray with the correct `AffineMap` set.

# Examples

```julia-repl
julia> ga[2:3,2:3,1]
2x2x1 Array{Float64, 3} with AffineMap([1.0 0.0; 0.0 1.0], [1.0, 1.0]) and undefined CRS
```
"""
function Base.getindex(ga::AbstractGeoArray, i::AbstractRange, j::AbstractRange, k::TypeINDEX = :)    
    A = @view ga.A[i, j, k]
    x, y = first(i) - 1, first(j) - 1
    t = ga.f(SVector(x, y))
    
    GeoArray(A, AffineMap(ga.f.linear, t), ga.crs)
end

function Base.getindex(ga::AbstractGeoArray, name::AbstractString)
    k = findall(ga.names .== name)
    rast(@view(ga.A[:, :, k]), ga.f, ga.crs, ga.names[k])
end

function Base.getindex(ga::AbstractGeoArray, k::TypeINDEX=:)
    GeoArray(ga, vals=ga.A[:, :, k])
end

function Base.getindex(ga::AbstractGeoArray, ::Colon, ::Colon, args...)
    rast(ga, vals = @view(ga.A[:, :, args...]))
end

# Base.getindex(ga::AbstractGeoArray, I::Vararg{<:Integer,2}) = begin
#     getindex(ga.A, I..., :)
# end
# Base.getindex(ga::AbstractGeoArray, I::Vararg{<:Integer,3}) = begin
#     println("d3", I)
#     getindex(ga.A, I...)
# end
Base.setindex!(ga::AbstractGeoArray, v, I::Vararg{<:AbstractFloat,2}) = setindex!(ga, v, SVector{2}(I))
Base.setindex!(ga::AbstractGeoArray, v, I::Vararg{TypeINDEX,2}) = setindex!(ga.A, v, I..., :)
Base.setindex!(ga::AbstractGeoArray, v, I::Vararg{TypeINDEX,3}) = setindex!(ga.A, v, I...)
