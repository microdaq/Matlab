function mdaqClose()
    global mdaqIsConnected_g;
    
    if ispc
        arch = computer('arch');
        suffix = arch(end-1:end);
        mlinklib = ['MLink',suffix];
    else
        mlinklib = 'libmlink64';
    end
    calllib(mlinklib,'mlink_disconnect_all');
    mdaqIsConnected_g = false;
