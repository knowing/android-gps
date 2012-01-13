function [ pause_table, poi_no ] = identify_pois( pause_table, maxdist )
%IDENTIFY_POIs identifies points belonging to the same address (i.e.
%distance less then maxdist) and writes their POI no. into column 9

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
end

