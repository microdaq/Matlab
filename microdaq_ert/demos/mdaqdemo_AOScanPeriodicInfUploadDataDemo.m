% generate triangle waveform in periodic mode for 2 seconds with 1kHz
% analog output update rate 

% generate output data 
data0 = linspace(0,2,1000)';

% init AO scanning session - first channel (1), 0 to 5V output range,
% perdiodic mode, 1kHz update rate, duration - Inf
mdaqAOScanInit(1, data0, [0, 5], false, 1000, -1);

% start signal generation
mdaqAOScan();

%generate new data 
data0 = (linspace(0,2,1000)') * 2;

pause(2)

% upload new data - don't reset data index after upload
mdaqAOScanData(1, data0, false);

pause(2)

%stop scanning session
mdaqAOScanStop();