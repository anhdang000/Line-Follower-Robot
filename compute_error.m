function [e1, e2, e3] = compute_error(x_control, y_control, phi, x_R, y_R, phi_R)
    e1 = (x_R - x_control)*cos(phi) + (y_R - y_control)*sin(phi);
    e2 = -(x_R - x_control)*sin(phi) + (y_R - y_control)*cos(phi);
    e2 = 0.8688*e2 + 0.0054;
    e3 = phi_R - phi;
end

