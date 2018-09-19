
function [xyz,vert,pattr,ele,eattr,nd] = readgrid_avs(fname)

% read vertex related stuff
fid = fopen(strcat(fname,'.inp'),'r')

mesh_header = fscanf(fid,'%i',5);

nvert       = mesh_header(1); % stringtoint(mesh_header[1]) # number of vertices
nele        = mesh_header(2); % stringtoint(mesh_header[2]) # number of elements
npattr      = mesh_header(3); % stringtoint(mesh_header[3]) # number of point attributes
nide        = mesh_header(4); % stringtoint(mesh_header[4]) # number of element attributes
nmodel      = mesh_header(5); % stringtoint(mesh_header[5]) # model data (assume this is zero)

nd   = 3;  %  spatial dimension
nide = 1;  % overwrite above
ntop = 3;  %

% allocate
xyz   = zeros(nvert,nd);
vert  = zeros(nvert, 2 );

% read vertex positions, enumeration, and attributes
for i=1:nvert
    vert(i,1)    = i;
    vert(i,2)    = fscanf(fid,'%i',1);
    for j=1:nd
        
        xyz(i,j)     = fscanf(fid,'%f',1);
       
    end
end

ele    = zeros(nele,4);
eattr  = zeros(nele,nide);
fprintf('read elements\n')

for k=1:nele

    % data = split(strip(readline(fid)))
    % if data[3]=="tri"
    ele(k,1) = fscanf(fid,'%i',1);
    temp     = fscanf(fid,'%i',1);
    temp     = fscanf(fid,'%s',1);
    
    %for i=1:nide
    %    eattr(k,i) = fscanf(fid,'%i',1);
    %end
    for i=1:3
        ele(k,1+i) = fscanf(fid,'%i',1);
    end
    
    % end
end
pattr = zeros(nvert,1);
fclose(fid)

end
