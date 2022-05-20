# @references:
# 1. `https://github.com/evetion/GeoArrays.jl/blob/master/src/geoarray.jl`

# using Stars

abstract type AbstractGeoArray{T,N} <: AbstractArray{T,N} end

# abstract type AbstractGeoArray{T,N,D,A} <: AbstractDimensionalArray{T,N,D,A} end

const RealOrMissing = Union{Missing,Real}
const TypeCRS = Union{WellKnownText,AbstractString}
"""
    GeoArray(A::AbstractArray{<:RealOrMissing}, f::AffineMap = default_affinemap, crs::WellKnownText = crs2wkt(""))
    GeoArray(A::AbstractArray{<:RealOrMissing}, f::AffineMap, crs::AbstractString)
    GeoArray(A::AbstractArray{<:RealOrMissing}, x::AbstractRange, y::AbstractRange, args...)

    GeoArray(fn::AbstractString, bands = nothing) 
    GeoArray(ga::AbstractGeoArray; vals::AbstractArray{<:RealOrMissing})

Construct a GeoArray from any Array. Meanwhile, `AffineMap` and `CRS` will be generated.

# Arguments

- `A`: An AbstractArray, at least 2d Array

# Examples
```julia
ga = GeoArray(rand(10,10,1))
GeoArray(rand(10,10))

GeoArray(ga, vals = ga.A)                        # copy `f` and `crs` from `ga`
GeoArray(rand(10,10), 1:10, 2:11)                # define coordinate by `x` and `y`
GeoArray(rand(7, 4), bbox([70, 15, 140, 55]...)) # define coordinate by `bbox`

# 4-d array
ga = GeoArray(rand(10, 10, 2, 3))
GeoArray(ga, vals = ga.A)
```
"""
Base.@kwdef mutable struct GeoArray{T<:RealOrMissing,N} <: AbstractGeoArray{T,N}
    A::AbstractArray{T,N}
    f::AffineMap
    crs::TypeCRS
    names
    time
end

# using Stars
function GeoArray(A::AbstractArray{<:RealOrMissing,N},
    f::AffineMap=default_affinemap,
    crs::TypeCRS=crs2wkt(""),
    names=nothing) where {N}

    # @show N
    if N == 1
        error("`A` should be matrix or array!")
    elseif N == 2
        A = reshape(A, (size(A)..., 1))
    end
    ntime = size(A) |> last
    if names !== nothing
        names = length(names) > ntime ? names[1:ntime] : nothing
    end
    GeoArray(; A=A, f=f, crs=crs2wkt(crs), names=names, time=nothing)
end

# # also suit for high-dimension
function GeoArray(A::AbstractArray{<:RealOrMissing},
    x::AbstractRange, y::AbstractRange, args...)

    if size(A)[1:2] != (length(x), length(y))
        # Note that this function takes *center coordinates*.
        error("Size of `GeoArray` $(size(A)) does not match size of (x,y): $((length(x), length(y))).")
    end
    f = unitrange_to_affine(x, y)
    # b = st_bbox(x, y)
    GeoArray(A, f, args...)
end

function GeoArray(A::AbstractArray{<:RealOrMissing}, b::bbox; proj=4326)
    ga = GeoArray(A)
    st_bbox!(ga, b)
    st_crs!(ga, proj)
    ga
end

GeoArray(fn::AbstractString, bands=nothing) = st_read(fn, bands)

function GeoArray(ga::AbstractGeoArray; vals::AbstractArray{<:RealOrMissing}, names=nothing)
    if names === nothing
        names = ga.names
    end
    GeoArray(vals, ga.f, ga.crs, names)
end

rast = GeoArray
export GeoArray, rast, AbstractGeoArray

include("st_[.jl")
include("st_Ops.jl")
