classdef OptProcess < handle
    %DISCIPLINES 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        const;  % Parameters prescribed by the assignment
        ac_ref;  % Parameters from the reference aircraft
        derived;  % Derived parameters
        planform;  % Geometry parameters of the wing planform

        x;  % Design vector
        x_var = {'cst', 'sweep_le', 'spar_f', 'spar_r', 'b_out', 'c_kink', 'taper', 'h_cruise', 'mach_cruise', 'cl_cd', 'w_wing', 'w_fuel'};  % Order of design variables
        coupling;  % Coupling variables
        output;  % Additional parameters required to report

        q3d_pass = true;  % If viscous calculation fails
        main_path = pwd;  % Path of main working directory
    end

    properties (Dependent)
        x_array;  % Design vector in array form
    end
    
    methods
        function obj = OptProcess(ac_ref, x_ref, derived)
            %DISCIPLINES 构造此类的实例
            %   此处显示详细说明
            obj.const.material.modulus = 70e9;  % N/m2
            obj.const.material.sigma_y = 295e6;  % N/m2, Same for tension and compression
            obj.const.material.rho_al = 2800;  % kg/m3
            obj.const.structure.rib_pitch = 0.5;  % m
            obj.const.perf.n_max = 2.5;
            obj.const.perf.rho_fuel = 0.81715e3;  % kg/m3
            obj.const.perf.emission = 3.16;  % Fuel weight to CO2 emission
            obj.const.tank.y_end_loc = 0.85;  % Relative span of wing fuel tank
            obj.const.tank.v_fraction = 0.93;  % Usable wing fuel tank volume fraction
            obj.const.g = 9.80665;
            
            obj.ac_ref = ac_ref;
            obj.x = x_ref;
            obj.derived = derived;
            
            obj.derived.wing.b_half = derived.wing.b_wing / 2;
            obj.ac_ref.wing.b_iw = ac_ref.wing.b_in - ac_ref.dim.w_fuse_half;
            obj.x.b_out = obj.derived.wing.b_half - ac_ref.wing.b_in;
            obj.derived.wing.c_root = derived.wing.c_fw - ac_ref.dim.w_fuse_half * (tand(ac_ref.wing.sweep_te) - tand(x_ref.sweep_le));
            [obj.derived.wing.mac, obj.derived.wing.s_wing, ...
                obj.x.c_kink, obj.derived.wing.sweep_te_o, obj.derived.wing.ar] = obj.wing_mac(obj.derived.wing.c_root, derived.wing.c_tip, ...
                x_ref.sweep_le, ac_ref.wing.sweep_te, ...
                ac_ref.wing.b_in, obj.x.b_out, 1);  % Ref MAC = 4.29 m -> 4.3587, Ref S = 122.4 -> 126.0771
            obj.x.taper = obj.derived.wing.c_tip / obj.x.c_kink;

            obj.x.h_cruise = obj.ac_ref.perf.h_cruise;
            [~, obj.derived.isa.a, ~, obj.derived.isa.rho, obj.derived.isa.nu, ~] = atmosisa(obj.x.h_cruise);
            obj.x.mach_cruise = obj.ac_ref.perf.v_cruise / obj.derived.isa.a;
            obj.derived.v_cruise = ac_ref.perf.v_cruise;
            obj.ac_ref.perf.mach_cruise = obj.x.mach_cruise;
            obj.ac_ref.perf.v_mo = obj.ac_ref.perf.mach_mo * obj.derived.isa.a;

            obj.derived.mzfw = derived.mtow - obj.x.w_fuel;
            obj.ac_ref.dry.weight = derived.mtow - obj.x.w_fuel - obj.x.w_wing;  % Update after running the performance evaluation and EMWET
            obj.ac_ref.structure.wing_loading = derived.mtow / obj.derived.wing.s_wing;  % 585.3118 kg/m2

            obj.compute_wing_planform();
            
            obj.x = orderfields(obj.x, obj.x_var);
        end
        %%
        function compute_wing_planform(obj)
            obj.planform.x = [0, obj.ac_ref.wing.b_in * tand(obj.x.sweep_le), obj.derived.wing.b_half * tand(obj.x.sweep_le)];
            obj.planform.y = [0, obj.ac_ref.wing.b_in, obj.derived.wing.b_half];
            obj.planform.z = [0, obj.ac_ref.wing.b_in * tand(obj.ac_ref.wing.dihedral), obj.derived.wing.b_half * tand(obj.ac_ref.wing.dihedral)];
            obj.planform.chord = [obj.derived.wing.c_root, obj.x.c_kink, obj.derived.wing.c_tip];
            obj.planform.twist = [0, 0, 0];
            % obj.planform.twist = [0, obj.ac_ref.wing.twist_kink, obj.ac_ref.wing.twist_tip];

            [~, unkinked_root] = obj.squared_chord(obj.x.c_kink, obj.ac_ref.wing.b_in, obj.x.sweep_le, obj.derived.wing.sweep_te_o, true);
            f_spar_root_loc = obj.x.spar_f * unkinked_root / obj.derived.wing.c_root;
            obj.planform.spar_f = [f_spar_root_loc, obj.x.spar_f, obj.x.spar_f];
            obj.planform.spar_r = ones(1, 3) * obj.x.spar_r;
            
            obj.planform.q3d = [obj.planform.x; obj.planform.y; obj.planform.z; obj.planform.chord; obj.planform.twist].';
            obj.planform.emwet = [obj.planform.chord; obj.planform.x; obj.planform.y; obj.planform.z; obj.planform.spar_f; obj.planform.spar_r];
        end
        %%
        function x = get.x_array(obj)
            extract_x = struct2cell(obj.x);
            x = [extract_x{:}];
        end
    end
    
    methods(Static)
        function [mac, s_wing, c_out, sweep_te_o, ar] = wing_mac(c_char, c_tip, sweep_le, sweep_te_i, b_i, b_o, ~)
            if nargin == 7  % Input c_root -> return c_kink
                [c_sq_i, c_kink] = OptProcess.squared_chord(c_char, b_i, sweep_le, sweep_te_i, false);
                c_root = c_char;
                c_out = c_kink;
                disp('input c_root')
            else  % Input c_kink -> return c_root
                [c_sq_i, c_root] = OptProcess.squared_chord(c_char, b_i, sweep_le, sweep_te_i, true);
                c_kink = c_char;
                c_out = c_root;
                disp('input c_kink -> ')
                disp([c_out, c_root])
            end
            sweep_te_o = atand((c_tip - c_kink) / b_o + tand(sweep_le));  % deg
            [c_sq_o, ~] = OptProcess.squared_chord(c_kink, b_o, sweep_le, sweep_te_o, false);
            % disp('tip chords, sweep_te_o')
            % disp([c_tip, c_tip_check, rad2deg(sweep_te_o)])

            s_wing = (c_root + c_kink) * b_i + (c_kink + c_tip) * b_o;  % m2, Area of ENTIRE wing
            ar = ((b_i + b_o) * 2)^2 / s_wing;
            mac = 2 / s_wing * (c_sq_i + c_sq_o);
        end
        %%
        function [c_sq, c_out] = squared_chord(c, span, sweep_le, sweep_te, input_short)
            sweep_coe = tand(sweep_te) - tand(sweep_le);
            if input_short
                c_short = c;
                c_long = c_short - span * sweep_coe;
                c_out = c_long;
            else
                c_long = c;
                c_short = c_long + span * sweep_coe;
                c_out = c_short;
            end
            c_sq = c_long^2 * span + sweep_coe * c_long * span^2 + sweep_coe^2 / 3 * span^3;
        end
    end
end

