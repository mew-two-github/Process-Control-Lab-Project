classdef Fcc_Block < matlab.System
    % MATLAB Function Block for simulating the response of the FCC Model.
    % Accepts a 2-D input and returns a 3-D output.
    %

    % Public, tunable properties
    properties
         
    end
    properties(Nontunable)
        SampleTime = 0.05; % Sample Time (sec)
        % Sample Time can be increased in case simulations are taking too
        % much time. However, larger sample times could provide more
        % inaccurate results. Sample Time of this Function Block is
        % independent of sample times of all other blocks.
    end
    properties(DiscreteState)
        next_output
    end

    % Pre-computed constants
    properties(Access = private)

    end

    methods(Access = protected)
        function sts = getSampleTimeImpl(obj)
                sts = createSampleTime(obj,'Type','Discrete',...
                  'SampleTime',obj.SampleTime);
        end
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            obj.next_output = zeros(1,3);
            % next_output contains the next output y value. The initial
            % value of y is specified as below
            obj.next_output = obj.next_output + [0.003844, 0.00472, 972.1];
        end

        function y = stepImpl(obj,u)
            % Step size is dependent on sample time
            del_t = obj.SampleTime;
            input = u;
            % One-step of RK4 with previous output value used as y0
            y_next_step = rk_one_step(0, obj.next_output, input, del_t);
            
            % The output of the current time-step is the output value that
            % was stored in previous time-step
            y = obj.next_output;
            
            % The y value calculated in this time-step will be used as the
            % output for the next time-step.
            obj.next_output = zeros(1,3) + y_next_step;
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
            obj.next_output = zeros(1,3);
            obj.next_output = obj.next_output + [0.003844, 0.00472, 972.1];
        end
    end
end

function y1 = rk_one_step(t,y,u,h)
    % Using the RK4 routine, calculate output y at time t + h, using
    % current inputs u and output y at time t.
    
    % Pre-allocation to enforce dimensions of output
    K_1 = zeros(1,3);
    K_2 = zeros(1,3);
    K_3 = zeros(1,3);
    K_4 = zeros(1,3);
    y1 = zeros(1,3);
    % Total 4 dydt function calls
    K_1 = h * dydt(t + 0.5 * h, y, u);
    K_2 = h * dydt(t + 0.5 * h, y + K_1, u);
    K_3 = h * dydt(t + 0.5 * h, y + K_2, u);
    K_4 = h * dydt(t + h, y + K_3, u);
    % During normal operation, derivative is expected to be real. 
    y1 = real(y + (1 / 6) * (K_1 + 2 * K_2 + 2 * K_3 + K_4));
end

function y_prime = dydt(t,y,u)  
    % ODE equations for FCC as given in Balchen and strand paper
    % - Chem Engg Sci 1992 787-807
    
    alpa = 0.12;            %  Catalyst Decay Rate Constant (1/s)
    COR  = 6.98;            %  Catalyst to Oil weight ratio (kg/kg)
    c_pa = 1.074;           %  Heat Capacity of Air (kJ/kg K)
    c_pd = 1.9;             %  Heat Capacity of Dispersing Stream (kJ/kg K)
    c_po = 3.1335;          %  Heat Capacity of Catalyst (kJ/kg K)
    c_ps = 1.005;           %  Heat Capacity of Oil  (kJ/kg K)
    delH_f = 506.2;         %  Heat of reaction Gas Oil burning (kJ/kg)
    E_cb = 158.6;           %  Activation Energy for Coke BURNING reaction (kJ/mol)
    E_cf = 41.79;           %  Activation Energy for Coke FORMATION (kJ/mol)
    E_f = 101.5;            %  Activation Energy for Gas Oil Cracking(kJ/mol)
    F_a0 =  1543.6/60;      %  Mass Flow Rate of Air to Regenerator (kg/s) [25.72]
    F_gi = 1;               %  Gasoline Yield Factor of Catalyst 
    F_oil = 2438/60;        %  Mass Flow Rate of Gas Oil Feed  (kg/s)  [40.63]
    F_rc = 17023.9/60;      %  Mass Flow Rate of Regenerated Catalyst (kg/s)[283.7] 
    F_sc0 = 17023.9/60;     %  Mass Flow Rate of Spent Catalyst(kg/s) [283.7] 
    h1 = 521150;            %  Parameter in the dH correln (kJ/kmol)
    h2 = 245;               %  Parameter in the dH correln (kJ/kmol K)
    I_gi = 0.9;             %  Gasoline Recracking Intensity
    k0 = 962000;            %  Rate Constant for Gas Oil Cracking (1/s)
    kc10 = 0.01897;         %  Rate Constant for Catalytic Coke formation (s^-0.5)
    k_com = 29.338/60;      %  Rate Constant for Coke burning      [0.4890]
    lamda = 0.035;          %  Weight Fraction of steam in feed stream to riser 
    m = 80;                 %  Empirical Deactivation Parameter 
    M_c = 14;               %  Mean Molecular Weight of Coke 
    n = 2;                  %  Hydrogen content in Coke 
    N = 0.4;                %  Empirical Exponent in Coke Formation eqn
    O_in = 0.2136;          %  Oxygen Mole Fraction in air 
    R = 8.3143e-3;          %  Universal Gas constant 
    Ra = 53.5/60;           %  Molar flow rate of air to regenerator,kmol/min
    R_r =0;                 %  Recycle Ratio
    sig2 = 0.006244;        %  Linear CO2/CO dependence on the temp 
    T_a = 320;              %  Temp. of Air to Regenerator 
    tc = 9.6;               %  Catalyst Residence Time in Riser (SECS!)
    T_oil0 = 420;           %  Nom Temp of Feed Gas Oil after preheater [147 C]
    W = 175738;             %  Catalyst hold up in regenerator
    Wa = 20;                %  Air Holdup in Regenerator 
    y_f0 = 1;               %  Nominal Weight fraction of Gas Oil in Feed 
    z_r = 0.0555;           %  zr = arg mean(Tr(z)), z in [0,1]

    C_rc = y(1);   O_d = y(2);  T_rg = y(3);  % controlled variables
    dFa  = u(1); dFsc  = u(2);          % inputs  

    F_a = F_a0 + dFa; F_sc = F_sc0 + dFsc; 
    T_oil = T_oil0 ; kc1 = kc10 ;

    T_ri0 = ((c_po*F_oil + lamda*F_oil*c_pd)*T_oil  +  c_ps*F_rc*T_rg)/(c_po*F_oil  +  lamda*F_oil*c_pd  +  c_ps*F_rc);
    gama  = delH_f * F_oil / (T_ri0*(F_rc*c_ps + F_oil*c_po  + lamda*F_oil*c_pd));
    phi0  = 1-(m*C_rc);
    K0 = k0*exp(-E_f/(R*T_ri0));

    T_r  =  T_ri0*(1-((gama*y_f0*K0*phi0*(1-exp(-alpa*tc*COR*z_r)))/(alpa + (K0*phi0*(1-exp(-alpa*tc*COR*z_r))))));
    Kr = k0*exp(-E_f/(R*T_r));
    y_f1 = y_f0*alpa/(alpa + (Kr*phi0*(1-exp(-alpa*tc*COR))));
    T_ri1 = T_ri0*(1-((gama*y_f0*Kr*phi0*(1-exp(-alpa*tc*COR)))/(alpa + (Kr*phi0*(1-exp(-alpa*tc*COR))))));
    y_g1 = (1+R_r)*F_gi*((y_f1^I_gi) - y_f1)/(1-I_gi);

    sig = 1.1 + sig2*(T_rg - 873);
    delH = -h1 - (h2*(T_rg-960)) + 0.6*(T_rg-960)^2 ; 
    k = k_com * exp(E_cb*((1/960)-(1/T_rg))/R);

    C_cat = kc1 * sqrt(tc*exp(-E_cf/(R*T_ri1))/(C_rc^N));
    C_sc = C_rc + C_cat; 

    y_prime = zeros(1,3);

    y_prime(1,1) = (F_sc*(C_sc-C_rc)/W) - k*O_d*C_rc;
    y_prime(1,2) = (Ra*(O_in - O_d)/Wa) - (((n+2+((n+4)*sig))*k*O_d*C_rc*W)/(4*M_c*Wa*(1+sig)));
    y_prime(1,3) = (T_ri1*F_sc/W) + (T_a*F_a*c_pa/(W*c_ps)) - (T_rg*(F_sc*c_ps + F_a*c_pa)/(W*c_ps)) - (delH*k*O_d*C_rc/(c_ps*M_c));
end
