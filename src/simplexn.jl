Lar = LinearAlgebraicRepresentation

"""
	simplex(n::Int, fullmodel=false::Bool)::Union{Lar.LAR, Lar.LARmodel}

Return a `LAR` model of the *`n`-dimensional simplex* in *`n`-space*.

When `fullmodel==true` return a `LARmodel`, including the faces, from dimension `1` to `n`.

# Example
```
using LinearAlgebraicRepresentation, Plasm, LinearAlgebra
Lar = LinearAlgebraicRepresentation

model = Lar.simplex(2)
Plasm.view( Lar.simplex(2) )

V, cells = Lar.simplex(3, true)
Plasm.view(Plasm.numbering(0.5)( (V,cells[1:end-1]) ))
```
"""
function simplex(n::Int, fullmodel=false)
	eye(n) = LinearAlgebra.Matrix{Int}(I,n,n)
	V = [zeros(n,1) eye(n)]
	CV = [collect(1:n+1)]
	if fullmodel == false
		return V,CV
	else
		h = n
		cells = [CV]
		while h != 0
			push!(cells, simplexFacets(cells[end]))
			h -= 1
		end
		return V,reverse(cells)
	end
end


@inline function createCellGroups(outcells, pattern)
    cellGroups = []
    for i in 1:size(outcells, 2)
        if pattern[i]>0
            cellGroups = vcat(cellGroups, outcells[:, i])
        end
    end
    return convert(Vector{Vector{Int}}, cellGroups)
end

@inline function createOutCells(FV, pattern, V)
    d, m = length(FV[1]), length(pattern)
    offset, outcells, rangelimit, i = length(V), [], d*m, 0

    for cell in FV
        i += 1
        tube = [v+k*offset for k in range(0, length=m+1) for v in cell]
        cellTube = [tube[k:k+d] for k in range(1, length=rangelimit)]
        if i==1 outcells = reshape(cellTube, d, m)
        else outcells = vcat(outcells, reshape(cellTube, d, m)) end
    end
    return outcells
end

"""
	extrudeSimplicial(model::LAR, pattern::Array)::LAR

Algorithm for multimensional extrusion of a simplicial complex.
Can be applied to 0-, 1-, 2-, ... simplicial models, to get a 1-, 2-, 3-, .... model.
The pattern `Array` is used to specify how to decompose the added dimension.

A `model` is a LAR model, i.e. a pair (vertices,cells) to be extruded, whereas pattern is an array of `Int64`, to be used as lateral measures of the *extruded* model. `pattern` elements are assumed as either *solid* or *empty* measures, according to their (+/-) sign.

# Example
```julia
julia> V = [[0,0] [1,0] [2,0] [0,1] [1,1] [2,1] [0,2] [1,2] [2,2]];

julia> FV = [[1,2,4],[2,3,5],[3,5,6],[4,5,7],[5,7,8],[6,8,9]];

julia> pattern = repeat([1,2,-3],outer=4);

julia> model = (V,FV);

julia> W,FW = extrudeSimplicial(model, pattern);

julia> Plasm.view(W,FW)
```
"""
@inline function extrudeSimplicial(model::Union{Any,Lar.Cells,Lar.LAR}, pattern)
    if (model isa Lar.LAR)
        V = [model[1][:,k] for k=1:size(model[1],2)]
        FV = model[2]
    else
        V,FV = model
    end

    coords = collect(cumsum(append!([0], abs.(pattern))))
    
    outcells = createOutCells(FV, pattern, V)
    cellGroups = createCellGroups(outcells, pattern)

    outVertices = [[v; [z]] for z in coords for v in V]
    hcat(outVertices...), cellGroups
end



"""
	simplexGrid(shape::Array)::LAR

Generate a simplicial complex decomposition of a cubical grid of ``d``-cuboids, where ``d`` is the length of `shape` array. Vertices (0-cells) of the grid have `Int64` coordinates.

# Examples
```julia
julia> simplexGrid([0]) # 0-dimensional complex
# output
([0], Array{Int64,1}[])

julia> V,EV = simplexGrid([1]) # 1-dimensional complex
# output
([0 1], Array{Int64,1}[[1, 2]])

julia> V,FV = simplexGrid([1,1]) # 2-dimensional complex
# output
([0 1 0 1; 0 0 1 1], Array{Int64,1}[[1, 2, 3], [2, 3, 4]])

julia> V,CV = simplexGrid([10,10,1]) # 3-dimensional complex
# output
([0 1 … 9 10; 0 0 … 10 10; 0 0 … 1 1], Array{Int64,1}[[1, 2, 12, 122], [2, 12, 122, 123], [12, 122, 123, 133], [2, 12, 13, 123], [12, 13, 123, 133], [13, 123, 133, 134], [2, 3, 13, 123], [3, 13, 123, 124], [13, 123, 124, 134], [3, 13, 14, 124]  …  [119, 229, 230, 240], [109, 119, 120, 230], [119, 120, 230, 240], [120, 230, 240, 241], [109, 110, 120, 230], [110, 120, 230, 231], [120, 230, 231, 241], [110, 120, 121, 231], [120, 121, 231, 241], [121, 231, 241, 242]])

julia> V
# output
3×242 Array{Int64,2}:
 0  1  2  3  4  5  6  7  8  9  10  0  1  2  3  …   1   2   3   4   5   6   7   8   9  10
 0  0  0  0  0  0  0  0  0  0   0  1  1  1  1     10  10  10  10  10  10  10  10  10  10
 0  0  0  0  0  0  0  0  0  0   0  0  0  0  0      1   1   1   1   1   1   1   1   1   1

julia> using Plasm

julia> hpc = Plasm.lar2exploded_hpc(V,CV) # exploded visualization of the grid

julia> Plasm.view(hpc)

julia> V,HV = simplexGrid([1,1,1,1]) # 4-dim cellular complex from the 4D simplex
# output
([0 1 … 0 1; 0 0 … 1 1; 0 0 … 1 1; 0 0 … 1 1], Array{Int64,1}[[1, 2, 3, 5, 9], [2, 3, 5, 9, 10], [3, 5, 9, 10, 11], [5, 9, 10, 11, 13], [2, 3, 5, 6, 10], [3, 5, 6, 10, 11], [5, 6, 10, 11, 13], [6, 10, 11, 13, 14], [3, 5, 6, 7, 11], [5, 6, 7, 11, 13]  …  [4, 6, 10, 11, 12], [6, 10, 11, 12, 14], [3, 4, 6, 7, 11], [4, 6, 7, 11, 12], [6, 7, 11, 12, 14], [7, 11, 12, 14, 15], [4, 6, 7, 8, 12], [6, 7, 8, 12, 14], [7, 8, 12, 14, 15], [8, 12, 14, 15, 16]])
```
"""
function simplexGrid(shape)
    model = [[]], [[1]]
    @inbounds @simd for item in shape
        model = extrudeSimplicial(model, fill(1, item))
    end
    V, CV = model
    V = convert(Matrix{Float64}, V)
    return V, CV
end





"""
	simplexFacets(simplices::Cells)::Cells

Compute the `(d-1)`-skeleton (unoriented set of `facets`) of a simplicial `d`-complex.

# Example
```julia
julia> V,FV = Lar.simplexGrid([1,1]) # 2-dimensional complex
# output
([0 1 0 1; 0 0 1 1], Array{Int64,1}[[1, 2, 3], [2, 3, 4]])

julia> Plasm.view(V,FV)

julia> W,CW = Lar.extrudeSimplicial((V,FV), [1])
([0.0 1.0 … 0.0 1.0; 0.0 0.0 … 1.0 1.0; 0.0 0.0 … 1.0 1.0],
Array{Int64,1}[[1,2,3,5],[2,3,5,6],[3,5,6,7],[2,3,4,6],[3,4,6,7],[4,6,7,8]])

julia> FW = Lar.simplexFacets(CW)
18-element Array{Any,1}:
[[1,3,5],[5,6,7],[3,5,7],[3,6,7],[4,6,7],[4,7,8],[4,6,8],
[6,7,8],[3,5,6],[2,3,5],[2,3,4],[3,4,7],[1,2,3],[2,4,6],[2,5,6],
[1,2,5],[2,3,6],[3,4,6]]

julia> Plasm.view(W,FW)
```

# Example

```julia
julia> V,(VV,EV,FV,CV) = Lar.cuboidGrid([3,3,3],true)

julia> TV = Lar.simplexFacets(CV)

julia> Plasm.view(V,TV)

```
"""
@inline function simplexFacets(simplices)
	out = Vector{Int64}[]
	@inbounds for simplex in simplices
		@inbounds @simd for v in simplex
			facet = setdiff(simplex,v)
			push!(out, facet)
		end
	end
	# remove duplicate facets
	return sort(collect(Set(out)))
end