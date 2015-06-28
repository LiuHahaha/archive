function predY = classify_with_tree(tree, X)
% X: matrix size NxJ
% returns: vector length N of predictions

N = size(X,1);
predY = zeros(N,1);

for i=1:N

  node = 1;
  while 1
    if tree{node}.is_nonterm
      % navigate down split
      var = tree{node}.variable;
      if X(i, var)
        node = tree{node}.rightchild;
      else
        node = tree{node}.leftchild;
      end

    else
      yc = tree{node}.y_counts;
      if yc(1)==yc(2)
        predY(i) = randi(2) - 1;
      else
        predY(i) = yc(2) > yc(1);
      end
      break;

    end
  end
end


