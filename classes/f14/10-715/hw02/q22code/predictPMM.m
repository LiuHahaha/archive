function [preds, classLogJoints] = predictPMM(X, theta, alpha)

  % prelims
  n = size(X, 1);
  K = numel(theta);

  % First obtain the class log joint probabilities
  classLogLs = zeros(n, K);
  parfor k = 1:K
    classLogLs(:, k) = classLogLikelihoods(X, alpha(k, :));
  end
  classLogJoints = bsxfun(@plus, classLogLs, log(theta'));

  % Finally obtain the predictions
  [~, preds] = max(classLogJoints, [], 2);

end

function logL = classLogLikelihoods(X, alphak)

  % Prelims
  Ak = sum(alphak);
  m = sum(X, 2); % number of words in each documents
  XplusAlpha = bsxfun(@plus, X, alphak);

  % Compute the log likelihood
  logL = gammaln(Ak) - gammaln(m + Ak) + ...
    sum(gammaln(XplusAlpha), 2) - sum( gammaln(alphak) );
end
