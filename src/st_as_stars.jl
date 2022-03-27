"""
    st_as_stars(data::AbstractArray{T, 2}, mask::AbstractArray{Bool, 2})
    
    st_as_stars(data::AbstractArray{T, 2}, r_mask::GeoArray; outfile = nothing)
    st_as_stars(data::AbstractArray{T, 2}, mask::AbstractArray{Bool, 2}, 
        b::bbox; kw...)
    st_as_stars(data::AbstractArray{T, 2}, mask::AbstractArray{Bool, 2}, 
        b::AbstractArray{<:Real, 1}; kw...) 
"""
function st_as_stars(data::AbstractArray{T, 2}, mask::AbstractArray{Bool, 2}) where T <: Real
    ntime = size(data, 2)
    arr = zeros(T, size(mask)..., ntime)

    ind = findall(mask)
    @views for i = 1:ntime
        x = arr[:, :, i]
        x[ind] = data[:, i]
    end
    arr
end

function st_as_stars(data::AbstractArray{T, 2}, r_mask::AbstractGeoArray; outfile = nothing) where T <: Real

    arr = st_as_stars(data, r_mask.A[:, :, 1])
    r = GeoArray(r_mask, vals = arr)
    if outfile !== nothing; st_write(r, outfile); end
    r
end

function st_as_stars(data::AbstractArray{T, 2}, mask::AbstractArray{Bool, 2}, 
    b::bbox; kw...) where T <: Real

    st_as_stars(data, rast(mask, b); kw...)
end

function st_as_stars(data::AbstractArray{T, 2}, mask::AbstractArray{Bool, 2}, 
    b::AbstractArray{<:Real, 1}; kw...) where T <: Real

    st_as_stars(data, rast(mask, bbox(b...)); kw...)
end


export st_as_stars
