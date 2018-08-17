clc; clear all;
delete(get(0,'Children'));
fontName='Helvetica';
set(0,'defaultAxesFontName', fontName);
set(0,'defaultTextFontName', fontName);

% s = tf('s');                % define as transfer function
% K = 1.0;                    % Assume unity gain
% G = K/(s*(s+4)*(s+6));      % Given transfer function
% H = -1;                     % Negative Unity gain on feedback loop
% sys = feedback(G,H)

% Alternative Method:
num = 1;                      % Assume Unity gain
den = [1,10,24,1];           % Feedback (with negative unity gain)
sys = tf(num,den)
ssys = tf2ss(num,den);

figure(1)
pzmap(num,den)
title(gca,{"Pole Zero of system"});

figure(2)
rlocus(sys)
title(gca,{"Root Locus of system"});
grid on;

figure(3)
stepplot(sys)
title(gca,{"Step Response of system"});
S = stepinfo(sys)

bode(sys)