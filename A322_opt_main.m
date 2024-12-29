clear all
close all
clc

% c_kink, taper, b_out, h_cruise, mach_cruise, to be initialized in class
% w_wing, to be initialized
% x_ref.cst = [0.2332    0.31314    0.2946    0.0874    0.3033  0.1664   0.3142 -0.1901   -0.1121    -0.4730    0.0701   -0.5134  0.0899 -0.0544];
x_ref.cst = [0.2332    0.12814    0.2946    0.0874    0.3033  0.1664   0.3142 -0.1901   -0.1121    -0.4730    0.0701   -0.5134  0.0899 -0.0544];
x_ref.sweep_le = 27.298;  % deg, Leading edge sweep angle
% x_ref.sweep_le = 45;  % deg, Leading edge sweep angle
x_ref.spar_f = 0.2;
x_ref.spar_r = 0.6;
x_ref.cl_cd = 16;  % From assignment
x_ref.w_wing = 5000;  % To be determined

ac_ref.structure.v_fuel = (15959 + 8250) / 1000;  %m3 
x_ref.w_fuel = ac_ref.structure.v_fuel * 1000 * 0.785;  % kg, Data from manual

derived.mtow = 73500;  % kg, Max Take-Off weight
derived.wing.c_fw = 6.07;  % m, Chord at fuselage-wing intersection, for initialization
derived.wing.c_tip = 1.5;  % m, Tip chord, for initialization
derived.wing.b_wing = 33.91;  % m, Wingspan, for initialization

ac_ref.engine.weight = 2331;  % kg
ac_ref.engine.y_rel = 0.338;  % m, Relative spawnwise nacelle location
ac_ref.engine.ct_ref = 1.688e-5;  % kg/Ns

ac_ref.structure.stringer_eff = 0.96;  % Stiffened panel efficiency factor
ac_ref.structure.mtow = 73500;

ac_ref.dim.w_fuse_half = 1.975;  % m, Half fuselage width
ac_ref.dim.v_fuse_tank = 8.25;  % m3, Volume of fuselage fuel tank

ac_ref.wing.b_in = 6.405;  % m, Inboard wingspan
ac_ref.wing.sweep_te = 0.1;  % deg, Trailing edge sweep
ac_ref.wing.twist_kink = -2.6;  % deg
ac_ref.wing.twist_tip = -2.1;  % deg
ac_ref.wing.incidence = 4.7;  % deg
ac_ref.wing.dihedral = 5.5;  % deg

ac_ref.perf.h_cruise = 11277.6;  % m, Cruise altitude
ac_ref.perf.v_cruise = 230.471;  % m/s, Cruise speed
ac_ref.perf.mach_mo = 0.82;  % Max operating Mach number
ac_ref.perf.range = 5000e3;  % m, Design range

% ac_ref.dry.weight = fill in after tests
cl_ref = 0.5346;
cd_ref = 0.024554284273866;
ac_ref.dry.cd = cl_ref / x_ref.cl_cd - cd_ref;

tic
opt = OptProcess(ac_ref, x_ref, derived);
% opt.discipline_loads()
% opt.discipline_strcutres()
opt.discipline_aerodynamics()
% opt.discipline_performance;

% opt.process_main(opt.x_array);
% opt.run;

Au = [0.2332    0.12814    0.2946    0.0874    0.3033  0.1664   0.3142] * 0.7;
Al = [-0.1901   -0.1121    -0.4730    0.0701   -0.5134  0.0899 -0.0544] * 0.7;

X = linspace(0,1,99)';      %points for evaluation along x-axis

[Xtu,Xtl,C] = D_airfoil2(Au,Al,X);

hold on
plot(Xtu(:,1),Xtu(:,2),'b');    %plot upper surface coords
plot(Xtl(:,1),Xtl(:,2),'b');    %plot lower surface coords
% plot(X,C,'r');                  %plot class function
daspect([1 1 1])
axis([0,1,-0.5,0.5]);


% opt.derived
% disp(opt.derived.isa)
% disp(opt.derived.wing)

fid = fopen('EMWET_package\A322_airfoil_norm_0.7.dat', 'r');
result = fscanf(fid, '%f %f', [2 Inf]);
plot(result(1, :), result(2, :))


% plot3(opt.planform.x, opt.planform.y, opt.planform.z, ...
%       opt.planform.x + opt.planform.chord, opt.planform.y, opt.planform.z, ...
%       opt.planform.x + opt.planform.chord .* opt.planform.spar_f, opt.planform.y, opt.planform.z, ...
%       opt.planform.x + opt.planform.chord .* opt.planform.spar_r, opt.planform.y, opt.planform.z)

% daspect([1 1 1])

% fid = fopen('EMWET_package\A322_airfoil_norm_0.7.dat', 'r');
% result = fscanf(fid, '%f %f', [2 Inf]);
% plot(result(1, :), result(2, :))

% for i = [0.02, 0.05, 0.08, 0.11]
%     % [~, c] = opt.squared_chord(opt.derived.wing.c_root, i * opt.derived.wing.b_half, opt.x.sweep_le, opt.ac_ref.wing.sweep_te, false)
%     [~, c] = opt.squared_chord(opt.x.c_kink, opt.ac_ref.wing.b_in - i * opt.derived.wing.b_half, opt.x.sweep_le, opt.derived.wing.sweep_te_o, true)
% end


% data = readtable('EMWET_package\A322.weight', 'FileType', 'text', 'HeaderLines', 4);
% y = data{:, 1};
% c = data{:, 2};
% 
% for i = 1:height(data)
%     plot([y(i) * opt.derived.wing.b_half * tand(opt.x.sweep_le), y(i) * opt.derived.wing.b_half * tand(opt.x.sweep_le) + c(i)] , [y(i), y(i)] * opt.derived.wing.b_half)
%     hold on
% end
% plot(opt.planform.x, opt.planform.y, ...
%      opt.planform.x + opt.planform.chord, opt.planform.y, ...
%      opt.planform.x + opt.planform.chord .* opt.planform.spar_f, opt.planform.y, ...
%      opt.planform.x + opt.planform.chord .* opt.planform.spar_r, opt.planform.y)


toc
