% Plots the specified dimensions of the results of simulator
%
% Inputs:
%   data - (usually high-dimensional) results of running sim_name on all
%          possible combinations of inputs; the first dimension should be
%          over trials in order for standard error plot to be correct
%   xs - x-values to plot
%   y_dim - dimension to plot on the y-axis
%   for_each_dim - plots once for each value along this dimension (optional)
%   sub_x_dim - dimension to vary horizontally along subplots (optional)
%   sub_y_dim - dimension to vary vertically along subplots (optional)
%
%   Requirements:
%   y_dim must be in 1:ndims(data).
%   If provided, for_each_dim, sub_x_dim, sub_y_dim must be in 1:ndims(data).
%   Must have size(data, y_dim) = length(xs);
%
% Outputs:
%   h - handle of figure produced
%
% For example, if
%   size(data, y_dim) = 17, size(data, sub_x_dim) = size(data, sub_y_dim) = 3,
%   and size(data, for_each_dim) == 6,
% the h will have 9 subplots, each containing 6 plotted lines of 17 points each
%
% TODO: add legend argument, and test plotter (e.g., by plotting KDE and KNN
% at each lag and noise level)

function h = plotter(data, xs, y_dim, for_each_dim, sub_x_dim, sub_y_dim)

  if nargin < 3
    error('Must input data matrix, x_dim, and y_dim.');
  end
  if nargin < 4
    for_each_dim = ndims(data) + 1;
    sub_x_dim = ndims(data) + 2;
    sub_y_dim = ndims(data) + 3;
  elseif nargin < 5
    sub_x_dim = ndims(data) + 1;
    sub_y_dim = ndims(data) + 2;
    if numel(for_each_dim) == 0
      for_each_dim = ndims(data) + 3;
    end
  elseif nargin < 6
    sub_y_dim = ndims(data) + 1;
    if numel(for_each_dim) == 0
      for_each_dim = ndims(data) + 2;
    end
  end

  % make new figure window
  figure;

  % for sake of convenience, bring the dimensions we care about to the front
  my_dims = [y_dim, for_each_dim, sub_x_dim, sub_y_dim];
  pdata = permute(data, [my_dims, setdiff(1:max(ndims(data), sub_y_dim), my_dims)]);
  data_size = size(pdata);
  my_data_size = [data_size(1:4) prod(data_size(5:end))];
  mpdata = mean(reshape(pdata, my_data_size), 5);
  spdata = std(reshape(pdata, my_data_size), [], 5)/sqrt(size(data, 1));

  for sub_x_idx = 1:size(pdata, 3)
    for sub_y_idx = 1:size(pdata, 4)
      plot_idx = size(pdata, 3)*(sub_y_idx - 1) + sub_x_idx;
      subplot(size(pdata, 4), size(pdata, 3), plot_idx); hold all;
      for for_each_idx = 1:size(pdata, 2)
        ys = squeeze(mpdata(:, for_each_idx, sub_x_idx, sub_y_idx));
        errs = squeeze(spdata(:, for_each_idx, sub_x_idx, sub_y_idx));
        errorbar(xs, ys, errs, 'linewidth', 2);
        axis([min(xs)-1 max(xs)+1 -0.1 1.1]);
      end
      plot(xs, 0.05*ones(size(xs)), '--'); % plot alpha (chance)
    end
  end

end
