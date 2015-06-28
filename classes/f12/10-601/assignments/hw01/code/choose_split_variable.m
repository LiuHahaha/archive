function chosen_var = choose_split_variable(X, Y, available_vars)
J = size(X,2);
N = size(X,1);

% Dumb baseline
% chosen_var = available_vars( randi(size(available_vars,2)) );

nvar = size(available_vars,2);

var_gains = zeros(nvar, 1);
for i=1:nvar
  xvar = available_vars(i);
  var_gains(i) = mutual_info(X(:, xvar), Y, ones(N,1));
end

% Breaks ties to the first -- gives a funny bias for small training sets.
% [m,best_ind] = max(var_gains);

% Break ties randomly.
m = max(var_gains);
tied_best_inds = find(var_gains==m);
best_ind = tied_best_inds( randi(size(tied_best_inds,2)) );
chosen_var = available_vars(best_ind);
