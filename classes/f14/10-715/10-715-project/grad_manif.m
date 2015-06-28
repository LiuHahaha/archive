% Given a matrix Xs of n points in R^d, grad_cluster attempts to find a vector
% Ys in [0,1]^n which minimizes H(Y | X) under the constraint min(Ys) = 0 and
% max(Ys) = 1

function Ys = grad_manif(K_X, K_Y, dK_dy, h_X, h_Y, e, Xs)

  [n d] = size(Xs);
  step = 1;

  % precompute kernel matrix of Xs
  K_Xs = zeros(n, n)
  for i=1:n
    for j=1:n
      K_Xs(i,j) = kernel(norm(Xs(i,:) - Xs(j,:))/h_X);
    end
  end
  K_Ys = zeros(n, n)
  % dK_dys(i,j) is the derivative of K_Ys(Ys(i),Ys(j)) with respect to Ys(i)
  dK_dys = zeros(n, n)

  % project Xs onto a uniformly random unit vector to initialize Ys
  proj = normrnd(0,1,d,1);
  Ys = Xs*proj;
  Ys = (Ys - min(Ys))/(max(Ys) - min(Ys)); % scale/translate Ys to [0,1]

  grad = ones(size(Ys));
  while norm(grad) > e
    % precompute kernel and kernel derivatives matrices of Ys
    for i=1:n
      for j=1:n
        K_Ys(i,j) = K_Y((Ys(i,:) - Ys(j,:))/h_Y);
        dK_dys(i,j) = dK_dy((Ys(i,:) - Ys(j,:))/h_Y)/h_Y;
      end
    end

    for i=1:n
      denoms(i) = K_Xs(i,:)*K_y(:,i);
    end

    for k=1:n
      lnum = K_Xs(k,:)*dK_dys(:,k);
      ldenom = denoms(k);
      rnums = zeros(n,1)
      rdenoms = zeros
      for i=1:n
        rnums(i) = K_Xs(i,k)*dK_dys(k,i);
      end 
      grad(k) = -(lnum/ldenom - sum(rnums./rdenoms))/n
    end

    % this should work for now, in theory

    Ys = Ys - step*grad;
    % plot(Xs,Ys)
  end

end
