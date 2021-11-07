close all;
%% Initialisation
Kc = 0.0669137468092512;
KI = 5.31692810242195e-08;
Gm = G11;
Gc = tf([Kc KI],[1 0]);
s = tf('s');
%% RH criterion
Dr = 1 + G11*Gc;
[num,~] = tfdata(Dr,'v');
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