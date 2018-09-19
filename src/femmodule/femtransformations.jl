function generatetransformation(g::Geometry{3},t::TetrahedronTopology,k::Int64)

	@inbounds begin
		dx1=x(g,t,k,2)-x(g,t,k,1)
		dy1=y(g,t,k,2)-y(g,t,k,1)
		dz1=z(g,t,k,2)-z(g,t,k,1)

		dx2=x(g,t,k,3)-x(g,t,k,1)
		dy2=y(g,t,k,3)-y(g,t,k,1)
		dz2=z(g,t,k,3)-z(g,t,k,1)

		dx3=x(g,t,k,4)-x(g,t,k,1)
		dy3=y(g,t,k,4)-y(g,t,k,1)
		dz3=z(g,t,k,4)-z(g,t,k,1)

		# determinant on each tetrahedron
		edet = dx1*dy2*dz3+dx2*dy3*dz1+dx3*dy1*dz2-dx3*dy2*dz1-dx1*dy3*dz2-dx2*dy1*dz3

		# transformation on each tetrahedron
		dFinv = zeros(Float64,3,3)

		dFinv[1,1] = (dy2*dz3-dy3*dz2)/edet
		dFinv[1,2] = (dx3*dz2-dx2*dz3)/edet
		dFinv[1,3] = (dx2*dy3-dx3*dy2)/edet

		dFinv[2,1] = (dy3*dz1-dy1*dz3)/edet
		dFinv[2,2] = (dx1*dz3-dx3*dz1)/edet
		dFinv[2,3] = (dx3*dy1-dx1*dy3)/edet

		dFinv[3,1] = (dy1*dz2-dy2*dz1)/edet
		dFinv[3,2] = (dx2*dz1-dx1*dz2)/edet
		dFinv[3,3] = (dx1*dy2-dx2*dy1)/edet
	end

	return edet,dFinv

end

function generatetransformation(g::Geometry{2},t::TriangleTopology,k::Int64)

	@inbounds begin
		dx1 = x(g,t,k,2)-x(g,t,k,1)
		dy1 = y(g,t,k,2)-y(g,t,k,1)

		dx2 = x(g,t,k,3)-x(g,t,k,1)
		dy2 = y(g,t,k,3)-y(g,t,k,1)
	end

	edet  = dx1*dy2 - dx2*dy1
	dFinv = [dy2 -dx2;-dy1 dx1] / edet

	return edet,dFinv

end

function generatetransformation(g::Geometry{3},t::TriangleTopology,k::Int64)

	@inbounds begin
		dx1 = x(g,t,k,2)-x(g,t,k,1)
		dy1 = y(g,t,k,2)-y(g,t,k,1)
		dz1 = z(g,t,k,2)-z(g,t,k,1)

		dx2 = x(g,t,k,3)-x(g,t,k,1)
		dy2 = y(g,t,k,3)-y(g,t,k,1)
		dz2 = z(g,t,k,3)-z(g,t,k,1)
	end

	n1   = sqrt(dx1^2+dy1^2+dz1^2)       # norm v1
	n22  = dx2^2+dy2^2+dz2^2             # squared norm v2
	s12  = (dx1*dx2+dy1*dy2+dz1*dz2)/n1  # scalar product v1*v2

	# project vp = v2 - (v1*v2)*v1/norm(v1)
	dx2p = dx2 - s12*dx1
	dy2p = dy2 - s12*dy1
	dz2p = dz2 - s12*dz1

	# set 2D coordinates based on e1 = v1/|v1| and e2=vp/|vp|
	dxp1 = n1
	dyp1 = 0.0
	dxp2 = s12
	dyp2 = sqrt(n22-dxp2^2)

	# compute determinant and transformation
	edet  = dxp1*dyp2 - dxp2*dyp1
	dFinv = [dyp2 -dxp2;-dyp1 dxp1] / edet

	return edet,dFinv

end

function generatetransformation(g::Geometry{1},t::IntervalTopology,k::Int64)

	@inbounds begin
		dx = x(g,t,k,2)-x(g,t,k,1)
	end

	edet  = dx
	dFinv = [1 / edet]'
	return edet,dFinv
end

function generatetransformation(g::Geometry{2},t::IntervalTopology,k::Int64)

	@inbounds begin
		dx = x(g,t,k,2)-x(g,t,k,1)
		dy = y(g,t,k,2)-y(g,t,k,1)
	end

	edet  = sqrt(dx^2+dy^2)
	dFinv = reshape([1 / edet],(1,1))  # should be this if we assume to only return the tangential
	# derivative and t. transformation. question is if we also need a tangential
	# projector in this case. for this, however, all "generatetransformation" should
	# have this syntax

	return edet,dFinv

end

function generatetransformation(g::Geometry{3},t::IntervalTopology,k::Int64)

	@inbounds begin
		dx = x(g,t,k,2)-x(g,t,k,1)
		dy = y(g,t,k,2)-y(g,t,k,1)
		dz = z(g,t,k,2)-z(g,t,k,1)
	end

	edet  = sqrt(dx^2+dy^2+dz^2)
	dFinv = reshape([1 / edet],(1,1))  # see comment Geometry{2} IntervalTopology

	return edet,dFinv

end
