% Returns an graphical model over n variables as estimated the PC algorithm
%
% Inputs:
%   test - function mapping two coordinates 
%   data - T-by-n matrix of T joint samples of all n voxels
%
% Outputs:
%   T - sparse, lower triangular matrix whose (i,j)^th entry is the weight of
%     the edge from X_i to X_j if they are connected in the estimated graph,
%     and zero otherwise
%

function T = pc_algo(test, data)

  

end
