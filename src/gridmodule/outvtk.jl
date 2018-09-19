export outvtk_mesh,outvtk_scalar,outvtk_vector

# output mesh to VTK file for visualization

function outvtk_mesh(fname::String,g::Geometry,t::AbstractTopology)

  topo_ids    = Dict(VertexTopology=>1,IntervalTopology=>2,TriangleTopology=>3,TetrahedronTopology=>4)

  topo_id       = topo_ids[typeof(t)]
  paraview_type = [1;3;5;10][topo_id]
  paraview_len  = [1;2;3;4][topo_id]

  fid = open(fname,"w");

  # output header
  println(fid,"# vtk DataFile Version 2.0")
  println(fid,"Simplex mesh created from Julia")
  println(fid,"ASCII")

  # create unstructured grid with points
  println(fid,"DATASET UNSTRUCTURED_GRID")
  println(fid,"POINTS $(nvertices(g)) float")

  xx=zeros(Float64,3)

  for k=1:nvertices(g)
    for d=1:dim(g)
      xx[d] = xyz(g,k,d)
    end
    println(fid,"$(xx[1]) $(xx[2]) $(xx[3])")
  end

  # output cell connectivity
  println(fid,"CELLS $(nelement(t)) $((paraview_len+1)*nelement(t))")
  for e in t
    println(fid,"$(paraview_len) $(join(e[2:(1+paraview_len)].-1," "))")
  end

  # output cell type 10 = tetraeder
  println(fid,"CELL_TYPES $(nelement(t))")
  for i=1:nelement(t)
    println(fid,"$(paraview_type)")
  end

  # choose a) scalar or b) vector output
  # a) println(fid,"SCALARS $(nameofthatscalar) float 1") # scalar
  # b) println(fid,"VECTORS vectors float") # vector
  # println(fid,"LOOKUP_TABLE default")
  # for i=1:nvertices(g)
  #   a) println(fid,"$(u[i])") # scalar
  #   b) println(fid,"$(ux[i]) $(uy[i]) $(uz[i])") # vector
  # end

  close(fid)

end

function outvtk_scalar(fname::String,g::Geometry,t::AbstractTopology,sname::String,u::Vector{Float64})

  topo_ids    = Dict(VertexTopology=>1,IntervalTopology=>2,TriangleTopology=>3,TetrahedronTopology=>4)
  topo_id       = topo_ids[typeof(t)]
  paraview_type = [1;3;5;10][topo_id]
  paraview_len  = [1;2;3;4][topo_id]

  fid = open(fname,"w");

  # output header
  println(fid,"# vtk DataFile Version 2.0")
  println(fid,"Simplex mesh created from Julia")
  println(fid,"ASCII")

  # create unstructured grid with points
  println(fid,"DATASET UNSTRUCTURED_GRID")
  println(fid,"POINTS $(nvertices(g)) float")

  xx=zeros(Float64,3)

  for k=1:nvertices(g)
    for d=1:dim(g)
      xx[d] = xyz(g,k,d)
    end
    println(fid,"$(xx[1]) $(xx[2]) $(xx[3])")
  end

  # output cell connectivity
  println(fid,"CELLS $(nelement(t)) $((paraview_len+1)*nelement(t))")
  for e in t
    println(fid,"$(paraview_len) $(join(e[2:(1+paraview_len)].-1," "))")
  end

  # output cell type 10 = tetraeder
  println(fid,"CELL_TYPES $(nelement(t))")
  for i=1:nelement(t)
    println(fid,"$(paraview_type)")
  end
  println(fid,"POINT_DATA $(length(u))")

  println(fid,"SCALARS $(sname) float 1") # scalar
  println(fid,"LOOKUP_TABLE default")
  for i=1:length(u)
    println(fid,"$(u[i])")
  end

  close(fid)

end

function outvtk_vector(fname::String,g::Geometry,t::AbstractTopology,sname::String,ux::Vector{Float64},uy::Vector{Float64},uz::Vector{Float64})

  topo_ids    = Dict(VertexTopology=>1,IntervalTopology=>2,TriangleTopology=>3,TetrahedronTopology=>4)
  topo_id       = topo_ids[typeof(t)]
  paraview_type = [1;3;5;10][topo_id]
  paraview_len  = [1;2;3;4][topo_id]

  fid = open(fname,"w");

  # output header
  println(fid,"# vtk DataFile Version 2.0")
  println(fid,"Simplex mesh created from Julia")
  println(fid,"ASCII")

  # create unstructured grid with points
  println(fid,"DATASET UNSTRUCTURED_GRID")
  println(fid,"POINTS $(nvertices(g)) float")

  xx=zeros(Float64,3)

  for k=1:nvertices(g)
    for d=1:dim(g)
      xx[d] = xyz(g,k,d)
    end
    println(fid,"$(xx[1]) $(xx[2]) $(xx[3])")
  end

  # output cell connectivity
  println(fid,"CELLS $(nelement(t)) $((paraview_len+1)*nelement(t))")
  for e in t
    println(fid,"$(paraview_len) $(join(e[2:(1+paraview_len)].-1," "))")
  end

  # output cell type 10 = tetraeder
  println(fid,"CELL_TYPES $(nelement(t))")
  for i=1:nelement(t)
    println(fid,"$(paraview_type)")
  end
  println(fid,"POINT_DATA $(length(ux))")

  println(fid,"VECTORS $(sname) float") # scalar
  # println(fid,"LOOKUP_TABLE default")
  for i=1:length(ux)
    println(fid,"$(ux[i]) $(uy[i]) $(uz[i])")
  end

  close(fid)

end
