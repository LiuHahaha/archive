% Scatter plot pairwise values vals over the euclidean distance between points
%
% Inputs:
%   XYZ - 2-by-n or 3-by-n matrix
%   vals - n-by-n symmetric matrix of values to plot on y-axis
%
% Outputs:
%   None

function plot_over_dists(XYZ, vals)

  vals(vals == 0) = realmin('single');
  scatter(pdist(XYZ'), nonzeros(tril(vals, -1)));

end
