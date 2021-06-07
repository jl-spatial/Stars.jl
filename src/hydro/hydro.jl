function replace_low!(A::Array{Int32,3}, trs::Int32; nodata = missing)
    inds = CartesianIndices(A)
    n = length(inds)
    @inbounds for ind = inds
        if !ismissing(A[ind]) && (A[ind] < trs)
            A[ind] = nodata;
        end
    end
end

function mapvalues(A::AbstractArray{T,2}, levs_old, levs_new) where T <: Real
    A2 = deepcopy(A);
    inds = CartesianIndices(A)
    n = length(inds)
    nlev = length(levs_old)
    @inbounds for ind = inds
        if !ismissing(A[ind]) 
            for i in 1:nlev
                if A[ind] == levs_old[i]
                    A2[ind] = levs_new[i]
                    break
                end
            end
        end
    end
    A2
end

# change ArcGIS direction into taudem direction
function flowdir_gis2tau(A::AbstractArray{T,2}) where T <: Real
    dir_gis = Int32.([1, 2, 4, 8, 16, 32, 64, 128]);
    dir_taudem = Int32.([1, 8, 7, 6, 5, 4, 3, 2]);
    mapvalues(A, dir_gis, dir_taudem)
end

function flowdir_tau2gis(A::AbstractArray{T,2}) where T <: Real
    dir_gis = Int32.([1, 2, 4, 8, 16, 32, 64, 128]);
    dir_taudem = Int32.([1, 8, 7, 6, 5, 4, 3, 2]);
    mapvalues(A, dir_taudem, dir_gis)
end

export flowdir_gis2tau, flowdir_tau2gis, mapvalues, replace_low!
