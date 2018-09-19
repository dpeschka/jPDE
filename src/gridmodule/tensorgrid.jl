#
# file: tensorgrid.jl
#
# Creation of 1D,2D,3D tensor grids
#

export tensor_grid

# This meshgrid functions are extracted from Julia (License is MIT) and modified
# by Dirk Peschka: Unfortunately this seemed not to be a callable part of Julia
# 0.4.0 base. Extracted only meshgrid functionality from the ndgrid.jl file available at
#
# https://github.com/JuliaLang/julia/blob/master/examples/ndgrid.jl
#
# and modified swapping x <-> y in the meshgrid output, that
# is probably a (strange) artifact from MATLAB.

"""
**Summary:**     `meshgrid{T}(vx, vy) :: Array{T,2}`

**Description:** `meshgrid{T}(vx,vy)` returns as type `T` two arrays xx,yy, so
that x[i,j]=vx[i], y[i,j]=vy[j] for all i,j.
"""
function meshgrid{T}(vx::AbstractVector{T}, vy::AbstractVector{T})
    m, n = length(vy), length(vx)
    vx = reshape(vx, n, 1)
    vy = reshape(vy, 1, m)
    (repmat(vx, 1, m), repmat(vy, n, 1))
end

"""
**Summary:**     `meshgrid{T}(vx, vy, vz) :: Array{T,3}`

**Description:** `meshgrid{T}(vx,vy)` returns as type `T` two arrays x,y,z so
that x[i,j,k]=vx[i], y[i,j,k]=vy[j], z[i,j,k]=vz[k] for all i,j,k.
"""
function meshgrid{T}(vx::AbstractVector{T}, vy::AbstractVector{T},
                     vz::AbstractVector{T})
    m, n, o = length(vy), length(vx), length(vz)
    vx = reshape(vx, n, 1, 1)
    vy = reshape(vy, 1, m, 1)
    vz = reshape(vz, 1, 1, o)
    om = ones(Int, m)
    on = ones(Int, n)
    oo = ones(Int, o)
    (vx[om, :, oo], vy[:, on, oo], vz[om, on, :])
end


"""
**Summary:** `isincreasing(x) :: Bool`

**Description:** The `function isincreasing(x)` returns true, if the elements
of the iterable object `x` are in strict increasing order, otherwise it returns
false.

Examples:

    * isincreasing([1 2 3]) => true
    * isincreasing([1 2 2]) => false
"""
function isincreasing(x)
  cnt = start(x)
  done(x,cnt) && return true
  prev, cnt = next(x, cnt)
  while !done(x, cnt)
    this, cnt = next(x, cnt)
    !isless(prev,this) && return false
    prev = this
  end
  return true
end

"""
**Summary:** `function tensor_grid(x::AbstractArray,pattr=1,eattr=1)`

**Description:** Creates a 1D tensor grid out of vertex positions in `x`.

Keyword arguments:

  * `pattr::Int` number of vertex attributes
  * `eattr::Int` number of element attributes
Examples:

    * g = tensor_grid(linspace(0,1,5))
    * g = tensor_grid([0. 0.1 0.3 0.6 1.0])
"""
function tensor_grid(xx::AbstractArray,pattr=1,eattr=1)

  # check if x strictly increasing
  x = collect(float(xx))
  if !isincreasing(x)
    error("Requires strictly increasing input!")
  end

  # create indices for topology
  n = length(x)
  m = pattr  # point attributes as a parameter (with default=1)?
  k = eattr  # element attributes (see above)
  x    = reshape(x,n,1)
  v    = [collect(1:n) collect(1:n) zeros(Int64,n,m)]
  # mark boundaries by default? or rather not
  v[1,3] = 1
  v[n,3] = 1
  elem = [collect(1:n-1) collect(1:(n-1)) collect(2:n) zeros(Int64,n-1,k)]

  # create geometry and topology using standard constructors
  vertices = VertexTopology(v,1,m)
  geometry = Geometry{1}(x,vertices)
  topology = IntervalTopology(elem,2,k)

  # create Grid type
  Grid{1,IntervalTopology}(geometry,topology)

end

"""
 Creates 2D tensor grid
"""
function tensor_grid(x::AbstractArray, y::AbstractArray)

  # check if x,y strictly increasing
  if !isincreasing(x)|!isincreasing(y)
    error("Requires strictly increasing input!")
  end

end

"""
Creates 3D tensor grid
"""
function tensor_grid(x::AbstractArray, y::AbstractArray, z::AbstractArray)
  # check whether arrays are monotone
  # check for singular subintervals
  # create arrays for coordinates and cells and do nested loops to fill them
  # create array for boundary facets and fill it
  if !isincreasing(x)|!isincreasing(y)|!isincreasing(z)
    error("Requires strictly increasing input!")
  end

end

#=
Assigns region markers to certain cells of the grid
=#
#function mark_cells(g::AbstractGrid)
#end

#=
Assigns region markers to certain facets of the grid
=#
#function mark_facets(g::AbstractGrid)
#end

#=
Remove parts of the grid
=#
#function extract_subgrid(g::AbstractGrid)
#end
