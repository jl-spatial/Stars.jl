include("DataTypes.jl")


wgs84_wkt = "GEOGCS[\"WGS 84\",DATUM[\"WGS_1984\",SPHEROID[\"WGS 84\",6378137,298.257223563,AUTHORITY[\"EPSG\",\"7030\"]],AUTHORITY[\"EPSG\",\"6326\"]],PRIMEM[\"Greenwich\",0,AUTHORITY[\"EPSG\",\"8901\"]],UNIT[\"degree\",0.0174532925199433,AUTHORITY[\"EPSG\",\"9122\"]],AXIS[\"Latitude\",NORTH],AXIS[\"Longitude\",EAST],AUTHORITY[\"EPSG\",\"4326\"]]"

"""
    GeoArray(A::AbstractArray{T,3} where T <: Union{Real,Union{Missing,Real}})

Construct a GeoArray from any Array. A default `AffineMap` and `CRS` will be generated.

# Examples
```julia-repl
julia> GeoArray(rand(10,10,1))
10x10x1 Array{Float64, 3} with AffineMap([1.0 0.0; 0.0 1.0], [0.0, 0.0]) and undefined CRS
```
"""
GeoArray(A::AbstractArray{T, 3} where T<:Union{Real, Union{Missing, Real}}) = GeoArray(A, geotransform_to_affine(SVector(0.,1.,0.,0.,0.,1.)), "")
GeoArray(A::AbstractArray{T, 3} where T<:Union{Real, Union{Missing, Real}}, f::AffineMap) = GeoArray(A, f, GFT.WellKnownText(GFT.CRS(), ""))
GeoArray(A::AbstractArray{T, 3} where T<:Union{Real, Union{Missing, Real}}, f::AffineMap, crs::String) = begin
    if crs == ""; crs = wgs84_wkt; end
    GeoArray(A, f, GFT.WellKnownText(GFT.CRS(), crs))
end

function GeoArray(A::AbstractArray{T, 3}, x::AbstractRange, y::AbstractRange, args...) where T<:Union{Real, Union{Missing, Real}}
    size(A)[1:2] != (length(x), length(y)) && error("Size of `GeoArray` $(size(A)) does not match size of (x,y): $((length(x),length(y))). Note that this function takes *center coordinates*.")
    f = unitrange_to_affine(x, y)
    GeoArray(A, f, args...)
end

function GeoArray(A::AbstractArray{T, 3}, bbox::box; proj = 4326) where T<:Union{Real, Union{Missing, Real}}
    ga = GeoArray(A)
    st_bbox!(ga, bbox)
    epsg!(ga, proj)
    ga
end

GeoArray(A::AbstractArray{T, 2} where T<:Union{Real, Union{Missing, Real}}, args...) = GeoArray(reshape(A, size(A)..., 1), args...)


Base.size(ga::GeoArray) = size(ga.A)
Base.IndexStyle(::Type{T}) where {T<:GeoArray} = IndexLinear()
Base.iterate(ga::GeoArray) = iterate(ga.A)
Base.length(ga::GeoArray) = length(ga.A)
Base.parent(ga::GeoArray) = ga.A
# Base.map(f, ga::GeoArray) = GeoArray(map(f, ga.A), ga.f, ga.crs)
# Base.convert(::Type{Array{T, 3}}, A::GeoArray{T}) where {T} = convert(Array{T,3}, ga.A)
Base.eltype(::Type{GeoArray{T}}) where {T} = T

Base.show(io::IO, ::MIME"text/plain", ga::GeoArray) = show(io, ga)
function Base.show(io::IO, ga::GeoArray)
    crs = GeoFormatTypes.val(ga.crs)
    wkt = length(crs) == 0 ? "undefined CRS" : "CRS $crs"
    print(io, "$(join(size(ga), "x")) $(typeof(ga.A)) with $(ga.f) and $(wkt)")
end


include("st_[.jl")
include("st_Ops.jl")
