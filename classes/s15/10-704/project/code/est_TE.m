% estimates the transfer entropy of X -> Y using samples Xs of X and samples
% Ys of Y, using the entropy estimator specified by type
%
% Inputs:
%   Xs - k1-by-n matrix of n 1-dimensional data points
%   Ys - k2-by-n matrix of n 1-dimensional data points
%   type - type of entropy estimator to use
%   beta - assumed Markov order of time series
%
% Outputs:
%   T - estimated transfer entropy from X to Y

function T = est_cond_H(Xs, Ys, type, beta)

  n = length(Xs);

  Xs_past = zeros(beta, n - beta);
  Ys_past = zeros(beta, n - beta);
  for i=1:beta
    Ys_past(i,:) = Ys(i:(end - beta + i - 1));
    Xs_past(i,:) = Xs(i:(end - beta + i - 1));
  end

  H_1 = est_cond_H(Ys((1 + beta):end), Ys_past, type);
  H_2 = est_cond_H(Xs_past, Ys_past, type);
  H_3 = est_cond_H([Ys((1 + beta):end); Xs_past], Ys_past, type);

  T = H_1 + H_2 - H_3;

end
