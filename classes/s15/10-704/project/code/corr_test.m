% returns an (asymptotically valid) p-value for testing whether
% Cor(X, Y) == 0

function p = corr_test(Xs, Ys, nperms)

  % compute estimate of correlation for true data
  truth = abs(dot(Xs, Ys));

  % compute estimates of correlation for permuted data
  comps = zeros(nperms, 1);
  for p_idx = 1:nperms
    comps(p_idx) = abs(dot(Xs, Ys(randperm(length(Ys)))));
  end

  p = mean(comps < truth);

end
