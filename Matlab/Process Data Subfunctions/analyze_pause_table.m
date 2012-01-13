function [ pause_table, poi_table ] = analyze_pause_table( pause_table, poi_table )
%ANALYZE_PAUSE_TABLE rest/transit distance and time, movement type, total rest/transit times
%   Detailed explanation goes here
% time difference:  1 minute: 60 seconds - 1 hour: 3600 seconds -  1 day: 86400 seconds


LastStop = pause_table{2,3}; % unix time in 3rd, utc time in 4th column, initialized with first value, so first rest time = 0seconds
LastLoc2 = [pause_table{2,7} pause_table{2,8}]; % coordinates of first point --> first distance is 0km
LastStopPOI = 1; % POI no. of first point --> makes type of first point = "rest"
poi_table(2:end,5:7) = num2cell(zeros(size(poi_table,1)-1, 3));

for i=2:2:size(pause_table,1);
    j = i+1;
    
    %% Distances between this and last point in column 10 and 11 of pause_table
    loc1 = [pause_table{i,7} pause_table{i,8}];
    loc2 = [pause_table{j,7} pause_table{j,8}];
    % "rest" distance (betw 'stop' and 'start') in km (col10)
    dist = haversine(LastLoc2, loc1);
    pause_table{i,10} = dist;
    LastLoc2 = loc2;
    % transit distance (betw 'start' and 'stop') in km (col11)
    dist = haversine(loc1, loc2);
    pause_table{j,11} = dist;
    
    %% Rest and Transit times from last to this point in column 12 and 13 of pause_table
    
    % rest time (betw 'stop' and 'start') in seconds (col12)
    RestInS = (pause_table{i,3} - LastStop)/1000;
    pause_table{i,12} = datestr(datenum(0,0,0,0,0,RestInS),'HH:MM:SS');
    pause_table{i,13} = RestInS;
    
    % transit time (betw 'start' and 'stop') in seconds (col13)
    TransitInS = (pause_table{j,3} - pause_table{i,3})/1000;
    pause_table{j,12} = datestr(datenum(0,0,0,0,0,TransitInS),'HH:MM:SS');
    pause_table{j,13} = TransitInS;
    
    LastStop = pause_table{j,3};
    
    %% Type of movement or rest to this point in column 14 of pause_table
    % MÖGLICHE FEHLER BEI AUFNAHME NICHT BEACHTET!!!
    
    % Possible types:
    rst = 'rest'; wog = 'underground'; wg = 'move with gps'; %underground can also be train etc.
    
    if (LastStopPOI == pause_table{i,9}) % no movement between stop and start --> rest
        pause_table{i, 14} = rst;
    else % movememt between stop and start --> movement underground or without gps, alt: if(poi no.(i) ~= poi no.(last j))
        pause_table{i, 14} = wog;
    end
    
    if (pause_table{i,9} == pause_table{j,9}) % no movement between start and stop --> rest
        pause_table{j, 14} = rst;
    else %movement between start and stop --> move with gps
        pause_table{j, 14} = wg;
    end
    LastStopPOI = pause_table{j,9};
    
end

% Count where 3a.m. was spent how often (day has 86400000 ms)
% 1293847200000 + x * 86400000; x=0 1/1/2011 3 a.m.; x=730 31/12/2012 3a.m.
start_time = 1293847200000; % 1/1/2011 3 a.m.
day = 86400000; % seconds per day
start_time1 = pause_table{2,3};
last_ind = ceil((start_time1 - start_time)/day); %Index der 1. Nacht


for k = 2:size(pause_table,1)
    %% Sum up rest time and transit time (col14 of pause_table)of each POI in column 5 and 6 of poi_table
    POI = pause_table{k,9};
    if strcmp(pause_table{k,14}, rst)
        poi_table{POI+1,5} = poi_table{POI+1,5} + pause_table{k,13};
    else
        poi_table{POI+1,6} = poi_table{POI+1,6} + pause_table{k,13};
    end
    
    %% Count where 3a.m. was spent how often
    st_time = pause_table{k,3};
    ind = ceil((st_time - start_time)/day); %Index der k. Nacht
    
    poi_table{POI+1,7} = poi_table{POI+1,7} + (ind - last_ind); % In Zeile des POI nach k. Nacht wird Anzahl der Nächte addiert
    last_ind = ind;


%     disp(epoch2date(start_time + index * day, false));
end