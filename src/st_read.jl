# This script is modified from: 
#   `https://github.com/evetion/GeoArrays.jl/blob/master/src/io.jl`
# Copyright (c) 2018 Maarten Pronk, MIT license

"""
    st_read(fn::AbstractString, bands = nothing)

# Return
A AbstractGeoArray object
"""
function st_read(fn::AbstractString, bands = nothing)
    isfile(fn) || error("File not found.")
    dataset = ArchGDAL.unsafe_read(fn)

    if bands === nothing
        nbands = ArchGDAL.nraster(dataset)
        bands = 1:nbands
    end
    A = ArchGDAL.read(dataset, bands)
    am = get_affine_map(dataset)

    # nodata masking
    # A = Array{Union{Missing, eltype(A)}}(A)
    mask = falses(size(A))
    
    for i = bands
        band = ArchGDAL.getband(dataset, i)
        maskflags = mask_flags(band)

        # All values are valid, skip masking
        if :GMF_ALL_VALID in maskflags
            @debug "No masking"
            continue
        # Mask is valid for all bands
        elseif :GMF_PER_DATASET in maskflags
            @debug "Mask for each band"
            maskband = ArchGDAL.getmaskband(band)
            m = ArchGDAL.read(maskband) .== 0
            mask[:,:,i] = m
        # Alpha layer
        elseif :GMF_ALPHA in maskflags
            @warn "Dataset has band $i with an Alpha band, which is unsupported for now."
            continue
        # Nodata values
        elseif :GMF_NODATA in maskflags
            @debug "Flag NODATA"
            nodata = get_nodata(band)
            mask[:, :, i] = A[:,:,i] .== nodata
        else
            @warn "Unknown/unsupported mask."
        end
    end

    if any(mask)
        A = Array{Union{Missing,eltype(A)}}(A)
        A[mask] .= missing
    end

    wkt = ArchGDAL.getproj(dataset) |> crs2wkt
    ArchGDAL.destroy(dataset)
    names = bandnames(fn)
    # @show names
    GeoArray(A, am, wkt, names)
end


"""
    readGDAL(file::String, options...)
    readGDAL(files::Array{String,1}, options)

# Arguments:
- `options`: other parameters to `ArchGDAL.read(dataset, options...)`.

# Return
"""
function readGDAL(file::AbstractString, options...)
    ArchGDAL.read(file) do dataset
        ArchGDAL.read(dataset, options...)
    end
end

# read multiple tiff files and cbind
function readGDAL(files::Vector{<:AbstractString}, options...)
    # bands = collect(bands)
    # bands = collect(Int32, bands)
    res = map(file -> readGDAL(file, options...), files)
    res
    # vcat(res...)
end


const read = st_read
export st_read, readGDAL
