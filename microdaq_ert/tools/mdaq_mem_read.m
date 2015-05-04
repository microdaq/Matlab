% function uses MLink to download data from MicroDAQ memory
% exampe: mdaq_mem_read(hex2dec(1, 400, 4)

function res_x =  mdaq_mem_read(address, data_size, vector_size)
len = data_size;

if len < 1
    error('Data count should be grater than 0!');
end


if mod( data_size, vector_size) > 0
    error('Incorrect data and vector size!!');
end

nr_channels = vector_size;
nr_samples = data_size / vector_size;

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

% Connect to MicroDAQ
TargetIP = getpref('microdaq','TargetIP');

result = calllib(mlinklib,'mlink_connect',TargetIP,4343,link_fd);
if result < 0
    out = calllib(mlinklib,'mlink_error',result);
    unloadlibrary(mlinklib);
    error('Error connecting to MicroDAQ: %s',out);
end

% Read DSP memory from specified index
data_init = single(zeros(len, 1)); % preallocate buffer of len 
dsp_ptr = libpointer('singlePtr', data_init); % data_ptr is a pointer to data 
result = calllib(mlinklib,'mlink_mem_get2',link_fd, address, len, dsp_ptr);
if result < 0
    out = calllib(mlinklib,'mlink_error',result);
    unloadlibrary(mlinklib);
    error('Error during MicroDAQ memory access %s',out);
end

% Perform type cast from byte to double
temp1_data = typecast(dsp_ptr.Value, 'single');
res_x = reshape(temp1_data, nr_channels, nr_samples);
% Return results


result = calllib(mlinklib,'mlink_disconnect',link_fd.Value );
if result < 0
    out = calllib(mlinklib,'mlink_error',result);
    unloadlibrary(mlinklib);
    error('Error during disconnecting %s',out);
end

% Unload MLink library
unloadlibrary(mlinklib);
