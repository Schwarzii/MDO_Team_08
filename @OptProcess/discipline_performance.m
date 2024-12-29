function w_fuel_req = discipline_performance(obj)
    %DISCIPLINE_PERFORMANCE 此处显示有关此函数的摘要
    %   此处显示详细说明
    
    ct_eta = exp(-(obj.derived.v_cruise - obj.ac_ref.perf.v_cruise)^2 / (2 * 70^2) - (obj.x.h_cruise - obj.ac_ref.perf.h_cruise)^2 / (2 * 2500^2));
    ct_trim = obj.ac_ref.engine.ct_ref / ct_eta * obj.const.g;  % N/Ns

    weight_ratio = 1 / exp(obj.ac_ref.perf.range * ct_trim / obj.derived.v_cruise / obj.x.cl_cd);
    w_fuel_req = (1 - 0.938 * weight_ratio) / (0.938 * weight_ratio) * obj.derived.mzfw;
    
    obj.coupling.w_fuel = w_fuel_req;

    disp(w_fuel_req)
end

