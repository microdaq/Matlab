function data = mdaqAIRead(channels, range, isDifferential)
    data = [];
    
    link_fd = libpointer('int32Ptr',0);
    TargetIP = getpref('microdaq','TargetIP');
    
    if size(channels, 1) > 1 
        error('Wrong channel - scalar or single row vector expected');
    end
    
    if size(range, 2) ~= 2
        error('Wrong range - matrix range [low,high;low,high;...] expected');
    end
    
    if size(isDifferential,1) > 1 
        error('Wrong mode - scalar or single row vector expected');
    end
    
    chCount = size(channels,2);
    
    aiRangeSize = size(range, 1);
    if aiRangeSize ~= 1 && aiRangeSize ~= chCount then
        error('Range vector should match selected AI channels!')
    end

    isDifferentialSize = size(isDifferential, 2);
    if isDifferentialSize ~= 1 && isDifferentialSize ~= chCount 
        error('Mode vector should match selected AI channels')
    end
    
    if aiRangeSize == 1 
        range_tmp = range;
        range = ones(chCount,2);
        range(:,1) = range_tmp(1);
        range(:,2) = range_tmp(2);
        clear range_tmp;
    end
    
    if isDifferentialSize == 1
        isDifferential = ones(1, chCount) * isDifferential;
    end
    isDifferential = uint8(isDifferential);
    
    range = reshape(range', 1, chCount*2);
    aiRangePtr = libpointer('doublePtr', range);
    channelsPtr = libpointer('uint8Ptr', channels);
    isDifferentialPtr = libpointer('uint8Ptr', isDifferential);

    dataPtr = libpointer('doublePtr', zeros(1, chCount));
    
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
    
    result = calllib(mlinklib,'mlink_ai_read',link_fd, channelsPtr ,uint8(chCount), aiRangePtr, isDifferentialPtr, dataPtr );
    if result < 0
        error(calllib(mlinklib,'mlink_error',result));
    end
    
    data = dataPtr.Value;
    
