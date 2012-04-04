function gpx_home_and_work (table, name, home_POI, work_POI)
%GPX_WPT_CREATOR creates gpx file from matlab location data
%   Waypoints of Home and Work Places
%   Latitude in 7th, longitude in 8th and POI no. in 9th column of pause_table
%   Latitude in 2nd, longitude in 3rd and POI no. in 1st column of poi_table
%   CAUTION: pause_table must have more than 9 and poi_table less than 8
%   columns!!!
%   2 January 2012
%   Johanna Maisel

filename = strcat('D:\Documents\Studienarbeit_PC\JOSM\', name,'\Points\', name,'_homePOI.gpx');
lat_col = 2; lng_col = 3; % in poi_table (HERE)

file = fopen(filename, 'w');
fprintf(file, '<gpx version="1.1" creator="Matlab">\n<author>Johanna Maisel</author>\n');

i=home_POI+1;
lat = table{i,lat_col};
lng = table{i,lng_col};
fprintf(file, '\t<wpt lat="%.7f" lon="%.7f">\n\t  <name>home</name>\n\t  </wpt>\n', lat, lng);

i=work_POI+1;
lat = table{i,lat_col};
lng = table{i,lng_col};
fprintf(file, '\t<wpt lat="%.7f" lon="%.7f">\n\t  <name>work</name>\n\t  </wpt>\n', lat, lng);

fprintf(file, '</gpx>\n');
end