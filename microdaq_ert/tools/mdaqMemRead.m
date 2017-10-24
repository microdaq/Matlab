function data = mdaqMemRead(index, dataSize, vectorSize)

error('Not supported - check for upgrades');
if index < 1 || index > 4000000
    error('Wrong index');
end

if index + dataSize > 4000000
    error('Data out of memory');
end

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

data = zeros(1, dataSize, 'single'); 
dataPtr = libpointer('singlePtr', data);
result = calllib(mlinklib,'mlink_mem_read',link_fd, int32(index), int32(dataSize), dataPtr);
if result < 0
    out = calllib(mlinklib,'mlink_error',result);
    error(out);
end

data = reshape(dataPtr.Value, dataSize / vectorSize, vectorSize);

