import DataFrames: DataFrame


function rast2df(r::GeoArray)
    LON, LAT = st_coords(r)    
    df = DataFrame(id = seq_along(LON), value = r.A[:], lon = LON[:], lat = LAT[:])
end

function rast2df(r::Array{GeoArray})
    df = [];
    for i in 1:length(r)
        d = rast2df(r[i])
        push!(df, d)
    end
    df
end

function rast2mat(ga::GeoArray, mask::Union{Nothing, AbstractArray{Bool, 2}} = nothing)
    if mask === nothing; mask = ga.A[:, :, 1] .!= 0; end
    ind = findall(mask)
    # ind_vec = LinearIndices(mat)[ind]
    ntime = size(ga, 3)
    res = zeros(eltype(ga.A), length(ind), ntime)
    @views for i = 1:ntime
        mat = ga.A[:, :, i]
        res[:, i] = mat[ind]
    end
    # keep enough information for the reverse operation
    res, mask
end


export rast2df, shrink_bbox, rast2mat
