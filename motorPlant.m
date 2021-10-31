function dN=motorPlant(t, N, PWM)
    dN = -23.12*N+329.6*PWM;
 end