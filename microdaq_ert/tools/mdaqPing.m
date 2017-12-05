% This function test if MicroDAQ is connected  
function mdaqPing()

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
    if ~libisloaded(mlinklib)
        loadlibrary([TargetRoot,'/MLink/',mlinklib],[TargetRoot,'/MLink/MLink.h']);
    end

%libfunctionsview mlinklib
% Pointer to link fd
hwid = libpointer('int32Ptr',zeros(1,5));
% Connect to MicroDAQ
TargetIP = getpref('microdaq','TargetIP');
fprintf('Connecting to MicroDAQ@%s......',TargetIP); 
try 
    link_fd = mdaqOpen();
catch
    fprintf(' FAILED!\nUnable to connect to MicroDAQ device, check your configuration!\n');
    fprintf('Simulink is configured to connect to MicroDAQ with following settings:\n');
    fprintf('IP address: %s, port %d\n', TargetIP, 4343); 
    fprintf('If MicroDAQ has different IP address use mdaqSetIP to set correct address.\n\n'); 
    error('Error during connecting to MicroDAQ device');
end

% get MicroDAQ HWID 
result = calllib(mlinklib,'mlink_hwid',link_fd, hwid );
if result < 0
    out = calllib(mlinklib,'mlink_error',result);
    result = calllib(mlinklib,'mlink_disconnect',link_fd);
    if result < 0
        out = calllib(mlinklib,'mlink_error',result);
        error('Error during disconnecting: %s',out);
    end
    error('%s',out);
end

if hwid.Value(1) ~= 2000 && hwid.Value(1) ~= 1100 && hwid.Value(1) ~= 1000 
    mdaqClose();
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

mdaqClose();

 

