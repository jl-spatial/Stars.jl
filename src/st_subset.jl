
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


"""
    shrink_bbox(ga, mask::AbstractArray{Bool, 2} = nothing)
    
only true values in `mask` will be kept.
"""
function shrink_bbox(ga::GeoArray, mask::AbstractArray{Bool, 2} = nothing)
    if mask === nothing; mask = ga.A[:, :, 1] .!= 0; end
    ind = findall(mask)
    # ind_vec = LinearIndices(mat)[ind]
    rows = map(x -> x[1], ind) # x, long
    cols = map(x -> x[2], ind) # y, lat

    I_x = seq(Range(rows)...)
    I_y = seq(Range(cols)...)
    ga[I_x, I_y]
end


export st_clip, shrink_bbox
