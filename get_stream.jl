using GeoArrays

# @time r = GeoArrays.read("merit90_china_accu.tif")
# @time r.A[skipmissing()] .= missing;
# ind = findall(r.A .< 1000);
# Array{Union{Missing, Int32},3}
function replace_low!(A::Array{Int32,3}, trs::Int32; nodata = missing)
    inds = CartesianIndices(A)
    n = length(inds)
    @inbounds for ind = inds
        if !ismissing(A[ind]) && (A[ind] < trs)
            A[ind] = nodata;
        end
    end
end

function mapvalues(A::AbstractArray{T,2}, levs_old, levs_new) where T <: Real
    A2 = deepcopy(A);
    inds = CartesianIndices(A)
    n = length(inds)
    nlev = length(levs_old)
    @inbounds for ind = inds
        if !ismissing(A[ind]) 
            for i in 1:nlev
                if A[ind] == levs_old[i]
                    A2[ind] = levs_new[i]
                    break
                end
            end
        end
    end
    A2
end

# change ArcGIS direction into taudem direction
function flowdir_gis2tau(A::AbstractArray{T,2}) where T <: Real
    dir_gis = Int32.([1, 2, 4, 8, 16, 32, 64, 128]);
    dir_taudem = Int32.([1, 8, 7, 6, 5, 4, 3, 2]);
    mapvalues(A, dir_gis, dir_taudem)
end

# @time replace_low(r.A, Int32(1000))
# r.A
# @time GeoArrays.writeRaster(r, "merit_stream_1k.tif")

## convert flowdir
# import GDAL
# import ArchGDAL; const AG = ArchGDAL
@time A = readGDAL("O:/水文数据/MERIT_hydro/OUTPUT/flowdir", 1)
@time flowdir = flowdir_gis2tau(A)

flowdir === A
bbox = box(70, 15, 140, 55)
# ga = GeoArray(r, bbox)
@time writeRaster(flowdir, bbox, "merit90_china_flowdir_taudem.tif")
@time writeRaster(A, bbox, "merit90_china_flowdir_arcgis.tif")

@time demfill = readGDAL("O:/水文数据/MERIT_hydro/OUTPUT/demfill2", 1)
@time writeRaster(demfill, bbox, "merit90_china_demfill.tif"; nodata = Int16(-32768))

## fix projection
fn = "I:/taudem/data-dem/merit90_china/merit90_china_flowdir_taudem2.tif"
@time r = GeoArrays.read(fn)
@time writeRaster(r, fn)

# using ArchGDAL
# dataset = ArchGDAL.unsafe_read(fn)
# wkt = ArchGDAL.getproj(dataset)

@time r = GeoArrays.read("I:/taudem/data-dem/strm90_china/strm90_china_flowaccu.tif")
@time writeRaster(r, "I:/taudem/data-dem/strm90_china/strm90_china_flowaccu2.tif") # , nodata = 0




fn  = "I:/taudem/data-dem/merit90_china/merit90_china_flowaccu.tif"
# fn2 = "I:/taudem/data-dem/merit90_china/merit90_china_flowaccu2.tif"
@time r = GeoArrays.read(fn)
r.A
# @time writeRaster(r, fn2)
@time replace_low!(r.A, Int32(100); nodata = 0)
@time writeRaster(r, "I:/taudem/data-dem/merit90_china/merit90_china_flowaccu_1h.tif", nodata = 0)

## get stream
# isfile(fn)
# epsg!(r, 4326);
run(`ls`)


