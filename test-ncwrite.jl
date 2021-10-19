using terra
using Plots
# using Statistics

indir = "K:/Researches/Phenology"
file_vi = "$indir/MOD13A2_Henan_2015_2020_EVI.tif"

@time ga = terra.read(file_vi)
@time r_mean = mean(ga)

# rast(ga, vals = r_mean.A[:, :, 1])

function Range(x::AbstractArray{<:Real}) 
    minimum(x), maximum(x)
end

function subset(ga)
    mat = ga.A[:, :, 1]

    ind = findall(mat .!= 0)
    # ind_vec = LinearIndices(mat)[ind]
    rows = map(x -> x[1], ind) # x, long
    cols = map(x -> x[2], ind) # y, lat

    I_x = seq(Range(rows)...)
    I_y = seq(Range(cols)...)
    
    rast(ga, vals = ga.A[I_x, I_y])
end

mat = r_mean.A[:,:,1]
ind = findall(mat .!= 0)
ind_vec = LinearIndices(mat)[ind]

rows = map(x -> x[1], ind)
cols = map(x -> x[2], ind)

seq(Range(rows)...)
seq(Range(cols)...)




# st_coordinates(ga, :x)
# st_coordinates(ga, :y)


plot(r_mean)

## -----------------------------------------------------------------------------
# gr()
plot(r_mean)
# dataset = AG.read(file_vi)
st_coordinates(r_mean)

x = sum(data.A, dims = 3)
