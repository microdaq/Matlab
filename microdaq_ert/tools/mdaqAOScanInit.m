function  mdaqAOScanInit(channels, initialData, range, isStreamMode, rate, duration)

    if duration < 0 && duration ~= -1 
        disp('WARNING: For infinite scan session as a duration parameter use -1 value instead!'); 
        duration = -1;
    end
    
    if size(channels, 1) > 1 
        error('Wrong channel - scalar or single row vector expected');
    end
    
    chCount = size(channels,2);
    if size(initialData,2) ~= chCount 
        error('Wrong output initial data - colums should match selected channels!')
    end
    
    dataSize = size(initialData,1) *chCount;

    if size(range, 2) ~= 2
        error('Wrong range - matrix range [low,high;low,high;...] expected');
    end

    rangeSize = size(range, 1);
    if rangeSize ~= 1 && rangeSize ~= chCount then
        error('Range vector should match selected AI channels!')
    end

    if rangeSize == 1 
        range_tmp = range;
        range = ones(chCount,2);
        range(:,1) = range_tmp(1);
        range(:,2) = range_tmp(2);
        clear range_tmp;
    end
    
    range = reshape(range', 1, chCount*2);
    rangePtr = libpointer('doublePtr', range);
    channelsPtr = libpointer('uint8Ptr', channels);

    
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
    
    result = calllib(mlinklib,'mlink_ao_check_params',link_fd, channelsPtr ,uint8(chCount), rangePtr );
    if result < 0
        error(calllib(mlinklib,'mlink_error',result));
    end
    
    initialData = reshape(initialData, 1, dataSize);
    dataPtr = libpointer('singlePtr', single(initialData));
    
    result = calllib(mlinklib,'mlink_ao_scan_init',link_fd, channelsPtr ,uint8(chCount), dataPtr, int32(dataSize),  rangePtr, uint8(isStreamMode), single(rate), single(duration) );
    if result < 0
        error(calllib(mlinklib,'mlink_error',result));
    end
    

    
    
    


