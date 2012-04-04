function [pause_table] = build_table(pause_table, data, filename, tgap)
%BUILD_TABLE returns table with elements before and after gaps of tgap
%   minutes incl. filename, timestamps, coordinates, accuracy etc.

% pause_table = {'Filename', 'Index', 'Unix time', 'UTC time', 'start/stop',...
% ...'Accuracy', 'Latitude', 'Longitude', 'POI no.', 'Distance', 'Transit time', 'Rest time'};
%   2 January 2012
%   Johanna Maisel

%% Initialisation
tgap = tgap * 60* 1000;
no_col = size(pause_table, 2); % following calculations are adapted to the number of columns defined in process_data.m
new_table = cell(50,no_col);
n=1; i=1;

%% initiate first line
new_table{n, 1} = filename;   %filename
new_table{n, 2} = i;        %index
new_table{n, 3} = data(i,1);%UNIX time (system time(=1) not provider time(=3))
new_table{n, 4} = epoch2date(data(i, 1), false); %UTC time (system time)
new_table{n, 5} = 'start';
new_table{n, 6} = data(i, 4); %accuracy
new_table{n, 7} = data(i, 5); %latitude
new_table{n, 8} = data(i, 6); %longitude
n = n+1;

for i = 2:size(data,1)
    act_gap = data(i,1) - data(i-1,1);
    if act_gap > tgap
        new_table{n, 1} = filename;   %filename
        new_table{n, 2} = i-1;        %index
        new_table{n, 3} = data(i-1,1);%UNIX time (system time(=1) not provider time(=3))
        new_table{n, 4} = epoch2date(data(i-1, 1), false); %UTC time (system time)
        new_table{n, 5} = 'stop';
        new_table{n, 6} = data(i-1, 4); %accuracy
        new_table{n, 7} = data(i-1, 5); %latitude
        new_table{n, 8} = data(i-1, 6); %longitude
        n = n+1;
        
        new_table{n, 1} = filename;   %filename
        new_table{n, 2} = i;        %index
        new_table{n, 3} = data(i,1);%UNIX time (system time(=1) not provider time(=3))
        new_table{n, 4} = epoch2date(data(i, 1), false); %UTC time (system time)
        new_table{n, 5} = 'start';
        new_table{n, 6} = data(i, 4); %accuracy
        new_table{n, 7} = data(i, 5); %latitude
        new_table{n, 8} = data(i, 6); %longitude
        n = n+1;
    end
end

i=size(data,1);
new_table{n, 1} = filename;   %filename
new_table{n, 2} = i;        %index
new_table{n, 3} = data(i,1);%UNIX time (system time(=1) not provider time(=3))
new_table{n, 4} = epoch2date(data(i, 1), false); %UTC time (system time)
new_table{n, 5} = 'stop';
new_table{n, 6} = data(i, 4); %accuracy
new_table{n, 7} = data(i, 5); %latitude
new_table{n, 8} = data(i, 6); %longitude
n = n+1;

if n>50
    error('Too few rows in new_table in function build_table.');
end
new_table(n:end, :) = [];

pause_table = [pause_table;new_table];
end