function main(v_ref)
    %% Parameters (mm)
    % Robot
    width = 160;
    length = 200;
    wheel_radius = 32.5;
    wheel_distance = 200;
    sensor_length = 133;

    % Map
    r = 500;

    % Control
    t_samp = 0.02;
    k1 = 0.01;
    k2 = 0.005;
    k3 = 0.001;
    omega_ref = v_ref/r;

    %% Draw map
    title('v_ref =');
    subplot(1, 2, 1);
    title('Simulation (view 1)');
    draw_map();
    subplot(1, 2, 2);
    draw_map();
    title('Simulation (view 2)');

    %% Starting states
    phi = 90;
    x_c = 1500;
    y_c = 0;

    %% Initialize storages
    e1_array = [];
    e2_array = [];
    e3_array = [];
    v_array = [];
    omega_array = [];
    v_left = [];
    v_right = [];

    %% Loop
    is_finish = 0;
    is_reached_F = 0;
    x_c_prev = x_c;
    y_c_prev = y_c;
    while is_finish == 0
        subplot(1,2,1);
        [x_sensor, y_sensor] = draw_agent(x_c, y_c, width, length, phi);
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

        [x_R, y_R, phi_R, is_exist] = find_R(x_sensor,y_sensor, x_control, y_control, x_c, y_c);
        disp(double(phi_R));
        [e1, e2, e3] = compute_error(x_control, y_control, phi, x_R, y_R, phi_R);
        [v, omega] = compute_lyapunov(e1, e2, e3, v_ref, omega_ref, k1, k2, k3);

        % Compute 
        x_c_prev = x_c;
        y_c_prev = y_c;
        x_c = double(x_c + v*t_samp*cosd(phi));
        y_c = double(y_c + v*t_samp*sind(phi));
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
    end

    figure
    hold on
    grid on
    title('e2');
    plot(e2_array, '-', 'LineWidth', 1, 'Color', 'r');

    % figure
    % hold on
    % grid on
    % title('Van toc cac banh xe');
    % plot(v_right, '-', 'LineWidth', 1, 'Color', [0.8500 0.3250 0.0980]);
    % plot(v_left, '-', 'LineWidth', 1, 'Color', [0.4660 0.6740 0.1880]);
    % legend('Right', 'Left');

    figure
    hold on
    grid on
    title('Van toc cua xe, v (m/s)');
    plot(v_array/1000, '-', 'LineWidth', 1, 'Color', [0.4660 0.6740 0.1880]);

    figure
    hold on
    grid on
    title('Van toc goc cua xe, w (rad/s)');
    plot(omega_array, '-', 'LineWidth', 1, 'Color', [0.8500 0.3250 0.0980]);
end