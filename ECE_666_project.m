% ***************************************************************************
% Program:            Penetration and impact of electric vehicle loads on system operation
% Project No.:        20
% Author:             Ahmed Abdalrahman
% Course:             ECE 666 - Winter 2017
% ***************************************************************************
% M/M/C Queuing model of charging station
clear
clc
close all
%=============================================%
% Forecasted Data
%=============================================%
% TTS data 
TTS=[0.5; 0.5; 0.5; 0.75; 2; 4; 7; 10; 5; 5; 6; 5; 4.5; 6; 8; 9; ...
    10; 6; 5; 4; 3; 2; 1; 0.5];

W=0; % intial waiting time
NoItr=100; %No. of itreation
TPch=0;
for Itr=1:NoItr
EPch=0;
for k=1:24
%=============================================%
% M/M/C gueuing Model
%=============================================%

%time dependent arrival rate as a function of TTS data
    if TTS(k)<= 4
        L(k)= randi ([1,4],1,1)
    elseif TTS(k)>4 && TTS(k)<=7
        L(k)= randi ([5,11],1,1)
    elseif TTS(k)>7 
        L(k)= randi ([12,16],1,1)
    end


% Service (Charging) Time <extructed from Battary charging Model>
BCM;
u=T+W;  % mean service time

% No. of Simultenusly charged PEVs
N0= 50; % randi ([1,17],1,1);

% Occupation rate of the PEV charging station
r= L(k)/u;  %traffic intensity
a= r/N0; %Server utilization

%Probability there are 0 customers in charging station
sum=0;
  for I=0:(N0-1)
  sum= sum+ (r^I)/factorial(I);
  end
P(1)= 1/(sum +(r^N0)/(factorial(N0)*(1-a)));

%Probability there are n customers in charging station
for n=2:N0+1
P(n)= P(1)*r^(n-1)/factorial(n-1);
end

%The expected number of customers waiting at the charging station
PN = P(1)*r^N0/(factorial(N0)*(1-a)); 
%The average waiting time of PEVs
W = PN*u/(N0+(1-a));

% Charging current
I = min((Ec/(0.4*T)),63);
EPch(k)=0;
for z= 0:N0
Pch = z*I*0.4;
NO(k,z+1)=P(z+1);
EPch(k)= EPch(k)+Pch*P(z+1);
end
end
TPch=TPch+EPch;
end

TPch=TPch/(1000*NoItr);

%=============================================%
% Output Figures
%=============================================%

t=1:24;
figure(1);
bar(t,TTS(t),.5,'b');
xlim([1,24])
ylim([0,12])
xlabel('Hours');
ylabel('Percentage of vehicles on Roads');

figure(2);
bar(t,TPch(t),.5,'b');
xlim([1,24])
%ylim([0,1])
xlabel('Hours');
ylabel('Expected charging demand of PEV P.U.');
%title('Total PEV expected charging demand');
hold on

figure(3);
bar(t,L(t),.5,'b');
xlim([1,24])
ylim([0,17])
xlabel('Hours');
ylabel('No. of PEVs arrived to the charging facility');
%title('Sample of the charging facility arrival rate');
hold on

x=1:10
figure(4);
bar(x,NO(1,x),.5,'b');
%xlim([1,30])
%ylim([0,1])
xlabel('NO. of PEV charging simultaneously');
ylabel('Probability');
%title('C');
hold on

filename = 'C:\Users\Ahmed\Documents\gamsdir\PEVload.xlsx';

A = {'time','PEV_load'; 1,TPch(1); 2,TPch(2); 3,TPch(3); 4,TPch(4);...
    5,TPch(5); 6,TPch(6); 7,TPch(7); 8,TPch(8);...
    9,TPch(9); 10,TPch(10); 11,TPch(11); 12,TPch(12);...
    13,TPch(13); 14,TPch(14); 15,TPch(15); 16,TPch(16);...
    17,TPch(17); 18,TPch(18); 19,TPch(19); 20,TPch(20);...
    21,TPch(21); 22,TPch(22); 23,TPch(23); 24,TPch(24)};
xlRange = 'A1';
xlswrite(filename,A,xlRange)



