% FROM: LabelMe Toolbox
function h=subplottight(Ny, Nx, j, margin)
% General utility function
%
% This function is like subplot but it removes the spacing between axes.
%
% subplottight(Ny, Nx, j)

if nargin <4 
    margin = 0;
end

j = j-1;
x = mod(j,Nx)/Nx;
y = (Ny-fix(j/Nx)-1)/Ny;
h=axes('position', [x+margin/Nx y+margin/Ny 1/Nx-2*margin/Nx 1/Ny-2*margin/Ny]);

