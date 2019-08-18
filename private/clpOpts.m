function options = clpOpts
    options.N       = 8;
    options.type    = 2;    % which parameterization is used
    options.S       = [];   % no controller structure
    options.gamma   = [];   % no robust stability constraint
    options.solver  = 'mosek';
    options.bisec   = 0;    % no golden section iteration
    options.verbose = 1;    % display solver information
    options.polish  = 0;    % remove tiny numbers in controller
    options.eps     = 8;    % rounding precision 1e-8;
end