function [mi] = mutual_info(xvals, yvals, counts)
% "Mutual Information" is the same thing as "Information Gain"
%
% xvals:  size N vector of x-values
% yvals:  size N vector of y-values
% counts: size N vector of counts.  Make it all ones if xvals,yvals are for individual examples.

% Using the form
% KL( p(xy) || p(x)p(y) )
%   =  sum_xy p(xy) log[ p(xy) / (p(x)p(y)) ]
%   =    -H[p(xy)]      -   -H[p(xy), p(x)p(y)]
%     "avg joint logp"      "avg indep logp"

is_x1 = xvals;
is_x0 = ~xvals;
is_y1 = yvals;
is_y0 = ~yvals;

big_N = sum(counts);

p_x0 = sum(counts(find(is_x0))) / big_N;
p_x1 = sum(counts(find(is_x1))) / big_N;
p_y0 = sum(counts(find(is_y0))) / big_N;
p_y1 = sum(counts(find(is_y1))) / big_N;

p_xy00 = sum(counts(find( is_x0 & is_y0 ))) / big_N;
p_xy01 = sum(counts(find( is_x0 & is_y1 ))) / big_N;
p_xy10 = sum(counts(find( is_x1 & is_y0 ))) / big_N;
p_xy11 = sum(counts(find( is_x1 & is_y1 ))) / big_N;

avg_joint_logp = (        ...
  p_log_q(p_xy00, p_xy00) + ...
  p_log_q(p_xy01, p_xy01) + ...
  p_log_q(p_xy10, p_xy10) + ...
  p_log_q(p_xy11, p_xy11));

avg_indep_logp =  ...
  p_log_q(p_xy00, p_x0*p_y0) + ...
  p_log_q(p_xy01, p_x0*p_y1) + ...
  p_log_q(p_xy10, p_x1*p_y0) + ...
  p_log_q(p_xy11, p_x1*p_y1);
  
mi = avg_joint_logp - avg_indep_logp;

function x = p_log_q(p, q)
% Special handling for p==0
% TODO what about q==0? for KL divergence crossent term, i guess that doesnt happen...
if p==0
  x = 0;
else
  x = p*log2(q);
end

