% estimates the conditional entropy of X given Y using samples Xs of X and
% samples Ys of Y, using the first order von Mises estimator with a kernel
% density estimator
%
% Inputs:
%   Xs - k1-by-n matrix of n k1-dimensional samples from X
%   Ys - k2-by-n matrix of n k2-dimensional samples from Y
%   type - type of entropy estimator to use
%
% Outputs:
%   H - estimated conditional entropy of X given Y

function H = est_cond_H(Xs, Ys, type)

  H = est_H([Xs; Ys], type) - est_H(Ys, type);

end
