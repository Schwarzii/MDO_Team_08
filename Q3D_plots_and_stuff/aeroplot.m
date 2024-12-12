%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Quasi-3D aerodynamic solver      
%
%       A. Elham, J. Mariens
%        
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Q3D_Start


X_planf=[AC.Wing.Geom(1,4),AC.Wing.Geom(1,1),AC.Wing.Geom(2,1),AC.Wing.Geom(2,1)+AC.Wing.Geom(2,4),AC.Wing.Geom(1,4)];
Y_planf=[AC.Wing.Geom(1,2),AC.Wing.Geom(1,2),AC.Wing.Geom(2,2),AC.Wing.Geom(2,2),AC.Wing.Geom(1,2)];
% there is something wrong with plotting this rn

figure 
plot(Y_planf,X_planf)
axis equal
axis([min(Y_planf)-1 max(Y_planf)+1 min(X_planf)-1 max(X_planf)+1])
saveas(gcf, fullfile('Q3D_plots_and_stuff/','planform.fig'));


figure
plot(Res.Section.Y,Res.Section.Cl,'r')
hold on
plot(Res.Wing.Yst,Res.Wing.cl,'bo')
legend("Wing CL spanwise distribution", "Section Cl spanwise distribution");
saveas(gcf, fullfile('Q3D_plots_and_stuff/','CL_b.fig'));


figure
plot(Res.Section.Y,Res.Section.Cd,'b')
hold on
plot(Res.Wing.Yst,Res.Wing.cdi,'r')
legend("Wing induced drag spanwise distribution", "Airfoil profile drag spanwise distribution");
saveas(gcf, fullfile('Q3D_plots_and_stuff/','CD_b.fig'));