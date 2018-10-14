clc; clear all;
delete(get(0,'Children'));

% Plant
num_plant = 1;                  % Unity gain
den_plant = [1,10,24,0];        % Open Loop
G_plant = tf(num_plant,den_plant);

% Compensator
num_comp = [1,2.7];             % Unity gain
den_comp = [1,11];              % Open Loop
G_comp = tf(num_comp,den_comp);

K = 500;
G = G_comp * G_plant;
H = 1;

diagram=strcat(...
'                                                                      \n',...
'                K          G_comp             G_plant                 \n',...
'             +-----+    +---------+    +---------------------+        \n',...
'      +-+    |     |    | s + 2.7 |    |          1          |        \n',...
' ---->|X|--->| 500 |--->| ------- |--->| ------------------- |--+---> \n',...
'   +  +-+    |     |    | s + 11  |    | s 3 + 10 s 2 + 24 s |  |     \n',...
'       ^     +-----+    +---------+    +---------------------+  |     \n',...
'     - |                                                        |     \n',...
'       |                                                        |     \n',...
'       +--------------------------------------------------------+     \n',...
'                                                                      \n');

sys_plant = feedback(G_plant,H);
sys_comp = feedback(G,H);
sys_gain = K*G/(1+K*G*H);	% This shows the mathematical results of gain upon the system
sys = feedback(K*G,H);      % Closed loop transfer function

% show poles,zeros,gain, check equality
[z,p,k] = tf2zp(cell2mat(sys.Numerator),cell2mat(sys.Denominator));
check = sys - sys_gain;
assert( cell2mat(check.Numerator) == 0); % check that the TFs are the same

% Step response
S_plant = stepinfo(sys_plant);
S_comp = stepinfo(sys_comp);
S = stepinfo(sys);

fprintf(diagram);
sys
p
z
disp('Response times');
disp('---------------');
disp(' ');
disp('Uncompensated plant :')
disp(S_plant)
disp('Compensated system (unity gain) :')
disp(S_comp)
disp('Compensated system with K=500 :')
disp(S)

%% Plotting

% Display setting and output setup
scr = get(groot,'ScreenSize');                              % screen resolution
fontName='Helvetica';
fontsize=16;
set(0,'defaultAxesFontName', fontName);
set(0,'defaultTextFontName', fontName);
set(0,'DefaultAxesFontSize', fontsize)
set(groot,'FixedWidthFontName', 'ElroNet Monospace')  

%% Pole-Zero Plot
fig1 =  figure('Position',...                               % draw figure
        [5 scr(4)-5 scr(3)/4 scr(4)*0.8]);
set(fig1,'numbertitle','off',...                            % Give figure useful title
        'name','Figure 1 - Pole-Zero plots',...
        'Color','white');
    
subplot(4,1,1);
pzmap(sys_plant);
ylim([-6 6]);
xlim([-16,1]);
title(gca,{"Pole Zero of uncompensated system (unity gain)"});
%
subplot(4,1,2);
pzmap(sys_comp);
ylim([-6 6]);
xlim([-16 1]);
title(gca,{"Pole Zero of compensated system (unity gain)"});
%
subplot(4,1,3);
pzmap(sys_gain);
ylim([-6 6]);
xlim([-16 1]);
title(gca,{"Pole Zero of compensated system with K=500"});
%
subplot(4,1,4);
pzmap(sys);
ylim([-6 6]);
xlim([-16 1]);
title(gca,{"Simplified Pole Zero of compensated system with K=500"});


%% Root Locus Plot
fig2 =  figure('Position',...                               % draw figure
        [fig1.Position(1)+fig1.Position(3)+5 scr(4)-5 scr(3)/4 scr(3)/3]);
set(fig2,'numbertitle','off',...                            % Give figure useful title
        'name','Figure 2: Root Locus',...
        'Color','white');
    
subplot(2,1,1);
rlocus(sys_plant);
ylim([-15 15]);
xlim([-16,5]);
title(gca,{"Root Locus of uncompensated system (unity gain)"});
subplot(2,1,2);
rlocus(sys_comp);
ylim([-15 15]);
xlim([-16 5]);
title(gca,{"Root Locus of compensated system (unity gain)"});


%% Step/Impulse Plot
fig3 =  figure('Position',...                               % draw figure
        [fig2.Position(1)+fig2.Position(3)+5 scr(4)-5 scr(3)/2.2 scr(4)/2.5]);
set(fig3,'numbertitle','off',...                            % Give figure useful title
        'name','Figure 3: Step and Impulse Response',...
        'Color','white');
    
subplot(2,3,1)
step(sys_plant)
ylim([0 1.5]);
xlim([0 200]);
title(gca,{"Uncompensated system (unity gain)"});
%
subplot(2,3,2)
step(sys_comp)
ylim([0 1.5]);
xlim([0 500]);
title(gca,{"Compensated system (unity gain)"});
%
subplot(2,3,3)
step(sys)
ylim([0 1.5]);
xlim([0 5]);
title(gca,{"Compensated system with K=500"});
%
subplot(2,3,4)
impulse(sys_plant)
ylim([-0.02 0.051]);
xlim([0 200]);
title(gca,{"Uncompensated system (unity gain)"});
%
subplot(2,3,5)
impulse(sys_comp)
ylim([-0.02 0.051]);
xlim([0 500]);
title(gca,{"Compensated system (unity gain)"});
%
subplot(2,3,6)
impulse(sys)
ylim([-2 5]);
xlim([0 5]);
title(gca,{"Compensated system with K=500"});
%
annotation(fig3,'textbox',...
    [0.48 0.94 0.2 0.05],...
    'String',{'Step Response'},...
    'HorizontalAlignment','center',...
    'FontWeight','bold',...
    'FontSize',14,...
    'FitBoxToText','off',...
    'EdgeColor','none');
%
annotation(fig3,'textbox',...
    [0.48 0.48 0.2 0.05],...
    'String',{'Impulse Response'},...
    'HorizontalAlignment','center',...
    'FontWeight','bold',...
    'FontSize',14,...
    'FitBoxToText','off',...
    'EdgeColor','none');

%% Bode Plot
fig4 =  figure('Position',...                               % draw figure
        [fig2.Position(1)+fig2.Position(3)+5 scr(4)-fig3.Position(2) scr(3)/2.2 scr(4)/2.5]);
set(fig4,'numbertitle','off',...                            % Give figure useful title
        'name','Figure 4: Bode Plots',...
        'Color','white');
    
subplot(1,3,1)
bode(sys_plant);
title(gca,{"Uncompensated system (unity gain)"});
%
subplot(1,3,2)
bode(sys_comp);
title(gca,{"Compensated system (unity gain)"});
%
subplot(1,3,3)
bode(sys);
title(gca,{"Compensated system with K=500"});
%
annotation(fig4,'textbox',...
    [0.48 0.94 0.2 0.05],...
    'String',{'Bode Plots'},...
    'HorizontalAlignment','center',...
    'FontWeight','bold',...
    'FontSize',14,...
    'FitBoxToText','off',...
    'EdgeColor','none');