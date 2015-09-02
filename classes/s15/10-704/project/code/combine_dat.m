lags = 1:3

name_base = 'MI_sim';

mMIs = zeros(10, 0);
mTEs = zeros(10, 0);
mMIRs = zeros(10, 0);
sMIs = zeros(10, 0);
sTEs = zeros(10, 0);
sMIRs = zeros(10, 0);

for lag = lags

  name = sprintf('%s_lag_%d', name_base, lag);
  load(name);

  mMIs = [mMIs mMI_p];
  mTEs = [mTEs mTE_p];
  mMIRs = [mMIRs mMIR_p];
  sMIs = [sMIs sMI_p];
  sTEs = [sTEs sTE_p];
  sMIRs = [sMIRs sMIR_p];

end
