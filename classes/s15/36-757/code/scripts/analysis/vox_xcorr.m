% Computes the maximum cross-correlation between voxels vox1 and vox2
% Inputs:
%   vox1: index of first voxel to compare
%   vox2: index of second voxel to compare
%   data: T-by-n matrix of T joint samples of all n voxels
%
% Outputs:
%   c: 1-by-n vector of correlations between voxel vox and all n voxels

function c = vox_corr(data, vox1, vox2)
  c = max(xcorr(data(:, vox1), data(:, vox2));
end
