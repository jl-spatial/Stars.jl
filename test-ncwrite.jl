using terra
# using Statistics
using Plots


indir = "K:/Researches/Phenology"
file_vi = "$indir/MOD13A2_Henan_2015_2020_EVI.tif"

@time ga = terra.read(file_vi)
@time r_mean = mean(ga)

plot(r_mean)

## -----------------------------------------------------------------------------
gr()
plot(r_mean)
# dataset = AG.read(file_vi)
st_coordinates(r_mean)

x = sum(data.A, dims = 3)
