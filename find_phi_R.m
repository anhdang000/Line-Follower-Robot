function phi_R = find_phi_R(x_R, y_R, x_control, y_control)
    syms x y
    if x_control >= 1000
        n = [x_R-1000; y_R];
        phi_R = abs(atand(-n(1)/n(2)));
        if phi_R > 90 && phi_R < 180
            phi_R = 180 - phi_R;
        end
        if -n(1)/n(2) < 0
            phi_R = 180 - phi_R;
        end
%         x = linspace(1000, 2000, 1000);
%         y = -n(1)/n(2) * (x-x_R) + y_R;
%         plot(x, y);
    elseif x_control <= -1000
        n = [x_R+1000; y_R];
        phi_R = abs(atand(-n(1)/n(2)) + 180);
        if phi_R > 90 && phi_R < 180
            phi_R = 180 - phi_R;
        end
        if -n(1)/n(2) < 0
            phi_R = 360 - phi_R;
        end
    elseif y_control > 0
        phi_R = 180;
    else
        phi_R = 0;
    end
end

