function [x_opt, optimum, exit_flag, output] = run(obj)
    %RUN 此处显示有关此函数的摘要
    %   此处显示详细说明

    %bounds
    bound.cst = {[], []};
    bound.sweep_le = {0.1, 45};
    bound.spar_f = {0.15, 0.5};
    bound.spar_r = {0.55, 0.6};
    bound.b_out = {5, 15};
    bound.c_kink = {3, 5};
    bound.taper = {0.1, 0.5};
    bound.h_cruise = {0.9 * obj.ac_ref.perf.h_cruise, 1.1 * obj.ac_ref.perf.h_cruise};
    bound.mach_cruise = {0.9 * obj.ac_ref.perf.mach_cruise, 1.1 * obj.ac_ref.perf.mach_cruise};

    bound.cl_cd = {12, 18};
    bound.w_wing = {3000, 7000};
    bound.w_fuel = {16000, 20000};
    
    lb = [];
    ub = [];

    bound_var = fieldnames(bound);
    for i = 1:length(bound_var)
        lb = cat(2, lb, bound.(bound_var{i}){1, 1});
        ub = cat(2, ub, bound.(bound_var{i}){1, 2});
    end
    
    
    % Options for the optimization
    options.Display         = 'iter-detailed';
    options.Algorithm       = 'sqp';
    options.FunValCheck     = 'off';
    options.DiffMinChange   = 1e-6;         % Minimum change while gradient searching
    options.DiffMaxChange   = 5e-2;         % Maximum change while gradient searching
    options.TolCon          = 1e-6;         % Maximum difference between two subsequent constraint vectors [c and ceq]
    options.TolFun          = 1e-6;         % Maximum difference between two subsequent objective value
    options.TolX            = 1e-6;         % Maximum difference between two subsequent design vectors
    
    options.MaxIter         = 30;           % Maximum iterations
    
    tic;
    [x_opt, optimum, exit_flag, output] = fmincon(obj.process_main, obj.x_array, [], [], [], [], lb, ub, obj.constraints, options);
    toc;
end

