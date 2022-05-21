import DataFrames: DataFrame

# using Stars
include("convert.jl")


"""
    st_shrink(ga::AbstractGeoArray, mask::Nothing=nothing; missval=NaN)
    st_shrink(ga::AbstractGeoArray, mask::AbstractGeoArray)
    st_shrink(ga::AbstractGeoArray, mask::AbstractArray{<:Real,2})
        
Only true values in `mask` will be kept.

## Arguments
- `mask`: 
    + `AbstractGeoArray`: returned by `get_mask`
    + ``
"""
st_shrink(ga::AbstractGeoArray) = st_shrink(ga, !isnan(ga[1]))

st_shrink(ga::AbstractGeoArray, mask::AbstractGeoArray;) =
    st_shrink(ga, mask.A[:, :, 1])

function st_shrink(ga::AbstractGeoArray, mask::AbstractArray{<:Real,2})
    ind = findall(mask)
    # ind_vec = LinearIndices(mat)[ind]
    rows = map(x -> x[1], ind) # x, long
    cols = map(x -> x[2], ind) # y, lat

    I_x = seq(Range(rows)...) # get the Range of `rows` and `cols`
    I_y = seq(Range(cols)...)
    ga[I_x, I_y]
end

## TODO:
# ind2mask

function mask2ind(r_mask::AbstractGeoArray{Bool})
    ind = findall(r_mask.A)
    LinearIndices(r_mask.A)[ind]
end

"""
d_coord = st_as_sf(mask)
"""
function maskCoords(r_mask::AbstractGeoArray{Bool})
    LON, LAT = st_coords(r_mask)
    ind = mask2ind(r_mask)
    DataFrame(id=ind, lon=LON[ind], lat=LAT[ind])
end

"""
    st_as_sf(ga::AbstractGeoArray, mask::Union{Nothing, AbstractArray{Bool, 2}} = nothing)
    st_as_sf(file::AbstractString, mask = nothing)

If the input is a file path, `st_shrink` will be applied.
"""
function st_as_sf(ga::AbstractGeoArray, mask::AbstractArray{Bool,2})
    ind = findall(mask)
    # ind_vec = LinearIndices(mat)[ind]
    ntime = size(ga, 3)
    res = zeros(eltype(ga.A), length(ind), ntime)
    @views for i = 1:ntime
        mat = ga.A[:, :, i]
        res[:, i] = mat[ind]
    end
    res
end
st_as_sf(ga::AbstractGeoArray, mask::Nothing=nothing) = st_as_sf(ga, .!isnan.(ga.A[:, :, 1]))
st_as_sf(ga::AbstractGeoArray, mask::AbstractGeoArray) = st_as_sf(ga, mask.A[:, :, 1])

# st_as_sf(ga::AbstractGeoArray, mask::AbstractArray{<:Bool,2}; kw...)

# keep enough information for the reverse operation
# rast(ga, vals = mask) # mat, mask

# function st_as_sf(file::AbstractString; missval=0)
#     ga = rast(file)
#     ga2 = st_shrink(ga)
#     st_as_sf(ga2; missval=missval)
# end

# mask is 3d boolean array
function st_as_sf(file::AbstractString, mask::AbstractGeoArray,
    mask_shrink=nothing)
    
    ga = rast(file)
    if mask_shrink !== nothing
        ga = st_shrink(ga, mask_shrink)
    end
    st_as_sf(ga, mask)
end

# the inverse operation

export rast2df, st_shrink, st_as_sf, maskCoords
