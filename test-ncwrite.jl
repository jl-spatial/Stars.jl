# This example demonstrates the use of the high-level Matlab-like interface
#
# First of all we create an array with top-of the atmosphere radiation data

using NetCDF

include("toa.jl")

# Define longitudes and latitudes, day and timesteps
lat = collect(-89:89)
lon = collect(0:359)
day = 1
tim = collect(0:23)

# Create radiation array
rad = Float64[g_pot(x2, x1, day, x3) for x1 in lon, x2 in lat, x3 in tim]

# Define some attributes of the variable (optionlal)
varatts = Dict("longname" => "Radiation at the top of the atmosphere", "units" => "W/m^2")
lonatts = Dict("longname" => "Longitude", "units" => "degrees east")
latatts = Dict("longname" => "Latitude", "units" => "degrees north")
timatts = Dict("longname" => "Time", "units" => "hours since 01-01-2000 00:00:00")

isfile("radiation.nc") && rm("radiation.nc")
nccreate(
    "radiation.nc",
    "HI",
    "lon", lon, lonatts,
    "lat", lat, latatts,
    "time", tim, timatts,
    atts = varatts,
)
ncwrite(rad, "radiation.nc", "rad")

ds["lon"]
