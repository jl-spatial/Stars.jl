# ENV["SHAPE_ENCODING"] = "UTF-8"
function writeORG(table, fn::AbstractString; layer_name::AbstractString="data", 
    geom_column::Symbol=:geom, crs::GFT.GeoFormat=GFT.EPSG(4326), driver::Union{Nothing,AbstractString}=nothing)
    
    rows = Tables.rows(table)
    sch = Tables.schema(rows)

    # Geom type can't be inferred from here
    geom_type = AG.getgeomtype(rows[1][geom_column])

    # Find driver
    _, extension = splitext(fn)
    if extension in keys(drivermapping)
        driver = AG.getdriver(drivermapping[extension])
    elseif driver !== nothing
        driver = AG.getdriver(driver)
    else
        error("Couldn't determine driver for $extension. Please provide one of $(keys(drivermapping))")
    end

    # Figure out attributes
    fields = Vector{Tuple{Symbol,DataType}}()
    for (name, type) in zip(sch.names, sch.types)
        if type != AG.IGeometry && name != geom_column
            push!(fields, (Symbol(name), type))
        end
    end

    options = ["ENCODING=UTF-8", "SHAPE_ENCODING=UTF-8"];
    AG.create(
        fn,
        driver=driver,
        options=options
    ) do ds
        AG.createlayer(
            name=layer_name,
            geom=geom_type,
            spatialref=AG.importCRS(crs), 
            options=options
        ) do layer
            for (name, type) in fields
                AG.addfielddefn!(layer, String(name), fieldmapping[type])
            end
            for row in rows
                AG.createfeature(layer) do feature
                    AG.setgeom!(feature, getproperty(row, geom_column))
                    for (name, type) in fields
                        AG.setfield!(feature, AG.findfieldindex(feature, name), getproperty(row, name))
                    end
                end
            end
            AG.copy(layer, dataset=ds, name=layer_name, options=options)
        end
    end
    fn
end

export writeORG
