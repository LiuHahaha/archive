% generates a 3D scatter plot with points at XYZ colored by vals
% Inputs:
%   vals - length-n column vector of values with which to color points
%   XYZ - 3-by-n matrix of spatial locations
%   marker - scatter plot marker (optional; default is '.')
function [] = plot_over_brain(vals, XYZ, marker)

  if nargin < 3
    marker = '.';
  end

  red = (vals' - min(vals))./(max(vals) - min(vals));
  blue = 1 - red;

  colors = [red zeros(size(red)) blue];

  scatter3(XYZ(1, :), XYZ(2, :), XYZ(3, :), [], colors, marker);
end
