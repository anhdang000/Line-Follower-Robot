function [v, omega] = lr2vomega(v_l, v_r, wheel_distance)
    v = (v_l + v_r)/2;
    omega = (v_r - v_l)/wheel_distance;
end

