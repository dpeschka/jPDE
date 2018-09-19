export topology_id,restrain_geometry

# returns selected id of a given topology
function topology_id(t::AbstractTopology,k::Int64,i::Int64)
  if i<=nid(t) & i>0
    return t.attributes[k,i]
  else
    return void
  end
end

# returns all selected id of a given topology
function topology_id(t::AbstractTopology,i::Int64)
  if i<=nid(t) & i>0
    return t.attributes[:,i]
  else
    return void
  end
end

# reduces a vertex topology by restraining to the first N vertices
# not such a nice implementation, since I need to access the Geometry directly
function restrain_geometry(g::Geometry,N::Int64)
  xyz  = g.vertices[1:N,:]
  vvv  = VertexTopology(g.topology.elements[1:N,:],g.topology.attributes[1:N,:])
  return Geometry{dim(g)}(xyz,vvv)
end
