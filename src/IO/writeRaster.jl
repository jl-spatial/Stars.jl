writeRaster(ga::GeoArray, fn::AbstractString; nodata = nothing) = write!(fn, ga, nodata)

function writeRaster(A::AbstractArray{T,3}, bbox::box, fn::AbstractString; nodata = nothing) where T <: Real
    ga = GeoArray(A, bbox)
    writeRaster(ga, fn; nodata = nodata)
end

function writeRaster(A::AbstractArray{T,2}, bbox::box, fn::AbstractString; nodata = nothing) where T <: Real
    ga = GeoArray(A, bbox)
    writeRaster(ga, fn; nodata = nodata)
end

export writeRaster
