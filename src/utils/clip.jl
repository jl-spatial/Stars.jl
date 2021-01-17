function clip_bbox(ga::GeoArray, bbox::box)
    # info = gdalinfo(file)
    info = gdalinfo(ga)
    X, Y = info["coords"]
    I_x = findall((X .<= bbox.xmax) .& (X .>= bbox.xmin))
    I_y = findall((Y .<= bbox.ymax) .& (Y .>= bbox.ymin))

    A = @view(ga.A[I_x, I_y, :]);
    ga = GeoArray(A, bbox);
    ga
end

export clip_bbox
