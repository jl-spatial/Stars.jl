push!(LOAD_PATH,"../src/")
using Documenter, Stars.jl

makedocs(sitename="Stars.jl")

deploydocs(
    repo = "github.com/geo-julia/Stars.jl.git",
)
