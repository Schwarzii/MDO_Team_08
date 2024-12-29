function [c, consistency] = constraints(obj, x)
    %CONSTRAINTS 此处显示有关此函数的摘要
    %   此处显示详细说明
    
    opt_mtow = obj.ac_ref.dry.weight + obj.coupling.w_fuel + obj.coupling.w_wing;
    c_w = opt_mtow - obj.ac_ref.structure.mtow;

    c_n = opt_mtow / obj.derived.wing.s_wing - obj.ac_ref.structure.wing_loading;
    
    v_wing_tank = 1000;
    c_v = obj.coupling.w_fuel / obj.const.perf.rho_fuel - v_wing_tank * obj.const.tank.v_fraction - obj.ac_ref.dim.v_fuse_tank;

    c = [c_w, c_n, c_v];

    consistency = [obj.coupling.cl_cd - x(end-2), obj.coupling.w_fuel - x(end-1), obj.coupling.w_wing - x(end)];
end

