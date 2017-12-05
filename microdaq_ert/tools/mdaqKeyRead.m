function state = mdaqKeyRead(functionKey)
    state = [];
    if functionKey < 1 || functionKey > 2 
        error('Wrong Key number'); 
    end

    
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

    statePtr = libpointer('uint8Ptr',0);
    result = calllib(mlinklib,'mlink_func_read',link_fd, uint8(functionKey), statePtr);
    if result < 0
        error(calllib(mlinklib,'mlink_error',result));
    end
    
    state = statePtr.Value; 
    

