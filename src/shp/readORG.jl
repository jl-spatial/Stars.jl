import GeoInterface

const drivers = AG.listdrivers()
const drivermapping = Dict(
    ".shp" => "ESRI Shapefile",
    ".gpkg" => "GPKG",
    ".geojson" => "GeoJSON",
)
const fieldmapping = Dict(v => k for (k, v) in AG._FIELDTYPE)

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
