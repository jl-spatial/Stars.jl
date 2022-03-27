import DataFrames: DataFrame


function rast2df(r::AbstractGeoArray)
    LON, LAT = st_coords(r)    
    DataFrame(id = seq_along(LON), value = r.A[:], lon = LON[:], lat = LAT[:])
end

function rast2df(r::Array{AbstractGeoArray})
    df = [];
    for i in 1:length(r)
        d = rast2df(r[i])
        push!(df, d)
    end
    df
end


"""
    shrink_bbox(ga, mask::AbstractArray{Bool, 2} = nothing)
    
only true values in `mask` will be kept.
"""
function shrink_bbox(ga::AbstractGeoArray, mask::Union{Nothing, AbstractArray{Bool, 2}} = nothing)
    if mask === nothing; mask = ga.A[:, :, 1] .!= 0; end
    ind = findall(mask)
    # ind_vec = LinearIndices(mat)[ind]
    rows = map(x -> x[1], ind) # x, long
    cols = map(x -> x[2], ind) # y, lat

    I_x = seq(Range(rows)...)
    I_y = seq(Range(cols)...)
    ga[I_x, I_y]
end


"""
    st_as_sf(ga::AbstractGeoArray, mask::Union{Nothing, AbstractArray{Bool, 2}} = nothing)
    st_as_sf(file::AbstractString, mask = nothing)

If the input is a file path, `shrink_bbox` will be applied.
"""
function st_as_sf(ga::AbstractGeoArray, mask::Union{Nothing, AbstractArray{Bool, 2}} = nothing; missval = 0)
    if mask === nothing; mask = ga.A[:, :, 1] .!= missval; end
    ind = findall(mask)
    # ind_vec = LinearIndices(mat)[ind]
    ntime = size(ga, 3)
    res = zeros(eltype(ga.A), length(ind), ntime)
    @views for i = 1:ntime
        mat = ga.A[:, :, i]
        res[:, i] = mat[ind]
    end
    # keep enough information for the reverse operation
    res, mask, st_bbox(ga)
    # rast(ga, vals = mask) # mat, mask
end

function st_as_sf(file::AbstractString; missval = 0)
    ga = rast(file)
    ga2 = shrink_bbox(ga)
    st_as_sf(ga2; missval = missval)
end

# mask is 3d boolean array
function st_as_sf(file::AbstractString, mask_shrink::AbstractArray{Bool}, 
    mask::AbstractArray{Bool}; missval = 0)

    ga = rast(file)
    ga2 = shrink_bbox(ga, mask_shrink)
    st_as_sf(ga2, mask; missval = missval)
end


"""
d_coord = st_as_sf(mask)
"""
function maskCoords(r_mask::AbstractGeoArray{Bool})
    LON, LAT = st_coords(r_mask)
    ind = findall(r_mask.A)
    DataFrame(id = seq_along(ind), lon = LON[ind], lat = LAT[ind])
end

# the inverse operation


export rast2df, shrink_bbox, st_as_sf, maskCoords
