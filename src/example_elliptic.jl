
push!(LOAD_PATH, "./femmodule/")
push!(LOAD_PATH, "./gridmodule/")

using BaseFEM
using BaseGrid

# m=grid1D("./mesh1d/mesh3")
# m=grid2D("./mesh2d/test")
m=grid3D("./mesh3d/ball")

top  = m.topology
ndof = ndof_P1(top)
geo  = restrain_geometry(m.geometry,ndof)

A,M=assembly_P1(geo,top)

# solve with homogeneous dirichlet boundary conditions
reduce = topology_id(geo.topology,1).==0

# elimination of boundary conditions
reduce = reduce[1:ndof]
u      = zeros(ndof)
rhs    = M*ones(ndof)

# solve reduced system
A_reduced    = A[reduce,reduce]
rhs_reduced  = rhs[reduce]
u_reduced    = A_reduced\rhs_reduced

# extend to full system again
u[reduce] = u_reduced

# output to ParaView vtk file
outvtk_scalar("output/example_poisson.vtk",geo,top,"sol",u)
