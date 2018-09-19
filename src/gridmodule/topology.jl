#
# file: topology.jl
#
# Definition of Geometry type and Topology types as the basis for compound
# grids in the module BaseGrid
#
#import Base.getindex,Base.setindex!,Base.start,Base.isempty,Base.length
#import Base.done,Base.next,Base.eltype,Base.endof
import Base.iterate,Base.eltype,Base.getindex,Base.setindex!
# ,Base.endof
import Base.length
export xyz,x,y,z,ele2vert
export AbstractTopology,Abstract0DTopology,Abstract1DTopology
export Abstract2DTopology, Abstract3DTopology
export VertexTopology,IntervalTopology,TriangleTopology,TetrahedronTopology

export Geometry,nvertices,dim,nelement
export isempty,length
export eltype,getindex,setindex!,iterate
export nid,ntop,iterate
# export endof

# mesh topology tree
# """
# **Description of abstract topology tree:**
#
# ```
# abstract AbstractTopology
# abstract Abstract0DTopology <: AbstractTopology
# abstract Abstract1DTopology <: AbstractTopology
# abstract Abstract2DTopology <: AbstractTopology
# abstract Abstract3DTopology <: AbstractTopology
# ```
#
# Abstract type tree, to store topological information of geometrical entities
# to build meshes
#
# * of vertices     (topological dimension 0),
# * of intervals    (topological dimension 1),
# * of triangles    (topological dimension 2),
# * of tetrahedrons (topological dimension 3),
#
# from which then concrete (final) data types are derived. The conrete types are
#
# * `VertexTopology      <: Abstract0DTopology`
# * `IntervalTopology    <: Abstract1DTopology`
# * `TriangleTopology    <: Abstract2DTopology`
# * `TetrahedronTopology <: Abstract3DTopology`
# """
abstract type AbstractTopology end
abstract type Abstract0DTopology <: AbstractTopology end
abstract type Abstract1DTopology <: AbstractTopology end
abstract type Abstract2DTopology <: AbstractTopology end
abstract type Abstract3DTopology <: AbstractTopology end
# comma syntax to allow all types to share the same documentation

# Further possible examples to think of (and to discuss):
# abstract AbstractPrismTopology <: AbstractTopology
# abstract AbstractQuadrilateralTopology <: AbstractTopology
# abstract AbstractAxisymmetricTriangleTopology <: AbstractTopology

# """
# **Summary:**
# ```
# struct VertexTopology      <: Abstract0DTopology
# struct IntervalTopology    <: Abstract1DTopology
# struct TriangleTopology    <: Abstract2DTopology
# struct TetrahedronTopology <: Abstract3DTopology
# ```
#
# **Fields:**
# ```
# elements   :: Array{Int64,2}
# attributes :: Array{Int64,2}
#
# ```
#
# **Description:**
#
# Stores the information (connectivity) for objects of a topological dimension *d*.
# This is done by defining the relation between objects of dimension *d* to objects
# of dimension *0*, i.e. the vertex numbers.
#
# `elements`: For each topology, the field `elements` carries the connectivity
#
# - `elements[k,1]`     = number of the element
# - `elements[k,2:end]` = topological definition of element (e.g. attached vertices)
# - `attributes[k,:]`   = attributes of element (material,boundary,...)
#
# The standard (flat) simplex geometries
#
# ```
# |-----------|--------------------|------|
# | Topology  |  attached entities | ntop |
# |-----------|--------------------|------|
# |  Vertex   |  2      = vertex   |  1   |
# |  Interval |  2,3    = vertices |  2   |
# |  Triangle |  2,3,4  = vertices |  3   |
# |  Tets     |  2,3,4,5= vertices |  4   |
# |-----------|--------------------|------|
# ```
#
# where in non-standard cases the number an be different.
#
# """
struct    VertexTopology <: Abstract0DTopology
	elements   :: Array{Int64,2}
	attributes :: Array{Int64,2}
	VertexTopology(e::Array{Int64,2},a::Array{Int64,2}) = new(e,a)
end
struct    IntervalTopology <: Abstract1DTopology
	elements   :: Array{Int64,2}
	attributes :: Array{Int64,2}
	IntervalTopology(e::Array{Int64,2},a::Array{Int64,2}) = new(e,a)
end
struct    TriangleTopology <: Abstract2DTopology
	elements   :: Array{Int64,2}
	attributes :: Array{Int64,2}
	TriangleTopology(e::Array{Int64,2},a::Array{Int64,2}) = new(e,a)
end
struct    TetrahedronTopology <: Abstract3DTopology
	elements   :: Array{Int64,2}
	attributes :: Array{Int64,2}
	TetrahedronTopology(e::Array{Int64,2},a::Array{Int64,2}) = new(e,a)
end


"""
**Summary:** `struct Geometry{N}``

**Fields:**
```
vertices :: Array{Float64,2}
topology :: VertexTopology
```

**Description:**

The type `Geometry` stores N-dimensional coordinates in the field `vertices` and
the vertex numbers and properties (IDs) in the field `topology`. The vertex
numbers are referenced by the arrays within higher dimensional `AbstractTopology`
objects.

* `vertices`: Stores the l-th coordinate of the k-th vertex in `vertices[k,l]`.

* `topology`: Geometry contains the `VertexTopolgy`.


"""
struct Geometry{N}

	"vertices::Array{Float64,2} are the vertex locations in Geometry type"
	vertices :: Array{Float64,2}

	"topology::VertexTopolgy contains vertex numbers and IDs"
	topology :: VertexTopology

end

function Geometry(xyz::Array{Float64,2},t::VertexTopology)
	if size(xyz,2)==N
		new{N}(xyz,t)
	else
		error("Array size of vertices does not match assigned dimension")
	end
end

# different ways to access coordinates

# access via geometry and dimension
xyz(g::Geometry,k::Int64,d::Int64) = g.vertices[k,d]

# vertex coordinate - based on geometry
x(g::Geometry,k::Int64) = xyz(g,k,1)
y(g::Geometry,k::Int64) = xyz(g,k,2)
z(g::Geometry,k::Int64) = xyz(g,k,3)

# vertex coordinate - based on geometry and topology
x(g::Geometry,t::AbstractTopology,k::Int64,l::Int64) = xyz(g,ele2vert(t,k,l),1)
y(g::Geometry,t::AbstractTopology,k::Int64,l::Int64) = xyz(g,ele2vert(t,k,l),2)
z(g::Geometry,t::AbstractTopology,k::Int64,l::Int64) = xyz(g,ele2vert(t,k,l),3)

# element -> vertex conversion
ele2vert(t::AbstractTopology,k::Int64,l::Int64) = t.elements[k,1+l]

Geometry(x::Vector{Float64},t::VertexTopology) = Geometry{1}(reshape(x,length(x),1),t)
Geometry(x::Vector{Float64},y::Vector{Float64},t:: VertexTopology) = Geometry{2}([x y],t)
Geometry(x::Vector{Float64},y::Vector{Float64},z::Vector{Float64},t:: VertexTopology) = Geometry{3}([x y z],t)


"""
**Summary:**     `function nvertices(g::Geomtry) :: Int`

**Description:** `nvertices(g)` returns as `Int` the number of vertices in the geometry g.
"""
nvertices(g::Geometry) = size(g.vertices,1)

"""
**Summary:**     `function ndim(g::Geomtry) :: Int`

**Description:** `ndim(g)` returns as `Int` the spatial dimension of the geometry g.
"""
dim(g::Geometry{1}) = Int(1)
dim(g::Geometry{2}) = Int(2)
dim(g::Geometry{3}) = Int(3)

"""
**Summary:**     `function nelement(t::AbstractTopology) :: Int`

**Description:** `nelement(t)` returns as `Int` the number of elements in the topology t.
"""
nelement(t::AbstractTopology) = size(t.elements,1)

"""
**Summary:**     `function ntdim(t::AbstractTopology) :: Int`

**Description:** `ntdim(t)` returns as `Int` the topological dimension of the topology t.
"""
dim(t::Abstract0DTopology)          = Int(0)
dim(t::Abstract1DTopology)          = Int(1)
dim(t::Abstract2DTopology)          = Int(2)
dim(t::Abstract3DTopology)          = Int(3)
"""
**Summary:**     `function nid(t::AbstractTopology) :: Int`

**Description:** `nid(t)` returns as `Int` the number of identifiers of the topology t.
"""
nid(t::AbstractTopology)  = size(t.attributes,2)
ntop(t::AbstractTopology) = size(t.elements,2)-1

# define function for iteration of topologies
# see http://docs.julialang.org/.../manual/interfaces/#man-interfaces-iteration
isempty(t::AbstractTopology)          = isempty(t.elements)
length(t::AbstractTopology)           = nelement(t)

iterate(t::AbstractTopology,state=1) = state > length(t) ? nothing : (collect(t.elements[state,:]),state+1)

eltype(::Type{AbstractTopology})   = Vector{Int64}

# define functions for indexing of topologies
# -> which parts of elements should be provided to the user?
# getindex(t::AbstractTopology, i::Int64) = collect(t.elements[i,:])
function setindex!(t::AbstractTopology, v::Vector{Int64}, i::Int64)
	for j=1:length(v)
		t.elements[i,1+j] = v[j] # -> should the user be able to specify the first argument or the ids?
	end
end

getindex(t::AbstractTopology, i::Int64) = collect(t.elements[i,:])


# endof(t::AbstractTopology) = length(t)
