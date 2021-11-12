function main(v_ref)
    close all
    %% Parameters (mm)
    % Robot
    rbt_width = 200;
    rbt_length = 200;
    wheel_radius = 85/2;
    wheel_distance = 170;
    sensor_interval = 17;
    n_sensors = 7;
    load('sensor_data.mat', 'sensor_data');
    
    % Map
    r = 500;

    % Control
    % --Lyapunov
    k1 = 0.01;
    k2 = 0.0002;
    k3 = 0.01;
    t_samp = 0.02;
    t_sensor = 0.0015;
    t_motor = t_samp - t_sensor;
    omega_ref = v_ref/r;
    n_ref = omega_ref*60/(2*pi);
    v = 0;
    omega = 0;
    [v_l, v_r] = vomega2lr(v, omega, wheel_distance);
    
    % --PID Motor
    % response
    num_dt = 20;
    t_seq = linspace(0, t_motor, num_dt);
    t_step = t_seq(2) - t_seq(1);
    
    % left
    kp_l = 0.02;
    ki_l = 0.06;
    kd_l = 0;
    err2_l = 0;
    int_l = 0;
    % right
    kp_r = 0.02;
    ki_r = 0.06;
    kd_r = 0;
    err2_r = 0;
    int_r = 0;
    
    %% Draw map
    draw_map();

    %% Starting states
    phi = pi/2;
    x_c = 1500;
    y_c = -100;

    %% Initialize storages
    e1_array = [];
    e2_array = [];
    e2_gt_array = [];
    e3_array = [];
    e3_gt_array = [];
    v_array = [];
    omega_array = [];
    v_left = [];
    v_right = [];
    v_left_ref = [];
    v_right_ref = [];
    x_c_array = [];
    y_c_array = [];
    phi_array = [];
    phi_R_array = [];
    
    %% Loop
    is_finish = 0;
    is_reached_F = 0;
    x_c_prev = x_c;
    y_c_prev = y_c;
    step = 0;
    while is_finish == 0
        step = step + 1;
        x_c_array = [x_c_array; x_c];
        y_c_array = [y_c_array; y_c];
        
        [x_sensor, y_sensor] = draw_agent(x_c, y_c, rbt_width, rbt_length, phi*180/pi);
        draw_agent_point(x_c, y_c, x_c_prev, y_c_prev);
        
        % Check completion
        if x_c_prev < 1000 && x_c >= 1000
            is_reached_F = 1;
        end
        if y_c_prev < 0 && y_c >= 0 && is_reached_F == 1
            is_finish = 1;
        end

        x_control = mean(x_sensor);
        y_control = mean(y_sensor);
        if x_control > -1000 && x_control < 1000
            omega_ref = 0;
        end

        [x_R, y_R, phi_R, is_exist] = find_R(x_sensor,y_sensor, x_control, y_control, x_c, y_c, phi);
        if is_exist == 0
            break
        end
        if isempty(v_array) == 0
            ds = v_array(end) * t_samp;
            e2_prev = e2_array(end);
        else
            ds = 0;
            e2_prev = 0;
        end
        [e1, e2, e2_gt, e3, e3_gt] = compute_error(x_control, y_control, phi, x_R, y_R, phi_R, sensor_interval, sensor_data, e2_prev, ds);
        disp([e3, e3_gt]);
        [v, omega] = compute_lyapunov(e1, e2_gt, e3, v_ref, omega_ref, k1, k2, k3);
        [v_l_ref, v_r_ref] = vomega2lr(v, omega, wheel_distance);
        
        v_l = v_l_ref;
        v_r = v_r_ref;
        [v, omega] = lr2vomega(v_l, v_r, wheel_distance);

        % Compute
        x_c_prev = x_c;
        y_c_prev = y_c;
        x_c = double(x_c + v*t_samp*cos(phi));
        y_c = double(y_c + v*t_samp*sin(phi));
        phi = double(phi + omega*t_samp);
        
        e1_array = [e1_array; double(e1)];
        e2_array = [e2_array; double(e2)];
        e2_gt_array = [e2_gt_array; double(e2_gt)];
        e3_array = [e3_array; double(e3)];
        e3_gt_array = [e3_gt_array; double(e3_gt)];
        v_array = [v_array; v];
        omega_array = [omega_array; omega];
        v_left = [v_left; v2rpm(v_l, wheel_radius)];
        v_right = [v_right; v2rpm(v_r, wheel_radius)];
        v_left_ref = [v_left_ref; v2rpm(v_l_ref, wheel_radius)];
        v_right_ref = [v_right_ref; v2rpm(v_r_ref, wheel_radius)];
        phi_array = [phi_array; double(phi)];
        phi_R_array = [phi_R_array; double(phi_R)];
    end
    
    num_steps = size(e2_array);
    num_steps = num_steps(1);
    x = 1:num_steps;
    x = x';
    
    figure
    hold on
    grid on
    plot(x*t_samp, e2_array, '-', 'LineWidth', 1, 'Color', 'r');
    xlabel('t(s)');
    ylabel('e2 (mm)');
    
    figure
    hold on
    grid on
    plot(x*t_samp, e2_array - e2_gt_array, '-', 'LineWidth', 1, 'Color', [0.1500 0.3250 0.0980]);
    xlabel('t(s)');
    ylabel('e2 error (mm)');
    
    figure
    hold on
    grid on
    plot(x*t_samp, e3_array - e3_gt_array, '-', 'LineWidth', 1, 'Color', [0.5500 0.5250 0.1980]);
    xlabel('t(s)');
    ylabel('e3 error (rad)');
    
    figure
    hold on
    grid on
    plot(x*t_samp, v_right, '-', 'LineWidth', 1, 'Color', [0.8500 0.3250 0.0980]);
    plot(x*t_samp, v_left, '-', 'LineWidth', 1, 'Color', [0.4660 0.6740 0.1880]);
    legend('Right', 'Left');
end