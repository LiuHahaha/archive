function [num_y0, num_y1] = get_y_counts_for_conjunction(variables, values, X, Y)
% variables is a vector of variables,             e.g. [2 3 1]
% values is a parallel vector of values for them, e.g. [1 1 0]
% then we execute the conjunction,                e.g. (X2=1 & X3=1 & X1=0)
% and return counts out of Y for those datapoints satisfying the conjunction.

N = size(X,1);
mask = ones(N,1);
for i=1:size(variables,1)
  mask = mask & (X(:, variables(i)) == values(i));
end
num_y1 = sum(Y(mask));
num_y0 = sum(~Y(mask));

