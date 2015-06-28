function [num_y0, num_y1] = get_y_counts_at_node(tree, node, X, Y)

% compute the counts via a conjunction down the path.
% yes, this could be done more efficiently with smarter datastructures
% by caching the dataset at each node and reusing.

[vars,values] = get_pathvars(tree, node);
[num_y0, num_y1] = get_y_counts_for_conjunction(vars,values, X, Y);
