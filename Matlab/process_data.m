%PROCESS_DATA creates table of all start and stop points
%   Reads in all data from 2011 and 2012 and checks GPS data of accuracy 
%   better than 60 meter for pauses of more than 1 minute.
%   All start or stop points are saved in "pause_table" including all relevant 
%   data (see second line in code).
%   All data points are compared and given an ID (number from 1 to 9). 
%   The distance in meter between each start and stop point is calculated.
%   The file is saved in gpx-format as waypoints.

%   2 January 2012
%   Johanna Maisel


%% Initalize %#ok
clear; clc;

%% Create pause_table
pause_table = {'Filename', 'Index', 'Unix time', 'UTC time', 'start/stop', 'Accuracy', ...
    'Latitude', 'Longitude', 'POI no.', 'Rest Distance', 'Transit Distance', 'Duration', ...
    'Duration in s', 'Type (Später durch Nummer ersetzen)'}; %changes here are adapted in all following subfunctions
no_col = size(pause_table, 2);

poi_table = {'POI no.', 'Latitude', 'Longitude', 'No. of points', 'Total rest time at this POI', ...
    'Total transit time to this POI', '3a.m.'}; %changes here are adapted in all following subfunctions

% maximum distance between two points belonging to the same POI or for
% definition of type "rest" and "move"
    maxdist = 0.1;

for y = 2011:2012
    for m = 1:12
        for d = 1:31
            date = strcat(num2str(y),num2str(m, '%02.f'),num2str(d, '%02.f'));
            %% check if location data of required date is available (every day in 2011 and 2012)
            file_loc = strcat('locprovider_', date);
            if (exist(file_loc, 'file') ~= 0)
                fprintf('%s  ', file_loc);
                run(file_loc);
                %% identify gps and network location data and save in seperate files
                [gps, net, gps_accu, net_accu] = divide_provider(provider); % teilt provider in "gps" und "network"
                
                %% create gpx file of gps data of each single day in JOSM folder if not yet existant
%                 if (exist(strcat('D:\Documents\Studienarbeit_PC\JOSM\Johanna\', date, '.gpx'), 'file') == 0)
%                     gpx_creator(gps, strcat('D:\Documents\Studienarbeit_PC\JOSM\Johanna\', date, '.gpx'))
%                 end
                
                %% if accurate gps data is available write start and stops in first 8 columns of "tabelle"
                if exist('gps', 'var') ~= 0
                    [new_table] = build_table(gps, file_loc, 5, no_col); %data, filename, minutes of gap, no. of columns in pause_table
                    pause_table = [pause_table;new_table]; %#ok
                end
            end
        end
    end
end
clear y m d new_table provider date file_loc gps* net*;
fprintf('\n\n');

%% Find addresses to coordinates: possible???

%% Give same places(POI) same POI no. and write them in column 9 of pause_table
[pause_table, total_pois] = identify_pois(pause_table, maxdist);

%% Create poi_table
poi_table = create_poi_table(poi_table, pause_table,total_pois);
clear total_pois;

%% Analyze pause_table: rest/transit distance and time, movement type, total rest/transit times
[ pause_table, poi_table ] = analyze_pause_table( pause_table, poi_table );

% %% Create GPX file to show all POI in JOS (pause_table)
% gpx_file = strcat('D:\Documents\Studienarbeit_PC\JOSM\Johanna\Points\Johanna_Points.gpx');
% gpx_wpt_creator(pause_table, gpx_file);
% 
% %% Create GPX file to show all POI as track in JOS (pause_table)
% gpx_file = strcat('D:\Documents\Studienarbeit_PC\JOSM\Johanna\Points\Johanna_Tracks.gpx');
% gpx_track_creator(pause_table, gpx_file);
% 
% %% Create GPX file to show all POI in JOS (poi_table)
% gpx_file = strcat('D:\Documents\Studienarbeit_PC\JOSM\Johanna\Points\Johanna_POI.gpx');
% gpx_wpt_creator(poi_table, gpx_file);
% clear gpx_file;

%% Find most x popular routes
route_table = route_finder(pause_table);

%% Guess home coordinates
% = Ort, an dem am meisten "rest time" verbracht wurden,
% Sollte kombiniert werden mit Ort, an dem am am häufigsten 3a.m. verbracht
% wurde, gespeichert unter poi_table(2:end, 7);
nights_at_poi = cell2mat(poi_table(2:end,7)); % vector indicating nights spent at POI no. x: nights_at_poi(x)
[max_nights, home_ind] = max(nights_at_poi); % place where most 3 a.m.s were spent
%% condition: only ONE home, else:
% nights_at_poi2 = nights_at_poi; nights_at_poi2(nights_ind) = 0;
% [max_nights2, home_ind2] = max(nights_at_poi2); % place where second most 3 a.m.s were spent
fprintf('These are your home coordinates (POI No. %i): \t %2.4f, %2.4f\n', home_ind, poi_table{home_ind+1,2}, poi_table{home_ind+1,3});

max_rest_ind = zeros(3,1);
rest_time = cell2mat(poi_table(2:end,5));
[max_rest1,max_rest_ind(1)] = max(rest_time);    % place where most rest time was spent
rest_time2 = rest_time; rest_time2(max_rest_ind(1)) = 0;
[max_rest2, max_rest_ind(2)] = max(rest_time2); % place where second most rest time was spent
% rest_time3 = rest_time; rest_time3(max_rest_ind(2)) = 0;
% [max_rest3, max_rest_ind(3)] = max(rest_time3); % place where third most rest time was spent

if home_ind == max_rest_ind(1)
    %home is where most rest time and most 3a.m.s where spent
    work_ind = max_rest_ind(2);
else %home is where most 3a.m.s are spent and work where most rest time was spent
    work_ind = max_rest_ind(1);
end

% Funktioniert nur wenn Arbeitsplatz (zweit)häufigster Aufenthaltsort ist
fprintf('You spent most time besides your home at POI No. %i: \t %2.4f, %2.4f\n\n', work_ind, poi_table{work_ind+1,2}, poi_table{work_ind+1,3});

start_poi=2; start_lng=0; start_lat=0; end_poi=3; end_lng=0; end_lat=0;
fprintf('Your favourite route starts at POI No. %i (%2.4f, %2.4f) and ends at POI No. %i (%2.4f, %2.4f).\n', start_poi, start_lng, start_lat, end_poi, end_lng, end_lat);
fprintf('Your second favourite route starts at POI No. %i (%2.4f, %2.4f) and ends at POI No. %i (%2.4f, %2.4f).\n\n', start_poi, start_lng, start_lat, end_poi, end_lng, end_lat);

fprintf('(Note: Please copy coordinates to Google Maps to find approximate addresses.)\n\n');




%% finish programm
clear no_col;
% fprintf('Done (completely)\n');