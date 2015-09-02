function decoded = arithmeticDecode(p, encoded)

  decoded = zeros(0, 1);
  cdf = [0; cumsum(p)];

  % lower and upper bounds on encoded based on bits read so far
  min_val = 0;
  max_val = 1;
  i = 1;
  while ~any(decoded == 1)

    if i <= length(encoded)
      new_bit = encoded(i);
      i = i + 1;
    else
      new_bit = 1;
    end

    if new_bit == 0 % left half
      max_val = (min_val + max_val)/2;
    else % right half
      min_val = (min_val + max_val)/2;
    end

    % while both lower and upper bounds are in the same interval
    while sum(cdf <= min_val) == sum(cdf < max_val)

      % output the symbol for that interval
      new_decoded = sum(cdf <= min_val);
      decoded = [decoded; new_decoded];
      if(new_decoded == 1)
        break;
      end

      % rescale bounds to that interval
      lower = cdf(new_decoded);
      upper = cdf(new_decoded + 1);
      min_val = (min_val - lower)/(upper - lower);
      max_val = (max_val - lower)/(upper - lower);
    end
  end
end
