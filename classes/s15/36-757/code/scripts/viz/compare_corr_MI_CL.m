% generates a 3D scatter plot with points at XYZ colored by Chow-Liu distance
% from the seed voxel
%
% Inputs:
%   vals - length-n column vector of values with which to color points
%   XYZ - 3-by-n matrix of spatial locations
%   marker - scatter plot marker (optional; default is '.')
function [] = compare_corr_MI_CL(corrs, MIs, seed, XYZ, marker)

  if nargin < 5
    marker = '.';
  end

  dists = graphallshortestpaths(chow_liu(MIs) > 0, 'Directed', false);

  subplot(1, 3, 1);
  plot_over_brain(corrs(seed, :), XYZ, marker);
  subplot(1, 3, 2);
  plot_over_brain(MIs(seed, :), XYZ, marker);
  subplot(1, 3, 3);
  plot_over_brain(dists(seed, :), XYZ, marker);

end
