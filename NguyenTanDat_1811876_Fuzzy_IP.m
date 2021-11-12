% Rotary Inverted Pendulum
clc;
clear all;
close all; 
%creat sampling time
tmax=5;
dt=0.01;
n=round(tmax/dt);
 
%reference data
yd(1)=0;
dyd(1)=0;
d2yd(1)=0;
for i=2:n
    t(i)=(i-1)*dt;   
    yd(i)=0;
    dyd(i)=0;
    d2yd(i)=0;
end
 
%initial data
x3(1)=60*pi/180; %Theta2
x4(1)=0;         %Theta2 dot
u(1)=0;

 %system data
h1=0.027;  
h2=0.012; 
h3=0.021; 
h4=0.785; 
%%Fuzzy set
a = newfis('Fuzzy_IP');
    %error
 e1 =-2; e2 = 2; e3=(e2-e1)/6;
a = addvar(a,'input','e',[e1,e2]);
a = addmf(a,'input',1,'NB','trimf',[e1 e1 e1+e3]);
a = addmf(a,'input',1,'NM','trimf',[e1 e1+e3 e1+e3*2]);
a = addmf(a,'input',1,'NS','trimf',[e1+e3 e1+e3*2 e1+e3*3]);
a = addmf(a,'input',1,'ZE','trimf',[e1+e3*2 e1+e3*3 e1+e3*4]);
a = addmf(a,'input',1,'PS','trimf',[e1+e3*3 e1+e3*4 e1+e3*5]);
a = addmf(a,'input',1,'PM','trimf',[e1+e3*4 e1+e3*5 e2]);
a = addmf(a,'input',1,'PB','trimf',[e1+e3*5 e2 e2]);
% figure(1)
% plotmf(a,'input',1) %Check error
    %error dot
 de1 =-10; de2=10; de3=(de2-de1)/6;
a = addvar(a,'input','de',[de1,de2]);
a = addmf(a,'input',2,'NB','trimf',[de1 de1 de1+de3]);
a = addmf(a,'input',2,'NM','trimf',[de1 de1+de3 de1+de3*2]);
a = addmf(a,'input',2,'NS','trimf',[de1+de3 de1+de3*2 de1+de3*3]);
a = addmf(a,'input',2,'ZE','trimf',[de1+de3*2 de1+de3*3 de1+de3*4]);
a = addmf(a,'input',2,'PS','trimf',[de1+de3*3 de1+de3*4 de1+de3*5]);
a = addmf(a,'input',2,'PM','trimf',[de1+de3*4 de1+de3*5 de2]);
a = addmf(a,'input',2,'PB','trimf',[de1+de3*5 de2 de2]);
    %u
u1 =-5; u2=5; u3=(u2-u1)/6;
a = addvar(a,'output','U',[u1,u2]);
a = addmf(a,'output',1,'NB','trimf',[u1 u1 u1+u3]);
a = addmf(a,'output',1,'NM','trimf',[u1 u1+u3 u1+u3*2]);
a = addmf(a,'output',1,'NS','trimf',[u1+u3 u1+u3*2 u1+u3*3]);
a = addmf(a,'output',1,'ZE','trimf',[u1+u3*2 u1+u3*3 u1+u3*4]);
a = addmf(a,'output',1,'PS','trimf',[u1+u3*3 u1+u3*4 u1+u3*5]);
a = addmf(a,'output',1,'PM','trimf',[u1+u3*4 u1+u3*5 u2]);
a = addmf(a,'output',1,'PB','trimf',[u1+u3*5 u2 u2]);

rulelist = [1 1 1 1 1; 2 1 1 1 1; 3 1 1 1 1; 4 1 2 1 1; 5 1 2 1 1; 6 1 3 1 1; 7 1 3 1 1
            1 2 1 1 1; 2 2 1 1 1; 3 2 2 1 1; 4 2 2 1 1; 5 2 3 1 1; 6 2 4 1 1; 7 2 4 1 1
            1 3 1 1 1; 2 3 2 1 1; 3 3 2 1 1; 4 3 3 1 1; 5 3 3 1 1; 6 3 4 1 1; 7 3 5 1 1
            1 4 2 1 1; 2 4 2 1 1; 3 4 3 1 1; 4 4 4 1 1; 5 4 4 1 1; 6 4 4 1 1; 7 4 5 1 1
            1 5 2 1 1; 2 5 3 1 1; 3 5 4 1 1; 4 5 4 1 1; 5 5 5 1 1; 6 5 5 1 1; 7 5 6 1 1
            1 6 3 1 1; 2 6 3 1 1; 3 6 4 1 1; 4 6 4 1 1; 5 6 5 1 1; 6 6 6 1 1; 7 6 7 1 1 
            1 7 3 1 1; 2 7 4 1 1; 3 7 5 1 1; 4 7 5 1 1; 5 7 6 1 1; 6 7 7 1 1; 7 7 7 1 1];
a = addrule(a,rulelist);
a = setfis(a,'DefuzzMethod','centroid');
writefis(a,'Fuzzy_IP');
a = readfis('Fuzzy_IP');
for i=2:n
    %system
    dx3(i)=x4(i-1);
    dx4(i)=-(h1*h4*x3(i-1))/(h1*h3-h2^2)-(h2*u(i-1))/(h1*h3-h2^2);
    x3(i)=dx3(i-1)*dt+x3(i-1);
    x4(i)=dx4(i-1)*dt+x4(i-1);
    y(i)=x3(i);
    dy(i)=dx3(i);
    d2y(i)=dx4(i);
 
    %tracking error
    e(i)=y(i)-yd(i);
    de(i)=(dy(i)-dyd(i));
    d2e(i)=(d2y(i)-d2yd(i));
  
    %controller
    u(i) = (evalfis([e(i) de(i)],a));
end 
u = u';         
figure(2)              
plot(t,y,'r',t,yd,'g');
xlabel('time');
ylabel('y&yd');

title ('Tracking Error');
legend('y','yd');


    
    


