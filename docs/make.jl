push!(LOAD_PATH,"../src/")

using Documenter, LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation

makedocs(
	sitename = "LinearAlgebraicRepresentation.jl",
	format = Documenter.HTML(),
	modules = [LinearAlgebraicRepresentation]
	# assets = ["assets/lar.css", "assets/logo.png"],
	# pages = [
	# 	"Home" => "index.md",
	# 	"L.A.R. Intro" => "lar.md",
	# 	"Grid generation" => [
	# 		"Cuboidal grids" => "largrid.md",
	# 		"Simplicial grids" => "simplexn.md"
	# 	]
	# ]
)


deploydocs(
	repo = "github.com/adelloste/LinearAlgebraicRepresentation.jl.git"
)
