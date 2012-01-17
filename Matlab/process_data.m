%PROCESS_DATA creates table of all start and stop points
%   Reads in all data from 2011 and 2012 and checks GPS data of accuracy 
%   better than max_accu meter for pauses of more than t_gap minute.
%   All start or stop points are saved in "pause_table" including all relevant 
%   data (see second line in code).
%   All data points are compared and given an ID (number starting from 1), 
%   these POIs are saved in "poi_table".
%   The distance in meter between each start and stop point is calculated.
%   The file is saved in gpx-format as waypoints.

%   17 January 2012
%   Johanna Maisel


%% Initalize %#ok
clear all; clc;

%% Create pause_table
pause_table = {'Filename', 'Index', 'Unix time', 'UTC time', 'start/stop', 'Accuracy', ...
    'Latitude', 'Longitude', 'POI no.', 'Rest Distance', 'Transit Distance', 'Duration', ...
    'Duration in s', 'Type (Später durch Nummer ersetzen)'}; %changes here are adapted in all following subfunctions

poi_table = {'POI no.', 'Latitude', 'Longitude', 'No. of points', 'Total rest time at this POI', ...
    'Total transit time to this POI', '3a.m.'}; %changes here are adapted in all following subfunctions

% Analyse all on the Matlab Path available data (Jan11-Dec12) and write start and stop points of pauses in gps data in "pause_table"
t_gap = 5;         % t_gap = minimum pause length in minutes
gps_type = 'gps';  % gps_type = 'gps' or 'gps_accu'
max_accu = 60;      % accu_max = max accuracy in meters classed as accurate for variable gps_accu
name = [];         % name = if name is a string: a gpx file of gps data of each single day is created in JOSM folder if not yet existant
                   % otherwise: name = [];
[ pause_table ] = create_pause_table( pause_table, t_gap, gps_type, max_accu, name );

%% Find addresses to coordinates: possible???

%% Give same points same POI no. and create table containing all POIs
maxdist = 0.1; % max distance between two points belonging to the same POI in km
[ poi_table, pause_table ] = poi(poi_table, pause_table, maxdist);

%% Analyze pause_table: rest/transit distance and time, movement type, total rest/transit times
[ pause_table, poi_table ] = analyze_pause_table( pause_table, poi_table );

%% Create gpx files of all points as track or waypoints and all POIs as wpts
if ischar(name)
    create_gpx( pause_table, poi_table, name );
end

%% OUTPUT RESULTS
%% Calculate where most 3 a.m.s where spent (saved in poi_table(2:end, 7) )
nights_at_poi = cell2mat(poi_table(2:end,7)); % nights_at_poi(x): number of nights spent at POI no. x
[max_nights, home_ind] = max(nights_at_poi); % place where most 3 a.m.s were spent
% Condition: only ONE home, otherwise:
    % nights_at_poi2 = nights_at_poi; nights_at_poi2(nights_ind) = 0;
    % [max_nights2, home_ind2] = max(nights_at_poi2); % place where second most 3 a.m.s were spent
    
%% Calculate where most rest time was spent
max_rest_ind = zeros(3,1);
rest_time = cell2mat(poi_table(2:end,5));
[max_rest1,max_rest_ind(1)] = max(rest_time);    % place where most rest time was spent
rest_time2 = rest_time; rest_time2(max_rest_ind(1)) = 0;
[max_rest2, max_rest_ind(2)] = max(rest_time2); % place where second most rest time was spent
% rest_time3 = rest_time; rest_time3(max_rest_ind(2)) = 0;
% [max_rest3, max_rest_ind(3)] = max(rest_time3); % place where third most rest time was spent

%% Output home and work place
if home_ind == max_rest_ind(1)  % home is where most rest time and most 3a.m.s where spent
    work_ind = max_rest_ind(2); % work is where second most rest time was spent
else 
    work_ind = max_rest_ind(1); % work is where most rest time was spent
    home_ind = max_rest_ind(2); % home is where most 3a.m.s are spent
end

fprintf('These are your home coordinates (POI No. %i): \t %2.4f, %2.4f\n', home_ind, poi_table{home_ind+1,2}, poi_table{home_ind+1,3});
fprintf('\t http://maps.google.de/maps?q=%2.4f,+%2.4f\n', poi_table{home_ind+1,2}, poi_table{home_ind+1,3});

fprintf('You spent most time besides your home at POI No. %i: \t %2.4f, %2.4f\n', work_ind, poi_table{work_ind+1,2}, poi_table{work_ind+1,3});
fprintf('\t http://maps.google.de/maps?q=%2.4f,+%2.4f\n\n', poi_table{work_ind+1,2}, poi_table{work_ind+1,3});

%% Calculate and output favourite routes
[ route_table ] = route_finder(pause_table); % Find most x popular routes

start_poi=2; start_lng=0; start_lat=0; end_poi=3; end_lng=0; end_lat=0;
fprintf('Your favourite route starts at POI No. %i (%2.4f, %2.4f) and ends at POI No. %i (%2.4f, %2.4f).\n', start_poi, start_lng, start_lat, end_poi, end_lng, end_lat);
fprintf('Your second favourite route starts at POI No. %i (%2.4f, %2.4f) and ends at POI No. %i (%2.4f, %2.4f).\n\n', start_poi, start_lng, start_lat, end_poi, end_lng, end_lat);


%% finish programm
% fprintf('Done (completely)\n');