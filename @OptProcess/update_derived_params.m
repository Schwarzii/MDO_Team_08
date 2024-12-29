function update_derived_params(obj)
    %UPDATE_DERIVED_PARAMS 此处显示有关此函数的摘要
    %   此处显示详细说明
    disp('updating')
    obj.derived.wing.b_half = obj.x.b_out + obj.ac_ref.wing.b_in;
    obj.derived.wing.b_wing = obj.derived.wing.b_half * 2;
    obj.derived.wing.c_tip = obj.x.c_kink * obj.x.taper;
    [obj.derived.wing.mac, obj.derived.wing.s_wing, ...
        obj.derived.wing.c_root, obj.derived.wing.sweep_te_o, obj.derived.wing.ar] = obj.wing_mac(obj.x.c_kink, obj.derived.wing.c_tip, ...
                obj.x.sweep_le, obj.ac_ref.wing.sweep_te, ...
                obj.ac_ref.wing.b_in, obj.x.b_out);

    [~, obj.derived.isa.a, ~, obj.derived.isa.rho, obj.derived.isa.nu, ~] = atmosisa(obj.x.h_cruise);
    obj.derived.v_cruise = obj.x.mach_cruise * obj.derived.isa.a;

    obj.derived.mtow = obj.ac_ref.dry.weight + obj.x.w_fuel + obj.x.w_wing;
    obj.derived.mzfw = obj.derived.mtow - obj.x.w_fuel;

    obj.compute_wing_planform();
end


