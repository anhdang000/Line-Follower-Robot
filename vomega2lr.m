function [v_l, v_r] = vomega2lr(v, omega, wheel_distance)
    v_r = (2*v + omega*wheel_distance) / 2;
    v_l = 2*v - v_r;
end

