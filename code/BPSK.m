clear all;
clc;

% Eb/N0 = Ps/Pn = a^2 / 2 / sigma^2
% 归一化能量e
% Eb = 1, a = 1
% 则 N0 = 
%    sigma = 
EbN0dB = 0:1:10;
SNR = 10.^(-EbN0dB/10);
sigma = sqrt(SNR/2);
% 理论 Pb
N = 2*10^6;
Pb = 0.5*erfc(sqrt(1./SNR));
ber = zeros(1, length(EbN0dB));
a = sign(randn(1, N));
noise = randn(1, N);
for n = 1:length(EbN0dB)
    rk = a + sigma(n)*noise;
    dec_a = sign(rk);
    ber(n) = sum(abs(a-dec_a)/2)/length(a);
end

semilogy(EbN0dB, ber, 'rd');
hold on;
semilogy(EbN0dB, Pb, 'LineWidth', 1);
% legend('理论结果', '仿真结果')
% xlabel('E_b/N_0(dB)'); ylabel('Pb');
% title('BPSK误码率仿真')
grid on





