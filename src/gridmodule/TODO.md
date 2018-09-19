# BaseGrid module
-----------------
### Status:
* types: `Geometry`, `AbstractTopology`, `Grid`
* methods: `ndim`,`ntdim`,`nvertices`,`nelement`,`x,y,z`, ...,  indexing and iteration,
  `tensor_grid`(1D)
* import: read *triangle*, *tetgen* files
* export/store: ParaView's VTK

### Next steps:

1. tensor grids
2. read and write files in HDF5
3. C-interface to triangle,tetgen, (gmsh?)
4. extractor for sub-topologies (boundary, select elements by id, select elements
  by functions acting on coordinates)
5. read boundary specification from files (tetgen & triangle)
6. Grids where Topologies are in a Dictionary container

### Open questions:

1. Need ID for special grids: Delaunay, axisymmetric, tensor,subgrids/topologies?
2. Need non-simplex grids?
3. Special needs of FVM versus special needs of FEM?
4. Should we use *parametric number type* `T<:Number` vs `Float64` for coordinates/calculations? Or perhaps a `typealias`?
5. Make topologies an `AbstractArray` object / to which extend implement iterator functions for grid/topologies? What should the be in `e` for `for e in t` with `t<:AbstractTopology`?
