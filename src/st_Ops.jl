# Copyright (c) 2018 Maarten Pronk, MIT license
# @references
# 1. `https://github.com/evetion/GeoArrays.jl/blob/master/src/geoarray.jl`
# Base.IndexStyle(::Type{T}) where {T<:AbstractGeoArray} = IndexLinear()
# Base.convert(::Type{Array{T, 3}}, A::AbstractGeoArray{T}) where {T} = convert(Array{T,3}, ga.A)
# using Stars

Base.iterate(ga::AbstractGeoArray) = iterate(ga.A)
Base.length(ga::AbstractGeoArray) = length(ga.A)
Base.parent(ga::AbstractGeoArray) = ga.A
Base.map(f, ga::AbstractGeoArray) = GeoArray(ga, vals = map(f, ga.A))
Base.size(ga::AbstractGeoArray) = size(ga.A)
Base.eltype(::Type{AbstractGeoArray{T}}) where {T} = T

Base.show(io::IO, ::MIME"text/plain", ga::AbstractGeoArray) = show(io, ga)
function Base.show(io::IO, ga::AbstractGeoArray)
    crs = GeoFormatTypes.val(ga.crs)
    wkt = length(crs) == 0 ? "undefined CRS" : "CRS $crs"
    print(io, "size  : $(join(size(ga), "x")) $(typeof(ga.A))")
    print(io, "\nextent: $(st_bbox(ga)) [xmin, ymin, xmax, ymax]")
    print(io, "\nnames : $(ga.names)")
    print(io, "\naffine: $(ga.f)")
    print(io, "\ncrs   : $(wkt)")
    print(io, "\ntime  : $(ga.time)")
end

## OPERATIONS ------------------------------------------------------------------
"""
Check whether two `GeoArrays`s `a` and `b` are geographically equal, 
although not necessarily in content.
"""
# function equals(a::AbstractGeoArray, b::AbstractGeoArray)
#     size(a) == size(b) && a.f == b.f && a.crs == b.crs
# end

Base.:(==)(a::AbstractGeoArray, b::AbstractGeoArray) = size(a) == size(b) && a.f == b.f && a.crs == b.crs
Base.:(==)(a::AbstractGeoArray, b::Real) = GeoArray(a, vals=a.A .== b)


Base_funcs = ((:Base, :+), (:Base, :-), (:Base, :*), (:Base, :/),
    (:Base, :>), (:Base, :<), (:Base, :>=), (:Base, :<=),
    (:Base, :!=))
for (m, f) in Base_funcs
    # _f = Symbol(m, ".:", f)
    @eval begin
        $m.$f(a::AbstractGeoArray, b::AbstractGeoArray) = begin
            a == b || throw(
                DimensionMismatch("Can't operate on non-geographic-equal `AbstractGeoArray`s"))
            GeoArray(a, vals=$m.$f.(a.A, b.A))
        end

        $m.$f(a::AbstractGeoArray, b::Real) = GeoArray(a, vals=$m.$f.(a.A, b))
        $m.$f(a::Real, b::AbstractGeoArray) = GeoArray(a, vals=$m.$f.(a, b.A))
    end
end

# export -, +, *, /, isless, equals, isequal, ==

## Math OPERATIONS -------------------------------------------------------------
for (m, f) in ((:Base, :sum), (:Base, :maximum), (:Base, :minimum), (:Statistics, :mean))
    @eval begin
        $m.$f(ga::AbstractGeoArray; dims=3, kw...) = begin
            arr = $m.$f(ga.A; dims=dims, kw...)
            GeoArray(ga, vals=arr)
        end
    end
end

export sum, mean, maximum, minimum
