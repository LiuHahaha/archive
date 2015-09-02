for i=1:3,

  if i == 1
    ylabel('power');
  end

  ax = subplot(3, 3, 3*num + i); hold all;
  errorbar(1:10, mTEs(:, i), sTEs(:, i), 'linewidth', 2);
  errorbar(1:10, mMIs(:, i), sMIs(:, i), 'linewidth', 2);
  errorbar(1:10, mMIRs(:, i), sMIRs(:, i), 'linewidth', 2);

  axis(ax, [0 11 0 1]);

end
