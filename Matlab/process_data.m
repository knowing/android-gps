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


%% Initalize %#ok
clear; clc;

%% Create pause_table
pause_table = {'Filename', 'Index', 'Unix time', 'UTC time', 'start/stop', 'Accuracy', ...
    'Latitude', 'Longitude', 'POI no.', 'Distance', 'Recording Error', 'Duration', ...
    'Duration in s', 'Type (Später durch Nummer ersetzen)', 'Average Velocity in km/h'}; %changes here are adapted in all following subfunctions

poi_table = {'POI no.', 'Latitude', 'Longitude', 'No. of points', 'Total rest time at this POI', ...
    'Total transit time to this POI', '3a.m.'}; %changes here are adapted in all following subfunctions

% Analyse all on the Matlab Path available data (Jan11-Dec12) and write start and stop points of pauses in gps data in "pause_table"
t_gap = 5;          % t_gap = minimum pause length in minutes
max_accu = 60;      % accu_max = max accuracy in meters classed as accurate for variable gps_accu
name = 'Johanna'; % name
gpx_docu = [];      % gpx_docu = 'name' : a gpx file of gps data of each single day is created in JOSM folder if not yet existant
                    % gpx_docu = [] : no gpx files are generated
[ pause_table ] = create_pause_table( pause_table, t_gap, max_accu, name, gpx_docu );

%% Find addresses to coordinates: possible???

%% Give points at same location (total distance less than 120 m) same POI number and create table containing all POIs and Analyze pause_table: rest/transit distance and time, movement type, total rest/transit times
maxdist = ( 2.2 * max_accu )/1000; % max distance between two points belonging to the same POI in km (2*maximum GPS accuracy + add. tolerance)
[pause_table, poi_table] = analyze_pause_table( pause_table, poi_table, maxdist);
% IST TOTAL REST AND TRANSIT TIME NOCH KORREKT UND SINNVOLL???

%% Determine home and work coordinates and output to user
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

%% Create gpx files of all points as track or waypoints and all POIs as wpts
%Create gpx file of home and work POIs and of 2 favourite routes
if ischar(gpx_docu)
    create_gpx( pause_table, poi_table, name );
    gpx_home_and_work( poi_table, name, home_POI, work_POI );
    gpx_routes( route1, route2, name, max_accu);
end
%% Lösche alle überflüssigen Variablen
clear gpx_docu max_accu maxdist t_gap;
fprintf('Done.\n\n');