function [ linacc ] = epoch2minutes(linacc)
%EPOCH2MINUTES converts epoch time in "linacc" col1 to minutes.seconds in
%col2
%   Detailed explanation goes here

import java.lang.System;
import java.text.SimpleDateFormat;
import java.util.Date;

sdf = SimpleDateFormat('mm.ss');

for i=1:size(linacc,1)
    jdate = Date(linacc(i,1));
    date_str = sdf.format(jdate);
    d_str = cell(date_str);
    linacc(i,2) = str2double(d_str{1,1});
end
end

