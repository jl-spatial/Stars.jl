# using Stars
# using Test

@testset "st_as_sf" begin
    file_vi = "data/MOD13A2_Henan_2015_2020_10km.tif"
    ga = rast(file_vi)
    mask = get_mask(ga, 0)
    # mask_shrink = ga.A[:, :, 1] .!= 0

    EVI = st_as_sf(file_vi)

    ## post processing
    # r_mask = rast(mask, b)
    lon, lat = st_dim(mask)
    d_coord = maskCoords(mask)
    @test length(d_coord[:, 1]) == 670
end


@testset "st_as_stars" begin
    function test_rastDiff(r1, r2)
        r_diff = (r1 - r2) |> maximum
        delta = filter(!isnan, r_diff.A) |> maximum
        @test delta <= 1e-9
    end

    f = "data/MOD13A2_Henan_2015_2020_10km.tif"
    r = rast(f)
    r_mask = get_mask(r, 0)
    EVI = st_as_sf(r, r_mask)

    # r1 = st_as_stars(EVI, mask, b)           # bbox works
    # r2 = st_as_stars(EVI, mask, bbox2vec(b)) # bbox in vector format also works
    r3 = st_as_stars(EVI, r_mask)

    # test_rastDiff(r1, r2)
    test_rastDiff(r, r3)
end


# @test r1.A == r3.A
# @test r2.A == r3.A
# @test r2.A == r1.A
# @time r = st_as_stars(EVI, mask, b; outfile = "MOD13A2_Henan_2015_2020.tif");
# @time plot(r[:,:, 1])

# heatmap(mat')
# @time d2 = unstack(d_coord, :lon, :lat, :id); "ok"
# @time Matrix(d2)
