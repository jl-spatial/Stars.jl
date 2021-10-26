# using Stars

@testset "gdalinfo" begin
    file = "data/MOD13A2_Henan_2015_2020_10km.tif"
    ga = st_read(file)
    @test gdalinfo(ga) == gdalinfo(file)
end
