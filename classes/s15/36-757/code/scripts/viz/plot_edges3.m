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

function plot_edges3(pairs, XYZ, linewidth)

  d = size(XYZ, 1);
  k = size(pairs, 1);
  if nargin < 3
    linewidth = 2;
  end

  if ~ismember(d, [2 3])
    print('Dimension must be 2 or 3.');
    return;
  end

  for i=1:k
    hold all;
    X1 = XYZ(1, pairs(i, 1));
    X2 = XYZ(1, pairs(i, 2));
    Y1 = XYZ(2, pairs(i, 1));
    Y2 = XYZ(2, pairs(i, 2));

    if d == 2
      plot([X1 X2], [Y1 Y2], 'g', 'linewidth', linewidth);
    else
      Z1 = XYZ(3, pairs(i,1));
      Z2 = XYZ(3, pairs(i,2));
      plot3([X1 X2], [Y1 Y2], [Z1 Z2], 'g', 'linewidth', linewidth);
    end
  end

end
