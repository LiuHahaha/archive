% returns an (asymptotically valid) p-value for testing whether X is
% independent of Y

function p = MI_test(Xs, Ys, type, nperms)

  % compute estimate of MI for true data
  truth = est_MI(Xs, Ys, type);

  % compute estimates of MI for permuted data
  comps = zeros(nperms, 1);
  for p_idx = 1:nperms
    comps(p_idx) = est_MI(Xs, Ys(randperm(length(Ys))), type);
  end

  p = mean(comps < truth);

end
