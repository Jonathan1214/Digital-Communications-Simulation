clear all;
close all;
clc;

%% test histogram
% N = 1000000;
% mu = 0;
% sigma = 1;
% R = random('Normal', mu, sigma, [N 1]);
% h = histogram(R, 'Normalization', 'pdf', 'EdgeColor', 'b');


%% Rayleigh Channel
path = 16;                       % 8 径

FDT = [0.0031 0.001];
initPhase = 2*pi/path*rand();
thetaN = initPhase + 2*pi/path.*(0:path-1);
k = (0:10^5)';                    % 离散时间
g = zeros(length(k), length(FDT));
phaseOfChannel = zeros(length(k), length(FDT));
for fdtIndex = 1:length(FDT)
    fdt = FDT(fdtIndex);
    Signal = zeros(length(k), 1);
    for i = 1:path
        randomPhase = rand()*2*pi;
        Signal = Signal + exp(1j*(2*pi*fdt*cos(thetaN(i))*k+randomPhase));
    end
    F = 1/sqrt(path)*Signal;
    g(:, fdtIndex) = abs(F);
    phaseOfChannel(:, fdtIndex) = angle(F)*180/pi;
end
%% plot 2
fdt = 0.0031;
path = 4;
initPhase = 2*pi/path*rand();
thetaN = initPhase + 2*pi/path.*(0:path-1);
Signal = zeros(length(k), 1);
for i = 1:path
    randomPhase = rand()*2*pi;
    Signal = Signal + exp(1j*(2*pi*fdt*cos(thetaN(i))*k+randomPhase));
end
F2 = 1/sqrt(path)*Signal;
g2 = abs(F2);
phaseOfChannel(:, fdtIndex) = angle(F2)*180/pi;

%% plot
figure(1)
semilogy(k, g)
hold on
semilogy(k, g2)
xlim([0 1000]);xlabel('离散时间');ylabel('幅度')
title('瑞利衰落信道特性');
legend('FDT = 0.0031, N = 16', 'FDT = 0.001,   N = 16', 'FDT = 0.0031, N = 4')




% for fdtIndex = 1:length(FDT)
%     subplot(3,4,1+(fdtIndex-1)*4)
%     semilogy(k, g(:,fdtIndex))
%     xlim([0 1000]);xlabel('离散时间');ylabel('幅度')
%     subplot(3,4,2+(fdtIndex-1)*4)
%     plot(k, phaseOfChannel(:,fdtIndex))
%     xlim([0 1000]);xlabel('离散时间');ylabel('相位/\circ')
%     subplot(3,4,3+(fdtIndex-1)*4)
%     h = histogram(g(:,fdtIndex), 'Normalization', 'pdf', 'EdgeColor', 'b');
%     xlabel('幅度');ylabel('PDF')
%     subplot(3,4,4+(fdtIndex-1)*4)
%     hh = histogram(phaseOfChannel(:,fdtIndex), 'Normalization', 'count');
%     xlabel('相位');ylabel('PDF')
% end

%% two
% FDT = 0.01;
% path2 = 2.^(0:5);
% 
% g2 = zeros(length(k), length(path2));
% phaseOfChannel2 = zeros(length(k), length(path2));
% 
% for pathIndex = 1:length(path2)
%     path2Cur = path2(pathIndex);
%     thetaN2 = 2*pi/path2Cur:2*pi/path2Cur:2*pi;
%     thetaN2 = thetaN2 / 8;
%     Signal2 = zeros(length(k), 1);
%     for i = 1:path2Cur
%         randomPhase = rand()*2*pi;
%         Signal2 = Signal2 + exp(1j*(2*pi*FDT*cos(thetaN2(i))*k+randomPhase));
%     end
%     F2 = 1/sqrt(path2Cur)*Signal2;
%     g2(:, pathIndex) = abs(F2);
%     phaseOfChannel2(:, pathIndex) = angle(F2)*180/pi;
% end
% 
% for pathIndex = 1:length(path2)
%     figure(pathIndex)
%     subplot(221)
%     semilogy(k, g2(:,pathIndex))
%     xlim([0 10000]);xlabel('离散时间');ylabel('幅度')
%     subplot(222)
%     plot(k, phaseOfChannel2(:,pathIndex))
%     xlim([0 1000]);xlabel('离散时间');ylabel('相位/\circ')
%     subplot(223)
%     hgPath = histogram(g2(:,pathIndex), 'Normalization', 'pdf', 'EdgeColor', 'b');
%     xlabel('幅度');ylabel('PDF')
%     subplot(224)
%     hphasePath = histogram(phaseOfChannel2(:,pathIndex), 'Normalization', 'count');
%     xlabel('相位');ylabel('PDF')
% end

