push!(LOAD_PATH,"../src/")
using Documenter, Stars

makedocs(sitename="Stars.jl")

deploydocs(
    repo = "github.com/jl-spatial/Stars.jl.git",
)
