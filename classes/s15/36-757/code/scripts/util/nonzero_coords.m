% Returns the coordinates of nonzero
%
% Inputs:
%   A - d-tensor of doubles
%
% Outputs:
%   coords - k-by-d matrix of d-dimensional coordinates of A's nonzero entries
%     k == length(find(A)) is the number of nonzero entries of A
%

function coords = nonzero_coords(A)

  [Is, Js] = ind2sub(size(A), find(A));
  coords = [Is Js];

end
