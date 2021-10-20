function [v, omega] = compute_lyapunov(e1, e2, e3, v_ref, omega_ref, k1, k2, k3)
    v = v_ref*cos(e3) + k1*e1;
    omega = k2*v_ref*e2 + omega_ref + k3*sin(e3);
end

