% ==============================================================================
% @File         :  QAM.m
% @Author       :  Li Jiangxuan 
% @Created      :  2020/5/6 22:58:49
% @Description  : 16QAM simulation
% 
% -----------------------------------------------------------------------------
% History
% -----------------------------------------------------------------------------
% Ver  :| Author       :| Mod. Date   :| Changes Made :|
% 
% ==============================================================================

clear all;
close all;
clc;

EbN0dB = 0:1:15;
EbN0 = 10.^(EbN0dB/10);

M = 16; % 16 QAM
N = 64; % 64 QAM
%% 16QAM 64QAM theory
Pe_16_help = 2*(1-1/sqrt(M))*qfunc(sqrt(3*log2(M)*EbN0/(M-1)));
Pe_16 = 1- (1 - Pe_16_help).^2;
Pb_16 = Pe_16 / 4;
Pe_64_help = 2*(1-1/sqrt(N))*qfunc(sqrt(3*log2(N)*EbN0/(N-1)));
Pe_64 = 1- (1 - Pe_64_help).^2;
%% 16PSK theory
Pe_theory_PSK = 2*qfunc(sin(pi/M)*sqrt(2*log2(M)*EbN0));
%% theory plot
semilogy(EbN0dB, Pe_16, 'LineWidth', 1)
hold on
% semilogy(EbN0dB, Pe_64)
% hold on
semilogy(EbN0dB, Pe_theory_PSK, 'k', 'LineWidth', 1)
hold on
semilogy(EbN0dB, Pb_16, 'c', 'LineWidth', 1)
hold on
semilogy(EbN0dB, Pe_theory_PSK / 4, 'g', 'LineWidth', 1)
grid on

xlabel('\it{E_b/N_0} \rm(dB)')
ylabel('P_b and P_e')

% 16QAM 仿真
% 格雷码映射表
gray_code_table = [0 0 0 0; % 0
                  1 0 0 0;  % 1
                  1 1 0 0;  % 2
                  0 1 0 0;  % 3
                  0 1 1 0;  % 4
                  1 1 1 0;  % 5
                  1 0 1 0;  % 6
                  0 0 1 0;  % 7
                  0 0 1 1;  % 8
                  1 0 1 1;  % 9
                  1 1 1 1;  % 10
                  0 1 1 1;  % 11
                  0 1 0 1;  % 12
                  1 1 0 1;  % 13
                  1 0 0 1;  % 14
                  0 0 0 1;];% 15
% 星座点位置表 16QAM
star_table_1 = [-1*(-3:2:3) (-3:2:3) -1*(-3:2:3) (-3:2:3)];
star_table_2 = [ones(1, 4)*3 ones(1, 4) -1*ones(1,4) -3*ones(1,4)];
star_table = [star_table_1' star_table_2'];
star_table_T = star_table';
table_used = reshape(star_table_T, 1, M*2);
% 星座点位置表 16PSK
phase = 0:2*pi/M:(2*pi-2*pi/M);
PSK16StarTable = [cos(phase);
                  sin(phase)];
PSK_table_used = reshape(PSK16StarTable, M*2, 1);
% 基带信号
N = 4*10^4; % bit数
base = (sign(randn(1, N)) + 1) / 2;
mid_modul = reshape(base, [4 N/4]);
mid_modul = mid_modul';
% 映射到星座点上 QAM 和 QPSK
modulSignalPosi = zeros(N/4, 2);
PSK_modulSignalPosi = zeros(2, N/4);
for symbol = 1:N/4
    dude = gray2int(mid_modul(symbol, :)) + 1;
    modulSignalPosi(symbol, :) = star_table(dude, :);
    PSK_modulSignalPosi(:, symbol) = PSK16StarTable(:, dude);
end
% 噪声
sigma = sqrt(4*(M-1)/6/log2(M)./EbN0/2);
PSK_sigma = sqrt(1/log2(M)./EbN0/2);
% 过信道 解调 求信噪比
be = zeros(1, length(EbN0dB));
se = zeros(1, length(EbN0dB));
PSK_be = zeros(1, length(EbN0dB));
PSK_se = zeros(1, length(EbN0dB));
for index = 1:length(EbN0dB)
    % 加噪声
    reciPosi = modulSignalPosi + sigma(index) * randn(N/4, 2);
    
    % 最小距离解调 QAM
    distanceMid = repmat(reciPosi, [1 M]) - repmat(table_used, N/4, 1);
    distanceMid = distanceMid.^2;
    distance = distanceMid(:, 1:2:(M*2-1)) + distanceMid(:, 2:2:(M*2));
    distance = distance';
    % decodePosi 即为解调结果对应gray_code_table的位置
    [~, decodePosi] = min(distance);
    
    % 解调结果映射到基带 QAM
    toBaseGray = gray_code_table(decodePosi, :);
    toBaseSignal = reshape(toBaseGray', 1, N);
    be(index) = sum(abs(base-toBaseSignal));
    se_posi = double(mid_modul ~= toBaseGray);
    se(index) = sum(sign(sum(se_posi, 2)));
    
    % PSK
    PSK_reciPosi = PSK_modulSignalPosi + PSK_sigma(index) * randn(2, N/4);
    
    PSK_distanceMid = repmat(PSK_reciPosi, [M 1]) - repmat(PSK_table_used, [1 N/4]);
    PSK_distanceMid = PSK_distanceMid.^2;
    PSK_distance = PSK_distanceMid(1:2:(M*2-1), :) + PSK_distanceMid(2:2:(M*2), :);
    [~, PSK_decodePosi] = min(PSK_distance);
    
    PSK_toBaseGray = gray_code_table(PSK_decodePosi, :);
    PSK_toBaseSignal = reshape(PSK_toBaseGray', 1, N);
    PSK_be(index) = sum(abs(base-PSK_toBaseSignal));
    PSK_se_posi = double(mid_modul ~= PSK_toBaseGray);
    PSK_se(index) = sum(sign(sum(PSK_se_posi, 2)));
end
semilogy(EbN0dB, se/N*4, 'v', 'MarkerEdgeColor', 'r')
hold on
semilogy(EbN0dB, be/N, '*', 'MarkerEdgeColor', 'r')
hold on
semilogy(EbN0dB, PSK_se/N*4, '^', 'MarkerEdgeColor', 'm')
hold on
semilogy(EbN0dB, PSK_be/N, '*', 'MarkerEdgeColor', 'm')
legend('16QAM理论误码率', '16PSK理论误码率', '16QAM理论误比特率',  '16PSK理论误比特率', ...
    '16QAM仿真误码率', '16QAM仿真误比特率', '16PSK仿真误码率', '16PSK仿真误比特率')
title('16QAM and 16PSK')

