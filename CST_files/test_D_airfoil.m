%script to test function D_airfoil2

clear;
close all;
clc;


Au = [0.1963    0.1235    0.2849    0.0887    0.3375    0.1697    0.2773];         %upper-surface Bernstein coefficients
Al = [ -0.1824   -0.1140   -0.4443    0.0703   -0.5026    0.0883   -0.0517
];    %lower surface Bernstein coefficients


X = linspace(0,1,99)';      %points for evaluation along x-axis

[Xtu,Xtl,C] = D_airfoil2(Au,Al,X);

hold on
plot(Xtu(:,1),Xtu(:,2),'b');    %plot upper surface coords
plot(Xtl(:,1),Xtl(:,2),'b');    %plot lower surface coords
%plot(X,C,'r');                  %plot class function
axis([0,1,-1.5,1.5]);
