function  mdaqAOWrite(channels, range, data)
    if size(channels, 1) > 1 
        error('Wrong channel - scalar or single row vector expected');
    end
    
    if size(range, 2) ~= 2
        error('Wrong range - matrix range [low,high;low,high;...] expected');
    end
        
    chCount = size(channels,2);
    
    aoRangeSize = size(range, 1);
    if aoRangeSize ~= 1 && aoRangeSize ~= chCount
        error('Range vector should match selected AI channels!')
    end
    
    if aoRangeSize == 1 
        range_tmp = range;
        range = ones(chCount,2);
        range(:,1) = range_tmp(1);
        range(:,2) = range_tmp(2);
        clear range_tmp;
    end
    
    range = reshape(range', 1, chCount*2);
    rangePtr = libpointer('doublePtr', range);
    channelsPtr = libpointer('uint8Ptr', channels);

    dataPtr = libpointer('doublePtr', data);

    
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
    
    result = calllib(mlinklib,'mlink_ao_write',link_fd, channelsPtr ,uint8(chCount), rangePtr, uint8(0), dataPtr );
    if result < 0
        error(calllib(mlinklib,'mlink_error',result));
    end
    

