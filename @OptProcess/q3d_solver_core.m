function [res, dynamic_pressure] = q3d_solver_core(obj, thread_name, visc, v_condition, weight_des)
    %Q3D_SOLVER_CORE 此处显示有关此函数的摘要
    %   此处显示详细说明

    if strcmp(v_condition, 'cruise')
        use_v = obj.derived.v_cruise;
        use_mach = obj.x.mach_cruise;
    else
        use_v = obj.ac_ref.perf.v_mo;
        use_mach = obj.ac_ref.perf.mach_mo;
    end
    dynamic_pressure = obj.derived.isa.rho * use_v^2 / 2;

    cl_des = 1 / (dynamic_pressure * obj.derived.wing.s_wing) * (weight_des * obj.const.g);
    reynolds = use_v * obj.derived.wing.mac / obj.derived.isa.nu;

    % Wing planform geometry 
    %               x                 y           z               chord(m)                  twist angle (deg) 
    AC.Wing.Geom = obj.planform.q3d;
    
    % Wing incidence angle (degree)
    AC.Wing.inc  = obj.ac_ref.wing.incidence;   
                
                
    % Airfoil coefficients input matrix
    %                    | ->     upper curve coeff.                <-|   | ->       lower curve coeff.       <-| 
    AC.Wing.Airfoils   = repmat(obj.x.cst, 2, 1);
                      
    AC.Wing.eta = [0; 1];  % Spanwise location of the airfoil sections
    
    % Viscous vs inviscid
    AC.Visc  = visc;              % 0 for inviscid and 1 for viscous analysis
    AC.Aero.MaxIterIndex = 300;    %Maximum number of Iteration for the
                                    %convergence of viscous calculation
                                    
    % Flight Condition
    AC.Aero.V     = use_v;            % flight speed (m/s)
    AC.Aero.rho   = obj.derived.isa.rho;         % air density  (kg/m3)
    AC.Aero.alt   = obj.x.h_cruise;             % flight altitude (m)
    AC.Aero.Re    = reynolds;        % reynolds number (bqased on mean aerodynamic chord)
    AC.Aero.M     = use_mach;           % flight Mach number 
    AC.Aero.CL    = cl_des;          % lift coefficient - comment this line to run the code for given alpha%
    % AC.Aero.Alpha = -4.29;             % angle of attack -  comment this line to run the code for given cl 
    
    disp("Q3D solver -> " + thread_name)
    tic
    try
        res = Q3D_solver(AC);
    catch error
        % success = 0;
        disp('Viscous calculation failed')
    end
    toc
    
end

