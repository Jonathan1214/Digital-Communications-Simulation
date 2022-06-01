clear all;
clc;

EbN0dB = 0:1:15;
EbN0 = 10.^(EbN0dB/10);

M = 16;
Pe_16_help = 2*(1-1/sqrt(M))*qfunc(sqrt(3*log2(M)*EbN0/(M-1)));
Pe_16QAM = 1- (1 - Pe_16_help).^2;
Pb_16QAM = Pe_16QAM / 4;

Pe_16PSK = 2*qfunc(sin(pi/M)*sqrt(2*log2(M)*EbN0));
Pb_16PSK = Pe_16PSK / 4;

Pe_BPSK = 0.5*erfc(sqrt(EbN0));

semilogy(EbN0dB, Pe_16QAM, EbN0dB, Pb_16QAM)
hold on
semilogy(EbN0dB, Pe_16PSK, EbN0dB, Pb_16PSK)
hold on
semilogy(EbN0dB, Pe_BPSK)
xlim([0 10])
legend('16QAM误码率', '16QAM误比特率', '16PSK误码率', '16PSK误比特率', 'BPSk误码率和误比特率')
xlabel('\it{E_b/N_0} \rm(dB)')
ylabel('P_b and P_e')
title('16QAM and 16PSK and BPSK')
grid on









