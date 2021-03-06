function [ poi_table, pause_table ] = poi(poi_table, pause_table, maxdist )
%POI identifies points belonging to the same address (i.e. distance less 
%    than maxdist) and writes their POI no. into column 9 of pause_table
%    POI then creates a table containing all POIs with averaged
%    coordinates.

% pause_table = {'Filename', 'Index', 'Unix time', 'UTC time', 'start/stop', 'Accuracy', ...
%     'Latitude', 'Longitude', 'POI no.', 'Rest Distance', 'Transit Distance', 'Duration', ...
%     'Duration in s', 'Type (Sp�ter durch Nummer ersetzen)'};
% 
% poi_table = {'POI no.', 'Latitude', 'Longitude', 'No. of points', 'Total rest time at this POI', ...
%     'Total transit time to this POI', '3a.m.'}; 

%% compare each point with all other points to determine those of distance less than maxdist and give those same poi_no in col. 9 of pause_table
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

%% enters all POIs including averaged coordinates and number of points accounting for this POI in poi_table
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


end

