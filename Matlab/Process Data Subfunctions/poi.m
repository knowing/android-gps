function [ poi_table, pause_table ] = poi(poi_table, pause_table, maxdist )
%POI identifies points belonging to the same address (i.e. distance less 
%    than maxdist) and writes their POI no. into column 9.
%    POI then creates a table containing all POIs with averaged
%    coordinates.

%    "poi_table" is a table with column titles in first row and one more row
%    for each POI (i.e. 1 + total_poi-1 rows).
%    Latitude in 7th, longitude in 8th and POI no. in 9th column of pause_table

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

poi_table = [poi_table; cell(poi_no, size(poi_table,2))]; %poi_no is here number of POIs

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

