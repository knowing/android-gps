function [date_str] = epoch2date(epochTime, gpx)
% EPOCH2DATE converts epoch time to human readable date string


% import java classes
import java.lang.System;
import java.text.SimpleDateFormat;
import java.util.Date;

% convert current system time if no input arguments
if (~exist('epochTime','var'))
    epochTime = System.currentTimeMillis/1000;
end

% convert epoch time (Date requires milliseconds)
jdate = Date(epochTime);

% format text and convert to cell array
if (gpx)
    sdf_d = SimpleDateFormat('yyyy-MM-dd');
    d_str = sdf_d.format(jdate);
    d_str = char(cell(d_str));
    
    sdf_t = SimpleDateFormat('HH:mm:ss');
    t_str = sdf_t.format(jdate);
    t_str = char(cell(t_str));
    
    date_str = strcat(d_str,'T',t_str,'Z');
else
    sdf = SimpleDateFormat('dd/MM/yyyy HH:mm:ss.SS');
    date_str = sdf.format(jdate);
    date_str = char(cell(date_str));
end