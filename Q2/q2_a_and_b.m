clear; close all;
%% Get data
open_system('Q2_FCC_Block_Diagram');
out = sim('Q2_FCC_Block_Diagram');
Y1 = squeeze(out.Y1.signals.values);
Y2 = squeeze(out.Y2.signals.values);
Y3 = squeeze(out.Y3.signals.values);
U1 = squeeze(out.U1.signals.values);
U2 = squeeze(out.U2.signals.values);
tout = squeeze(out.tout);
Ts = tout(2) - tout(1);
% Use iddata
Y = [Y1 Y2 Y3];
U = [U1 U2];
data = iddata(Y,U,Ts);
%% Part a): n4sid, estimate state space
% number of states as given
Nx = 5;
Nu = 2;
ny = 3;
% Estimate state space
sys = n4sid(data,Nx,'DisturbanceModel','none','Feedthrough',true(1,Nu));
%% Part b): Check for OL stability
% Finding poles
poles = eig(sys.A)
% We realise that all poles are within the unit disk and 2 are on the
% unit disk so marginally stable
% confirm it MATLAB
stability = isstable(sys)
