% Plot edges between pairs of point with coordinates XYZ
%
% Inputs:
%   pairs - k-by-2 matrix of indices of pairs of points between which to draw
%    edges, where k is the number of edges to draw
%   XYZ - d-by-n matrix of n point coordinates; d = 2 or d = 3
%   linewidth - thickness of edges (default is 1)
%   linecolors - colors of each edge (not yet implemented)
%
% Outputs:
%   None (generates plot)

function plot_edges3(vals, thresh, XYZ)

  plot_brain(XYZ);
  plot_edges3(nonzero_coords(tril(vals, -1) > thresh), XYZ);

end
