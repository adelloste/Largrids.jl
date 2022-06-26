push!(LOAD_PATH,"../src/")

using Documenter, Largrids
Lar = Largrids

makedocs(
	sitename = "Largrids.jl",
	format = Documenter.HTML(),
	assets = ["assets/lar.css", "assets/logo.png"],
	pages = [
		"Home" => "index.md",
		"L.A.R. Intro" => "lar.md",
		"Dependency graph" => [
			"Original dependency graph" => "dependency-graph-original.md",
			"Modified dependency graph" => "dependency-graph-modified.md"
		],
		"Reports" => [
			"Preliminary study" => "report-1.md",
			"Executive study" => "report-2.md",
			"Final study" => "report-3.md"
		],
		"Grid generation" => [
			"Cuboidal grids" => "largrid.md",
			"Simplicial grids" => "simplexn.md"
		]
	]
)


deploydocs(
	repo = "github.com/adelloste/Largrids.jl.git"
)