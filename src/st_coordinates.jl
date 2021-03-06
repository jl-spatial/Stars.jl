# Generate center coordinates for specific index
"""
    st_coords(ga; mid)

`st_coords` is for regular AbstractGeoArray.

# Return
- `X,Y`: A matrix with the dimension of [NX, NY]
""" 
function st_coords(ga::AbstractGeoArray; mid::Vector{Int} = [1, 1])
    x, y = st_dim(ga; mid)
    meshgrid(x, y)
end


# This script is modified from: 
#   `https://github.com/evetion/AbstractGeoArrays.jl/blob/master/src/AbstractGeoArray.jl`
# Copyright (c) 2018 Maarten Pronk, MIT license

"""
    st_coordinates(ga)
  
`st_coordinates` is similar as `st_dim`, but for irregular AbstractGeoArray.
"""
function st_coordinates(ga::AbstractGeoArray, p::SVector{2, Int})
    ga.f(p .- 0.5)
end
st_coordinates(ga::AbstractGeoArray, p::Vector{Int}) = st_coordinates(ga, SVector{2}(p))

function st_coordinates(ga::AbstractGeoArray)
    # (ui, uj) = size(ga)[1:2]
    # ci = [st_coordinates(ga, SVector{2}(i,j)) for i in 1:ui, j in 1:uj]
    nrow, ncol = size(ga)[1:2]
    X = zeros(nrow, ncol)
    Y = zeros(nrow, ncol)
    @inbounds for i = 1:nrow, j = 1:ncol
        ci = st_coordinates(ga, SVector{2}(i,j))
        X[i, j] = ci[1]
        Y[i, j] = ci[2]
    end
    X, Y
end

function st_coordinates(ga::AbstractGeoArray, dim::Symbol)
    if is_rotated(ga)
        error("This method cannot be used for a rotated AbstractGeoArray")
    end
    if dim==:x
        ui = size(ga,1)
        ci = [st_coordinates(ga, SVector{2}(i,1))[1] for i in 1:ui]
    elseif dim==:y
        uj = size(ga,2)
        ci = [st_coordinates(ga, SVector{2}(1,j))[2] for j in 1:uj]
    else
        error("Use :x or :y as second argument")
    end
    return ci
end


"""
    st_coordinates!(ga, x::AbstractUnitRange, y::AbstractUnitRange)

Set AffineMap of `AbstractGeoArray` by specifying the *center coordinates* for each x, y 
dimension by a `UnitRange`.
"""
function st_coordinates!(ga, x::AbstractUnitRange, y::AbstractUnitRange)
    size(ga)[1:2] != (length(x), length(y)) && error("Size of `AbstractGeoArray` $(size(ga)) does not match size of (x,y): $((length(x),length(y))). Note that this function takes *center coordinates*.")
    ga.f = unitrange_to_affine(x, y)
    ga
end


export st_coords, st_coordinates, st_coordinates!
