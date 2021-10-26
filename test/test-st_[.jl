@testset begin
    ga = rast(rand(4, 4, 10))

    @test size(ga[:,:, 1]) == (4, 4, 1)
    @test size(ga[2:4, 1:4, :]) == (3, 4, 10)
end
