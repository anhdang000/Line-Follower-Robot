function [e1, e2, e3] = compute_error(x_control, y_control, phi, x_R, y_R, phi_R)
    e1 = (x_R - x_control)*cosd(phi) + (y_R - y_control)*sind(phi);
    e2 = -(x_R - x_control)*sind(phi) + (y_R - y_control)*cosd(phi);
    e3 = phi_R - phi;
end

