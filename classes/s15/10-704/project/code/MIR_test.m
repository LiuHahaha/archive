function p = MIR_test(Xs, Ys, type, lag, nperms)

  % compute estimates of TE and MI for true data
  truth = est_MIR(Xs, Ys, type, lag);

  % compute estimates of TE and MI for permuted data
  comps = zeros(nperms, 1);
  parfor p_idx = 1:nperms
    comps(p_idx) = est_MIR(Xs, Ys(randperm(length(Ys))), type, lag);
  end

  p = mean(comps < truth);

end
