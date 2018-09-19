% create mercedes star mesh
% ele and node files

N    = 100;
Nphi =   2;
Nattr=   1;

% 1..N-1
x1 = linspace(-1,0,N);x1=x1(1:end-1);
y1 = linspace(-1,0,N);y1=y1(1:end-1);

% N .. 2*(N-1)
x2 = linspace(+1,0,N);x2=x2(1:end-1);
y2 = linspace(-1,0,N);y2=y2(1:end-1);

% 2*(N-1)+(1..N)
x3 = linspace(0,0,N);
y3 = linspace(0,1,N);

NN = 2*(N-1)+1;

ele1 = [1:N-1;[2:N-1 NN]];
ele2 = [(N-1+(1:N-1));[(N-1+(2:N-1)) NN]];
ele3 = 2*(N-1)+[1:N-1;2:N];

ele = [ele1';ele2';ele3'];

Nele = size(ele,1);

x=[x1(:);x2(:);x3(:)];
y=[y1(:);y2(:);y3(:)];

idv      = zeros(length(x),1);
idv(1)   = 1;
idv(N)   = 1;
idv(end) = 1;

ide    = ones(Nele,1);

fid = fopen('mesh3.node','w');
fprintf(fid,'%i %i %i %i\n',length(x),2,0,1);
for i=1:length(x)
    fprintf(fid,'%i %e %e %i\n',i,x(i),y(i),idv(i));
end
fprintf(fid,'# generated by mesh3.m\n')
fclose(fid);

fid = fopen('mesh3.ele','w');
fprintf(fid,'%i %i %i\n',Nele,Nphi,Nattr);
for i=1:Nele
    fprintf(fid,'%i %i %i %i\n',i,ele(i,1),ele(i,2),ide(i));
end
fprintf(fid,'# generated by mesh3.m\n')
fclose(fid)