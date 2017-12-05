function microdaq_download(modelName,makertwObj)

disp(['### Downloading ', modelName, ' to MicroDAQ...']);

TargetRoot = getpref('microdaq','TargetRoot');

%MLink is a:
% default download method and
% always used in PIL
downloadMethod = '"MLink"';
if (ischar(makertwObj)) %String 'PIL'
    outfile = modelName;
else
    outfile = [modelName, '.out'];
    % Check the MicroDAQ download method
    if verLessThan('matlab', '8.1')
        makertwObj = get_param(gcs, 'MakeRTWSettingsObject');
        makertwArgs = makertwObj.BuildInfo.BuildArgs;
    else
        % See R2013a Simulink Coder release notes.
        makertwObj = rtwprivate('get_makertwsettings',gcs,'BuildInfo');
        makertwArgs = makertwObj.BuildArgs;
    end

    for i=1:length(makertwArgs)
        if strcmp(makertwArgs(i).DisplayLabel,'MICRODAQ_DOWNLOAD_METHOD')
            downloadMethod = makertwArgs(i).Value;
        end
    end
end



disp('### Using MLink for download...');
mlink_download(outfile,TargetRoot,0);

end
