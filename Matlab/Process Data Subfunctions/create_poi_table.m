function [ poi_table ] = create_poi_table(poi_table, pause_table, total_poi )
%CREATE_POI_TABLE creates table of POIs with averaged coordinates
%   poi_table is a table with column titles in first row and one more row
%   for each POI (i.e. 1 + total_poi-1 rows).
%   Latitude in 7th, longitude in 8th and POI no. in 9th column of pause_table

poi_table = [poi_table; cell(total_poi, size(poi_table,2))];

for poi_cnt=1:(total_poi-1)
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

