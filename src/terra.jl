module terra

using GDAL
using ArchGDAL; const AG = ArchGDAL

using CoordinateTransformations
using StaticArrays
using GeoFormatTypes
const GFT = GeoFormatTypes

import Statistics
import Statistics: mean


include("geoarray.jl")
include("st_bbox.jl")
include("st_affine.jl")
include("st_crs.jl")

include("st_dim.jl")
include("st_coordinates.jl")

include("tools_ratser.jl")
include("tools_Ipaper.jl")

include("utils/utils.jl")
include("raster/Raster.jl")
include("shp/GeoDataFrames.jl")
include("gdal/gdal.jl")

include("st_plot.jl")

include("hydro/hydro.jl")
include("hydro/snap_pour_points.jl")

export GeoArray

export coords
export centercoords
export indices

export compose!

export epsg!
export crs!

export -,+,*,/

end
