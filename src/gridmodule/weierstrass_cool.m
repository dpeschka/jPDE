%[xyz,vert,pattr,ele,eattr,nd] = readgrid_avs('len_5_s_1');
%save mesh
%[xyz1,vert1,pattr1,ele1,eattr1,nd1] = readgrid_avs('len_10_s_1');
%save mesh1
%%
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

zm1 = mean(z1(top1),2);

phirange = linspace(0,2*pi,25*10);
hold off
phirange = phirange(1:end-1);
mprint = 0;
for phi = phirange
    xv =  cos(phi)*x + sin(phi)*y;
    yv = -sin(phi)*x + cos(phi)*y;
    zv = z;
    
    xv1 =  cos(phi)*x1 + sin(phi)*y1;
    yv1 = -sin(phi)*x1 + cos(phi)*y1;
    zv1 = z1;
    
    c = 0*x;
    
    trisurf(top,xv,yv,zv,c);
    hold on
    zmin = -250 + 000*(1-cos(2*phi))/2;
    zmax = -250 + 620*(1-cos(2*phi))/2;
    
    sel = zm1>zmin & zm1<zmax;
    aaa=trisurf(top1(sel,:),xv1,yv1,zv1,0*xv1,'FaceColor','none','EdgeAlpha',0.35);
    hold off
    axis off
    colormap gray
    
    axis equal
    
    xlim([-250 250])
    ylim([-250 250])
    zlim([-250 345])
    
    shading interp
    light('Position',[-250 -250 300],'Style','local','Color',[1.0 0.5 0.5])
    light('Position',[-250 +250 300],'Style','local','Color',[0.5 1.0 0.5])
    light('Position',[+250 +000 300],'Style','local','Color',[0.5 0.5 1.0])
    view(0,10)
    drawnow
    mprint = mprint + 1;
    
    print('-djpeg95','-r350',sprintf('img_mesh1_%4.4i.jpg',mprint))
end


