% This function test if MicroDAQ is connected  
function mdaq_con_test()

% MLink library name
if ispc
    arch = computer('arch');
    suffix = arch(end-1:end);
    mlinklib = ['MLink',suffix];
else
    mlinklib = 'libmlink64';
end

% Load MLink library
TargetRoot = getpref('microdaq','TargetRoot');
loadlibrary([TargetRoot,'/MLink/',mlinklib],[TargetRoot,'/MLink/MLink.h']);

%libfunctionsview mlinklib
% Pointer to link fd
link_fd = libpointer('int32Ptr',0);
hwid = libpointer('int32Ptr',zeros(1,5));
% Connect to MicroDAQ
TargetIP = getpref('microdaq','TargetIP');
fprintf('Connecting to MicroDAQ......'); 
result = calllib(mlinklib,'mlink_connect',TargetIP,4343,link_fd);
if result < 0
    out = calllib(mlinklib,'mlink_error',result);
    unloadlibrary(mlinklib);
    
    fprintf(' FAILED!\nUnable to connect to MicroDAQ device, check your configuration!\n');
    fprintf('Simulink is configured to connect to MicroDAQ with following settings:\n');
    fprintf('IP address: %s, port %d\n', TargetIP, 4343); 
    fprintf('If MicroDAQ has different IP address use mdaq_ip_set to set correct address.\n\n'); 
    error('Error during connecting to MicroDAQ device %s',out);
end

result = calllib(mlinklib,'mlink_hwid',link_fd.Value, hwid );

if result < 0
    out = calllib(mlinklib,'mlink_error',result);
    result = calllib(mlinklib,'mlink_disconnect',link_fd.Value );
    if result < 0
        out = calllib(mlinklib,'mlink_error',result);
        unloadlibrary(mlinklib);
        error('Error during disconnecting %s',out);
    end
    unloadlibrary(mlinklib);
    error('%s',out);
end

if hwid.Value(1) ~= 2000 && hwid.Value(1) ~= 1100 && hwid.Value(1) ~= 1000 
    result = calllib(mlinklib,'mlink_disconnect',link_fd.Value );
    if result < 0
        out = calllib(mlinklib,'mlink_error',result);
        unloadlibrary(mlinklib);
        error('Error during disconnecting %s',out);
    end
    unloadlibrary(mlinklib);
    error('Unknown MicroDAQ device');
end
fprintf('SUCCESS\n');

% create file for proper sysbios binary selection
TargetRoot = getpref('microdaq','TargetRoot');
path = [TargetRoot,  '\sysbios.mk'];
if ispc
	path(path=='\')='/';
end
fileID = fopen(path, 'w+');
fprintf(fileID,'SYSBIOS_PATH=sysbios/cpu%d/configPkg/linker.cmd', hwid.Value(4));
fclose(fileID);

result = calllib(mlinklib,'mlink_disconnect',link_fd.Value );
if result < 0
    out = calllib(mlinklib,'mlink_error',result);
    unloadlibrary(mlinklib);
    error('Error during disconnecting %s',out);
end

% Unload MLink library
unloadlibrary(mlinklib);

