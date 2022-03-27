# This script is modified from: 
#   `https://github.com/evetion/GeoArrays.jl/blob/master/src/io.jl`
# Copyright (c) 2018 Maarten Pronk, MIT license

function write!(fn::AbstractString, ga::GeoArray, nodata = nothing, shortname = find_shortname(fn))

    options = String[]
    w, h, b = size(ga)
    dtype = eltype(ga)
    data = copy(ga.A)
    use_nodata = false

    # Set compression options for GeoTIFFs
    shortname == "GTiff" && (options = ["COMPRESS=DEFLATE","TILED=YES", "NUM_THREADS=4"]) # NUM_THREADS=4, BIGTIFF=YES

    # Slice data and replace missing by nodata
    if isa(dtype, Union) && dtype.a == Missing
        dtype = dtype.b
        try convert(ArchGDAL.GDALDataType, dtype)
            nothing
        catch
            dtype, data = cast_to_gdal(data)
        end
        nodata === nothing && (nodata = typemax(dtype))
        m = ismissing.(data)
        data[m] .= nodata
        data = Array{dtype}(data)
        use_nodata = true
    end

    try convert(ArchGDAL.GDALDataType, dtype)
        nothing
    catch
        dtype, data = cast_to_gdal(data)
    end

    ArchGDAL.create(fn, driver=ArchGDAL.getdriver(shortname), width=w, height=h, nbands=b, dtype=dtype, options=options) do dataset
        for i = 1:b
            band = ArchGDAL.getband(dataset, i)
            ArchGDAL.write!(band, data[:,:,i])
            use_nodata && ArchGDAL.GDAL.gdalsetrasternodatavalue(band.ptr, nodata)
        end

        # Set geotransform and crs
        gt = affine_to_geotransform(ga.f)
        ArchGDAL.GDAL.gdalsetgeotransform(dataset.ptr, gt)
        ArchGDAL.GDAL.gdalsetprojection(dataset.ptr, GFT.val(ga.crs))

    end
    fn
end

"""
    st_write(ga::GeoArray, fn::AbstractString; nodata = nothing)
    st_write(A::AbstractArray{T}, b::bbox, fn::AbstractString;nodata = nothing)


# Arguments
- `A`: 2d or 3d array
- `fn`: outfile path
- `nodata`: should be in the same data type as ga.A (or A)
"""
st_write(ga::GeoArray, fn::AbstractString; nodata = nothing) = write!(fn, ga, nodata)

function st_write(A::AbstractArray{T}, b::bbox, fn::AbstractString; nodata = nothing) where T <: Real
    ga = GeoArray(A, b)
    st_write(ga, fn; nodata = nodata)
end


export st_write
