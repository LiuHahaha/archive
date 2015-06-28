function [vars,vals] = get_pathvars(tree, node)
% get variables going up the path to the root.

totdepth = tree{node}.depth;
curdepth = totdepth;
vars = zeros(totdepth, 1);
vals = zeros(totdepth, 1);
while curdepth>0
  cur = tree{node};
  par = tree{tree{node}.parent};
  myval = par.rightchild==node;   % LEFT is for value=0, RIGHT for value=1

  vars(curdepth) = par.variable;
  vals(curdepth) = myval;

  node = cur.parent;
  curdepth = curdepth - 1;
end


