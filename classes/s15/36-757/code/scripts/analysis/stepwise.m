% Computes the
% voxel i is included in layer k if i is dependent on s when conditioned on
% any subset of voxels in layer (k - i) (for all i in (1, k - 1)), and is
% independent of s when conditioned on some subset of voxels in layer (k - 1)

function DAG = stepwise(data, seed, thresh, max_depth, method)

  p = size(data, 2); % number of voxels

  active = (1:p) ~= seed;
  connected = (1:p) == seed; % logical indices of connected voxels; initially just seed
  DAG = cell(max_depth, p); % allocate space for output

  corrs = data(:, active)'*data(:, seed);

  for layer = 1:max_depth
    active = active &
  end

end
