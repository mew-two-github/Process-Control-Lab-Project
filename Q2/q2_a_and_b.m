%clear; 
close all;
%% Get data
% open_system('Q2_FCC_Block_Diagram');
% out = sim('Q2_FCC_Block_Diagram');
tout = squeeze(out.tout);
Y1 = squeeze(out.Y1.signals.values);
Y1 = rescale(Y1);
lol = smoothdata(Y1);
lol(1:13300)=Y1(1:13300);
Y1 = lol;
plot(tout,Y1,'LineWidth',2);
title('Y_1 original'); xlabel('time'); ylabel('Y_1');
Y2 = squeeze(out.Y2.signals.values);
Y2 = rescale(Y2);
% lol = smoothdata(Y2);
% lol(1:31868)=Y2(1:31868);
% Y2 = lol;
figure;
plot(tout,Y2,'LineWidth',2);
title('Y_2 original'); xlabel('time'); ylabel('Y_2');
Y3 = squeeze(out.Y3.signals.values);
Y3 = rescale(Y3);
lol = smoothdata(Y3);
lol(1:14743)=Y3(1:14743);
Y3 = lol;
figure;
plot(tout,Y3,'LineWidth',2);
title('Y_3 original'); xlabel('time'); ylabel('Y_3');
U1 = squeeze(out.U1.signals.values);
U2 = squeeze(out.U2.signals.values);

Ts = tout(2) - tout(1);
% Use iddata
Y = [Y1 Y2 Y3];
U = [U1 U2];
data = iddata(Y,U,Ts);
%% Part a): n4sid, estimate state space
% number of states as given
Nx = 5;
Nu = 2;
Ny = 3;
% Estimate a continous state space model
sys = n4sid(data,Nx,'DisturbanceModel','none','Feedthrough',true(1,Nu),'Ts',0);
%% Part b): Check for OL stability
% Finding poles
poles = eig(sys.A)
% We realise that all poles are within the unit disk and 1 is at zero so
% marginally stable
% confirm it MATLAB
stability = isstable(sys)
%% Part c) Obtain transfer functions
tfs = tf(sys);
G11 = tf(tfs.NUM(1,1),tfs.DEN(1,1));
G12 = tf(tfs.NUM(2,1),tfs.DEN(2,1));
G13 = tf(tfs.NUM(3,1),tfs.DEN(3,1));
G21 = tf(tfs.NUM(1,2),tfs.DEN(1,2));
G22 = tf(tfs.NUM(2,2),tfs.DEN(2,2));
G23 = tf(tfs.NUM(3,2),tfs.DEN(3,2));
% open_system('q2_part_c');