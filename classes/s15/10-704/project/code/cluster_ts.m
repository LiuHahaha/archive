% clusters variables based on their the estimated dependencies
% Inputs:
%   Xs - k-by-n data matrix of n (possibly dependendent) samples from k
%   variables
%   K - desired number of clusters
%   dependence_meas - measure of dependence (one of 'MI', 'TE', or 'MIR')
%   est_type - type of nonparametric estimator to use to estimate
%   dependence_meas (one of 'KDE' or 'KNN')
%
% Outputs:
%   C - column vector of indices of variables' cluster assignments

function [C] = cluster_ts(Xs, K, dependence_meas, est_type)

end
