function [ pause_table, poi_table ] = analyze_pause_table( pause_table, poi_table, maxdist)
%ANALYZE_PAUSE_TABLE
%   I identifies points belonging to the same address (i.e. distance less
%    than maxdist) and writes their POI no. into column 9 of pause_table
%   II creates a table containing all POIs with averaged coordinates.
%   III calculates distance and time between this and last point,
%       classifies movement as 'rest', 'move with gps', move without gps'
%   IV counts where 3a.m. was spent how often

% time difference:  1 minute: 60 seconds - 1 hour: 3600 seconds -  1 day: 86400 seconds

% pause_table = {'Filename', 'Index', 'Unix time', 'UTC time', 'start/stop', 'Accuracy', ...
%     'Latitude', 'Longitude', 'POI no.', 'Distance', 'Recording Error', 'Duration', ...
%     'Duration in s', 'Type (Später durch Nummer ersetzen)'};
%
% poi_table = {'POI no.', 'Latitude', 'Longitude', 'No. of points', 'Total rest time at this POI', ...
%     'Total transit time to this POI', '3a.m.'};

%% Compare each point with all other points to determine those of distance less than maxdist and give those same poi_no in col. 9 of pause_table
pause_table(2,9) = {1};
poi_no=2;known=0;
for j=3:size(pause_table,1);
    for i=2:j-1
        loc1 = [pause_table{i,7} pause_table{i,8}];
        loc2 = [pause_table{j,7} pause_table{j,8}];
        dist = haversine(loc1, loc2);
        if dist < maxdist
            pause_table{j,9} = pause_table{i,9};
            known = 1;
            break
        end
    end
    if known == 0
        pause_table{j,9} = poi_no;
        poi_no=poi_no+1;
    end
    known = 0;
end

%% Enter all POIs including averaged coordinates and number of points accounting for this POI in poi_table
poi_table = [poi_table; cell(poi_no, size(poi_table,2))]; %Creates poi_table of necessary size (poi_no is here number of POIs)
for poi_cnt=1:(poi_no-1)
    cnt = 0; % counter for number of points with same POI no.
    lat = 0; % sums up all latitude coordinates for each POI no.
    lng = 0; % sums up all longitude coordinates for each POI no.
    
    for i=1:size(pause_table,1)
        if pause_table{i,9} == poi_cnt % row describing relevant POI
            lat = lat + pause_table{i,7};
            lng = lng + pause_table{i,8};
            cnt = cnt + 1;
        end
    end
    poi_table{poi_cnt+1, 1} = poi_cnt; % POI no.
    poi_table{poi_cnt+1, 2} = lat/cnt; % average latitude
    poi_table{poi_cnt+1, 3} = lng/cnt; % average longitude
    poi_table{poi_cnt+1, 4} = cnt;     % no. of points of this POI no.
end

%% Calculate distance and travel/rest time between last und this point, classify movement as 'rest', 'move with gps', move without gps'
LastStop = pause_table{2,3}; % unix time in 3rd, utc time in 4th column, initialized with first value, so first rest time = 0seconds
LastLoc = [pause_table{2,7} pause_table{2,8}]; % coordinates of first point --> first distance is 0km
LastStopPOI = 1; % POI no. of first point --> makes type of first point = "rest"
poi_table(2:end,5:7) = num2cell(zeros(size(poi_table,1)-1, 3));

for i=2:size(pause_table,1);
    
    % Distance in km between this and last point in column 10 of pause_table
    NewLoc = [pause_table{i,7} pause_table{i,8}];
    dist = haversine(LastLoc, NewLoc);
    pause_table{i,10} = dist;
    LastLoc = NewLoc;
    
    % Rest and Transit times in seconds from last to this point in column 12 and 13 of pause_table
    RestInS = (pause_table{i,3} - LastStop)/1000;
    pause_table{i,12} = datestr(datenum(0,0,0,0,0,RestInS),'HH:MM:SS');
    pause_table{i,13} = RestInS;
    LastStop = pause_table{i,3};
    
    % Average velocity approaching this point in column 15 of pause_table
    pause_table{i, 15} = (pause_table{i, 10} * 3600 )/pause_table{i, 13}; % (distance in km * 3600 s/h) /duration in s = km/h
    % Type of movement or rest to this point in column 14 of pause_table
    % MÖGLICHE FEHLER BEI AUFNAHME NICHT BEACHTET!!!
    
    if (LastStopPOI == pause_table{i,9}) % no movement between this and last point --> rest
        if pause_table{i, 15} < 1 % average velocity < 1km/h
            pause_table{i, 14} = 'rest';
        else
            pause_table{i, 14} = 'short walk or transfer';
        end
    elseif strcmp(pause_table{i,5},'stop') == 1   %POI nicht wie zuvor UND 'stop' --> move with gps
        pause_table{i, 14} = 'move with gps';
    elseif strcmp(pause_table{i,5},'start') == 1    %POI nicht wie zuvor UND 'start' --> move without gps
        pause_table{i, 14} = 'move without gps';
    end
    LastStopPOI = pause_table{i,9};
    
    %% Automatisierte Fehlersuche
    if pause_table{i,13} < 0 %negative duration
        pause_table{i, 11} = 'error: negative duration';
    elseif pause_table{i,13} > 3600 && strcmp(pause_table{i,14},'rest') == 0
        if pause_table{i,15} < 1 % average velocity < 1 km/h
            pause_table{i, 11} = 'warning: > 1h journey @ 0 speed';
        else
            pause_table{i, 11} = 'warning: > 1h journey time';
        end
    elseif pause_table{i,13} < 600 && strcmp(pause_table{i,14},'rest') == 1
        pause_table{i, 11} = 'warning: < 10min rest';
    elseif strcmp(pause_table{i,14},'rest') == 1 && strcmp(pause_table{i-1,14},'move without gps') == 1
        pause_table{i, 11} = 'warning: ''rest'' directly following ''underground movement''';
    elseif strcmp(pause_table{i,14},'move without gps') == 1 && strcmp(pause_table{i-1,14},'rest') == 1
        pause_table{i, 11} = 'warning: ''underground movement'' directly following ''rest''';
    end
    
end

%% Count where 3a.m. was spent how often (day has 86400000 ms)
% 1293847200000 + x * 86400000; x=0 1/1/2011 3 a.m.; x=730 31/12/2012 3a.m.
start_time = 1293847200000; % 1/1/2011 3 a.m.
day = 86400000; % seconds per day
start_time1 = pause_table{2,3};
last_ind = ceil((start_time1 - start_time)/day); %Index der 1. Nacht


for k = 2:size(pause_table,1)
    % Sum up rest and transit time (col14 of pause_table)of each POI in column 5 of poi_table
    POI = pause_table{k,9};
    poi_table{POI+1,5} = poi_table{POI+1,5} + pause_table{k,13};
    
    % Count where 3a.m. was spent how often
    st_time = pause_table{k,3};
    ind = ceil((st_time - start_time)/day); %Index der k. Nacht
    
    poi_table{POI+1,7} = poi_table{POI+1,7} + (ind - last_ind); % In Zeile des POI nach k. Nacht wird Anzahl der Nächte addiert
    last_ind = ind;
end

end