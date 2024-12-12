

function [out]=Start_polar(CL)
%% Aerodynamic solver setting

% Wing planform geometry 
%                x    y     z   chord(m)    twist angle (deg) 
%AC.Wing.Geom = [0     0     0     3.5         0;
%                0.9  14.5   0     1.4         0];

% Wing incidence angle (degree)
%AC.Wing.inc  = 0;   
            
            
% Airfoil coefficients input matrix
%                    | ->     upper curve coeff.                <-|   | ->       lower curve coeff.       <-| 
%AC.Wing.Airfoils   = [0.2171    0.3450    0.2975    0.2685    0.2893  -0.1299   -0.2388   -0.1635   -0.0476    0.0797;
%                      0.2171    0.3450    0.2975    0.2685    0.2893  -0.1299   -0.2388   -0.1635   -0.0476    0.0797];
                  
%AC.Wing.eta = [0;1];  % Spanwise location of the airfoil sections

% Viscous vs inviscid
%AC.Visc  = 1;              % 0 for inviscid and 1 for viscous analysis

% Flight Condition
%AC.Aero.V     = 68;            % flight speed (m/s)
%AC.Aero.rho   = 1.225;         % air density  (kg/m3)
%AC.Aero.alt   = 0;             % flight altitude (m)
%AC.Aero.Re    = 1.14e7;        % reynolds number (bqased on mean aerodynamic chord)
%AC.Aero.M     = 0.2;           % flight Mach number 
load("AC.mat");
AC.Aero.CL    = CL;          % lift coefficient - comment this line to run the code for given alpha%
% AC.Aero.Alpha = 2;             % angle of attack -  comment this line to run the code for given cl 


%% 


Res = Q3D_solver(AC);



% X_planf=[AC.Wing.Geom(1,4),AC.Wing.Geom(1,1),AC.Wing.Geom(2,1),AC.Wing.Geom(2,1)+AC.Wing.Geom(2,4),AC.Wing.Geom(1,4)];
% Y_planf=[AC.Wing.Geom(1,2),AC.Wing.Geom(1,2),AC.Wing.Geom(2,2),AC.Wing.Geom(2,2),AC.Wing.Geom(1,2)];

% figure 
% plot (Y_planf,X_planf)
% axis equal
% axis([min(Y_planf)-1 max(Y_planf)+1 min(X_planf)-1 max(X_planf)+1])
     
out=Res.CDwing;
     