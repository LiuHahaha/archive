function H = est_H(Xs, type, bw)

  if strcmp(type, 'KDE')
    if nargin < 3
      bw = 'rot';
    end

    H = entropy(kde(Xs, bw));
    return;
  else
    cost_name = 'Shannon_kNN_k';
    L = size(Xs, 1);
    co = H_initialization(cost_name,1);
    H = H_estimation(Xs, co);
  end
end
