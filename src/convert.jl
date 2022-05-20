import DataFrames: DataFrame

function rast2df(r::AbstractGeoArray)
    LON, LAT = st_coords(r)
    DataFrame(id=seq_along(LON), value=r.A[:], lon=LON[:], lat=LAT[:])
end

function rast2df(list::Vector{AbstractGeoArray})
    map(rast2df, list)
end
