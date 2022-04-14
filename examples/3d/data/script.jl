using LinearAlgebraicRepresentation
using Plasm, LinearAlgebra
Lar = LinearAlgebraicRepresentation
using SparseArrays

# shell> cd ~/Documents/dev/LinearAlgebraicRepresentation.jl
# /Users/paoluzzi/Documents/dev/LinearAlgebraicRepresentation.jl

include("./examples/3d/data/LARinput.jl")

# s = Lar.Struct(store)
# V,CV,FV,EV = Lar.struct2lar(s)
# V = Plasm.normalize3D(V) TODO:  solve MethodError bug
# Plasm.view(V,CV)

cop_EV = Lar.coboundary_0(EV::Lar.Cells);
cop_EW = convert(Lar.ChainOp, cop_EV);
cop_FE = Lar.coboundary_1(V, FV::Lar.Cells, EV::Lar.Cells);
W = convert(Lar.Points, V');

V, copEV, copFE, copCF = Lar.space_arrangement(
	W::Lar.Points, cop_EW::Lar.ChainOp, cop_FE::Lar.ChainOp)

cc = [copEV, copFE, copCF]
output = Lar.lar2obj(V::Lar.Points, cc::Lar.ChainComplex)

f = open("./test/out3d.obj", "w")
print(f, output)
close(f)

V,EVs,FVs = Lar.obj2lar("./test/out3d.obj")

Plasm.view(V, FVs[1])


for k=1:length(FVs)
	Plasm.view(V, FVs[k])
end
