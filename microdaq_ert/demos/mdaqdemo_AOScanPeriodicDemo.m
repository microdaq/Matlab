% generate triangle waveform in periodic mode for 10 seconds with 1kHz
% analog output update rate 

% generate output data 
data0 = linspace(0,2,1000)';

% init AO scanning session - first channel (1), 0 to 5V output range,
% perdiodic mode, 1kHz update rate, duration - 10seconds
mdaqAOScanInit(1, data0, [0, 5], false, 1000, 10);

% start signal generation
mdaqAOScan();

