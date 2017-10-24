function mdaqAOScanData(channels, data, opt)

    if opt == true 
        opt = 1;
    else 
        opt = 0; 
    end
    
    if size(channels, 1) > 1 
        error('Wrong channel - scalar or single row vector expected');
    end
    
    chCount = size(channels,2);
    if size(data,2) ~= chCount 
        error('Wrong output data - colums should match selected channels!')
    end
    
    dataSize = size(data,1) *chCount;
    channelsPtr = libpointer('uint8Ptr', channels);

    data = reshape(data, 1, dataSize);
    dataPtr = libpointer('singlePtr', single(data));

    
    TargetRoot = getpref('microdaq','TargetRoot');
     if ispc
        arch = computer('arch');
        suffix = arch(end-1:end);
        mlinklib = ['MLink',suffix];
    else
        mlinklib = 'libmlink64';
    end
    if ~libisloaded(mlinklib)
        loadlibrary([TargetRoot,'/MLink/',mlinklib],[TargetRoot,'/MLink/MLink.h']);
    end
    
    result = mdaqOpen();
    if result < 0
        error(calllib(mlinklib,'mlink_error',result));
    end
    link_fd = libpointer('int32Ptr',result);
    
    result = calllib(mlinklib,'mlink_ao_scan_data',link_fd, channelsPtr ,uint8(chCount), dataPtr, int32(dataSize),   uint8(opt));
    if result < 0
        error(calllib(mlinklib,'mlink_error',result));
    end

