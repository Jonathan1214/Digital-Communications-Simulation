%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file:         baseband.m
% arthor:       Li Jiangxuan
% description:  des
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
clc;

Ts = 1;
N_sample = 8; % 每个码元的抽样点数
dt = Ts / N_sample; % 抽样时间间隔
fs = 1 / dt;
N = 1000;           % 码元数

t= 0:dt:(N*N_sample-1)*dt;
len_t = length(t);
gt1 = ones(1, N_sample); % NRZ
gt2 = ones(1, N_sample/2); %RZ
gt2 = [gt2 zeros(1, N_sample/2)];

d = (sign(randn(1, N)) + 1) / 2;
data = sigexpand(d, N_sample);

st1 = conv(data, gt1);
st2 = conv(data, gt2);

S1 = fftshift(abs((fft(st1(1:len_t))))).^2 / len_t;
S2 = fftshift(abs((fft(st2(1:len_t))))).^2 / len_t;
figure(1)
subplot(211)
plot(t, st1(1:length(t)))
axis([0 50 -0.5 1.5])
grid on
subplot(212)
plot(((-len_t/2):1:(len_t/2-1))*fs/len_t, 10*log10(S1))
grid on

figure(2)
subplot(211)
plot(t, st2(1:length(t)))
axis([0 50 -0.5 1.5])
grid on
subplot(212)
plot(((-len_t/2):1:(len_t/2-1))*fs/len_t, 10*log10(S2))
grid on







