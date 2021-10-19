"""
Boundary bbox

- st_bbox(xmin, ymin, xmax, ymax)
- st_bbox(lon, lat)    
- st_bbox(ga::GeoArray)    
- st_bbox!(ga::GeoArray, b::bbox) : reset bbox
- st_bbox(ncfile::String)  
"""

function st_bbox(lon, lat)
    cellsize_x = abs(lon[2] - lon[1])
    cellsize_y = abs(lat[2] - lat[1])
    bbox(minimum(lon) - cellsize_x/2, minimum(lat) - cellsize_y/2, 
        maximum(lon) + cellsize_x/2, maximum(lat) + cellsize_y/2)
end

function st_bbox(ga::GeoArray)
    ax, ay = ga.f(SVector(0,0))
    bx, by = ga.f(SVector(size(ga)[1:2]))
    # (min_x=min(ax, bx), min_y=min(ay, by), max_x=max(ax, bx), max_y=max(ay, by))
    bbox(min(ax, bx), min(ay, by), max(ax, bx), max(ay, by))
end

function st_bbox(ncfile::String)
    lat = NetCDF.ncread(ncfile, "lat")
    lon = NetCDF.ncread(ncfile, "lon")
    st_bbox(lon, lat)    
end

function bbox_to_affine(size::Tuple{Integer, Integer}, b::bbox)
    AffineMap(
        SMatrix{2,2}((b.xmax - b.xmin) / size[1], 0, 0, -(b.ymax - b.ymin)/size[2]),
        SVector(b.xmin, b.ymax)
        )
end

"""Set geotransform of `GeoArray` by specifying a bounding box.
Note that this only can result in a non-rotated or skewed `GeoArray`."""
function st_bbox!(ga::GeoArray, b::bbox)
    ga.f = bbox_to_affine(size(ga)[1:2], b)
    ga
end


export bbox, st_bbox, st_bbox!
