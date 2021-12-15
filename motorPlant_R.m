function dN=motorPlant_R(t, N, PWM)
    dN = -1.07*N+402.7*PWM;
 end