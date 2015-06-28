% parameters
mu = [1 0];
sigma = 0.6;
n = 50;
Cs = 10.^(-3:3);
Cs2 = 10.^(-4:0.05:4);
num_trials = 50;

% Part I: training only
% generate data
Class1 = [normrnd(-mu(1), sigma, n, 1) normrnd(-mu(2), sigma, n, 1)];
Class2 = [normrnd(mu(1), sigma, n, 1) normrnd(mu(2), sigma, n, 1)];
X = [Class1; Class2];
Y = [-ones(n,1); ones(n,1)];

X_train = X;
Y_train = Y;

planes = zeros(length(Cs),2);
marg = zeros(size(Cs));

figure;
axis([min(X(:,1))-0.2 max(X(:,1))+0.6 min(X(:,2))-0.2 max(X(:,2))+0.2]);
hold all;

for Ci = 1:length(Cs)
  % run svmtrain with chosen C
  cmd = ['-c ', num2str(Cs(Ci))];
  model = svmtrain(Y_train, X_train, cmd);

  % extract learned coefficients
  w = (model.sv_coef' * full(model.SVs))
  b = -model.rho;

  % store results
  planes(Ci,:) = w;
  marg(Ci) = 2/norm(w);

  b_fun = @(x1) -(b + w(1)*x1)/w(2);
  red = ((Ci - 1)/(length(Cs) - 1));
  blue = 1 - red;
  plot([-10 10], [b_fun(-10) b_fun(10)], 'color', [red 0 blue], 'linewidth', 2);
  labs{Ci} = ['C = 2^{' num2str(log10(Cs(Ci))) '}'];
end
legend(labs);
scatter(Class1(:,1), Class1(:,2));
scatter(Class2(:,1), Class2(:,2));
xlabel('x');
ylabel('y');

% % plot margin over C
% figure;
% loglog(Cs, marg,'linewidth', 2);
% xlabel('C');
% ylabel('Margin 2/||w||');

% % Part II: training and testing
% % separate random training and test sets of equal size
% Cs = Cs2;
% train_errs = zeros(length(Cs), num_trials);
% test_errs = zeros(length(Cs), num_trials);
% 
% for trial = 1:num_trials
%   Class1 = [normrnd(-mu(1), sigma, n, 1) normrnd(-mu(2), sigma, n, 1)];
%   Class2 = [normrnd(mu(1), sigma, n, 1) normrnd(mu(2), sigma, n, 1)];
%   X = [Class1; Class2];
%   Y = [-ones(n,1); ones(n,1)];
% 
%   order = randperm(2*n);
%   X_train = X(order(1:n),:);
%   Y_train = Y(order(1:n));
%   X_test = X(order((n + 1):(2*n)),:);
%   Y_test = Y(order((n + 1):(2*n)));
% 
%   for Ci = 1:length(Cs)
%     cmd = ['-c ', num2str(Cs(Ci))];
%     model = svmtrain(Y_train, X_train, cmd);
%     [~, accuracy, ~] = svmpredict(Y_train, X_train, model); 
%     train_errs(Ci, trial) = 100 - accuracy(1);
%     [~, accuracy, ~] = svmpredict(Y_test, X_test, model); 
%     test_errs(Ci, trial) = 100 - accuracy(1);
%   end
% end
% 
% % plot results for Part II
% figure;
% hold all;
% % plot mean error
% plot(log10(Cs), mean(train_errs, 2), 'linewidth', 2, 'color', 'g');
% plot(log10(Cs), mean(test_errs, 2), 'linewidth', 2, 'color', 'b');
% % plot standard error band
% plot(log10(Cs), mean(train_errs, 2) + std(train_errs, 0, 2)/sqrt(num_trials), 'color', 'g');
% plot(log10(Cs), mean(train_errs, 2) - std(train_errs, 0, 2)/sqrt(num_trials), 'color', 'g');
% plot(log10(Cs), mean(test_errs, 2)  + std(test_errs,  0, 2)/sqrt(num_trials), 'color', 'b');
% plot(log10(Cs), mean(test_errs, 2)  - std(test_errs,  0, 2)/sqrt(num_trials), 'color', 'b');
% ylim([0 70]);
% xlabel('log_{10} C')
% ylabel('Percent Error')
% legend('Training','Test');
