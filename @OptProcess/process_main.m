function emission_kg = process_main(obj, x)
    %OPT_PROCESS 此处显示有关此函数的摘要
    %   此处显示详细说明

    obj.x.cst = x(1:14);
    x = x(15:end);
    design_var = fieldnames(obj.x);
    for i = 2:length(design_var)
        obj.x.(design_var{i}) = x(i -1);
    end

    obj.update_derived_params;
    
    obj.discipline_loads;
    obj.discipline_strcutres;
    obj.discipline_aerodynamics;
    w_fuel_req = obj.discipline_performance;
    
    if obj.discipline_pass
        emission_kg = obj.const.perf.emission * w_fuel_req;
    else
        emission_kg = Inf;
    end
end

