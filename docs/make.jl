using XLNet
using Documenter

DocMeta.setdocmeta!(XLNet, :DocTestSetup, :(using XLNet); recursive=true)

makedocs(;
    modules=[XLNet],
    authors="Sambhaw Kumar, <vampiresambhaw@gmail.com>",
    repo="https://github.com/SambhawDrag/XLNet.jl/blob/{commit}{path}#{line}",
    sitename="XLNet.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://SambhawDrag.github.io/XLNet.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/SambhawDrag/XLNet.jl",
)
