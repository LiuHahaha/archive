% Computes the vector of correlations between voxel vox and all n voxels
% Inputs:
%   vox: index of voxel to compare
%   data: T-by-n matrix of T joint samples of all n voxels
%
% Outputs:
%   c: 1-by-n vector of correlations between voxel vox and all n voxels

function c = vox_corr(data, vox)
  c = corr(data(:, vox), data);
end
