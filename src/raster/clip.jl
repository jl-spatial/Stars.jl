cbind  = hcat
rbind  = vcat
# cbind! = hcat!
# rbind! = vcat!
# hcat! not defined
export cbind, rbind, cbind!, rbind!

"""
clip_point(r, shp; ngrid = 10)
===
- shp: DataFrame with the column of `geom`
"""
function clip_point(r::GeoArray, shp; ngrid = 10)
    lons, lats = get_coords(shp)
    LON, LAT   = coords_xy(r)
    info       = gdalinfo(r)
    cellsize   = info["cellsize"][1]
    delta      = cellsize/2
    
    I, J = meshgrid(-ngrid:ngrid, -ngrid:ngrid)
    I = I[:]; J = J[:];
    loc = DataFrame(I = I, J = J)
    
    res = []
    df  = [];
    @inbounds for i = 1:length(lons)
        lon = lons[i]
        lat = lats[i]
        I_lon = findall( ((LON .- delta) .<= lon) .& ((LON .+ delta) .>= lon) )[1]
        I_lat = findall( ((LAT .- delta) .<= lat) .& ((LAT .+ delta) .>= lat) )[1]

        ind_x = I_lon-ngrid:I_lon+ngrid
        ind_y = I_lat-ngrid:I_lat+ngrid
        arr = @view(r.A[ind_x, ind_y])

        r2 = GeoArray(arr, st_bbox(LON[ind_x], LAT[ind_y]))
        d = raster2df(r2)
        d = cbind(d, loc)

        push!(res, r2)
        push!(df, d)
    end
    Dict("raster" => res, "data" => df)
end


"""
cellIJ(r::GeoArray, point::Tuple)

@return
- I_lon, I_lat
"""
function cellIJ(r::GeoArray, point::Tuple)
    info       = gdalinfo(r)
    LON, LAT   = info["coords"]
    # LON, LAT   = coords_xy(r)
    cellsize   = info["cellsize"][1]
    delta      = cellsize/2
    
    lon, lat = point
    I_lon = findall( ((LON .- delta) .<= lon) .& ((LON .+ delta) .>= lon) )[1]
    I_lat = findall( ((LAT .- delta) .<= lat) .& ((LAT .+ delta) .>= lat) )[1]
    I_lon, I_lat
end

export cellIJ
export clip_point
