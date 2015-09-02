function encoded = arithmeticEncode(p, raw)

  encoded = zeros(0, 1);
  lower = 0;
  upper = 1;

  for char = raw'

    % rescale and shift cdf to [lower, upper] interval
    cdf_shifted = ([0; cumsum(p)]*(upper - lower)) + lower;
    lower = cdf_shifted(char);
    upper = cdf_shifted(char + 1);

    % encode any symbols that can be unambiguously encoded
    [lower, upper, new_encoded] = encodePrefix(lower, upper);
    encoded = [encoded; new_encoded];
  end

  % encoded any number in the interval we've found
  encoded = [encoded; 0];
  while lower < 0.5;
    lower = (lower + upper)/2;
    encoded = [encoded; 1];
  end

end

function [lower, upper, new_encoded] = encodePrefix(lower, upper)

  new_encoded = zeros(0, 1);

  while (lower - 0.5)*(upper - 0.5) >= 0
    bit = lower >= 0.5; % new bit is 0 or 1
    new_encoded = [new_encoded; bit];

    % left shift lower and upper
    lower = 2*lower - bit;
    upper = 2*upper - bit;
  end
end
