
function GeoArray(A::AbstractArray{T, 3}, b::bbox; proj = 4326) where T<:Union{Real, Union{Missing, Real}}
    ga = GeoArray(A)
    st_bbox!(ga, b)
    st_crs!(ga, proj)
    ga
end

function GeoArray(fn::AbstractString, bands = nothing)
    st_read(fn, bands)
end

function GeoArray(ga::GeoArray; vals::AbstractArray{T}) where T<: Real
    GeoArray(vals, ga.f, ga.crs)
end


"""
- rast(fn::AbstractString, bands = nothing): construct `GeoArray` object from file
- rast(ga::GeoArray; vals::AbstractArray{T}): Reconstruct `GeoArray` object
"""
rast = GeoArray

export rast
