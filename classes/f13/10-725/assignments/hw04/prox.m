function [beta] = prox(z, lam)
% accept input n-by-1 z (or, actually, y) and scalar lam 
% output n-by-1 beta
% before calling this function, please run 
% $ mex prox_matlab.cpp 
% in matlab to compile the dependency.

beta = prox_matlab([], double(z(:)), double(lam(:)));
