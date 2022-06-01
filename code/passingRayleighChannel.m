%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% title:    BPSK passing Rayleigh Channel
% date:     2020.06.04
% author:   LiJiangXuan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
clc;

EbN0dB = 0:2:10;
EbN0 = 10.^(EbN0dB/10);
Pb = 0.5*erfc(sqrt(EbN0));          % 无衰落
N_sim = 10^5;                       % 点数
baseband = randi([0 1], N_sim, 1);  % 基带信号
toTran = sign(baseband - 0.5);      % 星座点映射
sigma = sqrt(1./EbN0);              % 噪声功率
toBase = zeros(size(baseband));     % 解调到基带
be = zeros(size(length(EbN0)));     % 误比特数
for i = 1:length(EbN0)
    %%%%%%%%%%%%%%%%%%%%% 瑞利信道 %%%%%%%%%%%%%%%%%%%%%%%%
    h_I = sqrt(1/2)*randn(N_sim, 1);
    h_Q = sqrt(1/2)*randn(N_sim, 1);
    
    %%%%%%%%%%%%%%%%%%%%% 接收信号 %%%%%%%%%%%%%%%%%%%%%%%%
    reci_I = toTran .* h_I + sigma(i) * randn(N_sim, 1);
    reci_Q = toTran .* h_Q + sigma(i) * randn(N_sim, 1);
    
    %%%%%%%%%%%%%%%%%%%%% 解调信号 %%%%%%%%%%%%%%%%%%%%%%%%
    decode_I = reci_I .* h_I + reci_Q .* h_Q;
    decode_Q = reci_Q .* h_I - reci_I .* h_Q;
    
    toBase = (sign(decode_I) + 1) / 2;
    be(i) = sum(double(toBase ~= baseband));
end

semilogy(EbN0dB, be / N_sim, 'r--o')
hold on
semilogy(EbN0dB, Pb, 'b-*')
legend('Rayleigh', 'AWGN')
xlabel('\itE_b/N_0\rm(dB)')
ylabel('Pb')






