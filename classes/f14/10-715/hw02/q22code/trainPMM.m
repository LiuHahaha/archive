function [theta, alpha] = trainPMM(XTrain, K, theta0, lambda, thetaInit, alphaInit);

  theta = thetaInit;
  alpha = alphaInit;

  for iter = 1:10
    Z = predictPMM(XTrain, theta, alpha);
    [theta, alpha] = trainPDA(XTrain, Z, theta0, lambda);
  end
end
