%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file:        BPSK_FadingChannels.m
% arthor:       Li Jiangxuan
% description: Rayleigh fading channel simulation with BPSK
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
clc;

EbN0dB = 0:4:40;
EbN0 = 10.^(EbN0dB/10);
%% Theory
Pe_theory = 0.5*(1-sqrt(EbN0./(1+EbN0)));
semilogy(EbN0dB, Pe_theory)

%% Simulation
N = 10^7;
a = sign(randn(1, N));      % 基带信号
sigma = sqrt(1./EbN0/2);    % 噪声
noise = randn(1, N);
%%%%%%%%%%%%%% 衰落信道 %%%%%%%%%%%%%%%%%%
fdt = 0.01;
path = 16;
k = 1:N;
initPhase = 0;
theta = initPhase + 2*pi/path.*(0:path-1);
Signal = zeros(1, N);       % 
for i = 1:path
    randomPhase = rand()*2*pi;
    Signal = Signal + exp(1j*(2*pi*fdt*cos(theta(i))*k+randomPhase));
end
F = 1/sqrt(path)*Signal;
ber = zeros(1, length(EbN0));
for n = 1:length(EbN0dB)
    rk = a .* F + sigma(n)*noise;
    d = a + sigma(n)*noise*sqrt(1/2).*randn(1, N);
    dec_a = sign(d);
    ber(n) = sum(abs(a-dec_a)/2)/length(a);
end

hold on
semilogy(EbN0dB, ber, 'o')








