clear all;
close all;
clc;

pathNum = 2.^(0:5);           % 来波数
initPhase = 0;
% theta = initPhase + 2*pi/N.*(0:N-1);
allLen = 10;
% standardLength = 10;
[X, Y] = meshgrid(0:0.01:allLen);
[row, col] = size(X);
F_all_2pi = zeros(row, col, length(pathNum));
F_all_pi8 = zeros(row, col, length(pathNum));
for i = 1:length(pathNum)
    N = pathNum(i);                            % 来波数
    theta = initPhase + 2*pi/N.*(0:N-1);    % 来波方向
    theta2 = initPhase + pi/8/N.*(0:N-1);
    F = zeros(size(X));
    F2 = zeros(size(X));
    for path = 1:N
        randomPhaseOfPath = randn()*2*pi;
        Xi = 2*pi*(Y*cos(theta(path))-X*sin(theta(path)));
        Xi2 = 2*pi*(Y*cos(theta2(path))-X*sin(theta2(path)));
        F = F + exp(1j*(Xi+randomPhaseOfPath));
        F2 = F2 + exp(1j*(Xi2+randomPhaseOfPath));
    end
    F = 1/sqrt(N)*F;
    F_all_2pi(:, :, i) = abs(F);
    F2 = 1/sqrt(N)*abs(F2);
    F_all_pi8(:, :, i) = abs(F2);
end


% subplot(221)
% mesh(X, Y, F_all_2pi(:,:,1))
% xlabel('x');ylabel('y');zlabel('幅度')
% legend('N=1, waveRange=2\pi')
% subplot(222)
% mesh(X,Y,F_all_2pi(:,:,2))
% xlabel('x');ylabel('y');zlabel('幅度')
% legend('N=2, waveRange=2\pi')
% subplot(223)
% mesh(X,Y,F_all_pi8(:,:,1))
% xlabel('x');ylabel('y');zlabel('幅度')
% legend('N=1, waveRange=0.5\pi')
% subplot(224)
% mesh(X,Y,F_all_pi8(:,:,2))
% xlabel('x');ylabel('y');zlabel('幅度')
% legend('N=2, waveRange=0.5\pi')
% 
% figure(2)
% subplot(221)
% mesh(X, Y, F_all_2pi(:,:,3))
% xlabel('x');ylabel('y');zlabel('幅度')
% legend('N=4, waveRange=2\pi')
% subplot(222)
% mesh(X,Y,F_all_2pi(:,:,4))
% xlabel('x');ylabel('y');zlabel('幅度')
% legend('N=8, waveRange=2\pi')
% subplot(223)
% mesh(X,Y,F_all_pi8(:,:,3))
% xlabel('x');ylabel('y');zlabel('幅度')
% legend('N=4, waveRange=0.5\pi')
% subplot(224)
% mesh(X,Y,F_all_pi8(:,:,4))
% xlabel('x');ylabel('y');zlabel('幅度')
% legend('N=8, waveRange=0.5\pi')
% 
% figure(3)
% subplot(221)
% mesh(X, Y, F_all_2pi(:,:,5))
% xlabel('x');ylabel('y');zlabel('幅度')
% legend('N=16, waveRange=2\pi')
% subplot(222)
% mesh(X,Y,F_all_2pi(:,:,6))
% xlabel('x');ylabel('y');zlabel('幅度')
% legend('N=32, waveRange=2\pi')
% subplot(223)
% mesh(X,Y,F_all_pi8(:,:,5))
% xlabel('x');ylabel('y');zlabel('幅度')
% legend('N=16, waveRange=0.5\pi')
% subplot(224)
% mesh(X,Y,F_all_pi8(:,:,6))
% xlabel('x');ylabel('y');zlabel('幅度')
% legend('N=32, waveRange=0.5\pi')


% figure(4)
% testX = 5.23;
% semilogy(Y(:, 1), F_all_2pi(:, testX*100+1, 5))
% hold on
% semilogy(Y(:, 1), F_all_pi8(:, testX*100+1, 5))
% xlabel('y');ylabel('幅度');
% legend('waveRange=2\pi, x=5.23, N=16', 'waveRange=\pi/8, x=5.23, N=16')
% figure(5)
% testY = 5.20;
% semilogy(X(1, :), F_all_2pi(testY*100+1, :, 5))
% hold on
% semilogy(X(1, :), F_all_pi8(testY*100+1, :, 5))
% xlabel('x'); ylabel('幅度')
% legend('waveRange=2\pi, y=5.20, N=16', 'waveRange=\pi/8, y=5.20, N=16')