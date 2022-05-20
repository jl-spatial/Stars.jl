import DataFrames: DataFrame


function rast2df(r::AbstractGeoArray)
    LON, LAT = st_coords(r)    
    DataFrame(id = seq_along(LON), value = r.A[:], lon = LON[:], lat = LAT[:])
end

function rast2df(list::Vector{AbstractGeoArray})
    # need to add a melt_list
    map(rast2df, list)
end

"""
    shrink_bbox(ga, mask::AbstractArray{Bool, 2} = nothing)
    
Only true values in `mask` will be kept.
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


function get_mask(ga::AbstractGeoArray, missval=NaN)
    not_nan = .!(isnan.(ga.A[:, :, 1]))
    vals = @views isnan(missval) ? not_nan : (ga.A[:, :, 1] .!= missval) .& not_nan
    rast(ga, vals=vals)
end

export get_mask;

"""
    st_as_sf(ga::AbstractGeoArray, mask::Union{Nothing, AbstractArray{Bool, 2}} = nothing)
    st_as_sf(file::AbstractString, mask = nothing)

If the input is a file path, `shrink_bbox` will be applied.
"""
function st_as_sf(ga::AbstractGeoArray, 
    mask::Union{Nothing,AbstractGeoArray}=nothing; missval=NaN)
    
    if mask === nothing; mask = get_mask(ga, missval); end

    ind = findall(mask.A)
    # ind_vec = LinearIndices(mat)[ind]
    ntime = size(ga, 3)
    res = zeros(eltype(ga.A), length(ind), ntime)
    @views for i = 1:ntime
        mat = ga.A[:, :, i]
        res[:, i] = mat[ind]
    end
    res # mask, st_bbox(ga)
end
# keep enough information for the reverse operation
# rast(ga, vals = mask) # mat, mask

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
    ind = LinearIndices(r_mask.A)[ind]
    DataFrame(id=ind, lon=LON[ind], lat=LAT[ind])
end

# the inverse operation


export rast2df, shrink_bbox, st_as_sf, maskCoords
