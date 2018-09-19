export outascii_scalar,outascii_mesh

function outascii_mesh(fname::String,g::Geometry,t::AbstractTopology)

  topo_ids      = Dict(VertexTopology=>1,IntervalTopology=>2,TriangleTopology=>3,TetrahedronTopology=>4)
  topo_id       = topo_ids[typeof(t)]
  element_len   = [1;2;3;4][topo_id]

  fid = open(fname*".node","w");
  xx=zeros(Float64,3)
  for k=1:nvertices(g)
    for d=1:dim(g)
      xx[d] = xyz(g,k,d)
    end
    println(fid,"$(xx[1]) $(xx[2]) $(xx[3])")
  end
  close(fid)

  fid = open(fname*".ele","w");
  for e in t
    println(fid,"$(join(e[2:(1+element_len)]," "))")
  end
  close(fid)

end

function outascii_scalar(fname::String,g::Geometry,t::AbstractTopology,sname::String,u::Vector{Float64})

  topo_ids      = Dict(VertexTopology=>1,IntervalTopology=>2,TriangleTopology=>3,TetrahedronTopology=>4)
  topo_id       = topo_ids[typeof(t)]
  element_len   = [1;2;3;4][topo_id]

  # fid = open(fname*".node","w");
  # xx=zeros(Float64,3)
  # for k=1:nvertices(g)
  #   for d=1:dim(g)
  #     xx[d] = xyz(g,k,d)
  #   end
  #   println(fid,"$(xx[1]) $(xx[2]) $(xx[3])")
  # end
  # close(fid)
  #
  # fid = open(fname*".ele","w");
  # for e in t
  #   println(fid,"$(join(e[2:(1+element_len)]," "))")
  # end
  # close(fid)

  fid = open(fname*".sol","w");
  for i=1:length(u)
    println(fid,"$(u[i])")
    #  @printf(fid,"%4.3f\n",u[i])
  end
  close(fid)

end
