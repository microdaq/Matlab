
function res = mdaqCheckAdcParams(channels, range, aiMode)
    result = -1;
    res = '';

    
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

    chCount = size(channels,2);
    range = reshape(range', 1, chCount*2);
    aiRangePtr = libpointer('doublePtr', range);
    channelsPtr = libpointer('uint8Ptr', channels);
    aiModePtr = libpointer('uint8Ptr', aiMode);
    result = calllib(mlinklib,'mlink_ai_check_params',link_fd, channelsPtr ,int8(chCount), aiRangePtr,   aiModePtr );
    if result < 0
        res = calllib(mlinklib,'mlink_error',result);
    end
    




