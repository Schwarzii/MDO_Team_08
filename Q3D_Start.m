%% Aerodynamic solver setting
clear all
close all
clc

% Wing planform geometry 
%                x    y     z   chord(m)    twist angle (deg) 
AC.Wing.Geom = [0     0     0     7.1334        0;
                6.45 * tan(deg2rad(28.3))  6.45  6.45 * tan(deg2rad(5.5))     3.66 + 6.45 * tan(deg2rad(0.1))          -2.6;
                17.05 * tan(deg2rad(28.3)) 17.05    17.05 * tan(deg2rad(5.5))     1.5        -2.1];

% Wing incidence angle (degree)
AC.Wing.inc  = 4.7;   
            
            
% Airfoil coefficients input matrix
%                    | ->     upper curve coeff.                <-|   | ->       lower curve coeff.       <-| 
AC.Wing.Airfoils   = [0.2332    0.31314    0.2946    0.0874    0.3033  1.664   0.3142 -0.1901   -0.1121    -0.4730    0.0701   -0.5134  0.0899 -0.0544;
                      0.2332    0.31314    0.2946    0.0874    0.3033  1.664   0.3142 -0.1901   -0.1121    -0.4730    0.0701   -0.5134  0.0899 -0.0544];
                  
AC.Wing.eta = [0;1];  % Spanwise location of the airfoil sections

% Viscous vs inviscid
AC.Visc  = 0;              % 0 for inviscid and 1 for viscous analysis
AC.Aero.MaxIterIndex = 150;    %Maximum number of Iteration for the
                                %convergence of viscous calculation
                                
V = 150;
M = V * sqrt(1.4 * 287.15 * 217);
% Flight Condition
AC.Aero.V     = V;            % flight speed (m/s)
AC.Aero.rho   = 0.34984;         % air density  (kg/m3)
AC.Aero.alt   = 11277.6;             % flight altitude (m)
AC.Aero.Re    = 1e7;        % reynolds number (bqased on mean aerodynamic chord)
AC.Aero.M     = M;           % flight Mach number 
% AC.Aero.CL    = 3;          % lift coefficient - comment this line to run the code for given alpha%
AC.Aero.CL    = 0.5458;          % lift coefficient - comment this line to run the code for given alpha%
% AC.Aero.Alpha = -4.29;             % angle of attack -  comment this line to run the code for given cl 


%% 
tic

Res = Q3D_solver(AC);

toc