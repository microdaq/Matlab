function mdaqAIScanStop()
    if ispc
        arch = computer('arch');
        suffix = arch(end-1:end);
        mlinklib = ['MLink',suffix];
    else
        mlinklib = 'libmlink64';
    end
    
    result = calllib(mlinklib,'mlink_ai_scan_stop' );
    if  result < 0 
        error(calllib(mlinklib,'mlink_error',result));
    end

