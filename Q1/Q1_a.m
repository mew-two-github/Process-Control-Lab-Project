load('Q1_Output_2x2_Step_Response_Data.mat')

G11U1_iddata = iddata(G11U1.signals.values,U1.signals.values,0.1);
%From the step Response plot we can identify the delay to be 2.5s
sysG11U1 = tfest(G11U1_iddata,1,0,2.5);
tfG11U1 = tf(sysG11U1.Numerator,sysG11U1.Denominator,'IODelay',sysG11U1.IODelay);

G12U2_iddata = iddata(G12U2.signals.values,U2.signals.values,0.1);
%From the step Response plot we can identify the delay to be 1.1s
sysG12U2 = tfest(G12U2_iddata,1,0,1.1);
tfG12U2 = tf(sysG12U2.Numerator,sysG12U2.Denominator,'IODelay',sysG12U2.IODelay);

G21U1_iddata = iddata(G21U1.signals.values,U1.signals.values,0.1);
%From the step Response plot we can identify the delay to be 1.1s
sysG21U1 = tfest(G21U1_iddata,1,0,1.1);
tfG21U1 = tf(sysG21U1.Numerator,sysG21U1.Denominator,'IODelay',sysG21U1.IODelay);

G22U2_iddata = iddata(G22U2.signals.values,U2.signals.values,0.1);
%From the step Response plot we can identify the delay to be 1.1s
sysG22U2 = tfest(G22U2_iddata,1,0,1.1);
tfG22U2 = tf(sysG22U2.Numerator,sysG22U2.Denominator,'IODelay',sysG22U2.IODelay);