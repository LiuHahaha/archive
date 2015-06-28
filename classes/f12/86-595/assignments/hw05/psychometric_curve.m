% USAGE: y=psychometric_curve([alpha,beta],X)
% returns y=1-.5*exp(-(X/alpha).^beta);
% Note that alpha and beta are passed as a single coefficient vector.
% Also, alpha and beta must be scalars.
%
% To fit a psychometric curve, call:
% params=nlinfit(X,y,@psychometric_curve,params_guess);
% A good guess for the parameters is beta=1 and alpha=coherence for near
% 75 percent correct, whatever that happens to be.

function y=psychometric_curve(coeffs,x)

alpha=coeffs(1); beta=coeffs(2);
y=1-.5*exp(-(x/alpha).^beta);

return