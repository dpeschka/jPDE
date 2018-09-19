%[xyz,vert,pattr,ele,eattr,nd] = readgrid_avs('len_5_s_1');
%save mesh
%[xyz1,vert1,pattr1,ele1,eattr1,nd1] = readgrid_avs('len_10_s_1');
%save mesh1
%%

wiasimg = imread('WIAS2011.jpg');

wiasimg = flipud(imfilter(wiasimg,ones(5,5) / 25));


load mesh1
top = ele(:,2:4);
top1 = ele1(:,2:4);

xm = mean(xyz,1);

xyz(:,1) = xyz(:,1) - xm(1);
xyz(:,2) = xyz(:,2) - xm(2);
xyz(:,3) = xyz(:,3) - xm(3);

xyz1(:,1) = xyz1(:,1) - xm(1);
xyz1(:,2) = xyz1(:,2) - xm(2);
xyz1(:,3) = xyz1(:,3) - xm(3);


x = xyz(:,1);
y = xyz(:,2);
z = xyz(:,3);

x1 = xyz1(:,1);
y1 = xyz1(:,2);
z1 = xyz1(:,3);

zm  = mean(z(top),2);
zm1 = mean(z1(top1),2);

ztop = max(z);
zbot = min(z);

phirange = linspace(0,-2*pi,25*10+1);
hold off
phirange = phirange(1:end-1);
mprint = 0;
phi0 = -0*pi;
xshift=350;
yshift=200;
zshift=200;
for phi = phirange
    
    imshow(160+.5*wiasimg)
    hold on
    xv = 0.5*( cos(phi-phi0)*x + sin(phi-phi0)*y );
    yv = 0.5*(-sin(phi-phi0)*x + cos(phi-phi0)*y );
    zv = 0.5*(z                                  );
    
    xv1 = 0.5*( cos(phi-phi0)*x1 + sin(phi-phi0)*y1);
    yv1 = 0.5*(-sin(phi-phi0)*x1 + cos(phi-phi0)*y1);
    zv1 = 0.5*(z1                                  );
    
    c = 0*x;
    zmin = zbot ;
    zmax = zbot + 1.1*(ztop-zbot)*(1-cos(phi))/2;
    
    
    zi = (zmin+zmax)/2;
    sel1 = zm1>zmin & zm1<zmax;  
    sel  = zm>zmin  & zm<zmax;
    
    trisurf(top(:,:),xv+xshift,zv+zshift,-(yv+yshift),1+0*xv,'FaceAlpha',(1+cos(phi))/4);
    trisurf(top1(sel1,:),xv1+xshift,zv1+zshift,-(yv1+yshift),1+0*xv1);
    trisurf(top1(sel1,:),xv1+xshift,zv1+zshift,-(yv1+yshift),0*xv1,'FaceColor','none','EdgeAlpha',0.4);
    
    hold off
    axis off
    colormap gray
    
    axis equal
    
    
    shading interp

    light('Position',[200  450  -300],'Style','local','Color',[0.5 0.5 1.0])
    light('Position',[200  450  -300],'Style','local','Color',[0.5 1.0 0.5])
    light('Position',[500  450   -50],'Style','local','Color',[1.0 0.5 0.5])

    view(0,-77)
    xlim([0 700])
    ylim([0 450])
    zlim([-300 0])

    drawnow
    mprint = mprint + 1;
    
    print('-djpeg95','-r200',sprintf('img_mesh_%4.4i.jpg',mprint))
end


