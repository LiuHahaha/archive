% Estimates the Shannon mutual information between two variables X and Y based
% on samples from their joint density. For simplicity, the estimator's
% parameters have been set internally, but these can be played with, as
% described below.
% 
% Inputs:
%     Xs - n-by-d_X data matrix of n samples of a d_X dimensional variable X
%     Ys - n-by-d_Y data matrix of n samples of a d_Y dimensional variable Y
% 
% Outputs:
%     I - estimated mutual information between X and Y

function I = MI_est(Xs, Ys)

  % SET ESTIMATOR PARAMETERS HERE
  % 'rot', 'hjsm', 'msp', 'lcv', 'hall', 'local', or d-by-1 numerical vector of
  % bandwidths for each dimension
  h = 'rot';
  % 'G', 'E', or 'L', for Gaussian, Epanechnikov/quadratic, or Laplacian kernel
  kernel = 'G';
  est_frac = 0.9; % fraction samples to be used for estimating the density

  [n, ~] = size(Xs);
  dat = [Xs Ys];
  
  % compute joint and marginal KDEs
  p_XY = kde(dat', h, [], kernel);
  p_X = kde(dat(:, 1)', h, [], kernel);
  p_Y = kde(dat(:, 2)', h, [], kernel);
  
  % compute MI estimate
  I = entropy(p_X) + entropy(p_Y) - entropy(p_XY);

end
