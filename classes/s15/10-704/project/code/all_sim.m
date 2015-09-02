% simulation parameters
T = 300; % number of time points (samples)
nperms = 2000; % number of permutations (for permutation test)
sigma = 1; % variance of shared Gaussian signal
sigma_Ys = 1:10; % variance of Gaussian noise on Y
decay = 1.2; % decay of X to 0
% lag = 2; % time lag (of Y behind X)
n_trials = 72; % number of trials
types = cell(2,1);
types{1} = 'KDE';
types{2} = 'KNN';


n_sigma_Ys = length(sigma_Ys);
n_types = length(types);

mTE_p =  zeros(n_sigma_Ys, n_types);
mMI_p =  zeros(n_sigma_Ys, n_types);
mMIR_p = zeros(n_sigma_Ys, n_types);

sTE_p =  zeros(n_sigma_Ys, n_types);
sMI_p =  zeros(n_sigma_Ys, n_types);
sMIR_p = zeros(n_sigma_Ys, n_types);

tic

for typei = 1:n_type

  type = types{typei};

  for sigma_Yi = 1:n_sigma_Ys

    sigma_Y = sigma_Ys(sigma_Yi);

    TE_p = zeros(n_trials,1);
    MI_p = zeros(n_trials,1);
    MIR_p = zeros(n_trials,1);
  
    parfor trial = 1:n_trials
      Xs = zeros(1, T);
      for t = 2:T
        Xs(t) = normrnd(Xs(t - 1)/decay, sigma);
      end
      Ys = Xs(1:(end - lag)) + normrnd(0, sigma_Y, 1, T - lag);
      Xs = Xs((1 + lag):end);
  
      TE_p(trial) = TE_test(Xs, Ys, lag, type, nperms);
      MI_p(trial) = MI_test(Xs, Ys, type, nperms);
      MIR_p(trial) = MIR_test(Xs, Ys, lag, type, nperms);
  
    end

    mTE_p(sigma_Yi) = mean(TE_p > 0.95);
    mMI_p(sigma_Yi) = mean(MI_p > 0.95);
    mMIR_p(sigma_Yi) = mean(MIR_p > 0.95);
  
    sTE_p(sigma_Yi) = std(TE_p > 0.95)/sqrt(n_trials);
    sMI_p(sigma_Yi) = std(MI_p > 0.95)/sqrt(n_trials);
    sMIR_p(sigma_Yi) = std(MIR_p > 0.95)/sqrt(n_trials);
  
    % disp(sprintf('TE test power:  %f    std: %f', mean(TE_p > 0.95),  std(TE_p > 0.95)));
    % disp(sprintf('MI test power:  %f    std: %f', mean(MI_p > 0.95),  std(MI_p > 0.95)));
    % disp(sprintf('MIR test power: %f    std: %f', mean(MIR_p > 0.95), std(MIR_p > 0.95)));

  end

end

h = figure; hold all;
errorbar(sigma_Ys, mTE_p, sTE_p, 'linewidth', 3);
errorbar(sigma_Ys, mMI_p, sMI_p, 'linewidth', 3);
errorbar(sigma_Ys, mMIR_p, sMIR_p, 'linewidth', 3);
legend('Transfer Entropy', 'Mutual Information', 'Mutual Info. Rate');
xlabel('sigma');
ylabel('power');

name = sprintf('all_sim_lag_%d', lag)
set(h, 'PaperPosition', [0 0 4 3]);

saveas(h, name, 'fig');
saveas(h, name, 'png');

close all;

toc
