import GeoInterface

const drivers = AG.listdrivers()
const drivermapping = Dict(
    ".shp" => "ESRI Shapefile",
    ".gpkg" => "GPKG",
    ".geojson" => "GeoJSON",
)
# const fieldmapping = Dict(v => k for (k, v) in _FIELDTYPE)

# "return the corresponding `DataType` in julia"
# const _FIELDTYPE = Dict{AG.OGRFieldType, DataType}(
#     GDAL.OFTInteger         => Int32,
#     GDAL.OFTIntegerList     => Nothing,
#     GDAL.OFTReal            => Float64,
#     GDAL.OFTRealList        => Nothing,
#     GDAL.OFTString          => String,
#     GDAL.OFTStringList      => Nothing,
#     GDAL.OFTWideString      => Nothing, # deprecated
#     GDAL.OFTWideStringList  => Nothing, # deprecated
#     GDAL.OFTBinary          => Nothing,
#     GDAL.OFTDate            => Date,
#     GDAL.OFTTime            => Nothing,
#     GDAL.OFTDateTime        => DateTime,
#     GDAL.OFTInteger64       => Int64,
#     GDAL.OFTInteger64List   => Nothing)
# geomtypes = (IGeometry{ArchGDAL.gettype(ArchGDAL.getgeomdefn(featuredefn, i))} for i in 0:ngeom-1)
# field_types = (_FIELDTYPE[gettype(fielddefn)] for fielddefn in fielddefns)

# AG.createpoint(1.0, 2.0)
function get_coords(geom::ArchGDAL.IGeometry)
    GeoInterface.coordinates(geom)
end

function get_coords(geom::Array{ArchGDAL.IGeometry,1})
    GeoInterface.coordinates.(geom)
end

function get_coords(shp)
    coord = GeoInterface.coordinates.(shp[:geom])
    coord = hcat(coord...) |> transpose
    lon = coord[:, 1]
    lat = coord[:, 2]
    lon, lat
end

function readORG(fn::AbstractString, layer::Union{Integer,AbstractString}=0)
    ds = AG.read(fn)
    layer = AG.getlayer(ds, layer)
    table = AG.Table(layer)
    df = DataFrame(table)
    "" in names(df) && rename!(df, Dict(Symbol("") => :geom, ))  # needed for now
    lon, lat = get_coords(df)
    df.lon = lon
    df.lat = lat
    df
end

export readORG
export get_coords
