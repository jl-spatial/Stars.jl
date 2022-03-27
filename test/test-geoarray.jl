using Stars

@testset "st_bbox" begin
    ga = st_read("data/utmsmall.tif") 
    lon, lat = st_dim(ga)
    @test st_bbox(ga) == st_bbox(lon, lat)
    @test st_bbox(ga) == bbox(xmin = 440720.0, ymin = 3.74532e6, xmax = 446720.0, ymax = 3.75132e6)
    @test st_bbox(ga) == bbox(440720.0, 3.74532e6, 446720.0, 3.75132e6)
    # @test bboxes(ga)[1] == (min_x = 440720.0, max_x = 440780.0, min_y = 3.75126e6, max_y = 3.75132e6)
    # @test bboxes(ga)[end] == (min_x = 446660.0, max_x = 446720.0, min_y = 3.74532e6, max_y = 3.74538e6)
end

@testset "st_dim" begin
    straight = GeoArray(rand(5, 5, 1), AffineMap([1.0 0.0; 0.0 -1.0], [375000.03, 380000.03]), "")
    rot = GeoArray(rand(5, 5, 1), AffineMap([1.0 0.5; 0.1 1.0], [0.0, 0.0]), "")
    @test st_dim(straight, :x; mid = [0, 0]) == collect(375000.03:1:375005.03)
    @test st_dim(straight, :y; mid = [0, 0]) == collect(380000.03:-1:379995.03)
    @test_throws ErrorException st_dim(straight, :z)
    # @test_throws ErrorException coords(rot, :x)
    # @test_throws ErrorException coords(rot, :y)
end


@testset "GeoArray constructors" begin
    x, y = range(4, stop = 8.0, length = 10), range(0, stop = 1, length = 9)
    ga2 = GeoArray(rand(10, 9), x, y)
    ga2 = GeoArray(rand(10, 9), x, y, "")
    ga3 = GeoArray(rand(10, 9, 8), x, y)
    ga3 = GeoArray(rand(10, 9, 8), x, y, "")
    
    # println(ga2)
    # for i in 1:length(x), j in 1:length(y)
    #     @test Stars.centercoords(ga2, [i,j]) ≈ [x[i],y[j]]
    # end
    # for i in 1:length(x), j in 1:length(y)
    #     @test Stars.centercoords(ga3, [i,j]) ≈ [x[i],y[j]]
    # end
    x, y = range(4, stop = 8.0, length = 11), range(0, stop = 1, length = 9)
    @test_throws ErrorException GeoArray(rand(10, 9), x, y)

    ## test for missing value
    x = [1 2; missing 4]
    ga = GeoArray(x)
    @test typeof(ga) == GeoArray{Union{Missing, Int64}, 3}
    @test size(ga) == (2, 2, 1)
    @test ga.crs == Stars.crs2wkt("")

    # 4-d array
    r = GeoArray(rand(10, 9, 8, 2))
    @test ndims(r) == 4
    @test ndims(r[:, :, 1, 2]) == 3 # at least 3d array
end


@testset "GeoArray Type Conversions" begin
    ga = GeoArray(rand(1:32000, 5, 5))
    st_write(ga, "test_conversion.tif")

    ga = GeoArray(rand(Bool, 5, 5))
    st_write(ga, "test_conversion.tif")
end
