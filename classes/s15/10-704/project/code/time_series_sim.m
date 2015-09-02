function power = time_series_sim(trial, T, data_type, est_type, test_type, ...
                                           nperms, lag, sigma, sigma_Y, decay)

  % generate data
  Xs = zeros(1, T);
  switch data_type
  case 'simultaneous only'
    Xs = zeros(1, T);
    for t = 2:T
      Xs(t) = normrnd(Xs(t - 1)/decay, sigma);
    end
    Ys = Xs + normrnd(0, sigma_Y, 1, T);
  
  case 'lagged only'
    Xs = zeros(1, T);
    for t = 2:T
      Xs(t) = normrnd(0, sigma);
    end
    Ys = Xs(1:(end - lag)) + normrnd(0, sigma_Y, 1, T - lag);
    Xs = Xs((1 + lag):end);

  case 'both'
    for t = 2:T
      Xs(t) = normrnd(Xs(t - 1)/decay, sigma);
    end
    Ys = Xs(1:(end - lag)) + normrnd(0, sigma_Y, 1, T - lag);
    Xs = Xs((1 + lag):end);

  otherwise
    error('Unrecognized data_type');
  end

  % run appropriate test
  switch test_type
  case 'MI'
    power = MI_test(Xs, Ys, est_type, nperms);
  case 'TE'
    power = TE_test(Xs, Ys, est_type, lag, nperms);
  case 'MIR'
    power = MIR_test(Xs, Ys, est_type, lag, nperms);
  case 'corr'
    power = corr_test(Xs, Ys, nperms);
  otherwise
    error('Unrecognized test_type');
  end

end
