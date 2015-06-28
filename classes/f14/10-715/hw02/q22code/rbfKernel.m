function K = rbfKernel(X1, X2, h)

  n1 = length(X1);
  n2 = length(X2);
  K = zeros(n1,n2);

  for i=1:n1
    for j=1:n2
      K(i,j) = exp(-(X1(i) - X2(j))^2/(2*h^2));
    end
  end

end
