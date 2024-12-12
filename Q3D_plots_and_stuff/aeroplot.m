%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Quasi-3D aerodynamic solver      
%
%       A. Elham, J. Mariens
%        
% 
%MODIFIED by: F. Oliviero for the execution of the exercise 1 of the
%tutorial 5 (AY 2018-2019)
% Routine for plotting planfrom, lift and drag disributions
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Q3D_Start_Exercise3


X_planf=[AC.Wing.Geom(1,4),AC.Wing.Geom(1,1),AC.Wing.Geom(2,1),AC.Wing.Geom(2,1)+AC.Wing.Geom(2,4),AC.Wing.Geom(1,4)];
Y_planf=[AC.Wing.Geom(1,2),AC.Wing.Geom(1,2),AC.Wing.Geom(2,2),AC.Wing.Geom(2,2),AC.Wing.Geom(1,2)];

figure 
plot (Y_planf,X_planf)
axis equal
axis([min(Y_planf)-1 max(Y_planf)+1 min(X_planf)-1 max(X_planf)+1])


figure
plot(Res.Section.Y,Res.Section.Cl,'r')
hold on
plot(Res.Wing.Yst,Res.Wing.cl,'bo')



figure
plot(Res.Section.Y,Res.Section.Cd,'b')
hold on
plot(Res.Wing.Yst,Res.Wing.cdi,'r')