function [e1, e2, e2_gt, e3] = compute_error(x_control, y_control, phi, x_R, y_R, phi_R, s, sensor_data)
    % Compute e2 from sensors
    e2_gt = -(x_R - x_control)*sin(phi) + (y_R - y_control)*cos(phi);
    weights = [-3 -2 -1 0 1 2 3];
    sensor_d = abs(weights*s - e2_gt);
    analogs = interp1(sensor_data(:, 1), sensor_data(:, 2), sensor_d, 'spline');
    if e2_gt ~= 0
        e2 = sign(e2_gt) * abs(sum(weights.*analogs)*s/sum(analogs));
    else
        e2 = abs(sum(weights.*analogs)/sum(analogs));
    end
    CR = calc_distances([x_control, y_control], [x_R, y_R]);
    e1 = (x_R - x_control)*cos(phi) + (y_R - y_control)*sin(phi);
    e3 = phi_R - phi;
end

