% Centers and normalizes the data to have mean zero and variance 1.
% Also ensures the data is a double.
%
% Inputs:
%   data - T-by-V data matrix, with T observations of V voxels
%
% Outputs:
%   Z - Centered, normalized, double verson of data

function Z = cnorm(data)

  Z = zscore(double(data));

end
