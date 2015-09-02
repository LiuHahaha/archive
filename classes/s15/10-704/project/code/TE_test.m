function p = TE_test(Xs, Ys, type, lag, nperms)

  % compute estimates of TE and MI for true data
  truth = est_TE(Xs, Ys, type, lag);

  % compute estimates of TE and MI for permuted data
  comps = zeros(nperms, 1);
  for p_idx = 1:nperms
    comps(p_idx) = est_TE(Xs, Ys(randperm(length(Ys))), type, lag);
  end

  p = mean(comps < truth);

end
