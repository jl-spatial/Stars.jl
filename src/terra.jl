module terra

using GDAL
using ArchGDAL; const AG = ArchGDAL

using CoordinateTransformations
using StaticArrays
using GeoFormatTypes
const GFT = GeoFormatTypes
# include("shp/GeoDataFrames.jl")

import Statistics
import Statistics: mean


include("GeoArray.jl")
include("st_bbox.jl")
include("st_affine.jl")
include("st_crs.jl")

include("st_dim.jl")
include("st_coordinates.jl")

include("tools_ratser.jl")
include("tools_Ipaper.jl")

include("utils/utils.jl")
include("raster/Raster.jl")

include("gdal_info.jl")
include("gdal_polygonize.jl")

include("st_plot.jl")
include("st_subset.jl")
include("st_read.jl")
include("st_write.jl")
include("st_convert.jl")


# include("hydro/hydro.jl")
# include("hydro/snap_pour_points.jl")

export GeoArray

export coords
export centercoords
export indices

export compose!

export epsg!
export crs!

export -,+,*,/

end
