
function result = mdaqAIScanInit(channels, range, isDifferential, rate, duration)
    result = 0;
 
    if duration < 0 
        duration = -1;
    end
    
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
    
    rangeSize = size(range, 1);
    if rangeSize ~= 1 && rangeSize ~= chCount then
        error('Range vector should match selected AI channels!')
    end

    isDifferentialSize = size(isDifferential, 2);
    if isDifferentialSize ~= 1 && isDifferentialSize ~= chCount then
        error('Mode vector should match selected AI channels')
    end
    
    if rangeSize == 1 
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
    rangePtr = libpointer('doublePtr', range);
    channelsPtr = libpointer('uint8Ptr', channels);
    isDifferentialPtr = libpointer('uint8Ptr', isDifferential);
    
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
    
    result = calllib(mlinklib,'mlink_ai_check_params',link_fd, channelsPtr ,uint8(chCount), rangePtr, isDifferentialPtr );
    if result < 0
        error(calllib(mlinklib,'mlink_error',result));
    end
    
    ratePtr = libpointer('singlePtr', single(rate));
    result = calllib(mlinklib,'mlink_ai_scan_init',link_fd, channelsPtr ,uint8(chCount), rangePtr, isDifferentialPtr, ratePtr, single(duration) );
    if result < 0
        error(calllib(mlinklib,'mlink_error',result));
    end
    