close all;
%% Initialisation
Kc = 179.074373920372;
KI = 5.21380137768688e-05;
Gm = G11;
Gc = tf([Kc KI],[1 0]);
s = tf('s');
%% RH criterion
Dr = 1 + G11*Gc;
%% Root locus
L = minreal(Gm/(s*(1+Kc*Gm)));
rlocusplot(L,KI);
grid on;
figure;
rlocusplot(L)
%rltool(L);
%% Bode plot
% CL_sys = minreal((Gm*Gc)/(1+Gm*Gc));
Lg = Gc*Gm;
figure;
margin(Lg);
%% Nyquist Plot
figure;
nyquist(Lg);
hold on;
n = 500;
theta = linspace(0,2*pi,n);
x = cos(theta); y = sin(theta);
plot(x,y,'r-.');
hold off;
legend('Nyquist','Unit Circle');