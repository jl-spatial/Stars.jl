<!-- [![](https://img.shields.io/badge/docs-stable-blue.svg)](https://geo-julia.github.io/stars.jl/)  -->
<!-- [![Build Status](https://travis-ci.org/geo-julia/stars.jl.svg?branch=master)](https://travis-ci.org/geo-julia/stars.jl)  -->
[![codecov](https://codecov.io/gh/geo-julia/stars.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/geo-julia/stars.jl)

# stars

Simple geographical raster interaction built on top of [ArchGDAL](https://github.com/yeesian/ArchGDAL.jl/), [GDAL](https://github.com/JuliaGeo/GDAL.jl) and [CoordinateTransformations](https://github.com/FugroRoames/CoordinateTransformations.jl).

A GeoArray is an AbstractArray, an AffineMap for calculating coordinates based on the axes and a CRS definition to interpret these coordinates into in the real world. It's three dimensional and can be seen as a stack (3d) of 2d geospatial rasters (bands), the dimensions are :x, :y, and :bands. The AffineMap and CRS (coordinates) only operate on the :x and :y dimensions.

This packages takes its inspiration from Python's [rasterio](https://github.com/mapbox/rasterio).

## Installation

```julia
(v1.5) pkg> add stars
```

## Examples

#### Basic Usage

```julia
julia> using stars

# Read TIF file
julia> fn = download("https://github.com/yeesian/ArchGDALDatasets/blob/master/data/utmsmall.tif?raw=true")
julia> geoarray = st_read(fn)
100x100x1 Array{UInt8,3} with AffineMap([60.0 0.0; 0.0 -60.0], [440720.0, 3.75132e6]) and CRS PROJCS["NAD27 / UTM zone 11N"...

# Affinemap containing offset and scaling
julia> geoarray.f
AffineMap([60.0 0.0; 0.0 -60.0], [440720.0, 3.75132e6])

# WKT projection string
julia> geoarray.crs
GeoFormatTypes.WellKnownText{GeoFormatTypes.CRS,String}(GeoFormatTypes.CRS(), "PROJCS[\"NAD27 / UTM zone 11N\",GEOGCS[\"NAD27\",DATUM[\"North_American_Datum_1927\",SPHEROID[\"Clarke 1866\",6378206.4,294.978698213898,AUTHORITY[\"EPSG\",\"7008\"]],AUTHORITY[\"EPSG\",\"6267\"]],PRIMEM[\"Greenwich\",0],UNIT[\"degree\",0.0174532925199433,AUTHORITY[\"EPSG\",\"9122\"]],AUTHORITY[\"EPSG\",\"4267\"]],PROJECTION[\"Transverse_Mercator\"],PARAMETER[\"latitude_of_origin\",0],PARAMETER[\"central_meridian\",-117],PARAMETER[\"scale_factor\",0.9996],PARAMETER[\"false_easting\",500000],PARAMETER[\"false_northing\",0],UNIT[\"metre\",1,AUTHORITY[\"EPSG\",\"9001\"]],AXIS[\"Easting\",EAST],AXIS[\"Northing\",NORTH],AUTHORITY[\"EPSG\",\"26711\"]]")

# Create, reference and write a TIFF
julia> ga = GeoArray(rand(100,200))
julia> st_bbox!(ga, bbox(xmin=2., ymin=51., xmax=5., ymax=54.))  # roughly the Netherlands
julia> st_crs!(ga, 4326)  # in WGS84
julia> st_write!("test.tif", ga)
```

#### Using coordinates

```julia
# Find coordinates by index
julia> coords(geoarray, [1,1])
2-element StaticArrays.SArray{Tuple{2},Float64,1,2}:
 440720.0
      3.75132e6

# Find index by coordinates
julia> indices(geoarray, [440720.0, 3.75132e6])
2-element StaticArrays.SArray{Tuple{2},Int64,1,2}:
 1
 1

# Find all coordinates
julia> coords(geoarray)
101×101 Array{StaticArrays.SArray{Tuple{2},Float64,1,2},2}:
 [440720.0, 3.75132e6]  [440720.0, 3.75126e6]  [440720.0, 3.7512e6] ...
 ...
```

#### Manipulation

```julia
# Translate complete raster by x + 100
julia> trans = Translation(100, 0)
julia> compose!(ga, trans)


# Math with stars (- + * /)
julia> GeoArray(rand(5,5,1)) - GeoArray(rand(5,5,1))
5x5x1 Array{Float64,3} with AffineMap([1.0 0.0; 0.0 1.0], [0.0, 0.0]) and undefined CRS
```


#### Plotting

```julia
# Plot a GeoArray
julia> using Plots
julia> fn = download("https://github.com/yeesian/ArchGDALDatasets/blob/master/pyrasterio/RGB.byte.tif?raw=true")
julia> ga = st_read(fn)
julia> plot(ga)

# or plot a band other than the first one
julia> plot(ga, band=2)
```

![example plot](docs/img/RGB.byte.png)
