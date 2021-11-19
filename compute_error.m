function [e1, e2, e2_gt, e3, e3_gt] = compute_error(x_control, y_control, phi, x_R, y_R, phi_R, s, sensor_data, e2_prev, ds)
    % Compute e2 ground truth    
    e2_gt = -(x_R - x_control)*sin(phi) + (y_R - y_control)*cos(phi);

    % Compute e2 from sensors
    weights = [-3 -2 -1 0 1 2 3];
    sensor_d = abs(weights*s - e2_gt);
    analogs = interp1(sensor_data(:, 1), sensor_data(:, 2), sensor_d, 'spline');
    if e2_gt ~= 0
        e2 = sign(e2_gt) * abs(sum(weights.*analogs)*s/sum(analogs));
    else
        e2 = abs(sum(weights.*analogs)/sum(analogs));
    end
    
    
    e1 = (x_R - x_control)*cos(phi) + (y_R - y_control)*sin(phi);
    e3_gt = phi_R - phi;
    if e3_gt > 6
        e3_gt = e3_gt - 2*pi;
    elseif e3_gt < -6
        e3_gt = e3_gt + 2*pi;
    end
    if ds ~= 0
        e3 = atan(e2-e2_prev)/ds;
    else
        e3 = 0;
    end
end

