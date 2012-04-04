function [ route1, route2 ] = route_finder( pause_table, poi_table )
%ROUTE_FINDER analyses pause_table to find the TWO (?) routes that were
%traced most often
%   Detailed explanation goes here

%% Create route_table containing start and stop of every journey and remove unnecessary columns
rest_table = pause_table(1:2,[1:4 7:9]); % nur manche Spalten werden übertragen
% Zu jedem Aufenthalt gehören zwei Zeilen in pause_table, ein 'stop' und
% ein 'start', nur zwei gleich aufeinander folgende Einträge sind echte
% POIs und nicht Haltestellen etc.
for i = 3 : size(pause_table,1)
    if strcmp(pause_table{i,14},'rest') == 1 % Fahrt geht bis zum Eintrag vor nächstem 'rest'
        rest_table = [rest_table; pause_table(i-1:i,[1:4 7:9])]; %#ok nächste Fahrt startet bei 'rest'
    end
end
rest_table = [rest_table; pause_table(end,[1:4 7:9])]; %last line is always important stop

% Entferne alle mehrfach genannten Aufenthaltsorte
i=2;
while i < size(rest_table,1)-1
    start_POI = rest_table{i,7}; %POI number
    while rest_table{i+2,7} == start_POI %wenn das übernächste Element gleich ist...
        if i+2 < size(rest_table,1)
        rest_table(i+1,:) = []; % ... entferne nächstes Element
        else rest_table(i+1:i+2,:) = []; % ... entferne nächstes und letztes Element am Ende der Matrix
            break;
        end
    end
    i=i+1;
end

%% Find 2 most used routes
% vector containing list of POIs in column 7
% max_POI = max(cell2mat(route_table(2:end,7))); %max POI no.
POIs = cell2mat(rest_table(2:end,7))'; %max POI no.
max_POI = max(POIs);

% Create Route Table
% number of possible combinations: max_POI*(max_POI-1)
route_table = cell( max_POI*(max_POI-1)+1 , 5 );
route_table(1,:) =  {'ID', 'Start POI', 'Stop POI', 'Frequency', 'Occurance'};
i=2;
for k = 1:max_POI
    for l = 1:max_POI
        if k ~= l
            pattern = [k l];
            where = strfind(POIs, pattern);
            route_table(i,:) = {i-1, k, l, length(where), where};
            i=i+1;
        end
    end
end

freq = cell2mat( route_table(2:end, 4));
[~, ID1] = max(freq); start1 = route_table{ID1+1,2}; goal1 = route_table{ID1+1,3};
freq(ID1) = 0;
[~, ID2] = max(freq); start2 = route_table{ID2+1,2}; goal2 = route_table{ID2+1,3};

%% Find coordinates of relevant routes = start1, start2, goal1, goal2
start1_lat = poi_table{start1+1,2};
start1_lng = poi_table{start1+1,3};

start2_lat = poi_table{start2+1,2};
start2_lng = poi_table{start2+1,3};

goal1_lat = poi_table{goal1+1,2};
goal1_lng = poi_table{goal1+1,3};

goal2_lat = poi_table{goal2+1,2};
goal2_lng = poi_table{goal2+1,3};

%% Output most used routes
fprintf('Your favourite route starts at POI No. %i (%2.4f, %2.4f) and ends at POI No. %i (%2.4f, %2.4f).\n', start1, start1_lng, start1_lat, goal1, goal1_lng, goal1_lat);
fprintf('Your second favourite route starts at POI No. %i (%2.4f, %2.4f) and ends at POI No. %i (%2.4f, %2.4f).\n\n', start2, start2_lng, start2_lat, goal2, goal2_lng, goal2_lat);

%% Transfer relevant information about these routes = 2 lines of route_table
route1 = rest_table(1,:); route2 = rest_table(1,:);
occurance1 = route_table{ID1+1,5}; occurance2 = route_table{ID2+1,5};
for i=1:length(occurance1)
   route1 = [route1; rest_table(occurance1(i)+1: occurance1(i)+2,:)];
end
for i=1:length(occurance2)
   route2 = [route2; rest_table(occurance2(i)+1: occurance2(i)+2,:)];
end
end