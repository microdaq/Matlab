
function [data, result] = mdaqAIScan(scanCount, isBlocking)
    result = 0;
    data = [];

    if ~isBlocking
        error('Blocking mode not supported - check for upgrades');
    end
    
    % MLink library name
    if ispc
        arch = computer('arch');
        suffix = arch(end-1:end);
        mlinklib = ['MLink',suffix];
    else
        mlinklib = 'libmlink64';
    end
    
    TargetRoot = getpref('microdaq','TargetRoot');
    if ~libisloaded(mlinklib)
        loadlibrary([TargetRoot,'/MLink/',mlinklib],[TargetRoot,'/MLink/MLink.h']);
    end

    chCount = calllib(mlinklib,'mlink_ai_scan_get_ch_count');
    if chCount  == 0
       error('AI scan not initialized');
    end
    
    if scanCount < 0 
        error('scanCount should be >= 0'); 
    end

    if  scanCount == 0 
        dataPtr = libpointer('doublePtr', zeros(1, 1));
    else
        dataPtr = libpointer('doublePtr', zeros(1, chCount * scanCount));
    end
    
    % TODO: should not return with error when timeout
    result = calllib(mlinklib,'mlink_ai_scan',dataPtr, uint32(scanCount), int32(isBlocking) );
    if result < 0
        error(calllib(mlinklib,'mlink_error',result));
    end

    if result > 0
        data = dataPtr.Value(1:result);
        data = reshape(data', chCount, result/chCount)';
    end
    
    
    
    
