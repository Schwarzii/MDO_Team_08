function discipline_aerodynamics(obj)
    %DISCIPLINE_AERODYNAMICS 此处显示有关此函数的摘要
    %   此处显示详细说明

    w_des = sqrt(obj.derived.mtow * obj.derived.mzfw);

    cd("Q3D_package\")
    [res, ~] = obj.q3d_solver_core('Aerodynamics', 1, 'cruise', w_des);
    cd(obj.main_path)
    
    if isnan(res.CDwing)
        obj.discipline_pass = false;
        disp('Viscous calculation failed')
    else
        disp([res.CLwing, res.CDwing])
        obj.coupling.cl_cd = res.CLwing / (res.CDwing + obj.ac_ref.dry.cd);
    end
end

