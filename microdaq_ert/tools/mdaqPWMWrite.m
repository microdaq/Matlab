function mdaqPWMWrite(module, dutyChannelA, dutyChannelB)
    if module < 1 || module > 2 
        error('Wrong PWM module'); 
    end
    
    if dutyChannelA > 100 || dutyChannelA < 0 
        disp('WARNING: Channel A duty out of range (0-100)!');
        if dutyChannelA > 100 
            dutyChannelA = 100;
        end
        if dutyChannelA < 0 
            dutyChannelA = 0;
        end
    end

    if dutyChannelB > 100 || dutyChannelB < 0 
        disp('WARNING: Channel B duty out of range (0-100)!');
        if dutyChannelB > 100 
            dutyChannelB = 100;
        end
        if dutyChannelB < 0 
            dutyChannelB = 0;
        end
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
    
    result = calllib(mlinklib,'mlink_pwm_write',link_fd, uint8(module) ,single(dutyChannelA), single(dutyChannelB));
    if result < 0
        error(calllib(mlinklib,'mlink_error',result));
    end
    


