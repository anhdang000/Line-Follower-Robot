function phi_R = find_phi_R(x_R, y_R, x_control, y_control, phi)
    syms x y
    if x_control >= 1000
        n = [x_R-1000; y_R];
        phi_R = abs(atan(-n(1)/n(2)));
        if phi_R > pi/2 && phi_R < pi
            phi_R = pi - phi_R;
        end
        if -n(1)/n(2) < 0
            phi_R = pi - phi_R;
        end
%         x = linspace(1000, 2000, 1000);
%         y = -n(1)/n(2) * (x-x_R) + y_R;
%         plot(x, y);
    elseif x_control <= -1000
        n = [x_R+1000; y_R];
        if ~(-n(1)/n(2) >= 0 && mod(phi/pi, 2) > 1.5 && mod(phi/pi, 2) <= 2)
            phi_R = abs(atan(-n(1)/n(2)) + pi);
        else
            phi_R = abs(atan(-n(1)/n(2)));
        end
        if phi_R > pi/2 && phi_R < pi
            phi_R = pi - phi_R;
        end
        if -n(1)/n(2) < 0
            phi_R = 2*pi - phi_R;
        end
    elseif y_control > 0
        phi_R = pi;
    else
        phi_R = 0;
    end
end

