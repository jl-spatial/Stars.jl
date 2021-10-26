
function meshgrid(x::AbstractArray{T,1}, y::AbstractArray{T,1}) where T <: Real 
    X = x .* ones(1, length(y))
    Y = ones(length(x)) .* y'
    X, Y
end

"""
    st_dim(ga::GeoArray; mid::Vector{Int} = [1, 1])
    st_dim(b::bbox, cellsize::T) where {T <: Real}
    st_dim(ga::GeoArray, dim::Symbol; mid::Vector{Int} = [1, 1])
    
Get dimensions of x and y
"""
function st_dim(ga::GeoArray; mid::Vector{Int} = [1, 1])
    if length(mid) == 1; mid = [mid, mid]; end
    
    cellsize_x = ga.f.linear[1]
    cellsize_y = abs(ga.f.linear[4])
    cellsize_y2 = ga.f.linear[4]
    
    delta = [cellsize_x, cellsize_y]/2 .* mid
    
    rbbox = st_bbox(ga)
    x = rbbox.xmin + delta[1]:cellsize_x:rbbox.xmax
    y = rbbox.ymin + delta[2]:cellsize_y:rbbox.ymax
    if cellsize_y2 < 0; y = reverse(y); end

    x, y
end

function st_dim(b::bbox, cellsize::T) where {T <: Real}
    lon = b.xmin + cellsize/2 : cellsize : b.xmax
    lat = reverse(b.ymin + cellsize/2 : cellsize : b.ymax)
    lon, lat # return
end

st_dim_x(ga::GeoArray; mid::Vector{Int} = [1, 1]) = st_dim(ga; mid)[1]
st_dim_y(ga::GeoArray; mid::Vector{Int} = [1, 1]) = st_dim(ga; mid)[2]

function st_dim(ga::GeoArray, dim::Symbol; mid::Vector{Int} = [1, 1])
    if dim==:x
        ci = st_dim_x(ga; mid = mid)
    elseif dim==:y
        ci = st_dim_y(ga; mid = mid)
    else
        error("Use :x or :y as second argument")
    end
    return ci
end


export meshgrid, st_dim
