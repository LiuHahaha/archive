% Computes
%
% Inputs:
%   Xs - k-by-n data matrix of n sequential, joint observations of X
%   metric - string indicating what measure of distance to use
%   varargin - depends on metric
%
% Outputs:
%   D - k-by-k matrix of

function D = dependence_matrix(Xs, metric)

  k = size(Xs, 1);
  D = zeros(k);

  for i=1:k
    for j=1:k
      if strcmp(metric, 'MI')
      elseif strcmp(metric, 'TE')
      elseif strcmp(metric, 'MIR')
      elseif strcmp(metric, 'corr')
      elseif strcmp(metric, 'Granger')
      else
        error('Unrecognized');
      end
    end
  end

end
