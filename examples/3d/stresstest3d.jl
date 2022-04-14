# test data generation

using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation
using IntervalTrees,SparseArrays,NearestNeighbors
using ViewerGL
GL = ViewerGL

function input_collection(data::Array)::Lar.LAR
	assembly = Lar.Struct(data)
	return Lar.struct2lar(assembly)
end


V,FV = Lar.sphere(2)([9,12])
#V,FV = Lar.sphere(2)([12,16])
EV = Lar.simplexFacets(FV)
#EV = Lar.quads2triangles(FV)
mysphere = V,FV,EV

data3d1 = mysphere
data3d2 = Lar.Struct([ Lar.t(0,1,0), mysphere ])
data3d3 = Lar.Struct([ Lar.t(0,0.5,0), Lar.s(0.4,0.4,0.4), mysphere ])
data3d4 = Lar.Struct([ Lar.t(4,0,0), Lar.s(0.8,0.8,0.8), mysphere ])
data3d5 = Lar.Struct([ Lar.t(4,0,0), Lar.s(0.4,0.4,0.4), mysphere ])

model3d = input_collection([ data3d5 ])#, data3d2, data3d3, data3d4, data3d5 ])
V,FV,EV = model3d
VV = [[k] for k in 1:size(V,2)];

GL.VIEW( GL.numbering(0.125)((V,[VV, EV, FV]),GL.COLORS[1],0.25) );

# copEV = Lar.coboundary_0(EV)
# copFE = Lar.coboundary_1(V,FV,EV)
# W = convert(Lar.Points, V')
