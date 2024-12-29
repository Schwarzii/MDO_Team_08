function discipline_strcutres(obj)
    %DIS_STRCUTRES 此处显示有关此函数的摘要
    %   此处显示详细说明
    init_file = fopen('EMWET_package\A322.init', 'w');

    fprintf(init_file, '%g %g \n', obj.derived.mtow, obj.derived.mzfw);
    fprintf(init_file, '%g \n', obj.const.perf.n_max);
    
    fprintf(init_file, '%g %g %g %g \n', obj.derived.wing.s_wing, obj.derived.wing.b_wing, 3, 2);
    
    airfoil_file = 'A322_airfoil_norm';
    % airfoil_file = 'b737a';
    fprintf(init_file, '%i %s \n', 0, airfoil_file);
    fprintf(init_file, '%i %s \n', 1, airfoil_file);
    
    fprintf(init_file, '%g %g %g %g %g %g \n', obj.planform.emwet);
    
    fprintf(init_file, '%g %g \n', obj.ac_ref.dim.w_fuse_half / obj.derived.wing.b_half, obj.const.tank.y_end_loc);
    
    fprintf(init_file, '%g \n', 1);
    fprintf(init_file, '%g  %g \n', obj.ac_ref.engine.y_rel, obj.ac_ref.engine.weight);
    
    for i = 1:4
        fprintf(init_file, '%g %g %g %g \n', obj.const.material.modulus, obj.const.material.rho_al, obj.const.material.sigma_y, obj.const.material.sigma_y);
    end
    
    fprintf(init_file,'%g %g \n', obj.ac_ref.structure.stringer_eff, obj.const.structure.rib_pitch);
    fprintf(init_file,'0 \n');

    fclose(init_file);
    
    cd("EMWET_package\")
    EMWET A322

    emwet_out = fopen("A322.weight");
    obj.coupling.w_wing = str2double(extractAfter(fgetl(emwet_out), "Wing total weight(kg) "));
    fclose(emwet_out);

    disp(obj.coupling.w_wing)

    cd(obj.main_path)
end

