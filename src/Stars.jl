module Stars

using GDAL
using ArchGDAL; const AG = ArchGDAL

using CoordinateTransformations
export AffineMap;

using StaticArrays
using GeoFormatTypes
const GFT = GeoFormatTypes
# include("shp/GeoDataFrames.jl")

import Statistics
import Statistics: mean

include("tools_Ipaper.jl")
include("geo_basic.jl")
include("geoarray.jl")

include("st_bbox.jl")
include("st_crs.jl")

include("st_dim.jl")
include("st_coordinates.jl")

include("tools_ratser.jl")

include("utils/utils.jl")
# include("raster/Raster.jl")
include("raster/ncread.jl")
include("raster/clip.jl")

include("gdal_basic.jl")
include("gdal_info.jl")
include("gdal_polygonize.jl")

include("st_plot.jl")
include("st_subset.jl")

include("st_read.jl")

include("st_write.jl")
include("st_as_sf.jl")
include("st_as_stars.jl")
include("sp/sp.jl")

# include("hydro/hydro.jl")
# include("hydro/snap_pour_points.jl")

end
