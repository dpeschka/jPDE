push!(LOAD_PATH, "./gridmodule/")

using BaseGrid

g1Da = grid1D("./mesh1d/mesh1")
g1Db = grid1D("./mesh1d/mesh2")
g1Dc = grid1D("./mesh1d/mesh3")

g2D = grid2D("./mesh2d/test")
g3D = grid3D("./mesh3d/ball")


gNEW = grid2D_avs("./mesh2d/len_10_s_1")


print("Interval mesh output:\n")
show(g1Da)
show(g1Db)
show(g1Dc)

print("Triangle mesh output:\n")
show(g2D)
show(gNEW)

print("Tetrahedron mesh output:\n")
show(g3D)

outvtk_mesh("output/test1Da.vtk",g1Da.geometry,g1Da.topology)
outvtk_mesh("output/test1Db.vtk",g1Db.geometry,g1Db.topology)
outvtk_mesh("output/test1Dc.vtk",g1Dc.geometry,g1Dc.topology)
outvtk_mesh("output/test2D.vtk" ,g2D.geometry ,g2D.topology)
outvtk_mesh("output/test3D.vtk" ,g3D.geometry ,g3D.topology)
outvtk_mesh("output/testNEW.vtk" ,gNEW.geometry ,gNEW.topology)
