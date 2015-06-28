function [params, svs] = dualSVMRegression(K, y, c, eps)

  n = length(y);
  z = [eps - y', eps + y'];
  Q = [K -K; -K K];
  size(z)
  size(Q)

  theta = quadprog(Q, z, [], [], [], [], zeros(2*n,1), c*ones(2*n,1));

  params.beta = theta(1:n);
  params.gamma = theta((n + 1):end);
  svs = abs(params.beta - params.gamma) > 0.01;

end
