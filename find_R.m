function [x_R, y_R, phi_R, is_exist] = find_R(x_sensor, y_sensor, x_control, y_control, x_c, y_c, phi)
    syms x y
    if x_sensor(1) ~= x_sensor(2)
        c = [[1; 1]  x_sensor(:)]\y_sensor(:);
        a = c(2);
        b = c(1);
        s_eqn = a*x + b == y;
    else
        s_eqn = x == x_sensor(1);
    end
    is_exist = 1;
    if x_control >= 1000
        % Right arc
        sol = solve(s_eqn, (x-1000)^2 + y^2 == 500^2);
        x_R = double(sol.x);
        y_R = double(sol.y);
        d = calc_distances([x_R y_R], [x_control, y_control]);
        [row, ~] = find(d == min(d));
        x_R = x_R(row);
        y_R = y_R(row);
    elseif x_control <= -1000
        % Left arc
        sol = solve(s_eqn, (x+1000)^2 + y^2 == 500^2);
        x_R = double(sol.x);
        y_R = double(sol.y);
        d = calc_distances([x_R y_R], [x_control, y_control]);
        [row, ~] = find(d == min(d));
        x_R = x_R(row);
        y_R = y_R(row);
    else
        if y_control > 0
            sol = solve(s_eqn, y == 500);
            x_R = double(sol.x);
            y_R = double(sol.y);
        else
            sol = solve(s_eqn, y == -500);
            x_R = double(sol.x);
            y_R = double(sol.y);
        end
    end
    
    % Check unreal solution
    if max(abs(imag(x_R))) > 0 || max(abs(imag(y_R))) > 0
        is_exist = 0;
        phi_R = NaN;
    else
        phi_R = find_phi_R(x_R, y_R, x_control, y_control, phi);
    end
end

