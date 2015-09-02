addpath(genpath('ite'))

% simulation parameters
trials = num2cell(1:72); % number of trials
Ts = num2cell([125 250 375 500]); % number of time points (samples) (CHANGED THIS LAST)
data_types = {'simultaneous only', 'lagged only', 'both'};
est_types = {'KDE', 'KNN'}; % types of entropy estimators to use
test_types = {'MI', 'TE', 'MIR'};
nperms = num2cell([500]); % # of permutations (for permutation test)
lags = num2cell([1 2 3 4 5 6]); % time lag (of Y behind X)
sigmas = num2cell([1]); % variance of shared Gaussian signal
sigma_Ys = num2cell([8:9]); % variance of Gaussian noise on Y
decays = num2cell([1.2]); % decay of X to 0

alpha = 0.05; % (1 - confidence) level for permutation test

tic

results = simulator('time_series_sim', trials, Ts, data_types, est_types, ...
                             test_types, nperms, lags, sigmas, sigma_Ys, decays);

results = squeeze(results{1} > 1 - alpha);

save('results_main_more_samples', 'results');

toc
