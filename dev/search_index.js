var documenterSearchIndex = {"docs":
[{"location":"Index/#Stars.jl-Documentation","page":"Introduction","title":"Stars.jl Documentation","text":"","category":"section"},{"location":"Index/","page":"Introduction","title":"Introduction","text":"","category":"page"},{"location":"Index/","page":"Introduction","title":"Introduction","text":"GeoArray","category":"page"},{"location":"Index/#Stars.GeoArray","page":"Introduction","title":"Stars.GeoArray","text":"GeoArray(A::AbstractArray{<:RealOrMissing}, f::AffineMap = default_affinemap, crs::WellKnownText = crs2wkt(\"\"))\nGeoArray(A::AbstractArray{<:RealOrMissing}, f::AffineMap, crs::AbstractString)\nGeoArray(A::AbstractArray{<:RealOrMissing}, x::AbstractRange, y::AbstractRange, args...)\n\nGeoArray(fn::AbstractString, bands = nothing) \nGeoArray(ga::AbstractGeoArray; vals::AbstractArray{<:RealOrMissing})\n\nConstruct a GeoArray from any Array. Meanwhile, AffineMap and CRS will be generated.\n\nArguments\n\nA: An AbstractArray, at least 2d Array\n\nExamples\n\nga = GeoArray(rand(10,10,1))\nGeoArray(rand(10,10))\n\nGeoArray(ga, vals = ga.A)                        # copy `f` and `crs` from `ga`\nGeoArray(rand(10,10), 1:10, 2:11)                # define coordinate by `x` and `y`\nGeoArray(rand(7, 4), bbox([70, 15, 140, 55]...)) # define coordinate by `bbox`\n\n# 4-d array\nga = GeoArray(rand(10, 10, 2, 3))\nGeoArray(ga, vals = ga.A)\n\n\n\n\n\n","category":"type"},{"location":"Index/","page":"Introduction","title":"Introduction","text":"Modules = [Stars]\nOrder   = [:function, :type]","category":"page"},{"location":"Index/#Base.getindex","page":"Introduction","title":"Base.getindex","text":"getindex(ga::AbstractGeoArray, i::AbstractRange, j::AbstractRange, k::TYPE_index = :)\nTYPE_index = Union{Colon,AbstractRange,Integer}\n\nIndex a AbstractGeoArray with AbstractRanges to get a cropped AbstractGeoArray with the correct AffineMap set.\n\nExamples\n\njulia> ga[2:3,2:3,1]\n2x2x1 Array{Float64, 3} with AffineMap([1.0 0.0; 0.0 1.0], [1.0, 1.0]) and undefined CRS\n\n\n\n\n\n","category":"function"},{"location":"Index/#Stars.cast_to_gdal-Tuple{AbstractArray{<:Real, 3}}","page":"Introduction","title":"Stars.cast_to_gdal","text":"Converts type of Array for one that exists in GDAL.\n\n\n\n\n\n","category":"method"},{"location":"Index/#Stars.cellIJ-Tuple{GeoArray, Tuple}","page":"Introduction","title":"Stars.cellIJ","text":"cellIJ(r::GeoArray, point::Tuple)\n\n@return\n\nIlon, Ilat\n\n\n\n\n\n","category":"method"},{"location":"Index/#Stars.clip_point-Tuple{GeoArray, Any}","page":"Introduction","title":"Stars.clip_point","text":"clip_point(r, shp; ngrid = 10)\n\nshp: DataFrame with the column of geom\n\n\n\n\n\n","category":"method"},{"location":"Index/#Stars.equals-Tuple{Stars.AbstractGeoArray, Stars.AbstractGeoArray}","page":"Introduction","title":"Stars.equals","text":"Check whether two GeoArrayss a and b are geographically equal,  although not necessarily in content.\n\n\n\n\n\n","category":"method"},{"location":"Index/#Stars.flipud!-Tuple{GeoArray}","page":"Introduction","title":"Stars.flipud!","text":"Function to flip GeoArray upside down to adjust to GDAL ecosystem.\n\n\n\n\n\n","category":"method"},{"location":"Index/#Stars.gdal_polygonize","page":"Introduction","title":"Stars.gdal_polygonize","text":"gdal_polygonize(raster_file, band = 1, out_file = \"out.shp\"; \n    fieldname = \"grid\", nodata = NaN)\n\nCreates vector polygons for all connected regions of pixels in the raster sharing a common pixel value.\n\nReferences\n\nhttps://gdal.org/programs/gdal_polygonize.html\n\n\n\n\n\n","category":"function"},{"location":"Index/#Stars.gdalinfo-Tuple{GeoArray}","page":"Introduction","title":"Stars.gdalinfo","text":"gdalinfo(ga::GeoArray)\ngdalinfo(file::AbstractString)\n\nget detailed GDAL information\n\nreturn\n\nrange    : [lonmin, lonmax, latmin, latmax]\ncellsize : [dx, dy]\ncoords   : [lon, lat]\ndim      : (width, height, ntime)\n\n\n\n\n\n","category":"method"},{"location":"Index/#Stars.get_nodata-Tuple{Ptr{Nothing}}","page":"Introduction","title":"Stars.get_nodata","text":"Retrieves nodata value from RasterBand.\n\n\n\n\n\n","category":"method"},{"location":"Index/#Stars.is_rotated-Tuple{Stars.AbstractGeoArray}","page":"Introduction","title":"Stars.is_rotated","text":"Check wether the AffineMap of a AbstractGeoArray contains rotations.\n\n\n\n\n\n","category":"method"},{"location":"Index/#Stars.maskCoords-Tuple{Stars.AbstractGeoArray{Bool}}","page":"Introduction","title":"Stars.maskCoords","text":"dcoord = stas_sf(mask)\n\n\n\n\n\n","category":"method"},{"location":"Index/#Stars.mask_flags-Tuple{Int32}","page":"Introduction","title":"Stars.mask_flags","text":"Takes bitwise OR-ed set of status flags and returns flags.\n\n\n\n\n\n","category":"method"},{"location":"Index/#Stars.readGDAL-Tuple{AbstractString, Vararg{Any}}","page":"Introduction","title":"Stars.readGDAL","text":"readGDAL(file::String, options...)\nreadGDAL(files::Array{String,1}, options)\n\nArguments:\n\noptions: other parameters to ArchGDAL.read(dataset, options...).\n\nReturn\n\n\n\n\n\n","category":"method"},{"location":"Index/#Stars.shrink_bbox","page":"Introduction","title":"Stars.shrink_bbox","text":"shrink_bbox(ga, mask::AbstractArray{Bool, 2} = nothing)\n\nOnly true values in mask will be kept.\n\n\n\n\n\n","category":"function"},{"location":"Index/#Stars.st_as_sf","page":"Introduction","title":"Stars.st_as_sf","text":"st_as_sf(ga::AbstractGeoArray, mask::Union{Nothing, AbstractArray{Bool, 2}} = nothing)\nst_as_sf(file::AbstractString, mask = nothing)\n\nIf the input is a file path, shrink_bbox will be applied.\n\n\n\n\n\n","category":"function"},{"location":"Index/#Stars.st_as_stars-Union{Tuple{T}, Tuple{AbstractMatrix{T}, AbstractMatrix{Bool}}} where T<:Real","page":"Introduction","title":"Stars.st_as_stars","text":"st_as_stars(data::AbstractArray{T, 2}, mask::AbstractArray{Bool, 2})\n\nst_as_stars(data::AbstractArray{T, 2}, r_mask::GeoArray; outfile = nothing)\nst_as_stars(data::AbstractArray{T, 2}, mask::AbstractArray{Bool, 2}, \n    b::bbox; kw...)\nst_as_stars(data::AbstractArray{T, 2}, mask::AbstractArray{Bool, 2}, \n    b::AbstractArray{<:Real, 1}; kw...)\n\n\n\n\n\n","category":"method"},{"location":"Index/#Stars.st_bbox!-Tuple{Stars.AbstractGeoArray, bbox}","page":"Introduction","title":"Stars.st_bbox!","text":"Set geotransform of AbstractGeoArray by specifying a bounding box. Note that this only can result in a non-rotated or skewed AbstractGeoArray.\n\n\n\n\n\n","category":"method"},{"location":"Index/#Stars.st_clip-Tuple{Stars.AbstractGeoArray, bbox}","page":"Introduction","title":"Stars.st_clip","text":"clipbbox(x::AbstractGeoArray, b::bbox) clipbbox(x::AbstractGeoArray, y::AbstractGeoArray)\n\n\n\n\n\n","category":"method"},{"location":"Index/#Stars.st_coordinates!-Tuple{Any, AbstractUnitRange, AbstractUnitRange}","page":"Introduction","title":"Stars.st_coordinates!","text":"st_coordinates!(ga, x::AbstractUnitRange, y::AbstractUnitRange)\n\nSet AffineMap of AbstractGeoArray by specifying the center coordinates for each x, y  dimension by a UnitRange.\n\n\n\n\n\n","category":"method"},{"location":"Index/#Stars.st_coordinates-Tuple{Stars.AbstractGeoArray, StaticArrays.SVector{2, Int64}}","page":"Introduction","title":"Stars.st_coordinates","text":"st_coordinates(ga)\n\nst_coordinates is similar as st_dim, but for irregular AbstractGeoArray.\n\n\n\n\n\n","category":"method"},{"location":"Index/#Stars.st_coords-Tuple{Stars.AbstractGeoArray}","page":"Introduction","title":"Stars.st_coords","text":"st_coords(ga; mid)\n\nst_coords is for regular AbstractGeoArray.\n\nReturn\n\nX,Y: A matrix with the dimension of [NX, NY]\n\n\n\n\n\n","category":"method"},{"location":"Index/#Stars.st_crs!-Tuple{Stars.AbstractGeoArray, GeoFormatTypes.WellKnownText}","page":"Introduction","title":"Stars.st_crs!","text":"st_crs!(ga::AbstractGeoArray, crs::WellKnownText{GeoFormatTypes.CRS,<:AbstractString})\nst_crs!(ga::AbstractGeoArray, crs::GFT.CoordinateReferenceSystemFormat)\nst_crs!(ga::AbstractGeoArray, epsgcode::Int)\n\nSet CRS on AbstractGeoArray by epsgcode or string\n\n\n\n\n\n","category":"method"},{"location":"Index/#Stars.st_dim-Tuple{Stars.AbstractGeoArray}","page":"Introduction","title":"Stars.st_dim","text":"st_dim(ga::AbstractGeoArray; mid::Vector{Int} = [1, 1])\nst_dim(b::bbox, cellsize::T) where {T <: Real}\nst_dim(ga::AbstractGeoArray, dim::Symbol; mid::Vector{Int} = [1, 1])\n\nGet dimensions of x and y\n\n\n\n\n\n","category":"method"},{"location":"Index/#Stars.st_read","page":"Introduction","title":"Stars.st_read","text":"st_read(fn::AbstractString, bands = nothing)\n\nReturn\n\nA AbstractGeoArray object\n\n\n\n\n\n","category":"function"},{"location":"Index/#Stars.st_write-Tuple{Stars.AbstractGeoArray, AbstractString}","page":"Introduction","title":"Stars.st_write","text":"st_write(ga::AbstractGeoArray, fn::AbstractString; nodata = nothing)\nst_write(A::AbstractArray{T}, b::bbox, fn::AbstractString;nodata = nothing)\n\nArguments\n\nA: 2d or 3d array\nfn: outfile path\nnodata: should be in the same data type as ga.A (or A)\n\n\n\n\n\n","category":"method"},{"location":"Index/#Stars.SpatialPixelsDataFrame","page":"Introduction","title":"Stars.SpatialPixelsDataFrame","text":"SpatialPixelsDataFrame{\n    T<:AbstractArray{<:Real, 2}, \n    C<:AbstractArray{<:Real, 2}, B<:bbox, P}  <: AbstractSpatialPoints\n\nSpatialPixelsDataFrame(data::AbstractArray{<:Real, 2}, coords::AbstractArray{<:Real, 2}, b::bbox, proj = 4326)\n\nUsage\n\nSpatialPixelsDataFrame(data, coords, bbox, proj)\n\n\n\n\n\n","category":"type"},{"location":"Index/#Stars.bbox","page":"Introduction","title":"Stars.bbox","text":"bbox(xmin, ymin, xmax, ymax)\nbbox(;xmin, ymin, xmax, ymax)\nbbox2tuple(b::bbox)\nbbox2vec(b::bbox)\nbbox2affine(size::Tuple{Integer, Integer}, b::bbox)\n\nSpatial bounding box\n\n\n\n\n\n","category":"type"},{"location":"Index/#Index","page":"Introduction","title":"Index","text":"","category":"section"},{"location":"Index/","page":"Introduction","title":"Introduction","text":"","category":"page"},{"location":"Variables/","page":"Variables","title":"Variables","text":"bbox\nGeoArray","category":"page"},{"location":"Variables/","page":"Variables","title":"Variables","text":"Spatial\nSpatialPoint\nSpatialPixelsDataFrame","category":"page"},{"location":"IO/","page":"IO","title":"IO","text":"st_write\nst_read\nreadGDAL","category":"page"},{"location":"IO/#Stars.st_write","page":"IO","title":"Stars.st_write","text":"st_write(ga::AbstractGeoArray, fn::AbstractString; nodata = nothing)\nst_write(A::AbstractArray{T}, b::bbox, fn::AbstractString;nodata = nothing)\n\nArguments\n\nA: 2d or 3d array\nfn: outfile path\nnodata: should be in the same data type as ga.A (or A)\n\n\n\n\n\n","category":"function"},{"location":"IO/#Stars.st_read","page":"IO","title":"Stars.st_read","text":"st_read(fn::AbstractString, bands = nothing)\n\nReturn\n\nA AbstractGeoArray object\n\n\n\n\n\n","category":"function"},{"location":"IO/#Stars.readGDAL","page":"IO","title":"Stars.readGDAL","text":"readGDAL(file::String, options...)\nreadGDAL(files::Array{String,1}, options)\n\nArguments:\n\noptions: other parameters to ArchGDAL.read(dataset, options...).\n\nReturn\n\n\n\n\n\n","category":"function"}]
}