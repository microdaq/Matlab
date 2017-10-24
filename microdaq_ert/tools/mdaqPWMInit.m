function mdaqPWMInit(module, period, activeLow, dutyChannelA, dutyChannelB)

    if module < 1 || module > 3 
        error('Wrong PWM module'); 
    end
    
    if period > 500000 || period < 2 
        error('Period out of range (2-500000us)');
    end
    
    if activeLow == true
        activeLow = 1; 
    else
        activeLow = 0; 
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

    result = calllib(mlinklib,'mlink_pwm_init',link_fd, uint8(module), uint32(period), uint8(activeLow), single(dutyChannelA), single(dutyChannelB));
    if result < 0
        error(calllib(mlinklib,'mlink_error',result));
    end
    

