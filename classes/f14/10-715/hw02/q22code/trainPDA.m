function [theta, alpha] = trainPDA(X, y, theta0, lambda)

  % Prelims
  K = numel(unique(y));
  V = size(X, 2);
  numData = size(X, 1);

  % MAP for theta
  table = tabulate(y);
  adjustedFreqs = table(:,2) + theta0 - 1;
  theta = adjustedFreqs/sum(adjustedFreqs);

  % MAP for alpha
  alpha = zeros(K, V);
  parfor k = 1:K
    Xk = X(y == k, :);
    alpha(k, :) = newtonRaphsonPDA(Xk, lambda);
  end
end

function [alpha_k] = newtonRaphsonPDA(Xk, lambda)

  % Prelims
  numNRIters = 10; % Just use 5 iterations of NR
  nk = size(Xk, 1); % number of training data in this class
  m = sum(Xk, 2); % number of words in each documents
  initPt = sum(Xk); initPt = initPt/sum(initPt); % Initialization

  % Now perform Newton's
  alpha_k = initPt; % alphak in the current iteration
  for nrIter = 1:numNRIters
    % Compute the following
    Ak = sum(alpha_k);
    XplusAlpha = bsxfun(@plus, Xk, alpha_k);
    % The gradient
    g = nk * psi(Ak) - sum(psi(m + Ak)) + sum( psi(XplusAlpha) ) ...
        - nk * psi(alpha_k) - 2 * lambda * alpha_k;
    % The value z (see solutions)
    z = nk * psi(1, Ak) - sum(psi(1, m + Ak));
    % The diagonal of the Hessian
    D = sum(psi(1, XplusAlpha)) - nk * psi(1, alpha_k) - 2*lambda;
    % Newton's step update
    Hinvg = g./D - (1./D) * sum(g./D) / (1/z + sum(1./D));
    alpha_k = alpha_k - 1*Hinvg;
  end
end
