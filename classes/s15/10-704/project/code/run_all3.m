lags = 3:3;

for lag = lags

  TE_sim;
  save(name, 'mTE_p', 'mMI_p', 'mMIR_p', 'sTE_p', 'sMI_p', 'sMIR_p');
  MI_sim;
  save(name, 'mTE_p', 'mMI_p', 'mMIR_p', 'sTE_p', 'sMI_p', 'sMIR_p');
  all_sim;
  save(name, 'mTE_p', 'mMI_p', 'mMIR_p', 'sTE_p', 'sMI_p', 'sMIR_p');

end
