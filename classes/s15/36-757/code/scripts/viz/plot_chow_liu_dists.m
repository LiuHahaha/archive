% generates a 3D scatter plot with points at XYZ colored by Chow-Liu distance
% from the seed voxel
%
% Inputs:
%   vals - length-n column vector of values with which to color points
%   XYZ - 3-by-n matrix of spatial locations
%   marker - scatter plot marker (optional; default is '.')
function [] = plot_chow_liu_dists(MIs, seed, XYZ, marker)

  if nargin < 4
    marker = '.';
  end

  dists = graphallshortestpaths(chow_liu(MIs) > 0, 'Directed', false);

  plot_over_brain(dists(seed, :), XYZ, marker);

end
