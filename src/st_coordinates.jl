# Generate center coordinates for specific index
"""
    st_coords(ga; mid)

`st_coords` is for regular GeoArray.

# Return
- `X,Y`: A matrix with the dimension of [NX, NY]
""" 
function st_coords(ga::GeoArray; mid::Vector{Int} = [1, 1])
    x, y = st_dim(ga; mid)
    meshgrid(x, y)
end


"""
    st_coordinates(ga)
  
`st_coordinates` is similar as `st_dim`, but for irregular GeoArray.

# Return
Matrix{StaticArrays.SVector{2, Float64}}, e.g.:
```julia
[110.004, 42.9958]  [110.004, 42.9875]  
[110.013, 42.9958]  [110.013, 42.9875]
```
"""
function st_coordinates(ga::GeoArray, p::SVector{2, Int})
    ga.f(p .- 0.5)
end
st_coordinates(ga::GeoArray, p::Vector{Int}) = st_coordinates(ga, SVector{2}(p))

function st_coordinates(ga::GeoArray)
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

function st_coordinates(ga::GeoArray, dim::Symbol)
    if is_rotated(ga)
        error("This method cannot be used for a rotated GeoArray")
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

Set AffineMap of `GeoArray` by specifying the *center coordinates* for each x, y 
dimension by a `UnitRange`.
"""
function st_coordinates!(ga, x::AbstractUnitRange, y::AbstractUnitRange)
    size(ga)[1:2] != (length(x), length(y)) && error("Size of `GeoArray` $(size(ga)) does not match size of (x,y): $((length(x),length(y))). Note that this function takes *center coordinates*.")
    ga.f = unitrange_to_affine(x, y)
    ga
end


## for missing  ----------------------------------------------------------------
function st_coordinatesnotmissing(ga::GeoArray)
    (ui, uj) = size(ga)[1:2]
    ci = [st_coordinates(ga, SVector{2}(i,j)) for i in 1:ui, j in 1:uj if ~ismissing(ga.A[i, j])]
end

function st_coordinatesmissing(ga::GeoArray)
    (ui, uj) = size(ga)[1:2]
    ci = [st_coordinates(ga, SVector{2}(i,j)) for i in 1:ui, j in 1:uj if ismissing(ga.A[i, j])]
end

function indexmissing(ga::GeoArray)
    (ui, uj) = size(ga)[1:2]
    ci = [[i,j] for i in 1:ui, j in 1:uj if ismissing(ga.A[i, j])]
end


export st_coordinates, st_coordinates!
