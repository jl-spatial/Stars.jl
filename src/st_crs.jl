# Copyright (c) 2018 Maarten Pronk, MIT license
# `https://github.com/evetion/GeoArrays.jl/blob/master/src/crs.jl`
# https://github.com/evetion/GeoArrays.jl/blob/master/src/geoutils.jl

# import GeoArrays: epsg2wkt, proj2wkt, wkt2wkt, str2wkt;
# import GeoArrays: get_affine_map, geotransform_to_affine, affine_to_geotransform, 
#     is_rotated, unitrange_to_affine;

st_affine(ga::AbstractGeoArray) = ga.f

"""Check wether the AffineMap of a AbstractGeoArray contains rotations."""
function is_rotated(ga::AbstractGeoArray)
    ga.f.linear[2] != 0. || ga.f.linear[3] != 0.
end

"""
    st_crs!(ga::AbstractGeoArray, crs::WellKnownText{GeoFormatTypes.CRS,<:AbstractString})
    st_crs!(ga::AbstractGeoArray, crs::GFT.CoordinateReferenceSystemFormat)
    st_crs!(ga::AbstractGeoArray, epsgcode::Int)

Set CRS on AbstractGeoArray by epsgcode or string
"""
function st_crs!(ga::AbstractGeoArray, crs::WellKnownText)
    ga.crs = crs
    ga
end

function st_crs!(ga::AbstractGeoArray, crs::GFT.CoordinateReferenceSystemFormat)
    ga.crs = convert(GFT.WellKnownText, GFT.CRS(), crs)
    ga
end

st_crs!(ga::AbstractGeoArray, epsgcode::Int) = st_crs!(ga, EPSG(epsgcode))

st_crs(ga::AbstractGeoArray) = ga.crs

epsg!(ga::AbstractGeoArray, epsgcode::Int) = st_crs!(ga, EPSG(epsgcode))
epsg!(ga::AbstractGeoArray, epsgstring::AbstractString) = st_crs!(ga, EPSG(epsgstring))


crs! = st_crs!

export st_crs, st_crs!, st_affine
