module BaseFEM


__precompile__()


using BaseGrid
using SparseArrays

export generatetransformation,localstiff,localmass,assembly_P1,ndof_P1

include("femtransformations.jl")

function ndof_P1(t::AbstractTopology)
	return maximum(collect(t.elements[:,2:(2+dim(t))]))
end

################
### 3D stuff ###
################

# 3D stiffness matrix for P1 element on flat tetraeders
function localstiff_P1(t::TetrahedronTopology,edet::Float64,dFinv::Array{Float64,2})
	dphi = [-1.0 -1.0 -1.0;1.0 0.0 0.0;0.0 1.0 0.0;0.0 0.0 1.0] * dFinv
	return dphi*dphi' * edet/6
end

# 3D mass matrix for P1 element on flat tetraeders
function localmass_P1(t::TetrahedronTopology,edet::Float64,dFinv::Array{Float64,2})
	return edet*[2 1 1 1;1 2 1 1;1 1 2 1;1 1 1 2]/120
end

################
### 2D stuff ###
################

# 2D stiffness matrix for P1 element on flat triangles
function localstiff_P1(t::TriangleTopology,edet::Float64,dFinv::Array{Float64,2})
	dphi = [-1.0 -1.0;1.0 0.0;0.0 1.0] * dFinv # correct
	# jdphi = [-1.0 -1.0;1.0 0.0;0.0 1.0]*(dFinv')
	return dphi*dphi' * edet/2
end

# 2D mass matrix for P1 element on flat triangles
function localmass_P1(t::TriangleTopology,edet::Float64,dFinv::Array{Float64,2})
	return edet*[1 1/2 1/2;1/2 1 1/2;1/2 1/2 1]/12
end

################
### 1D stuff ###
################

# 2D stiffness matrix for P1 element on flat triangles
function localstiff_P1(t::IntervalTopology,edet::Float64,dFinv::Array{Float64,2})
	dphi = [-1.0;1.0] / edet
	return dphi*dphi' * edet
end

# 1D mass matrix for P1 element on intervals
function localmass_P1(t::IntervalTopology,edet::Float64,dFinv::Array{Float64,2})
	return edet*[1/3 1/6;1/6 1/3]
end

###############
### GENERAL ###
###############

function assembly_P1(g::Geometry,t::AbstractTopology)

	nphi = dim(t)+1;
	ii = zeros(  Int64,nelement(t),nphi^2)
	jj = zeros(  Int64,nelement(t),nphi^2)
	aa = zeros(Float64,nelement(t),nphi^2)
	bb = zeros(Float64,nelement(t),nphi^2)

	iloc = zeros(Int64,nphi,nphi)
	jloc = zeros(Int64,nphi,nphi)

	for i=1:nphi
		for j=1:nphi
			iloc[i,j]=i
			jloc[i,j]=j
		end
	end
	iloc = collect(iloc)
	jloc = collect(jloc)

	@inbounds for k=1:nelement(t)

		ix = t[k]
		edet,dFinv = generatetransformation(g,t,k)

		# compute local matrix
		sloc = localstiff_P1(t,edet,dFinv)
		mloc = localmass_P1(t,edet,dFinv)

		# dof mapper
		ii[k,:] = ix[iloc.+1]
		jj[k,:] = ix[jloc.+1]

		# set matrix
		aa[k,:] = sloc[:]
		bb[k,:] = mloc[:]

	end

	A = sparse(ii[:],jj[:],aa[:])
	M = sparse(ii[:],jj[:],bb[:])

	return A,M

end

end
