using DataFrames

function raster2df(r::GeoArray)
    LON, LAT = GeoArrays.coords(r)    
    df = DataFrame(id = seq_along(LON), value = r.A[:], lon = LON[:], lat = LAT[:])
end

function raster2df(r::Array{GeoArray})
    df = [];
    for i in 1:length(r)
        d = raster2df(r[i])
        push!(df, d)
    end
    df
end

export raster2df
