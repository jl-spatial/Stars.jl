# using Stars
# using Test
# cd("test")

@testset "SpatialPixelsDataFrame" begin
    b = bbox(70, 15, 140, 55)
    proj = 4326
    coords = [1 2; 3 4]
    data = [1.0 2; 3 4]

    s = Spatial(b, proj)
    @test typeof(s) == Spatial{bbox, Int64} # 

    sp = SpatialPoints(coords, b, proj)
    @test typeof(sp) == SpatialPoints{Matrix{Int64}, bbox, Int64}

    sp_df = SpatialPixelsDataFrame(data, coords, b, proj)
    @test typeof(sp_df) == SpatialPixelsDataFrame{Matrix{Float64}, Matrix{Int64}, bbox, Int64}

    @test st_bbox(s) == b
    @test st_bbox(sp) == b
    @test st_bbox(sp_df) == b  
    
    @test st_proj(s) == proj
    @test st_proj(sp) == proj
    @test st_proj(sp_df) == proj

    @test st_coords(sp) == coords
    @test st_coords(sp_df) == coords
end

