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


function snap_pour_point(flowaccu::GeoArray, shp, outfile = "outlet_snaped.shp"; ngrid = 15)
    @time res = clip_point(flowaccu, shp; ngrid = ngrid);
    lst = res["data"];
    shp2 = shp[:, setdiff(1:15, 13)]

    R"""
    library(data.table)
    library(purrr)
    # library()
    shp = $shp2
    # res = map($lst, ~data.table(.x)[value > 100]) %>% set_names(seq_along(.))
    res = $lst %>% set_names(seq_along(.))
    save(res, shp, file = "flowaccu.rda")

    df = snap_pour_point(res, shp)
    # "I:/ChinaBasins/shp/chinaRunoff_stationInfo_Yangtze_sp87_snaped.shp"
    sp2::df2sp(df) %>% sp2::write_shp($outfile)
    # $lst[[1]] %>% data.table()
    """
end
