
function shpfiles(file)
   [file, 
    replace(file, ".shp" => ".shx"), 
    replace(file, ".shp" => ".prj"), 
    replace(file, ".shp" => ".dbf")] 
end


@testset "gdal_polygonize" begin
    file = "data/MOD13A2_Henan_2015_2020_10km.tif"
    outfile = "Henan_EVI.shp"
    gdal_polygonize(file, 1, outfile; fieldname = "EVI")
    
    rm.(shpfiles(outfile))
    @test true
end
