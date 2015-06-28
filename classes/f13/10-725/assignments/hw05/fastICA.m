function W = fastICA(X)
  % Inputs:
  %   X - N-by-M data matrix of M observations in R^N
  %       Note: It is assumed that N <= M
  % 
  % Outputs:
  %   W - N-by-N estimate of unmixing matrix

  epsilon = 10^(-10);

  g = @(u) tanh(u);                             % non-linearity function
  g_deriv = @(u) 1 - tanh(u).^2;                % derivative of g

  [N M] = size(X);


  %%% BEGIN PREPROCESSING %%%
  %%  CENTERING  %%

  m = mean(X,2);
  for i=1:M
    X(:,i) = X(:,i) - m;
  end

  %%  WHITENING  %%

  C = X*X'/M;     % covariance matrix
  [U,D,~] = svd(C);
  D = inv(sqrtm(D));
  X = (U * D * U') * X;

  %%% FINISH PREPROCESSING %%%

  %%% BEGIN FAST ICA %%%

  for i = 1:N
    w = rand(1,N);      % random initial vector
    w_old = w + 1;      % anything different from w so the loop starts

    while(norm(w_old - w) > epsilon)
      w_old = w;

      p = w*X;                        % dot product of w onto columns of X
      w = (g(p)*X' - g_deriv(p)*ones(M,1)*w)./M;        % main update step

      % orthogonalize w with respect to previous output vectors
      for j=1:(i - 1)
        w = w - dot(w,W(j,:))*W(j,:); % subtract projection onto j^th vector
      end    

      % normalize w
      w = w/norm(w);
    end

    W(i,:) = w;
  end
end
