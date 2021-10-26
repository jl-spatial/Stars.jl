# using Stars


@testset "Projection string checking" begin
    ga = rast("data/MOD13A2_Henan_2015_2020_10km.tif")
    LON, LAT = st_coords(ga)

    @test size(LON) == size(LAT)
    @test size(LON) == (38, 30)

    LON2, LAT2 = st_coordinates(ga)
    @test maximum(LON - LON2) <= 1e-7
    @test maximum(LAT - LAT2) <= 1e-7


    lon2 = st_coordinates(ga, :x)
    lat2 = st_coordinates(ga, :y)

    lon, lat = st_dim(ga)

    @test maximum(abs.(lon - lon2)) <= 1e-7
    @test maximum(abs.(lat - lat2)) <= 1e-7
end
