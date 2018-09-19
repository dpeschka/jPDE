export readgrid

if VERSION < v"0.4.0-dev+1419"
  stringtoint(s)   = int(s);
  stringtofloat(s) = float(s);
else
  stringtoint(s)   = parse(Int64,s);
  stringtofloat(s) = parse(Float64,s);
end

"""
**Summary:**
```
 xyz,vert,pattr,ele,eattr,nd=function readgrid(fname::String)
```

**Description:**

Reads a *1D,2D,3D* topology grid from the file `fname` and stores data in
intermediate structure consisting of

- `xyz  ::Array{Float64,2}` vertices positions
- `vert ::Array{Int64,2}`   vertex numbers
- `pattr::Array{Int64,2}`   vertex attributes
- `ele  ::Array{Int64,2}`   element connectivity
- `eattr::Array{Int64,2}`   element attributes
- `nd::Int64`               spatial dimension (<=topological dimension)

 xyz,vert,pattr,ele,eattr,nd

as read from node and ele files. Can handle meshes generated with *triangle*,
*tetgen*, and the corresponding *1D* equivalent. The type of mesh (intervals,
triangles, tetraeders etc.) should be known by the caller of readgrid, when
creating the proper derived objects, i.e. topologies.

"""

function readgrid(fname::String)

  # read vertex related stuff
  fid = open(fname * ".node","r")
  mesh_header = split(strip(readline(fid))) # read file header
  nvert       = stringtoint(mesh_header[1]) # number of vertices
  nd          = stringtoint(mesh_header[2]) # spatial dimension
  npattr      = stringtoint(mesh_header[3]) # number of point attributes
  nidv        = stringtoint(mesh_header[4]) # number of boundary markers

  # allocate
  xyz   = zeros(Float64,nvert,nd)
  vert  = zeros(Int64, nvert, 2 )
  pattr = zeros(Int64, nvert, nidv + npattr)

  # read vertex positions, enumeration, and attributes
  for i=1:nvert
    data         = split(strip(readline(fid)))
    for j=1:nd
      xyz[i,j]     = stringtofloat(data[1+j])
    end
    vert[i,1]    = i
    vert[i,2]    = stringtoint(data[1])
    for j=1:nidv+npattr
      pattr[i,j] = stringtoint(data[1+nd+j])
    end
  end
  close(fid)

  # read element related stuff
  fid = open(fname * ".ele","r")
  mesh_header = split(strip(readline(fid)))
  nele   = stringtoint(mesh_header[1]) # number of elements
  ntop   = stringtoint(mesh_header[2]) # number of entities per element
  nide   = stringtoint(mesh_header[3]) # number of element attributes

  # allocate
  ele    = zeros(Int64,nele,ntop+1)
  eattr  = zeros(Int64,nele,nide)

  # read element enumeration, connectivity and attributes
  for k=1:nele
    data = split(strip(readline(fid)))
    for i=1:(ntop+1)
      ele[k,i] = stringtoint(data[i])
    end
    for i=1:nide
      eattr[k,i] = stringtoint(data[ntop+1+i])
    end
  end
  close(fid)
  return xyz,vert,pattr,ele,eattr,nd

end

# see http://userpages.umbc.edu/~squire/UCD_Form.htm
# readable with ParaView
function readgrid_avs(fname::String)

  # read vertex related stuff
  fid = open(fname * ".inp","r")
  mesh_header = split(strip(readline(fid))) # read file header
  nvert       = stringtoint(mesh_header[1]) # number of vertices
  nele        = stringtoint(mesh_header[2]) # number of elements
  npattr      = stringtoint(mesh_header[3]) # number of point attributes
  nide        = stringtoint(mesh_header[4]) # number of element attributes
  nmodel      = stringtoint(mesh_header[5]) # model data (assume this is zero)

  nd   = 3 # spatial dimension
  nide = 1 # overwrite above
  ntop = 3

  # allocate
  xyz   = zeros(Float64,nvert,nd)
  vert  = zeros(Int64, nvert, 2 )

  # read vertex positions, enumeration, and attributes
  for i=1:nvert
    data         = split(strip(readline(fid)))
    for j=1:nd
      xyz[i,j]     = stringtofloat(data[1+j])
    end
    vert[i,1]    = i
    vert[i,2]    = stringtoint(data[1])
  end

  ele    = zeros(Int64,nele,4)
  eattr  = zeros(Int64,nele,nide) # ==1?

  for k=1:nele
    data = split(strip(readline(fid)))
    if data[3]=="tri"
      ele[k,1] = stringtoint(data[1])
      for i=1:3
        ele[k,1+i] = stringtoint(data[3+i])
      end
      for i=1:nide
        eattr[k,i] = stringtoint(data[1+i])
      end
    end
  end

  # read from INP file?
  pattr = zeros(Int64,nvert,1)

  close(fid)
  return xyz,vert,pattr,ele,eattr,nd

end
