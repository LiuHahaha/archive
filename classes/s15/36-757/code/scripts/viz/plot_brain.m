% generates a 3D scatter plot with points at XYZ
%
% Inputs:
%   XYZ - 3-by-n matrix of spatial locations

function [] = plot_over_brain(XYZ, marker)

  scatter3(XYZ(1, :), XYZ(2, :), XYZ(3, :));

end
