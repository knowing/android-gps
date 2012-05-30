function process_data(name, gpx, repare, max_accu, t_gap, arff)

%PROCESS_DATA creates table of all start and stop points
%   Reads in all data from 2011 and 2012 and checks GPS data of accuracy
%   better than max_accu meter for pauses of more than t_gap minute.
%   All start or stop points are saved in "pause_table" including all relevant
%   data (see second line in code).
%   All data points are compared and points at the same location are given
%   the same ID (number starting from 1), these POIs are saved in "poi_table".
%   The distance in meter between each start and stop point is calculated.
%   The file is saved in gpx-format as waypoints.
%   Home and work place coordinates are determined according to the place
%   where 3a.m. was spent most of the time. Favourite and second favourite
%   route are determined depending on the order of places visited.

%   17 January 2012
%   Johanna Maisel

% t_gap = 5;          % t_gap = minimum pause length in minutes
% max_accu = 60;      % accu_max = max accuracy in meters classed as accurate for variable gps_accu
% name = 'Johanna';     % name aus 'Arthur', 'Basti', 'Christoph', 'Johanna', 'Matze'
% gpx = 0;            % gpx = 1 : a gpx file of gps data of each single day is created in JOSM folder if not yet existant
%                     % gpx = 0 : no gpx files are generated
% repare = 0;         % repare = 1: files are repared ( ]; is added )
%                     % repare = 0: all files are correct
% arff = 0;           % arff = 1: create arff data of route2 first route


clc;
% foldername = strcat('D:\Documents\Studienarbeit_PC\App-Aufnahmen\', name);
% addpath(foldername);
%% Repare files before they can be used the first time
if repare == 1
    disp('Repare files...');
    repare_files(name);
end

%% Create pause_table
% disp('Load gps data...');

pause_table = {'Date', 'Index', 'Unix time', 'UTC time', 'start/stop', 'Accuracy', ...
    'Latitude', 'Longitude', 'POI no.', 'Distance', 'Recording Error', 'Duration', ...
    'Duration in s', 'Type (Später durch Nummer ersetzen)', 'Average Velocity in km/h'}; %changes here are adapted in all following subfunctions

poi_table = {'POI no.', 'Latitude', 'Longitude', 'No. of points', 'Total rest time at this POI', ...
    'Total transit time to this POI', '3a.m.'}; %changes here are adapted in all following subfunctions

% Analyse all on the Matlab Path available data (Jan11-Dec12) and write start and stop points of pauses in gps data in "pause_table"
[ pause_table ] = create_pause_table( pause_table, t_gap, max_accu, name, gpx );

%% Find addresses to coordinates: possible???

%% Give points at same location (total distance less than 120 m) same POI number and create table containing all POIs and Analyze pause_table: rest/transit distance and time, movement type, total rest/transit times
% disp('Analyze gps data...');
maxdist = ( 2.2 * max_accu )/1000; % max distance between two points belonging to the same POI in km (2*maximum GPS accuracy + add. tolerance)
[pause_table, poi_table] = analyze_pause_table( pause_table, poi_table, maxdist);
% IST TOTAL REST AND TRANSIT TIME NOCH KORREKT UND SINNVOLL???

%% Determine home and work coordinates and output to user
% disp('Calculate home, work and routes...');
[home_POI, work_POI] = home_finder( poi_table );
% Idee: im home_finder wurde home und work coordinates berechnet, suche
% alle Verbindungen dieser Punkte und analysiere sie (TO DO) == AKTIVER
% ROUTENPLANER
% Frage: Wo werden POIs aussortiert, die für Umsteigeorte stehen: In
% route_finder als 'short walk or transfer' deklariert

%% Calculate and output favourite routes
% Idee: pause_table enthält Abfolge aller Orte, erstelle Vektor aus POIs in
% richtiger Reihenfolge, die mit 'rest' in Spalte ? gekennzeichnet sind.
% Suche die zwei häufigsten Routen bzw. die häufigste Abfolge und analysiere sie
[ route1, route2 ] = route_finder(pause_table, poi_table); % Find 2 most popular routes

%% Create Feature Vector für erste Route von route2
if arff ==1
%     disp('Create arff file...');

%     date   = '20111213';
%     istart = 1;
%     istop  = NaN;
%     entry = 8;
%     fprintf('Route 1 has %i entries. Try entry no %i. ', (size(route1,1)-1)/2, entry);
%     entry_ind = entry*2; date   = route1{entry_ind,1}; 
%     istart = route1{entry_ind,2}; istop  = route1{entry_ind+1,2};
%     create_feature_vector(name, date, istart, istop, max_accu);

%     for entry = 1:(size(route1,1)-1)/2
%         fprintf('Route 1 has %i entries. Try entry no %i. ', (size(route1,1)-1)/2, entry);
%         entry_ind = entry*2; dat   = route1{entry_ind,1}; 
%         istart = route1{entry_ind,2}; istop  = route1{entry_ind+1,2};
%         create_feature_vector(name, dat, istart, istop, max_accu);
%     end
%     for entry = 1:(size(route2,1)-1)/2
%         fprintf('Route 2 has %i entries. Try entry no %i. ', (size(route2,1)-1)/2, entry);
%         entry_ind = entry*2; dat   = route2{entry_ind,1};
%         istart = route2{entry_ind,2}; istop  = route2{entry_ind+1,2};
%         create_feature_vector(name, dat, istart, istop, max_accu);
%     end

    for y = 2011:2012
        for m = 1:12
            for d = 1:31
                dat = strcat(num2str(y),num2str(m, '%02.f'),num2str(d, '%02.f'));
                % check if location data of required date is available (every day in 2011 and 2012)
                file_loc = strcat('D:\Documents\Studienarbeit_PC\App-Aufnahmen\', name, '\locprovider_', dat, '.m');
                if (exist(file_loc, 'file') ~= 0) % if file exists...
                    fprintf('Evaluate %s.\n', dat);
                    istart = 1;
                    istop  = NaN;
                    create_feature_vector(name, dat, istart, istop, max_accu);
                end
            end
        end
    end
    
end

%% Create gpx files of all points as track or waypoints and all POIs as wpts
%Create gpx file of home and work POIs and of 2 favourite routes
if gpx == 1
    disp('Create gpx files...');
    create_gpx( pause_table, poi_table, name );
    gpx_home_and_work( poi_table, name, home_POI, work_POI );
    gpx_routes( route1, route2, name, max_accu);
end

%% Lösche alle überflüssigen Variablen
clear all;
fprintf('Done.\n');