function hLib = microdaq_timer


hLib = RTW.TflTable;
%---------- entry: code_profile_read_timer -----------
hEnt = RTW.TflCFunctionEntry;
hEnt.setTflCFunctionEntryParameters( ...
          'Key', 'code_profile_read_timer', ...
          'Priority', 100, ...
          'ImplementationName', 'profileTimerRead', ...
          'ImplementationSourceFile', fullfile(getpref('microdaq','TargetRoot'),...
                                        'rtiostream','microdaq_timer.c'));

hEnt.EntryInfo.CountDirection = 'RTW_TIMER_UP';
hEnt.EntryInfo.TicksPerSecond = 300000000;

% detect CPU 
sysbiosPath =  fullfile(getpref('microdaq','TargetRoot'), 'sysbios.mk');
fileID = fopen(sysbiosPath,'r');
CPUSysbios = fgets(fileID);
fclose(fileID);
cpuVer = strfind(CPUSysbios,'cpu0');

if (cpuVer ~= isempty(cpuVer))
    hEnt.EntryInfo.TicksPerSecond = 300000000;
else
    hEnt.EntryInfo.TicksPerSecond = 456000000;
end

% Conceptual Args
arg = hEnt.getTflArgFromString('y1','uint32');
arg.IOType = 'RTW_IO_OUTPUT';
hEnt.addConceptualArg(arg);

% Implementation Args
arg = hEnt.getTflArgFromString('y1','uint32');
arg.IOType = 'RTW_IO_OUTPUT';
hEnt.Implementation.setReturn(arg);

hLib.addEntry( hEnt );

