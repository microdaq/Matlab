function result = mdaqOpen()
    global mdaqIsConnected_g;
    global mdaqLinkFd_g; 
    
    if isempty(mdaqIsConnected_g) || mdaqIsConnected_g == false
        % MLink library name
        
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
        
        link_fd = libpointer('int32Ptr',0);
        TargetIP = getpref('microdaq','TargetIP');
        result = calllib(mlinklib,'mlink_connect',TargetIP,4343,link_fd);
        if result < 0 
            calllib(mlinklib,'mlink_disconnect_all');
            result = calllib(mlinklib,'mlink_connect',TargetIP,4343,link_fd);
            if result < 0 
                mdaqLinkFd_g = -1;
                error(calllib(mlinklib,'mlink_error',result));
            end
        end
        mdaqLinkFd_g = result;
        mdaqIsConnected_g = true; 
    else
        result = mdaqLinkFd_g;
    end
    