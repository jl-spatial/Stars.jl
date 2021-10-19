function rast(ga::GeoArray; vals::AbstractArray{T}) where T<: Real
    GeoArray(vals, ga.f, ga.crs)
end


"""
clip_bbox(x::GeoArray, b::bbox)
clip_bbox(x::GeoArray, y::GeoArray)
"""
function st_clip(x::GeoArray, b::bbox)
    # info = gdalinfo(file)
    info = gdalinfo(x)
    x, y = info["coords"]
    
    I_x = findall((X .<= b.xmax) .& (X .>= b.xmin))
    I_y = findall((Y .<= b.ymax) .& (Y .>= b.ymin))

    b = st_bbox(x, y)
    A = @view(x.A[I_x, I_y, :]);
    ga = GeoArray(A, b);
    ga
end


function st_clip(x::GeoArray, y::GeoArray)
    st_clip(x, st_bbox(y))
end


export st_clip, rast
