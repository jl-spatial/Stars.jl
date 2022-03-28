
"""
Terra Object

- `class`      : 
- `dimensions` : 
- `resolution` : 
- `extent`     : 
- `coord.ref.` : 
- `source`     : 
- `names`      : `[bandnames]`
"""

# https://stackoverflow.com/questions/32609570/how-to-set-the-band-description-option-tag-of-a-geotiff-file-using-gdal-gdalw

gdal_close(ds::Ptr{Nothing}) = GDAL.gdalclose(ds)

# gdal_open(file::AbstractString) = ArchGDAL.read(file)
function gdal_open(f::AbstractString, mode = GDAL.GA_ReadOnly, args...)
  GDAL.gdalopen(f, GDAL.GA_ReadOnly, args...)
end

function gdal_open(func::Function, args...; kwargs...)
  ds = gdal_open(args...; kwargs...)
  try
    func(ds)
  finally
    gdal_close(ds)
  end
end

function nband(f)
  gdal_open(f) do ds
    GDAL.gdalgetrastercount(ds)
  end
end
# function nband(file::AbstractString)
#     # ArchGDAL.unsafe_read(file) do ds
#     ArchGDAL.read(file) do ds
#         ArchGDAL.nraster(ds)
#     end
# end
nratser = nband
nlyr = nband

function bandnames(f)
  n = nband(f)
  gdal_open(f) do ds
    
    map(iband -> begin
      band = GDAL.gdalgetrasterband(ds, iband)
      GDAL.gdalgetdescription(band)
    end, 1:n)
  end
end



function gdalinfo(file::AbstractString) 
    ds = ArchGDAL.read(file)
    gt = ArchGDAL.getgeotransform(ds)
    # band = ArchGDAL.getband(ds, 1)
    w, h = ArchGDAL.width(ds), ArchGDAL.height(ds)
    dx, dy = gt[2], -gt[end]
    x0 = gt[1] #+ dx/2
    x1 = x0 + w* dx
    y1 = gt[4] #- dy/2
    y0 = y1 - h*dy
    b = bbox(x0, y0, x1, y1)
    
    lon = x0 + dx/2 : dx: x1
    lat = reverse(y0 + dy/2 : dy: y1)
    nband = ArchGDAL.nraster(ds)
    
    Dict(
        # "file"     => basename(file),
        "bbox"     => b, 
        "cellsize" => [dx, dy], 
        "coords"   => [lon, lat],
        "dim"      => (Int64.([w, h, nband])..., ) # convert to tuple
    )
end

"""
    gdalinfo(ga::GeoArray)
    gdalinfo(file::AbstractString) 
    
get detailed GDAL information

## return
- `range`    : [lon_min, lon_max, lat_min, lat_max]
- `cellsize` : [dx, dy]
- `coords`   : [lon, lat]
- `dim`      : (width, height, ntime)
"""
function gdalinfo(ga::GeoArray)
    # mid = [1, 1];
    # if length(mid) == 1; mid = [mid, mid]; end
    dx = ga.f.linear[1]
    dy = abs(ga.f.linear[4])
    dy2 = ga.f.linear[4]
    
    mid = [1, 1] # default mid is true
    delta = [dx, dy]/2 .* mid
    
    b = st_bbox(ga)
    lon = b.xmin + delta[1]:dx:b.xmax
    lat = b.ymin + delta[2]:dy:b.ymax
    if dy2 < 0; lat = reverse(lat); end

    Dict(
        "bbox"     => b, 
        "cellsize" => [dx, dy], 
        "coords"   => [lon, lat],
        "dim"      => size(ga.A))
end

export gdal_open, gdal_close, nband, bandnames
export gdalinfo
