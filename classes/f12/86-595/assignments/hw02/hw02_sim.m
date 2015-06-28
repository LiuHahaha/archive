MI = zeros(100,6);

for trial=1:100
  num = 1;
  for N=[4 8 16 32 64 128];
    data = [poissrnd(2,1,N);
            poissrnd(4,1,N);
            poissrnd(6,1,N);
            poissrnd(8,1,N)];

    for i=1:4
      u = unique(data(i,:));
      prob{i} = zeros(2,length(u));
      prob{i}(1,:) = u;
  
      for j=1:length(u)
        prob{i}(2,j) = length(find(data(i,:) == prob{i}(1,j)))./(4*N);
      end
    end
  
    all = [prob{1} prob{2} prob{3} prob{4}];
    u = unique(all(1,:));
    pr = zeros(2,length(u));
    pr(1,:) = u;
  
    for i=1:length(u)
      s = sum(all(2,find(all(1,:) == pr(1,i))));
      pr(2,i) = s;
    end
  
    HR = -sum(pr(2,:).*log2(pr(2,:)));
    HRS = -sum(all(2,:).*log2(4.*all(2,:)));
  
    MI(trial,num) = HR - HRS;
  
    num = num + 1;
  end
end
