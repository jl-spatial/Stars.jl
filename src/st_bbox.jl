"""
Boundary bbox

    st_bbox(lon, lat)
    
- st_bbox(ga::AbstractGeoArray)    
- st_bbox!(ga::AbstractGeoArray, b::bbox) : reset bbox
- st_bbox(ncfile::String)  
"""

function st_bbox(lon, lat)
    cellsize_x = abs(lon[2] - lon[1])
    cellsize_y = abs(lat[2] - lat[1])
    bbox(minimum(lon) - cellsize_x/2, minimum(lat) - cellsize_y/2, 
        maximum(lon) + cellsize_x/2, maximum(lat) + cellsize_y/2)
end

function st_bbox(ga::AbstractGeoArray; to_vec = false)
    ax, ay = ga.f(SVector(0,0))
    bx, by = ga.f(SVector(size(ga)[1:2]))
    # (min_x=min(ax, bx), min_y=min(ay, by), max_x=max(ax, bx), max_y=max(ay, by))
    b = bbox(min(ax, bx), min(ay, by), max(ax, bx), max(ay, by))
    # to_vec ? (xmin = b.xmin, ymin = b.ymin, xmax = b.xmax, ymax = b.ymax) : b
    to_vec ? bbox2vec(b) : b
end

function st_bbox(ncfile::String)
    lat = NetCDF.ncread(ncfile, "lat")
    lon = NetCDF.ncread(ncfile, "lon")
    st_bbox(lon, lat)    
end

"""Set geotransform of `AbstractGeoArray` by specifying a bounding box.
Note that this only can result in a non-rotated or skewed `AbstractGeoArray`."""
function st_bbox!(ga::AbstractGeoArray, b::bbox)
    ga.f = bbox2affine(size(ga)[1:2], b)
    ga
end


export bbox, bbox2vec, st_bbox, st_bbox!
