close all;
clc;
clear;

%This script performs the optimization of the file CST_optimization.m 20
%times, with an increasing number of CST-coefficients in the design-vector
%x (parameter M increases). This allows to compare the effect of increasing CST-order on the best
%achievable airfoil curve fit (lowest possible error).

%BE AWARE - Running this script takes considerable time (5 ~ 10 minutes)

for i=2:14
i
%Define optimization parameters
x0 = 0*ones(2*i,1);     %initial value of design vector x(starting vector for search process)
lb = -1*ones(2*i,1);    %upper bound vector of x
ub = 1*ones(2*i,1);     %lower bound vector of x

tic
%perform optimization
[x,fval,exitflag] = fmincon(@CST_objective,x0,[],[],[],[],lb,ub);

time(i)=toc;
%Store output optimized fitting-error value
F(i) = fval;

end

figure
