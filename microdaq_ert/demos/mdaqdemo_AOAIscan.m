aiData = [];
channels = 1;
rate = 1000;
scanDataSize = 1000;
duration = 5;
expValue = -3;
sineBias = 2.5;
sineBase = sin(linspace(0, 2*pi, scanDataSize));
expWave = exp(linspace(expValue, expValue + 0.8, scanDataSize));
sineWave = sineBase.*expWave + sineBias;

% initialize analog input/output scanning sessions
mdaqAOScanInit(channels, sineWave', [-10,10], true, rate, duration);
mdaqAIScanInit(channels, [-10,10], false, rate, duration);

% start AI scanning without waiting for data
mdaqAIScan(0, true);
% start signal generation
mdaqAOScan();
n = (rate  * duration) / scanDataSize;

for i=1:n-1
    expValue = expValue + 0.8;
    expWave = exp(linspace(expValue, expValue + 0.8, scanDataSize));
    sineWave = sineBase.*expWave + sineBias;
    % queue new data 
    mdaqAOScanData(channels, sineWave', true);
    % start and acquire data from analog inputs
    aiData = [aiData; mdaqAIScan(scanDataSize, true)];
end
% acquire rest of samples
aiData = [aiData; mdaqAIScan(scanDataSize, true)];
plot(aiData)
clear aiData;