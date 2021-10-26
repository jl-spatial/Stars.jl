
"""
clip_bbox(x::GeoArray, b::bbox)
clip_bbox(x::GeoArray, y::GeoArray)
"""
function st_clip(ga::GeoArray, b::bbox)
    x, y = st_dim(ga)
    I_x = findall((x .<= b.xmax) .& (x .>= b.xmin))
    I_y = findall((y .<= b.ymax) .& (y .>= b.ymin))
    ga[I_x, I_y]
end

function st_clip(x::GeoArray, y::GeoArray)
    st_clip(x, st_bbox(y))
end


export st_clip
