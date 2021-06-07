using Plots

function plot_rs(res, shp; nlayout = [4, 4])
    np = prod(nlayout)
    lons, lats = get_coords(shp)    
    ps = []
    for i in 1:length(res)
        p = plot(res[i])
        scatter!(p, [lons[i]], [lats[i]], label = "outlet", title = shp.id[i])
        outfile = @sprintf("Figures/%02d.png", i)
        println(outfile)
        savefig(outfile)
        push!(ps, p)
    end
    ps
end
