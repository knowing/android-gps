function gpx_wpt_creator (tabelle, filename)
%GPX_WPT_CREATOR creates gpx file from matlab location data
%   Use this if location data only contains points not tracks
%   Latitude in 7th, longitude in 8th and POI no. in 9th column of pause_table
%   Latitude in 2nd, longitude in 3rd and POI no. in 1st column of poi_table
%   CAUTION: pause_table must have more than 9 and poi_table less than 8
%   columns!!!
%   2 January 2012
%   Johanna Maisel

if size(tabelle, 2) > 9
    lat_col = 7; lng_col = 8; name_col = 9; time_col = 3; % in pause_table
elseif size(tabelle, 2) < 8
    lat_col = 2; lng_col = 3; name_col = 1; % in poi_table
end

file = fopen(filename, 'w');
fprintf(file, '<gpx version="1.1" creator="Matlab">\n<author>Johanna Maisel</author>\n');

for i=2:size(tabelle,1)
lat = tabelle{i,lat_col};
lng = tabelle{i,lng_col};
if size(tabelle, 2) > 9
    time = epoch2date(tabelle{i,time_col}, true);
elseif size(tabelle, 2) < 8
    time = 'no time';
end
name = tabelle{i,name_col};
fprintf(file, '\t<wpt lat="%.7f" lon="%.7f">\n\t  <name>%i</name>\n\t  <time>%s</time>\n\t</wpt>\n', lat, lng, name, time);
end

fprintf(file, '</gpx>\n');
end