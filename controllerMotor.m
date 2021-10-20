close all
global PWM nRef;

radius = 0.0425;
vRef = 2;
omegaRef = vRef/radius;
nRef = omegaRef*60/(2*pi);

time = 3;
tsamp = 0.02;
runtime = time/tsamp;

kp=0.15;
ki=0.1;
kd=0;

T=0;
N=0;
n=0;
V = 0;
err1=0;
err2=0;
de_dt=0;
int = 0;
Nref = nRef;
for i = 1:runtime
    err1=err2;
    err2=nRef - n + 0.07*0.1*(1-rand());
    int = int + err2;
    PWM = kp*err2 + ki*int+ kd*(err2-err1)/tsamp;
    if(PWM > 100)
        PWM = 100;
    end
    if(PWM < 0)
        PWM = 0;
    end
    [t,y] = ode45(@motorPlant,[0 tsamp],n);
    n = y(length(y),1);  
    T = [T; i*tsamp];
    N = [N;n];
    v = n*2*pi/60*radius;
    V = [V;v];
    Nref = [Nref;nRef];
end
figure(1);
title('Response of the RPM using PID controller');
hold on
grid on
xlabel('Time (s)');
ylabel('RPM (rpm)');
plot(T,Nref,'b');
plot(T,N,'r','linewidth',2);