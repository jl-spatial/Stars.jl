# Copyright (c) 2018 Maarten Pronk, MIT license
# 
# @references:
# 1. `https://github.com/evetion/GeoArrays.jl/blob/master/src/geoutils.jl`

function get_affine_map(ds::ArchGDAL.Dataset)
    # ArchGDAL fails hard on datasets without
    # an affinemap. GDAL documents that on fail
    # a default affinemap should be returned.
    try
        global gt = ArchGDAL.getgeotransform(ds)
    catch y
        @warn y.msg
        global gt = [0.0, 1.0, 0.0, 0.0, 0.0, 1.0]
    end
    geotransform_to_affine(SVector{6,Float64}(gt))
end

function geotransform_to_affine(gt::SVector{6,Float64})
    # See https://lists.osgeo.org/pipermail/gdal-dev/2011-July/029449.html
    # for an explanation of the geotransform format
    AffineMap(SMatrix{2,2}([gt[2] gt[3]; gt[5] gt[6]]), SVector{2}([gt[1], gt[4]]))
end
geotransform_to_affine(A::Vector{Float64}) = geotransform_to_affine(SVector{6}(A))

function affine_to_geotransform(am::AffineMap)
    l = am.linear
    t = am.translation
    (length(l) == 4 && length(t) == 2) || error("AffineMap has wrong dimensions.")
    [t[1], l[1], l[3], t[2], l[2], l[4]]
end

function unitrange_to_affine(x::AbstractRange, y::AbstractRange)
    δx, δy = step(x), step(y)
    AffineMap(
        SMatrix{2,2}(δx, 0, 0, δy),
        SVector(x[1] - δx / 2, y[1] - δy / 2)
    )
end


"""
    bbox(xmin, ymin, xmax, ymax)
    bbox(;xmin, ymin, xmax, ymax)
    bbox2tuple(b::bbox)
    bbox2vec(b::bbox)
    bbox2affine(size::Tuple{Integer, Integer}, b::bbox)

Spatial bounding box
"""
Base.@kwdef struct bbox
    xmin::Float64
    ymin::Float64
    xmax::Float64
    ymax::Float64
end

bbox2range(b::bbox) = [b.xmin, b.xmax, b.ymin, b.ymax]

bbox2tuple(b::bbox) = (xmin=b.xmin, ymin=b.ymin, xmax=b.xmax, ymax=b.ymax)
bbox2vec(b::bbox) = [b.xmin, b.ymin, b.xmax, b.ymax]

function bbox2affine(size::Tuple{Integer,Integer}, b::bbox)
    AffineMap(
        SMatrix{2,2}((b.xmax - b.xmin) / size[1], 0, 0, -(b.ymax - b.ymin) / size[2]),
        SVector(b.xmin, b.ymax))
end

const default_affinemap = geotransform_to_affine(SVector(0.0, 1.0, 0.0, 0.0, 0.0, 1.0))
const TYPE_CRS = Union{WellKnownText,AbstractString}

crs2wkt(crs::AbstractString="") = GFT.WellKnownText(GFT.CRS(), crs)
crs2wkt(crs::WellKnownText) = crs

WGS84_str = "GEOGCS[\"WGS 84\",DATUM[\"WGS_1984\",SPHEROID[\"WGS 84\",6378137,298.257223563,AUTHORITY[\"EPSG\",\"7030\"]],AUTHORITY[\"EPSG\",\"6326\"]],PRIMEM[\"Greenwich\",0,AUTHORITY[\"EPSG\",\"8901\"]],UNIT[\"degree\",0.0174532925199433,AUTHORITY[\"EPSG\",\"9122\"]],AXIS[\"Latitude\",NORTH],AXIS[\"Longitude\",EAST],AUTHORITY[\"EPSG\",\"4326\"]]"

WGS84_wkt = crs2wkt(WGS84_str)


export affine_to_geotransform, geotransform_to_affine,
    crs2wkt, bbox,
    bbox2range, bbox2vec;
