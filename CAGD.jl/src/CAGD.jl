module CAGD
	using DataStructures
	using IntervalTrees
	using LinearAlgebra
	using LinearAlgebraicRepresentation
	using NearestNeighbors
	using SparseArrays

	Lar = LinearAlgebraicRepresentation

	include("./model.jl")
	
	include("./planar_arrangement.jl")
	include("./spatial_arrangement.jl")
	include("./spatial_indices.jl")

#	include("./input.jl")
	include("./splitting.jl")
	include("./congruence.jl")
	include("./tgw2.jl")
	include("./tgw3.jl")
	include("./loops.jl")
	include("./utils.jl")
#	include("./output.jl")
	include("./bool.jl")

	include("lar_interface.jl")

	export chaincongruence
end
