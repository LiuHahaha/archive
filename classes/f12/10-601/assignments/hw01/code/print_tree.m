function print_tree(tree)

% Lame approach
% for node=1:size(tree,1)
%   disp(node);
%   disp(tree{node});
% end

% DFS
recurs_print_node2(tree, 1, -1, -1, '');

end

function s = recurs_print_node2(tree, node, parvar, parvalue, prevline)

if parvar==-1
  s = prevline;
else
  s = sprintf('%s V%d=%d', prevline, parvar, parvalue);
end

if tree{node}.is_nonterm
  disp(s);
  v = tree{node}.variable;
  recurs_print_node2(tree, tree{node}.leftchild,  v,0, s);
  recurs_print_node2(tree, tree{node}.rightchild, v,1, s);
else
  yc = tree{node}.y_counts;
  dec = yc(2) > yc(1);
  s = sprintf('%s        => decide Y=%d, counts [%d %d]', s, dec, yc(1), yc(2));
  disp(s)
end

end

