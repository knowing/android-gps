
%% COMMENT FILE and SINGLE COMMANDS

%% create gpx files for JOSM
% gpx_file = strcat('D:\Dropbox\Studienarbeit\JOSM\Johanna\', date, '.gpx');
% gpx_creator (gps, gpx_file);
% gpx_file = strcat('D:\Dropbox\Studienarbeit\JOSM\Johanna\', date, '_accurate.gpx');
% gpx_creator (gps_accu, gpx_file);
% gpx_file = strcat('D:\Dropbox\Studienarbeit\JOSM\Johanna\', date, '_net.gpx');
% gpx_creator (net, gpx_file);
% gpx_file = strcat('D:\Dropbox\Studienarbeit\JOSM\Johanna\', date, '_net_accurate.gpx');
% gpx_creator (net_accu, gpx_file);

%% process accelerometer data
% file_acc = strcat('accelerometer_', date); %create filename
% run(file_acc); %run data file
% [acc, mgn] = divide_acc(acc); %divide data in acc. and magn. data
% [tindex_acc, t_acc, tdate_acc] = find_pauses(acc, 1, 5); %data, time column, minutes of gap
% plot(acc(gap_index(5):gap_index(6), 1), acc(gap_index(5):gap_index(6),4), 'r-'); %plot one segment


% Convert old Sensor Inside Data
% acc=[acc_t;acc_t;acc_x;acc_y;acc_z]';
% gps=[gps_t;gps_accu;gps_t;gps_accu;gps_lat;gps_lng;gps_bear;gps_spd]';
% net=[net_t;net_accu;net_t;net_accu;net_lat;net_lng;net_bear;net_spd]';

% Convert UNIX time in real time:
% date_gpx = epoch2date(acc(1,1), true); % e.g. 2011-12-08T10:13:19Z
% date_str = epoch2date(acc(1,1), false); % e.g. 08/12/2011 10:13:19.793

%Attributes of 'acc' and 'provider'
% ACCELEROMETER Attributes:
% system time, time stamp, (sensor type,) x_value, y_value, z_value 
%
% NETWORK PROVIDER Attributes:
% system time, provider name (3 for gps, 7 for network), pr. time, 
% pr. accuracy, pr. latitude, pr. longitude, pr. bearing, pr. speed 
