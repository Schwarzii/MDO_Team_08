function load_dis = discipline_loads(obj)
    % Loads discipline
    % Inviscid calculation mode
    
    cd("Q3D_package\")
    [res, dynamic_pressure] = obj.q3d_solver_core('Loads', 0, 'mo', obj.derived.mtow * obj.const.perf.n_max);
    cd(obj.main_path)
    
    normalized_y = (res.Wing.Yst / obj.derived.wing.b_half).';
    lift = (res.Wing.ccl * dynamic_pressure).';
    moment = (res.Wing.cm_c4 .* res.Wing.chord * dynamic_pressure).';
    load_write = [normalized_y; lift; moment];
    
    load_file = fopen('EMWET_package\A322.load', 'w');
    fprintf(load_file, '%.4f %.4f %.4f\n', load_write);
    fclose(load_file);

    % figure
    % plot(normalized_y, lift, normalized_y, moment)

    load_dis = load_write;
    
end

