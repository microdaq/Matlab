% generate triangle waveform in stream mode for 2 seconds with 1kHz
% analog output update rate 

% generate output data 
data0 = linspace(0,2,1000)';

% init AO scanning session - first channel (1), 0 to 5V output range,
% perdiodic mode, 1kHz update rate, duration - Inf
mdaqAOScanInit(1, data0, [0, 5], true, 1000, -1);

% start signal generation
mdaqAOScan();

for i = 1:10
    % generate new data 
    data0 = (linspace(0,2,1000)') * (1+1*i/10);
    % queue new data - blocking mode 
    mdaqAOScanData(1, data0, true);    
end

% wait for sesstion end 
pause(2)

%stop scanning session
mdaqAOScanStop();