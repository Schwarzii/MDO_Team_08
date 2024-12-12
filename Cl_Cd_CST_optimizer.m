clear
addpath(genpath(fullfile(pwd, 'Q3D_plots_and_stuff/'))); % Add CST stuff for better organization

% Load the data from previous runs
load("Res.mat");
load("AC.mat");

% Define the objective function
obj_fun = @(x) CST_objective(x, AC);

% Initial guess (x0), which is AC.Wing.Airfoils
x0 = AC.Wing.Airfoils(1,:);


% Calculate lower and upper bounds based on conditions
lb = arrayfun(@(v) 0.8 * v * (v > 0) + 1.2 * v * (v <= 0), x0);  % If x0(i) > 0, multiply by 0.8, otherwise by 1.2
ub = arrayfun(@(v) 1.2 * v * (v > 0) + 0.8 * v * (v <= 0), x0);  % If x0(i) > 0, multiply by 1.2, otherwise by 0.8


% Set options for the fmincon optimizer
options = optimset('Display', 'iter','DiffMinChange', 1e-4);  % Display iteration information

% Run the optimizer
tic
[x, fval, exitflag] = fmincon(@(x) obj_fun(x), x0, [], [], [], [], lb, ub, [], options);
t = toc;

% Display the results
disp('Optimized x:');
disp(x);
disp('Objective function value (fval):');
disp(fval);
disp('Exit flag:');
disp(exitflag);
disp(['Optimization took ' num2str(t) ' seconds.']);

% --- Define the CST_objective function ---
function f = CST_objective(x, AC)
    % Update the Airfoils with the new x
    AC.Wing.Airfoils = [x; x];  % x needs to be used for both upper and lower curves

    % Call Q3D_solver(AC) to run the solver (make sure Q3D_solver updates Res)
    Res = Q3D_solver(AC);  % This should update Res.CLwing and Res.CDwing

    % Return the objective function value (CLwing/CDwing)
    f = Res.CDwing / Res.CLwing;
end
