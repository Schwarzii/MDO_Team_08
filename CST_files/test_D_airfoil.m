%script to test function D_airfoil2

clear;
close all;
clc;


Au = [2 2 2 1 1];         %upper-surface Bernstein coefficients
Al = [-4 -3 -2 -1 -1];    %lower surface Bernstein coefficients

X = linspace(0,1,99)';      %points for evaluation along x-axis

[Xtu,Xtl,C] = D_airfoil2(Au,Al,X);

hold on
plot(Xtu(:,1),Xtu(:,2),'b');    %plot upper surface coords
plot(Xtl(:,1),Xtl(:,2),'b');    %plot lower surface coords
%plot(X,C,'r');                  %plot class function
axis([0,1,-1.5,1.5]);
