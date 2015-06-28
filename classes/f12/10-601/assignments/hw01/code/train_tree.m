function [tree] = train_tree(X, Y, maxdepth)

J = size(X,2);
if J < maxdepth
  disp('maxdepth too high. setting to number of features.');
  maxdepth = J;
end

tree = cell(2^J +1, 1);   % bigger than necessary
curmax = 1;
curnode = 1;
tree{1} = struct('parent', -1, 'depth', 0);
queue = [1];

while size(queue,2) > 0

  curnode = queue(1);
  queue = queue(2:size(queue,2));

  is_nonterm = tree{curnode}.depth < maxdepth;
  tree{curnode}.is_nonterm = is_nonterm;

  if is_nonterm

    % Choose split var
    [used_vars,bla] = get_pathvars(tree, curnode);
    avail_vars = setdiff(1:J, used_vars);
    var = choose_split_variable(X, Y, avail_vars);
    tree{curnode}.variable = var;

    % Add child nodes
    leftchild = curmax + 1;
    rightchild= curmax + 2;
    curmax = curmax + 2;

    tree{curnode}.leftchild = leftchild;
    tree{curnode}.rightchild = rightchild;

    % Create child nodes
    tree{leftchild}  = struct('parent', curnode, 'depth', tree{curnode}.depth+1);
    tree{rightchild} = struct('parent', curnode, 'depth', tree{curnode}.depth+1);

    queue = [queue leftchild rightchild];

  else
    [y0 y1] = get_y_counts_at_node(tree, curnode, X, Y);
    tree{curnode}.y_counts = [y0 y1];
  end

end


