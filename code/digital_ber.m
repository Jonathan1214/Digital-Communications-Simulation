clear all;
clc;

EbN0dB = 0:0.5:10;
N0 = 10.^(-EbN0dB/10);
sigma = sqrt(N0/2);
% 理论误码率
Pb = 0.5*erfc(sqrt(1./N0));
% 仿真值
ber = zeros(1, length(EbN0dB));
for n = 1:length(EbN0dB)
    a = sign(randn(1, 100000));
    rk = a + sigma(n)*randn(1, 100000);
    dec_a = sign(rk);
    ber(n) = sum(abs(a-dec_a)/2)/length(a);
end

semilogy(EbN0dB, Pb);
hold on;
semilogy(EbN0dB, ber, 'rd-');
legend('理论结果', '仿真结果')
xlabel('Eb/N0(dB)'); ylabel('Pb');



