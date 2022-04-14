module Arrangement
    using LinearAlgebraicRepresentation
    using IntervalTrees
    using NearestNeighbors
   #using Triangle
    using Triangulate
	using SparseArrays
	using LinearAlgebra    
	using Distributed    
	Lar = LinearAlgebraicRepresentation

    include("./minimal_cycles.jl")
    include("./dimension_travel.jl")
    include("./planar_arrangement.jl")
    include("./spatial_arrangement.jl")

    export planar_arrangement, spatial_arrangement

end