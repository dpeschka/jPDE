push!(LOAD_PATH, "./gridmodule/")
push!(LOAD_PATH, "./femmodule/")

using BaseFEM
using BaseGrid
using LinearAlgebra

# 1D ring
#m=grid1D("./mesh1d/mesh2")
#tau = 1e-3
#eps = 0.1

# 3D ball
#m=grid3D("./mesh3d/ball")
#tau = 1e-3
#eps = 0.1

# greenland example
#m=grid2D("./mesh2d/greenland")
#tau = 1e-1
#eps = 3.00

# sphere example
m=grid2D("./mesh2d/sphere_hq05")
tau = 1e-6
eps  = 0.01

top  = m.topology
ndof = ndof_P1(top)
geo  = restrain_geometry(m.geometry,ndof)
A,M=assembly_P1(geo,top)

# initial conditions
u      = 2.0*rand(ndof).-1.0
time = 0.0
S = factorize([M tau*A;-A M])
mprint = 0

for i=1:1000
	global time,u,mprint
	println("iteration $(i) at time $(time)")

	dWdu = (4*u.^3-4*u)/eps

	rhs1 = M*u
	rhs2 = M*dWdu

	sol = S\[rhs1;rhs2]
	u   = sol[1:ndof]
	time = time + tau

	# output to ParaView vtk file
	if mod(i,10) == 0
		mprint = mprint + 1
		outvtk_scalar("output/example_cahnhilliard"*string(mprint)*".vtk",geo,top,"sol",u)
	end
end
# alternative meshes
# m=grid2D("./mesh2d/test")
# m=grid2D("./mesh2d/sphere")
