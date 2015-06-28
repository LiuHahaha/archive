function preds = dualSVMPredict(params, ks)
  preds = (params.beta - params.gamma)'*ks;
end
