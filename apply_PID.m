function [sol, err2, int] = apply_PID(kp, ki, kd, err2, int, v_ref, v, t_samp, wheel_radius)
    n_ref = v2rpm(v_ref, wheel_radius);
    n = v2rpm(v, wheel_radius);
    err1 = err2;
    err2 = n_ref - n;
    int = int + err2;
    PWM = kp*err2 + ki*int+ kd*(err2-err1)/t_samp;
    PWM = double(clip(PWM, 0, 100));
    sol = ode45(@(t, N) motorPlant(t, N, PWM), [0 t_samp], n);
    [t, N] = ode45(@(t, N) motorPlant(t, N, PWM), [0 t_samp], n);
    disp([double(n_ref), double(deval(sol, t_samp))]);
end

