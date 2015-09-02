% Returns the Chow-Liu Tree over n variables using an input matrix
%
% Inputs:
%   MIs - matrix whose (i,j)^th entry is the mutual information between the
%     variables X_i and X_j
%   R - desired root of the Chow-Liu Tree (optional; 1 by default)
% Outputs:
%   T - sparse, lower triangular matrix whose (i,j)^th entry is the weight of
%     the edge from X_i to X_j if they are connected in the Chow-Liu tree, and
%     zero otherwise; nnz(T) == (n - 1)
%   preds - vector whose i^th entry is the predecessor of the i^th node in the
%     rooted Chow-Liu tree
%

function [T, preds] = chow_liu(MIs)

  [T, preds] = graphminspantree(-sparse(MIs - max(MIs(:)) - 1));

end
