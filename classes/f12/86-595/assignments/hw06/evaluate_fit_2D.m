% USAGE: [r2]=evaluate_fit_2D(vhat,v)
% vhat: Your estimated velocities (as a cell array)
% v: The real arm velocities (also a cell array)

function [r2]=evaluate_fit_2D(vhat,v)

SE=[]; STOT=[];
for i=1:length(vhat)
    SE=[SE;(vhat{i}(:)-v{i}(:)).^2];
    STOT=[STOT;(v{i}(:).^2)];
end

SSE=sum(SE); SSTOT=sum(STOT);
r2=1-SSE/SSTOT;

return