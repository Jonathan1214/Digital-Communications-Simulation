clear all;
close all;
clc;

% K = [1 3 7 11];
% FDT = [0.1 0.01 0.001];
% N = 2.^(0:5);

path = 15;
thetaN = 2*pi/path:2*pi/path:2*pi;
% thetaN = rand(1, path)*2*pi;
% thetaN = thetaN / 8;
dt = 0:10^5;
dt = dt';
FDT = 0.01;
KPool = [1 3 7 11];
g = zeros(length(dt), length(KPool));
phaseOfChannel = zeros(length(dt), length(KPool));
randomPhase = rand(1, path)*2*pi;
for KIndex = 1:length(KPool)
    K = KPool(KIndex);
    theNthSignal = zeros(length(dt), 1);
    A = sqrt(K/(K+1));
    B = sqrt(1/path/(1+K));
    for i = 1:path
        theNthSignal = theNthSignal + exp(1j*(2*pi*FDT*cos(thetaN(i))*dt+randomPhase(i)));
    end
    mainWaveDirec = rand()*2*pi;
    mainWaveRandomPhase = rand()*2*pi;
    F = B*theNthSignal + A*exp(1j*(2*pi*FDT*cos(mainWaveDirec)*dt+mainWaveRandomPhase));

    g(:, KIndex) = abs(F);
    phaseOfChannel(:, KIndex) = angle(F)*180/pi;
end

for KIndex = 1:length(KPool)
    subplot(4,4,1+(KIndex-1)*4)
    semilogy(dt, g(:,KIndex))
    xlim([0 1000]);xlabel('离散时间');ylabel('幅度')
    subplot(4,4,2+(KIndex-1)*4)
    plot(dt, phaseOfChannel(:,KIndex))
    xlim([0 1000]);xlabel('离散时间');ylabel('相位/\circ')
    subplot(4,4,3+(KIndex-1)*4)
    h = histogram(g(:,KIndex), 'Normalization', 'pdf', 'EdgeColor', 'b');
    xlabel('幅度');ylabel('PDF')
    subplot(4,4,4+(KIndex-1)*4)
    hh = histogram(phaseOfChannel(:,KIndex), 'Normalization', 'count');
    xlabel('相位');ylabel('PDF')
end

%% test FDT
% K = 7;
% FDT = [0.1 0.01 0.001];
% A = sqrt(K/(K+1));
% B = sqrt(1/path/(1+K));
% g2 = zeros(length(dt), length(FDT));
% phaseOfChannel2 = zeros(length(dt), length(FDT));
% 
% for fdtIndex = 1:length(FDT)
%     fdt = FDT(fdtIndex);
%     theNthSignal = zeros(length(dt), 1);
%     for i = 1:path
%         randomPhase = rand()*2*pi;
%         theNthSignal = theNthSignal + exp(1j*(2*pi*fdt*cos(thetaN(i))*dt+randomPhase));
%     end
%     mainWaveDirec = rand()*2*pi;
%     mainWaveRandomPhase = rand()*2*pi;
%     F = B*theNthSignal + A*exp(1j*(2*pi*fdt*cos(mainWaveDirec)*dt+mainWaveRandomPhase));
%     g2(:, fdtIndex) = abs(F);
%     phaseOfChannel2(:, fdtIndex) = angle(F)*180/pi;
% end
% 
% for fdtIndex = 1:length(FDT)
%     subplot(3,4,1+(fdtIndex-1)*4)
%     semilogy(dt, g2(:,fdtIndex))
%     xlim([0 10000]);xlabel('离散时间');ylabel('幅度')
%     subplot(3,4,2+(fdtIndex-1)*4)
%     plot(dt, phaseOfChannel2(:,fdtIndex))
%     xlim([0 1000]);xlabel('离散时间');ylabel('相位/\circ')
%     subplot(3,4,3+(fdtIndex-1)*4)
%     h = histogram(g2(:,fdtIndex), 'Normalization', 'pdf', 'EdgeColor', 'b');
%     xlabel('幅度');ylabel('PDF')
%     subplot(3,4,4+(fdtIndex-1)*4)
%     hh = histogram(phaseOfChannel2(:,fdtIndex), 'Normalization', 'count');
%     xlabel('相位');ylabel('PDF')
% end

%% path
% FDT = 0.01;
% K = 7;
% A = sqrt(K/(K+1));
% B = sqrt(1/path/(1+K));
% path2 = 2.^(0:5);
% 
% g3 = zeros(length(dt), length(path2));
% phaseOfChannel3 = zeros(length(dt), length(path2));
% for pathIndex = 1:length(path2)
%     path2Cur = path2(pathIndex)-1;
%     thetaN2 = 2*pi/path2Cur:2*pi/path2Cur:2*pi;
%     theNthSignal = zeros(length(dt), 1);
%     for i = 1:path2Cur
%         randomPhase = rand()*2*pi;
%         theNthSignal = theNthSignal + exp(1j*(2*pi*FDT*cos(thetaN2(i))*dt+randomPhase));
%     end
%     mainWaveDirec = rand()*2*pi;
%     mainWaveRandomPhase = rand()*2*pi;
%     F = B*theNthSignal + A*exp(1j*(2*pi*FDT*cos(mainWaveDirec)*dt+mainWaveRandomPhase));
%     g3(:, pathIndex) = abs(F);
%     phaseOfChannel3(:, pathIndex) = angle(F)*180/pi;
% end
% 
% for pathIndex = 1:length(path2)
%     figure(pathIndex)
%     subplot(221)
%     semilogy(dt, g3(:,pathIndex))
%     xlim([0 10000]);xlabel('离散时间');ylabel('幅度')
%     subplot(222)
%     plot(dt, phaseOfChannel3(:,pathIndex))
%     xlim([0 1000]);xlabel('离散时间');ylabel('相位/\circ')
%     subplot(223)
%     hgPath = histogram(g3(:,pathIndex), 'Normalization', 'pdf', 'EdgeColor', 'b');
%     xlabel('幅度');ylabel('PDF')
%     subplot(224)
%     hphasePath = histogram(phaseOfChannel3(:,pathIndex), 'Normalization', 'count');
%     xlabel('相位');ylabel('PDF')
% end
