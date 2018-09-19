module BaseGrid

# @pyimport scipy.spatial as spatial
# py  = spatial.ConvexHull(x)
# tri = convert(Array{Int64,2},py["simplices"])+1


__precompile__()


import Base.show

include("gridreader.jl")
include("topology.jl")
# include("tensorgrid.jl")
include("modifier.jl")
include("outvtk.jl")
include("outascii.jl")

export grid_to_dict
export AbstractGrid,Grid,DictGrid
export grid1D,grid2D,grid3D,grid2D_avs


# data and functions

abstract type AbstractGrid end


"""
**Summary:**
```
struct Grid{TopoType<:AbstractTopology} <: AbstractGrid
```

**Fields:**
```
geometry :: Geometry{Float64}
topology :: TopoType
```

**Description:**

Container for `geometry` and `topology`, where topology enters as parameter
for Grid type.
"""
struct Grid{N,TopoType<:AbstractTopology} <: AbstractGrid

	geometry :: Geometry{N}
	topology :: TopoType

end

# # something like this should be more general
# struct DictGrid{N} <: AbstractGrid
#
#   	geometry ::  Geometry{N}
#   	topology ::  Dict{String,AbstractTopology}
# 
# end

#
# I think I can detect the dimension without needing 3 functions
#
"Reads mesh file and constructs 1D topology mesh."
function grid1D(fname::String)

	xyz,vert,pattr,ele,eattr,nd = readgrid(fname)
	vertices = VertexTopology(vert,pattr)
	geometry = Geometry{nd}(xyz,vertices)
	topology = IntervalTopology(ele,eattr)
	Grid{nd,IntervalTopology}(geometry,topology)

end

"Reads mesh file and constructs 2D topology mesh."
function grid2D(fname::String)

	xyz,vert,pattr,ele,eattr,nd = readgrid(fname)
	vertices = VertexTopology(vert,pattr)
	geometry = Geometry{nd}(xyz,vertices)
	topology = TriangleTopology(ele,eattr)
	Grid{nd,TriangleTopology}(geometry,topology)

end

"Reads mesh file and constructs 2D topology mesh."
function grid2D_avs(fname::String)

	xyz,vert,pattr,ele,eattr,nd = readgrid_avs(fname)
	vertices = VertexTopology(vert,pattr)
	geometry = Geometry{nd}(xyz,vertices)
	topology = TriangleTopology(ele,eattr)
	Grid{nd,TriangleTopology}(geometry,topology)

end

"Reads mesh file and constructs 3D topology mesh."
function grid3D(fname::String)

	xyz,vert,pattr,ele,eattr,nd = readgrid(fname)
	vertices = VertexTopology(vert,pattr)
	geometry = Geometry{nd}(xyz,vertices)
	topology = TetrahedronTopology(ele,eattr)
	Grid{nd,TetrahedronTopology}(geometry,topology)

end

"Generates terminal output for `AbstractTopology`"
function show(io::IO, t::AbstractTopology)

	ne = nelement(t) # number of vertices
	nt = dim(t)      # topology dimension

	if nt<4
		se = Dict(0=>"vertices",1=>"intervals",2=>"triangles",3=>"tetrahedrons")[nt]
	else
		se = "elements("*string(nt)*")"
	end

	# output
	println(io, "$(nt)D topology: $(ne) $(se).")
end

"Generates terminal output for `Geometry`"
function show(io::IO, g::Geometry)

	nv = nvertices(g) # number of vertices
	nd = dim(g)       # spatial dimension

	# output
	println(io, "$(nd)D geometry: $(nv) vertices.")
end

"Generates terminal output for `AbstractGrid`"
function show(io::IO, g::AbstractGrid)

	# access data from AbstractGrid
	nv = nvertices(g.geometry) # number of vertices
	ne = nelement(g.topology)  # number of elements
	nt = dim(g.topology)       # topological dimension
	nd = dim(g.geometry)       # spatial dimension

	# convert topological dimension into the corresponding word, which is
	# true as long as we deal with simplex meshes. otherwise this needs to
	# be more elaborate.
	if nt<4
		se = Dict(0=>"vertices",1=>"intervals",2=>"triangles",3=>"tetrahedrons")[nt]
	else
		se = "elements("*string(nt)*")"
	end

	# output
	println(io, "$(nd)D grid: $(nv) vertices, $(ne) $(se).")
end

end # module
