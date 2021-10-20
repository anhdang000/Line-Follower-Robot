function dN=motorPlant(t,N)
    global PWM nRef 
%     dN = -23.12*N+329.6*PWM;
%     dN = -7.587*N + 18.24*PWM;
    dN = -379.4*N + 912*PWM;
 end