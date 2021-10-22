function read(fn::AbstractString, bands = nothing)
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

    wkt = ArchGDAL.getproj(dataset)
    ArchGDAL.destroy(dataset)
    GeoArray(A, am, wkt)
end

"""
- rast(fn::AbstractString, bands = nothing): construct `GeoArray` object from file
- rast(ga::GeoArray; vals::AbstractArray{T}): Reconstruct `GeoArray` object
"""
rast(fn::AbstractString, bands = nothing) = read(fn, bands)
function rast(ga::GeoArray; vals::AbstractArray{T}) where T<: Real
    GeoArray(vals, ga.f, ga.crs)
end


"""
    st_read(file::String, options...)
    st_read(files::Array{String,1}, options)

# Arguments:
- `options`: other parameters to `ArchGDAL.read(dataset, options...)`.
"""
function st_read(file::String, options...)
    ArchGDAL.read(file) do dataset
        ArchGDAL.read(dataset, options...)
    end
end

# read multiple tiff files and cbind
function st_read(files::Array{String,1}, options)
    # bands = collect(bands)
    # bands = collect(Int32, bands)
    res = map(file -> st_read(file, options...), files)
    vcat(res...)
end


export st_read, rast
