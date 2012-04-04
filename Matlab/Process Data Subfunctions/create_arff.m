function [ output_args ] = create_arff( data, data_type, file_loc )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%Possibly also of interest: Type, Average Speed
if strcmp(data_type, 'gps')==1 % Date/Time, Latitude, Longitude, Speed
    data1 = lat;
    data2 = lng;
    data3 = speed;
elseif strcmp(data_type, 'acc')==1 % Date/Time, x, y, z
    data1 = x;
    data2 = y;
    data3 = z;
end


%% Header
header = strcat('% GPS or Sensor Data for Classification of Transport Modes\n',...
                 '% Author: Johanna Maisel, created by Matlab \n',...
                 '% Person ID: , Mobile Phone: , Sensor Type: , Data Rate: \n',...
                 '@RELATION "', data_type, '"\n\n',...
                 '@ATTRIBUTE "', date, '" DATE \n',...
                 '@ATTRIBUTE "', data1, '" NUMERIC \n',...
                 '@ATTRIBUTE "', data1, '" NUMERIC \n',...
                 '@ATTRIBUTE "', data1, '" NUMERIC \n');
%%Body
body = strcat('@DATA\n',...
              data(1,1), data(1,2), 

fileID = fopen(file_loc,'w');
fprintf(fileID,text);
fclose(fileID);
end

