clear all;
close all;
clc;

SNR_dB = -10:0.5:16;
% 比特信噪比
EbN0dB = SNR_dB - 10*log10(2);
SNR = 10.^(SNR_dB/10);
Pe_qpsk = 1 - (1- 0.5*erfc(sqrt(SNR/2))).^2;
Pb_qpsk = 0.5*erfc(sqrt(SNR/2));
Pe_bpsk = 0.5*erfc(sqrt(SNR));
semilogy(EbN0dB, Pe_qpsk, 'LineWidth', 1)
hold on
semilogy(EbN0dB, Pb_qpsk)
hold on
semilogy(SNR_dB, Pe_bpsk, 'o')
xlim([-10, 10])
xlabel('E_b/N_0 (dB)')
grid on
legend('QPSK 误码率', 'QPSK 误比特率', 'BPSK 误码率')

