% Extracts a random subsample of k voxels from the full data set
%
% Inputs:
%   k - number of voxels to sample
%   data - T-by-V data matrix, with T observations of V voxels
%   XYZ - 3-by-V matrix of XYZ coordinates of voxels
%
% Outputs:
%   s_data - T-by-k submatrix of data (drawn without replacement)

function [s_data s_XYZ] = sub_vox(k, data, XYZ)

  idxs = randsample(size(data, 2), k);

  s_data = data(:, idxs);
  s_XYZ = XYZ(:, idxs);

end
