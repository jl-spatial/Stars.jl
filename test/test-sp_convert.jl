using Stars
using Test
cd("test")


# @testset "st_as_sf" 
begin
    file_vi = "data/MOD13A2_Henan_2015_2020_10km.tif"
    ga = rast(file_vi)
    mask_shrink = ga.A[:, :, 1] .!= 0

    data, mask, b = st_as_sf(file_vi)    

    ## post processing
    r_mask = rast(mask, b)
    lon, lat = st_dim(r_mask)
    d_coord = maskCoords(r_mask)
    @test length(d_coord[:, 1]) == 737
end


# @testset "st_as_stars" 
begin
    function test_rastDiff(r1, r2)
        r_diff = (r1 - r2) |> maximum
        delta = filter(!isnan, r_diff.A) |> maximum 
        @test delta <= 1e-9
    end

    file_vi = "data/MOD13A2_Henan_2015_2020_10km.tif"
    data, mask, b = st_as_sf(file_vi)
    r_mask = rast(mask, b)

    r1 = st_as_stars(data, mask, b)           # bbox works
    r2 = st_as_stars(data, mask, bbox2vec(b)) # bbox in vector format also works
    r3 = st_as_stars(data, r_mask)
    
    test_rastDiff(r1, r2)
    test_rastDiff(r2, r3)
end
