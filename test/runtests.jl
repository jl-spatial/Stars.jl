using Stars
using Test


function nan_equal(x, y)
    ind = findall(.!(isnan.(y)))
    x[ind] == y[ind]
end


@testset "GeoArrays" begin
    cd(dirname(@__FILE__)) do
        # include("get_testdata.jl")
        # include("test_geoutils.jl")
        include("test-geoarray.jl")
        include("test-st_as_sf.jl")
        include("test-st_Ops.jl")
        include("test-st_crs.jl")
        
        include("test-gdalinfo.jl")
        include("test-readGDAL.jl")
        include("test-st_coords.jl")
        # include("test_interpolate.jl")
        # include("test_crs.jl")
        # include("test_operations.jl")
    end
end
