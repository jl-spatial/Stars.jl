using GeoArrays
using Printf
using Plots
using ArchGDAL
const AG = ArchGDAL
using DataFrames
using RCall



begin 
    # file = "f:/SciData/ET_products/PMLV2_v016/PMLV2_yearly_G010_v016_2001-01-01.tif"
    # file = "/mnt/i/ChinaBasins/china90_merit/merit90_china_flowaccu.tif"
    file = "i:/ChinaBasins/china90_merit/merit90_china_flowaccu.tif"
    @time flowaccu = GeoArrays.read(file)

    shp = readORG("I:/ChinaBasins/shp/chinaRunoff_stationInfo_Yangtze_sp87.shp")
end

begin
    R"source('src/hydro/snap_pour_point.R')"
    include("src/hydro/snap_pour_point.jl")
    snap_pour_point(flowaccu, shp, "chinaRunoff_stationInfo_Yangtze_sp87_snaped.shp"; ngrid = 15)
end
@time ps = plot_rs(res["raster"], shp)

# plot(ps[1:6]..., layout = (2, 3))
# # writeRaster(r2, "01.tif")
# # using Plots
# begin
#     p = plot(ps[1:16]..., layout = (4, 4), size = (1200*1.5, 1200))
#     savefig(p, "a.pdf")    
# end
