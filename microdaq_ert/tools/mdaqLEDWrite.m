function mdaqLEDWrite(led, state)

    if led < 1 || led > 2 
        error('Wrong LED number'); 
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

    result = calllib(mlinklib,'mlink_led_write',link_fd, uint8(led), uint8(state));
    if result < 0
        error(calllib(mlinklib,'mlink_error',result));
    end
    

