"""
	characteristicMatrix( FV::Cells )::ChainOp

Binary matrix representing by rows the `p`-cells of a cellular complex.
The input parameter must be of `Cells` type. Return a sparse binary matrix,
providing the basis of a ``Chain`` space of given dimension. Notice that the
number of columns is equal to the number of vertices (0-cells).

# Example

```julia
julia> V,(VV,EV,FV,CV) = Lar.cuboid([1.,1.,1.], true);

julia> Matrix(Lar.characteristicMatrix(FV))

julia> Matrix(Lar.characteristicMatrix(CV))

julia> Matrix(Lar.characteristicMatrix(EV))
```
"""
function characteristicMatrix( FV::Cells )::ChainOp
	I,J,V = Int64[],Int64[],Int8[]
	for f=1:length(FV)
		for k in FV[f]
		push!(I,f)
		push!(J,k)
		push!(V,1)
		end
	end
	M_2 = sparse(I,J,V)
	return M_2
end
