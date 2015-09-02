% estimates the mutual information rate between X and Y using samples Xs of X
% and samples Ys of Y, using the entropy estimator specified by type, under a
% beta-Markov assumption
%
% Inputs:
%   Xs - k1-by-n vector of n 1-dimensional data points
%   Ys - k2-by-n vector of n 1-dimensional data points
%   type - type of entropy estimator to use
%   beta - assumed Markov order of time series
%
% Outputs:
%   I - estimated mutual information rate between X to Y

function I = est_MIR(Xs, Ys, type, beta)

  n = length(Xs);

  Xs_past = zeros(beta, n - beta);
  Ys_past = zeros(beta, n - beta);
  for i=1:beta
    Xs_past(i,:) = Xs(i:(end - beta + i - 1));
    Ys_past(i,:) = Ys(i:(end - beta + i - 1));
  end
  Xs_tail = Xs((1 + beta):end);
  Ys_tail = Ys((1 + beta):end);

  CH_X = est_cond_H(Xs_tail, Xs_past, type);
  CH_Y = est_cond_H(Ys_tail, Ys_past, type);
  CH_XY = est_cond_H([Xs_tail; Ys_tail], [Xs_past; Ys_past], type);

  I = CH_X + CH_Y - CH_XY;

end
