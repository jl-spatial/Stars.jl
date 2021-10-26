# using Stars
using Statistics


@testset "st_Ops" begin
    r1 = GeoArray(rand(4, 4, 3))
    r2 = GeoArray(rand(4, 4, 3))

    @test (r1 + r2).A == r1.A + r2.A
    @test (r1 - r2).A == r1.A - r2.A
    @test (r1 * r2).A == r1.A .* r2.A
    @test (r1 / r2).A == r1.A ./ r2.A    
end

@testset "st_Ops Statistics" begin
    r = GeoArray(rand(4, 4, 3))

    @test mean(r).A == mean(r.A, dims = 3)
    @test sum(r).A == sum(r.A, dims = 3)
    @test minimum(r).A == minimum(r.A, dims = 3)
    @test maximum(r).A == maximum(r.A, dims = 3)
end
