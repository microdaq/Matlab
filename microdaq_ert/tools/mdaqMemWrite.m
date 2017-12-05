function mdaqMemWrite(index, data)

error('Not supported - check for upgrades');

if index < 1 || index > 4000000
    error('Wrong index');
end

dataSize = size(data,1) *size(data,2);
if index + dataSize > 4000000
    error('Data out of memory');
end

% MLink library name
if ispc
    arch = computer('arch');
    suffix = arch(end-1:end);
    mlinklib = ['MLink',suffix];
else
    mlinklib = 'libmlink64';
end

result = mdaqOpen();
if result < 0
    out = calllib(mlinklib,'mlink_error',result);
    error('Error connecting to MicroDAQ: %s',out);
end
link_fd = libpointer('int32Ptr',result);

data = reshape(data, 1, dataSize);
dataPtr = libpointer('singlePtr', single(data));

result = calllib(mlinklib,'mlink_mem_write',link_fd, int32(index), int32(dataSize), dataPtr);
if result < 0
    out = calllib(mlinklib,'mlink_error',result);
    error(out);
end

