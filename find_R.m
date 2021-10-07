function [x_R, y_R, phi_R, is_exist] = find_R(x_sensor, y_sensor, x_control, y_control, x_c, y_c)
    syms x y
    c = [[1; 1]  x_sensor(:)]\y_sensor(:);
    a = c(2);
    b = c(1);
    is_exist = 1;
    if x_control >= 1000
        % Right arc
        sol = solve(a*x+b == y, (x-1000)^2 + y^2 == 500^2);
        x_R = sol.x;
        y_R = sol.y;
        d = calc_distances([x_R y_R], [x_control, y_control]);
        [row, ~] = find(d == min(d));
        x_R = x_R(row);
        y_R = y_R(row);
    elseif x_control <= -1000
        % Left arc
        sol = solve(a*x+b == y, (x+1000)^2 + y^2 == 500^2);
        x_R = sol.x;
        y_R = sol.y;
        d = calc_distances([x_R y_R], [x_control, y_control]);
        [row, ~] = find(d == min(d));
        x_R = x_R(row);
        y_R = y_R(row);
    else
        if y_control > 0
            sol = solve(a*x+b == y, y == 500);
            x_R = sol.x;
            y_R = sol.y;
        else
            sol = solve(a*x+b == y, y == -500);
            x_R = sol.x;
            y_R = sol.y;
        end
    end
    
    % Check unreal solution
    if max(abs(imag(x_R))) > 0 || max(abs(imag(y_R))) > 0
        is_exist = 0;
    else
        phi_R = find_phi_R(x_R, y_R, x_control, y_control);
    end
end

