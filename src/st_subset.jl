function rast(ga::GeoArray; vals::AbstractArray{T}) where T<: Real
    GeoArray(vals, ga.f, ga.crs)
end

export rast
