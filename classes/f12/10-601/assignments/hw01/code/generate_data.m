function [X,Y] = generate_data(N, theta, varargin)
if size(varargin,2)==1
    seed = varargin{1};
    rng(seed);
end

J = 6;

X = zeros(N, J);
for j=1:J
  X(:,j) = rand(N,1) > 0.5;
end


Y = X(:,1) | (~X(:,1) & X(:,2) & X(:,6));

signal_flips = rand(N,1) > theta;
Y(signal_flips) = ~Y(signal_flips);

end

