function mdaqDIOFunc(dioFunction, isEnabled)
    if dioFunction < 1 || dioFunction > 6
		disp('1 - ENC1: DIO1 - Channel A, DIO2 - Channel B (enabled by default)');
		disp('2 - ENC2: DIO3 - Channel A, DIO4 - Channel B (enabled by default)');
		disp('3 - PWM1: DIO10 - Channel A, DIO11 - Channel B (enabled by default)');
		disp('4 - PWM2: DIO12 - Channel A, DIO13 - Channel B (enabled by default)');
		disp('5 - PWM3: DIO14 - Channel A, DIO15 - Channel B (enabled by default)');
		disp('6 - UART: DIO8 - Rx, DIO9 - Tx (enabled by default)');
        error('Wrong DIO function selected');
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

    result = calllib(mlinklib,'mlink_dio_set_func',link_fd, uint8(dioFunction), uint8(isEnabled));
    if result < 0
        error(calllib(mlinklib,'mlink_error',result));
    end
    
