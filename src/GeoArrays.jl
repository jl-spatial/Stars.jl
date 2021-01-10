module GeoArrays

using GeoFormatTypes
using GDAL
using ArchGDAL
using CoordinateTransformations
using StaticArrays
const GFT = GeoFormatTypes

include("geoarray.jl")
include("bbox.jl")
include("affine.jl")

include("centercoords.jl")
include("coords.jl")
include("crs.jl")

include("utils.jl")
include("interpolate.jl")
include("operations.jl")
include("plot.jl")
include("resample.jl")

include("IO/IO.jl")
include("gdal/gdal.jl")

export GeoArray

export coords
export centercoords
export indices

export bbox, bbox!
export bboxes

export compose!

export interpolate!

export epsg!
export crs!

export -,+,*,/

end
