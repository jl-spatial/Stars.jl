
"""
clip_bbox(x::AbstractGeoArray, b::bbox)
clip_bbox(x::AbstractGeoArray, y::AbstractGeoArray)
"""
function st_clip(ga::AbstractGeoArray, b::bbox)
    x, y = st_dim(ga)
    I_x = findall((x .<= b.xmax) .& (x .>= b.xmin))
    I_y = findall((y .<= b.ymax) .& (y .>= b.ymin))
    ga[I_x, I_y]
end

function st_clip(x::AbstractGeoArray, y::AbstractGeoArray)
    st_clip(x, st_bbox(y))
end


export st_clip
