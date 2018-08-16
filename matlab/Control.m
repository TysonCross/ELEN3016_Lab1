H = tf([1],[1,10,24,1])
figure(1)
pzmap(H)
figure(2)
rlocus(H)
grid on

figure(3)
step(H)
S = stepinfo(H)
H1 =tf([1],[24, 1])
figure(4)
%
step(H1)
S1=stepinfo(H1)