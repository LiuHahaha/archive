% estimates the mutual information between X and Y using samples Xs of X and
% samples Ys of Y, using the entropy estimator specified by type
%
% Inputs:
%   Xs - k1-by-n matrix of n k1-dimensional data points
%   Ys - k2-by-n matrix of n k2-dimensional data points
%   type - type of entropy estimator to use
%
% Outputs:
%   I - estimated conditional entropy of X given Y

function I = est_MI(Xs, Ys, type)

  I = est_H(Xs, type) + est_H(Ys, type) - est_H([Xs; Ys], type);

end
