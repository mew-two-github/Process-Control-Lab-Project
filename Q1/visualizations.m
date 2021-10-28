load('Q1_Output_2x2_Step_Response_Data.mat')
figure;
plot(U1.time, U1.signals.values)
hold on
plot(G11U1.time, G11U1.signals.values)
s = tf('s');
ystep = G11U1.signals.values;
ustep = U1.signals.values;
gain = ystep(end);
[~, t1_index] = min(abs(0.353*gain-ystep));
[~, t2_index] = min(abs(0.853*gain-ystep));
t1 = U1.time(t1_index);
t2 = U1.time(t2_index);
D = 2.5;
tau = 0.67*(t2-t1);
K = gain/ustep(end);
G_11_ks = K*exp(-D*s)/(tau*s+1);
G_11_ks
hold on
y_ext = lsim(G_11_ks, ustep, U1.time);
plot(U1.time, y_ext)


figure;
plot(U2.time, U2.signals.values)
hold on
plot(G12U2.time, G12U2.signals.values)
ystep = G12U2.signals.values;
ustep = U2.signals.values;
gain = ystep(end);
[~, t1_index] = min(abs(0.353*gain-ystep));
[~, t2_index] = min(abs(0.853*gain-ystep));
t1 = U2.time(t1_index);
t2 = U2.time(t2_index);
D = 1.2;
tau = 0.67*(t2-t1);
K = gain/ustep(end);
G_12_ks = K*exp(-D*s)/(tau*s+1);
G_12_ks
hold on
y_12_ext = lsim(G_12_ks, ustep, U2.time);
plot(U2.time, y_12_ext)


figure;
plot(U1.time, U1.signals.values)
hold on
plot(G21U1.time, G21U1.signals.values)
ystep = G21U1.signals.values;
ustep = U1.signals.values;
gain = ystep(end);
[~, t1_index] = min(abs(0.353*gain-ystep));
[~, t2_index] = min(abs(0.853*gain-ystep));
t1 = U1.time(t1_index);
t2 = U1.time(t2_index);
D = 1.1;
tau = 0.67*(t2-t1);
K = gain/ustep(end);
G_21_ks = K*exp(-D*s)/(tau*s+1);
G_21_ks
hold on
y_21_ext = lsim(G_21_ks, ustep, U1.time);
plot(U1.time, y_21_ext)


figure;
plot(U2.time, U2.signals.values)
hold on
plot(G22U2.time, G22U2.signals.values)
s = tf('s');
ystep = G22U2.signals.values;
ustep = U2.signals.values;
gain = ystep(end);
[~, t1_index] = min(abs(0.353*gain-ystep));
[~, t2_index] = min(abs(0.853*gain-ystep));
t1 = U2.time(t1_index);
t2 = U2.time(t2_index);
D = 1.1;
tau = 0.67*(t2-t1);
K = gain/ustep(end);
G_22_ks = K*exp(-D*s)/(tau*s+1);
G_22_ks
hold on
y_22_ext = lsim(G_22_ks, ustep, U2.time);
plot(U2.time, y_22_ext)



% function d = delayEst(u, y)
%     for i = 1:
% end



% step(G_1_ks, Gs)
% legend('Model', 'Process')
% figure;
% plot(U2.time, U2.signals.values)
% hold on
% plot(G12U2.time, G12U2.signals.values)
% figure;
% plot(U1.time, U1.signals.values)
% hold on
% plot(G21U1.time, G21U1.signals.values)
% figure;
% plot(U2.time, U2.signals.values)
% hold on
% plot(G22U2.time, G22U2.signals.values)
