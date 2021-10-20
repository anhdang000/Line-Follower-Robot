function main(v_ref)
    close all
    %% Parameters (mm)
    % Robot
    width = 200;
    length = 200;
    wheel_radius = 85/2;
    wheel_distance = 170;
    sensor_length = 133;

    % Map
    r = 500;

    % Control
    t_samp = 0.02;
    k1 = 0.001;
    k2 = 0.0003;
    k3 = 0.001;
    omega_ref = v_ref/r;

    %% Draw map
    subplot(1, 2, 1);
    draw_map();
    subplot(1, 2, 2);
    draw_map();

    %% Starting states
    phi = pi/2;
    x_c = 1500;
    y_c = 0;
%     phi = 5.4325;
%     x_c = -1398.6;
%     y_c = -323.0184;
    

    %% Initialize storages
    e1_array = [];
    e2_array = [];
    e3_array = [];
    v_array = [];
    omega_array = [];
    v_left = [];
    v_right = [];
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
        disp(step);
        x_c_array = [x_c_array; x_c];
        y_c_array = [y_c_array; y_c];
        subplot(1,2,1);
        [x_sensor, y_sensor] = draw_agent(x_c, y_c, width, length, phi*180/pi);
        subplot(1,2,2);
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
        [e1, e2, e3] = compute_error(x_control, y_control, phi, x_R, y_R, phi_R);
        [v, omega] = compute_lyapunov(e1, e2, e3, v_ref, omega_ref, k1, k2, k3);
        
        % Compute 
        x_c_prev = x_c;
        y_c_prev = y_c;
        x_c = double(x_c + v*t_samp*cos(phi));
        y_c = double(y_c + v*t_samp*sin(phi));
        phi = double(phi + omega*t_samp);

        e1_array = [e1_array; double(e1)];
        e2_array = [e2_array; double(e2)];
        e3_array = [e3_array; double(e3)];
        v_array = [v_array; v];
        omega_array = [omega_array; omega];
        v_r = (2*v + omega*wheel_distance) / 2;
        v_l = 2*v - v_r;
        v_right = [v_right; v_r/wheel_radius * 60/(2*pi)];
        v_left = [v_left; v_l/wheel_radius * 60/(2*pi)];
        phi_array = [phi_array; double(phi)];
        phi_R_array = [phi_R_array; double(phi_R)];
    end
    
    num_steps = size(e2_array);
    num_steps = num_steps(1);
    x = 1:num_steps;
    x = x';
    
    % Plot emax on main simulation graph
%     e2_max = max(abs(e2_array));
%     TF_max = islocalmax(e2_array) & e2_array >= e2_max*0.8;
%     plot(x_c_array, y_c_array, x_c_array(TF_max), y_c_array(TF_max), 'bo');
    
    figure
    hold on
    grid on
    title('Sai so e2');
    plot(x*t_samp, e2_array, '-', 'LineWidth', 1, 'Color', 'r');
    xlabel('t(s)');
    ylabel('e2 (mm)');
%     plot(x, e2_array, x(TF_max), e2_array(TF_max), 'bo');
    
    
%     figure
%     hold on
%     grid on
%     title('Sai s? e3');
%     plot(x*t_samp, e3_array, '-', 'LineWidth', 1, 'Color', 'g');
%     xlabel('t(s)');
%     ylabel('e3 (mm)');
    
    figure
    hold on
    grid on
%     title('Van toc cac banh xe');
    plot(x*t_samp, v_right, '-', 'LineWidth', 1, 'Color', [0.8500 0.3250 0.0980]);
    plot(x*t_samp, v_left, '-', 'LineWidth', 1, 'Color', [0.4660 0.6740 0.1880]);
    legend('Right', 'Left');

%     figure
%     hold on
%     grid on
%     title('V?n t?c c?a xe, v (m/s)');
%     plot(v_array/1000, '-', 'LineWidth', 1, 'Color', [0.4660 0.6740 0.1880]);
%     xlabel('t(s)');
%     ylabel('v (m/s)');

    figure
    hold on
    grid on
    title('Van toc goc cua xe, w (rad/s)');
    plot(omega_array, '-', 'LineWidth', 1, 'Color', [0.8500 0.3250 0.0980]);
    xlabel('t(s)');
    ylabel('w (rad/s)');
end