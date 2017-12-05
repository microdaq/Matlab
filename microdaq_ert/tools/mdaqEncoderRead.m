function [position, direction] = mdaqEncoderRead(module)

    position = [];
    direction = [];
   
    if module < 1 || module > 2
        error('Wrong Encoder module'); 
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
    
    dirPtr = libpointer('uint8Ptr', 0); 
    valuePtr = libpointer('int32Ptr', 0); 

    % EXTERNC MDAQ_API int mlink_enc_read( int *link_fd, uint8_t ch, uint8_t *dir, int32_t *value );
    result = calllib(mlinklib,'mlink_enc_read',link_fd, uint8(module), dirPtr, valuePtr);
    if result < 0
        error(calllib(mlinklib,'mlink_error',result));
    end
    
    position = valuePtr.Value;   
    direction = dirPtr.Value; 
    


    