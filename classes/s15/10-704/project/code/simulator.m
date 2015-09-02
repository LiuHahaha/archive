% Runs the input simulation with each possible combination of input parameters.
% A short but surprisingly tricky-to-implement harness for simulations.
%
% Inputs:
%   sim_name - string indicating the name of the matlab function for running
%              the simulation; e.g., 'sim1', where sim1.m is a function file in
%              matlab's path
%   varargin - row cell array containing, for each argument to sim_name, a
%              a cell array of possible values;
%              e.g., if varargin =  [[1] [2]] [3], then simulator will run
%              sim_name(1,3) and sim_name(2, 3)
% Outputs:
%   res - row cell array containing, for each output of sim_name, the results
%         of that output from running sim_name on all possible combinations of
%         inputs

% simulator just initializes an empty input (which is built-up as
% sim_helper recurses), and then calls sim_helper
function res = simulator(sim_name, varargin)
  res = sim_helper(sim_name, cell(0, 1), varargin{:});
end

% sim_helper recursively does all the work
function res = sim_helper(sim_name, input, varargin)

  nout = nargout(sim_name);

  % base case (no remaining input arguments to add); run the simulation
  if length(varargin) == 0
    fh = str2func(sim_name);
    [res{1:nout}] = fh(input{:});
    return;
  end

  % allocate space to return each of the outputs
  for out_i = 1:nout
    res{out_i} = zeros(cellfun(@length, varargin));
  end

  % iterate over all values of the first remaining input, recursing each time
  tmp = cell(nout, length(varargin{1}) - 1); % for parfor classification
  parfor in_i = 1:length(varargin{1})

    new_res = sim_helper(sim_name, [input {varargin{1}{in_i}}], varargin{2:end});
    for out_i = 1:nout
      if numel(new_res{out_i}) > 1
        new_res{out_i} = reshape(new_res{out_i}, [1 size(new_res{out_i})]);
      end
      tmp{out_i,in_i} = new_res{out_i};
    end

  end

  idx = repmat({':'}, 1, length(varargin) - 1);
  for out_i = 1:nout
    for in_i = 1:length(varargin{1})
      res{out_i}(in_i, idx{:}) = tmp{out_i,in_i};
    end
  end
end
