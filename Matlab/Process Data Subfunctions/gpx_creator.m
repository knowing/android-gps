function gpx_creator (locdata, filename)
%GPX_CREATOR creates gpx file from matlab location data (track)
%   Latitude in 7th, longitude in 8th and POI no. in 9th column of pause_table

%   2 January 2012
%   Johanna Maisel

lat_col = 5; lng_col = 6; time_col = 1; acc_col = 4; spd_col = 8; line1 = 1;
% lat_col = 7; lng_col = 8; time_col = 3; no_col = 9;

file = fopen(filename, 'w');
fprintf(file, '<gpx version="1.1" creator="Matlab">\n<author>Johanna Maisel</author>\n');

lat = locdata(line1,lat_col);
lng = locdata(line1,lng_col);
time = epoch2date(locdata(line1,time_col), true);
fprintf(file, '\t<wpt lat="%.7f" lon="%.7f">\n\t  <name>Start</name>\n\t  <time>%s</time>\n\t</wpt>\n', lat, lng, time);

date = epoch2date(locdata(line1,time_col),false);
time = epoch2date(locdata(line1,time_col),true);
fprintf(file, '\t<trk>\n\t\t<name>%s</name>\n\t\t<time>%s</time>\n\t\t<trkseg>\n', date, time);

last = size(locdata,1);
for i=line1:last
    lat = locdata(i,lat_col);
    lng = locdata(i,lng_col);
    acc = locdata(i,acc_col);
    time = epoch2date(locdata(i,time_col), true);
%     number = locdata(i,no_col);
    speed = locdata(i,spd_col);
    fprintf(file, '\t\t\t<trkpt lat="%.7f" lon="%.7f"><time>%s</time><hdop>%.3f</hdop><speed>%.3f</speed></trkpt>\n', lat, lng, time, acc, speed);
%     fprintf(file, '\t\t\t<trkpt lat="%.7f" lon="%.7f"><time>%s</time><name>%d</name></trkpt>\n', lat, lng, time, number);

end

fprintf(file, '\t\t</trkseg>\n\t</trk>\n');

lat = locdata(last,lat_col);
lng = locdata(last,lng_col);
time = epoch2date(locdata(last,time_col), true);
fprintf(file, '\t<wpt lat="%.7f" lon="%.7f">\n\t  <name>Stop</name>\n\t  <time>%s</time>\n\t</wpt>\n', lat, lng, time);

fprintf(file, '</gpx>\n');
end