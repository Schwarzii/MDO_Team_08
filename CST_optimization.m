close all;
clc;
clear all;

addpath(genpath(fullfile(pwd, 'CST_files/'))); % adds CST stuff to another folder for better organization

% This script shows the implementation of the CST airfoil-fitting
% optimization of MDO Tutorial 1

M = 14;  %Number of CST-coefficients in design-vector x

%Define optimization parameters
%x0 = 0.5*ones(M,1);     %initial value of design vector x(starting vector for search process)
%x0(floor(M/2)+1:end) = -x0(floor(M/2)+1:end);
x0 = [0.23 0.14 0.26 .15 .24 .28 0.24 -0.18 -0.18 -0.33 -0.18 -0.18 -0.18 0];
lb = -3*ones(M,1);    %upper bound vector of x
ub = 3*ones(M,1);     %lower bound vector of x

options=optimset('Display','Iter');

tic
%perform optimization
[x,fval,exitflag] = fmincon(@CST_objective,x0,[],[],[],[],lb,ub,[],options);
t=toc;
disp(sqrt(fval / 163));

M_break=M/2;
N = 200;
epsilon = 1e-5;  % Small value to avoid log(0)
X_vect = logspace(log10(epsilon), 0, N)';  % Logarithmic distribution from epsilon to 1
X_vect = X_vect - epsilon;  % Shift to start from 0
% Split the x vector into upper and lower surface coordinates
Aupp_vect=x(1:M_break);
Alow_vect=x(1+M_break:end);
% Call the airfoil function
[Xtu,Xtl,C,Thu,Thl,Cm] = D_airfoil2(Aupp_vect,Alow_vect,X_vect);

% Plot the upper and lower surface coordinates
hold on
plot(Xtu(:,1),Xtu(:,2),'b');    %plot upper surface coords
plot(Xtl(:,1),Xtl(:,2),'b');    %plot lower surface coords

% Plot the class function (red)
plot(X_vect,C,'r');                  %plot class function
axis([0,1,-1.5,1.5]);

% Set axis limits
axis([0, 1, -1.5, 1.5]);

% Read the coordinates from the file
fid= fopen('A320-200_rearranged.dat','r'); % Filename can be changed as required
Coor = fscanf(fid,'%g %g',[2 Inf]) ; 
fclose(fid) ; 

% Plot the coordinates from the file (red 'x' markers)
plot(Coor(1,:),Coor(2,:),'rx')

% Add legend
legend('Upper Surface', 'Lower Surface', 'Class Function', 'Rearranged Data Points', 'Location', 'best');

% Display grid for better visualization
grid on;