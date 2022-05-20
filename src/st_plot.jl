# This script is modified from: 
#   `https://github.com/evetion/GeoArrays.jl/blob/master/src/plot.jl`
# Copyright (c) 2018 Maarten Pronk, MIT license

using RecipesBase

@recipe function f(ga::AbstractGeoArray; band=1, fact=nothing)
    xflip --> false
    yflip --> false
    aspect_ratio --> 1
    seriestype := :heatmap
    seriescolor := :viridis

    # 默认的分辨率为全球0.25°
    if fact === nothing
        n = prod(size(ga.A)[1:2])
        cellsize = 0.5
        fact = ceil(Int, sqrt(n / (360 / cellsize * 180 / cellsize)))
    end
    
    if fact > 1
        println("[st_plot]: fact = $fact\n")
        ga = resample(ga, fact)
    end
    # coords = st_coordinates(ga)
    # @show coords
    x = st_coordinates(ga, :x)
    y = st_coordinates(ga, :y)
    # x = map(x->x[1], coords[:, 1])
    # y = map(x->x[2], coords[end, :])
    z = ga.A[:, :, band]'

    # Can't use x/yflip as x/y coords
    # have to be sorted for Plots
    if ga.f.linear[1] < 0
        z = reverse(z, dims=2)
        reverse!(x)
    end
    if ga.f.linear[4] < 0
        z = reverse(z, dims=1)
        reverse!(y)
    end

    xlims --> (extrema(x))
    ylims --> (extrema(y))

    x, y, z
end
