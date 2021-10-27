push!(LOAD_PATH,"../src/")
using Documenter, Stars


## References:
# https://github.com/Alexander-Barth/NCDatasets.jl/blob/master/docs/make.jl

CI = get(ENV, "CI", nothing) == "true"
makedocs(
    sitename="Stars.jl", 
    format = Documenter.HTML(prettyurls = CI,),
    pages = [
        "Introduction"   => "Index.md",
        "Variables"      => "Variables.md",
        "IO" => "IO.md",
    ],
)

deploydocs(
    repo = "github.com/jl-spatial/Stars.jl.git",
)
