% 3 second AI scan session (Inf scanning session) with 10kHz scan rate on first channel (1) and
% -10 to 10V range in single-ended configuration
mdaqAIScanInit(1, [-10,10], false, 10000, -1);

% start and acquire data from AI 
data = mdaqAIScan(10000, true);
data = [data; mdaqAIScan(10000, true)];
data = [data; mdaqAIScan(10000, true)];

mdaqAIScanStop();

plot(data)
