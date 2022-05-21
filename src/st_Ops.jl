# Copyright (c) 2018 Maarten Pronk, MIT license
# @references
# 1. `https://github.com/evetion/GeoArrays.jl/blob/master/src/geoarray.jl`
# Base.IndexStyle(::Type{T}) where {T<:AbstractGeoArray} = IndexLinear()
# Base.convert(::Type{Array{T, 3}}, A::AbstractGeoArray{T}) where {T} = convert(Array{T,3}, ga.A)
# using Stars

for f in (:isnan,)
    m = :Base
    @eval $m.$f(ga::AbstractGeoArray) = GeoArray(ga, vals=$m.$f.(ga.A))
end

Base.parent(ga::AbstractGeoArray) = ga.A
Base.iterate(ga::AbstractGeoArray) = iterate(ga.A)
Base.length(ga::AbstractGeoArray) = length(ga.A)
Base.size(ga::AbstractGeoArray) = size(ga.A)
Base.eltype(::Type{AbstractGeoArray{T}}) where {T} = T
Base.map(f, ga::AbstractGeoArray) = GeoArray(ga, vals=map(f, ga.A))

Base.show(io::IO, ::MIME"text/plain", ga::AbstractGeoArray) = show(io, ga)
function Base.show(io::IO, ga::AbstractGeoArray)
    info = gdalinfo(ga)

    crs = GeoFormatTypes.val(ga.crs)
    wkt = length(crs) == 0 ? "undefined CRS" : "CRS $crs"
    print(io, "size      : $(join(size(ga), "x")) $(typeof(ga.A)) \n")
    # print(io, "dimensions: $(info["dim"]) (nrow, ncol, nlyr)\n")
    print(io, "resolution: $(info["cellsize"]) (x, y)\n")
    print(io, "extent    : $(st_bbox(ga)) [xmin, ymin, xmax, ymax] \n")
    print(io, "affine    : $(ga.f) \n")
    print(io, "crs       : $(wkt) \n")
    print(io, "names     : $(ga.names) \n")
    print(io, "time      : $(ga.time) \n")
    print(io, "----------------\n")
    r_summary(ga.A[:, :, 1])
end

## OPERATIONS ------------------------------------------------------------------
"""
Check whether two `GeoArrays`s `a` and `b` are geographically equal, 
although not necessarily in content.
"""
Base.:(==)(a::AbstractGeoArray, b::AbstractGeoArray) = size(a) == size(b) && a.f == b.f && a.crs == b.crs
Base.:(==)(a::AbstractGeoArray, b::Real) = GeoArray(a, vals=a.A .== b)
Base.:!(a::AbstractGeoArray) = GeoArray(a, vals=.!a.A)

Base_ops = ((:Base, :+), (:Base, :-), (:Base, :*), (:Base, :/))

Base_lgl = ((:Base, :>), (:Base, :<), (:Base, :>=), (:Base, :<=),
    (:Base, :!=),
    (:Base, :&), (:Base, :|))

for (m, f) in Base_ops
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

# 对于lgl型运算，增加NaN的处理
for (m, f) in Base_lgl
    # _f = Symbol(m, ".:", f)
    @eval begin
        $m.$f(a::AbstractGeoArray, b::AbstractGeoArray) = begin
            a == b || throw(
                DimensionMismatch("Can't operate on non-geographic-equal `AbstractGeoArray`s"))
            GeoArray(a, vals=$m.$f.(a.A, b.A))
        end

        $m.$f(a::AbstractGeoArray, b::Real) = begin
            lgl = .&($m.$f.(a.A, b), .!isnan.(a.A))
            GeoArray(a, vals=lgl)
        end
        $m.$f(a::Real, b::AbstractGeoArray) = begin
            lgl = .&($m.$f.(a, b.A), .!isnan.(b.A))
            GeoArray(a, vals=lgl)
        end
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
