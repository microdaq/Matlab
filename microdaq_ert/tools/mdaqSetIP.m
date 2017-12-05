% Functions sets target IP address  
function mdaqSetIP( ipAddress )
    setpref('microdaq', 'TargetIP', char(ipAddress)); 
end 
