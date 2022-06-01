9clear all;
close all;
clc;
%% 理论
SNR_dB = 3:0.5:13;
% 比特信噪比
EbN0dB = SNR_dB - 10*log10(2);
SNR = 10.^(SNR_dB/10);
Pe = 1 - (1- 0.5*erfc(sqrt(SNR/2))).^2;
semilogy(EbN0dB, Pe, 'LineWidth', 1)
hold on

%% baseband 
N = 1000000;
base = (sign(randn(1, N)) + 1) / 2;

%% star1 
%%%% star1 %%%%%%%%%%%
%      +1
%   -1    +1
%      -1
%%%%%%%%%%%%%%%%%%%%%%

%%%%%% Gray %%%%%%%%%%
%       00
%     01  10
%       11
%%%%%%%%%%%%%%%%%%%%%%
a = base(1:2:N-1);
b = base(2:2:N);

%%% Modulate
ma = b - a;
mb = double((a + b) == 0) + -1*double((a + b) == 2);
deci = zeros(1, N);
sigma = sqrt(1./SNR/2);
noise_a = randn(1, N/2);
noise_b = randn(1, N/2);
ber_gray = zeros(1, length(SNR_dB));
ser_gray = zeros(1, length(SNR_dB));
for index = 1:length(SNR_dB)
    ra = ma + sigma(index)*noise_a;
    rb = mb + sigma(index)*noise_b;
    decide_a = demodulate2(ra);
    decide_b = demodulate2(rb);
    
    decode_a = double(decide_a == -1) + double(decide_b == -1);
    decode_b = double(decide_a == 1) + double(decide_b == -1);
    
    err_a = double(decode_a ~= a);
    err_b = double(decode_b ~= b);
    err_s = (sign(err_a + err_b - 0.5) + 1) / 2;
    ber_gray(index) = sum(err_a + err_b) / N;
    ser_gray(index) = sum(err_s)/N*2;
end

semilogy(EbN0dB, ser_gray, 'o')
hold on
semilogy(EbN0dB, ber_gray, '*')
%%%%%% Normal %%%%%%%%
%       01
%     10  00
%       11
%%%%%%%%%%%%%%%%%%%%%%
Normal_base = reshape(base, [2, N/2]);
for i = 1:N/2
       if Normal_base(:, i) == [0;0]
           Normal_base(:, i) = [1;0];
       else if Normal_base(:, i) == [0;1]
           Normal_base(:, i) = [0;1];
           else if Normal_base(:, i) == [1;0]
           Normal_base(:, i) = [-1;0];
               else
           Normal_base(:, i) = [0;-1];           
               end
           end
       end
end

