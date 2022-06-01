clear all;
close all;
clc;

%% 理论值
SNR_dB = 3:2:13;
% 比特信噪比
EbN0dB = SNR_dB - 10*log10(2);
SNR = 10.^(SNR_dB/10);
Pe = 1 - (1- 0.5*erfc(sqrt(SNR/2))).^2;
Pb = 0.5*erfc(sqrt(SNR/2));
semilogy(EbN0dB, Pe, 'LineWidth', 1)
hold on
semilogy(EbN0dB, Pb)
%% 仿真
% 产生双极性不归零基带信号

N = 1000000;
base = (sign(randn(1, N)) + 1) / 2;
b = reshape(base, [2 N/2]);
a = b(1, :); % I 路
b = b(2, :); % Q 路
%%%%%% Gray %%%%%%%%%%
%       00
%     10  01
%       11
%%%%%%%%%%%%%%%%%%%%%%
% Gray 映射
a_double_gray = sign(b - 0.5);
b_double_gray = -1*sign(a - 0.5);
% 非 Gray 映射
b_double_normal = -1*sign(a - 0.5);
a_double_normal = double(a == b);
a_double_normal = sign(a_double_normal - 0.5);
% 信号变换 转双极性
% 还是令 Eb = 1 每条支路 a = 1 得到噪声的相对方差
% a_double = sign(a - 0.5);
% b_double = sign(b - 0.5);
% 两个支路功率平均分配 信噪比降为一半
sigma = sqrt(1./SNR);
noise_a = randn(1, N/2);
noise_b = randn(1, N/2);
ser = zeros(1, length(SNR_dB));
ber = zeros(1, length(SNR_dB));
decode_a = zeros(1, N/2);
decode_b = zeros(1, N/2);

ser2 = zeros(1, length(SNR_dB));
ber2 = zeros(1, length(SNR_dB));

ser_ng = zeros(1, length(SNR_dB));
ber_ng = zeros(1, length(SNR_dB));
for i = 1:length(SNR_dB)
    %% gray
    % I 路
    ra = a_double_gray + sigma(i)*noise_a; % 接收
    decided_a = sign(ra);             % 判决
    err_a = abs(a_double_gray-decided_a)/2;
    be_a = sum(err_a);   % 误码数

    % Q 路
    rb = b_double_gray + sigma(i)*noise_b; % 接收
    decided_b = sign(rb);             % 判决
    err_b = abs(b_double_gray-decided_b)/2;
    be_b = sum(err_b);   % 误码数
    
    % 合计
    ber(i) = (be_a + be_b) / N; % bit error
    err_c = (sign(err_a + err_b - 0.5) + 1) / 2;
    ce = sum(err_c); % 误码数
    ser(i) = ce / (N / 2); % 误码率
    
    % 另一种计算 gray
    decode_a = double(decided_b == -1);
    decode_b = double(decided_a == 1);
    err_a2 = double(decode_a ~= a);
    err_b2 = double(decode_b ~= b);
    err_s2 = (sign(err_a2 + err_b2 - 0.5) + 1) / 2;
    ber2(i) = sum(err_a2) / N *2;
    ser2(i) = sum(err_s2)/N*2;
    
    %% 非 Gray
    ra_ng = a_double_normal + sigma(i)*noise_a;
    rb_ng = b_double_normal + sigma(i)*noise_b;
    decided_a_ng = sign(ra_ng);             % 判决
    decided_b_ng = sign(rb_ng);             % 判决
    decode_a_ng = double(decided_b_ng == -1);
    decode_b_ng = double(decided_a_ng ~= decided_b_ng);
    err_a_ng = double(decode_a_ng ~= a);
    err_b_ng = double(decode_b_ng ~= b);
    err_s_ng = (sign(err_a_ng + err_b_ng - 0.5) + 1) / 2;
    ber_ng(i) = sum(err_a_ng + err_b_ng) / N;
    ser_ng(i) = sum(err_s_ng)/N*2;
end

semilogy(EbN0dB, ser2, 'go')
hold on
semilogy(EbN0dB, ber2, 'x')
hold on
semilogy(EbN0dB, ser_ng, '*')
hold on
semilogy(EbN0dB, ber_ng, '+-')
legend('理论误码率','理论误信率', '格雷编码误码率', '格雷编码误比特率', '普通编码误码率', '普通编码误比特率')
grid on
title('QPSK')
xlabel('Eb/N0(dB)')
ylabel('Pe and Pb')






