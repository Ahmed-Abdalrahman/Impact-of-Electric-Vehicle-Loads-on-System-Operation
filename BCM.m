% ***************************************************************************
% Program:            Penetration and impact of electric vehicle loads on system operation
% Project No.:        20
% Author:             Ahmed Abdalrahman
% Course:             ECE 666 - Winter 2017
% ***************************************************************************
% Battary charging Model

%  daily miles driven according to TTS
m = 40;
v = 20;
mu = log((m^2)/sqrt(v+m^2));
sigma = sqrt(log(v/(m^2)+1));
DD = lognrnd(mu,sigma);

% PEVs classes
i = randi ([1,4],1,1);  % class selection

if i== 1
    C_lower= 8;  %Total PEV battery capacity for different classes, kWh
    C_upper= 12;
    Em_lower= 20; %Energy consumption of PEV battery per mile driven for different classes, Wh/mile
    Em_upper= 30;
elseif i==2
    C_lower= 10;
    C_upper= 14;
    Em_lower= 25;
    Em_upper= 35; 
elseif i==3
    C_lower= 14;
    C_upper= 18;
    Em_lower= 35;
    Em_upper= 45;
elseif i==4
    C_lower= 19;
    C_upper= 23;
    Em_lower= 48;
    Em_upper= 58;
end

Cbat = randi ([C_lower,C_upper],1,1);  % Battery capacity of selected class 
Em = randi ([Em_lower,Em_upper],1,1)/100;  % Energy consumption of selected class
DDmax= Cbat/Em;

if DD>= DDmax
    Ec= Cbat;
elseif DD< DDmax
    Ec=Em*DD;
end

SOC= (1- (Ec/Cbat))*100;

if SOC <= 20
    SOC = 20;
elseif SOC>80 
    SOC = 80;
end

% charging time calculation

if SOC>= 20 && SOC< 50
    T= (22 -(SOC-20)/3)/60;   % Max charging time is 22 min to achive %80 SOC
elseif SOC>= 50 && SOC< 75
    T= (22 - 10 -(SOC-50))/60;
elseif SOC>= 75 && SOC< 90
    T= (22- 15-(SOC-75)/2.14)/60;
end


    





