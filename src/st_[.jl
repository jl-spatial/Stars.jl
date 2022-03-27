## This script is modified from: 
##   `https://github.com/evetion/GeoArrays.jl/blob/master/src/crs.jl`
## Copyright (c) 2018 Maarten Pronk, MIT license

const TYPE_index = Union{Colon,AbstractRange,Integer}
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
    k::TYPE_index = :)
    
    A = @view ga.A[i, j, k]
    x, y = first(i) - 1, first(j) - 1
    t = ga.f(SVector(x, y))
    
    GeoArray(A, AffineMap(ga.f.linear, t), ga.crs)
end

function Base.getindex(ga::GeoArray, ::Colon, ::Colon, args...)
    rast(ga, vals = @view(ga.A[:, :, args...]))
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
