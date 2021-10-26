# using Stars
# cd("test")

@testset "readGDAL" begin
    file = "data/MOD13A2_Henan_2015_2020_10km.tif"
    files = [file, file]
    x = readGDAL(file)
    @test size(x) == (38, 30, 10)

    y = readGDAL(file, 2)
    @test nan_equal(x[:, :, 2], y)

    ## rast vector
    x = readGDAL(files)
    @test length(x) == 2
end

