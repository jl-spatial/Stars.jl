module GeoArrays

using GDAL
using ArchGDAL; const AG = ArchGDAL

using CoordinateTransformations
using StaticArrays
using GeoFormatTypes
const GFT = GeoFormatTypes

include("geoarray.jl")
include("bbox.jl")
include("affine.jl")

include("centercoords.jl")
include("coords.jl")
include("crs.jl")

include("tools_ratser.jl")
include("tools_Ipaper.jl")

include("utils/utils.jl")
include("raster/Raster.jl")
include("shp/GeoDataFrames.jl")
include("gdal/gdal.jl")

include("plot.jl")

export GeoArray

export coords
export centercoords
export indices

export compose!

export epsg!
export crs!

export -,+,*,/

end
