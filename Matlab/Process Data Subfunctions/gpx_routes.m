function gpx_routes( route1, route2, name, max_accu )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

lat_col = 5; lng_col = 6; time_col = 1; acc_col = 4; spd_col = 8;

%% Route 1

% create gpx file of gps data of every time this route was taken
filename = strcat('D:\Documents\Studienarbeit_PC\JOSM\', name, '\Points\', name, '_Route1.gpx');
file = fopen(filename, 'w');
fprintf(file, '<gpx version="1.1" creator="Matlab">\n<author>Johanna Maisel</author>\n');

for i = 2:2:size(route1,1) % oder length(route1)-1 ???
    % load relevant location data
    file_loc = route1{i,1};
    if (exist(file_loc, 'file') ~= 0) % if file exists...
        run(file_loc);
        % identify gps and network location data and save in seperate files
        gps = provider; % net = provider;
        gps(any(gps(:,2)==7, 2),:)=[]; % net(any(net(:,2)==3, 2),:)=[];
        % delete any gps data points less accurate than "max_accu"
        gps(any(gps(:,4)> max_accu, 2),:)=[]; % net(any(net(:,4)> max_accu, 2),:)=[];
        
        %save gps data in route1 AUCH ACC???
        
        locdata = gps(route1{i,2}: route1{i+1,2}, :);
        route1{i,8} = locdata;
        
        %start waypoint for this journey
        lat = locdata(1,lat_col);
        lng = locdata(1,lng_col);
        time = epoch2date(locdata(1,time_col), true);
        fprintf(file, '\t<wpt lat="%.7f" lon="%.7f">\n\t  <name>Start</name>\n\t  <time>%s</time>\n\t</wpt>\n', lat, lng, time);
        
        %start trek segment for this journey
        date = epoch2date(locdata(1,time_col),false);
        time = epoch2date(locdata(1,time_col),true);
        fprintf(file, '\t<trk>\n\t\t<name>%s</name>\n\t\t<time>%s</time>\n\t\t<trkseg>\n', date, time);
        
        last = size(locdata,1);
        for k=1:last
            lat = locdata(k,lat_col); lng = locdata(k,lng_col); acc = locdata(k,acc_col);
            time = epoch2date(locdata(k,time_col), true); speed = locdata(k,spd_col);
            fprintf(file, '\t\t\t<trkpt lat="%.7f" lon="%.7f"><time>%s</time><hdop>%.3f</hdop><speed>%.3f</speed></trkpt>\n', lat, lng, time, acc, speed);
        end
        
        % finish trek segment
        fprintf(file, '\t\t</trkseg>\n\t</trk>\n');
        % finish waypoint
        lat = locdata(last,lat_col);
        lng = locdata(last,lng_col);
        time = epoch2date(locdata(last,time_col), true);
        fprintf(file, '\t<wpt lat="%.7f" lon="%.7f">\n\t  <name>Stop</name>\n\t  <time>%s</time>\n\t</wpt>\n', lat, lng, time);
    end
    
end
fprintf(file, '</gpx>\n');

%% Route 2

% create gpx file of gps data of every time this route was taken
filename = strcat('D:\Documents\Studienarbeit_PC\JOSM\', name, '\Points\', name, '_Route2.gpx');
file = fopen(filename, 'w');
fprintf(file, '<gpx version="1.1" creator="Matlab">\n<author>Johanna Maisel</author>\n');

for i = 2:2:size(route2,1) % oder length(route2)-1 ???
    % load relevant location data
    file_loc = route2{i,1};
    if (exist(file_loc, 'file') ~= 0) % if file exists...
        run(file_loc);
        % identify gps and network location data and save in seperate files
        gps = provider; % net = provider;
        gps(any(gps(:,2)==7, 2),:)=[]; % net(any(net(:,2)==3, 2),:)=[];
        % delete any gps data points less accurate than "max_accu"
        gps(any(gps(:,4)> max_accu, 2),:)=[]; % net(any(net(:,4)> max_accu, 2),:)=[];
        
        %save gps data in route2 AUCH ACC???
        
        locdata = gps(route2{i,2}: route2{i+1,2}, :);
        route2{i,8} = locdata;
        
        %start waypoint for this journey
        lat = locdata(1,lat_col);
        lng = locdata(1,lng_col);
        time = epoch2date(locdata(1,time_col), true);
        fprintf(file, '\t<wpt lat="%.7f" lon="%.7f">\n\t  <name>Start</name>\n\t  <time>%s</time>\n\t</wpt>\n', lat, lng, time);
        
        %start trek segment for this journey
        date = epoch2date(locdata(1,time_col),false);
        time = epoch2date(locdata(1,time_col),true);
        fprintf(file, '\t<trk>\n\t\t<name>%s</name>\n\t\t<time>%s</time>\n\t\t<trkseg>\n', date, time);
        
        last = size(locdata,1);
        for k=1:last
            lat = locdata(k,lat_col); lng = locdata(k,lng_col); acc = locdata(k,acc_col);
            time = epoch2date(locdata(k,time_col), true); speed = locdata(k,spd_col);
            fprintf(file, '\t\t\t<trkpt lat="%.7f" lon="%.7f"><time>%s</time><hdop>%.3f</hdop><speed>%.3f</speed></trkpt>\n', lat, lng, time, acc, speed);
        end
        
        % finish trek segment
        fprintf(file, '\t\t</trkseg>\n\t</trk>\n');
        % finish waypoint
        lat = locdata(last,lat_col);
        lng = locdata(last,lng_col);
        time = epoch2date(locdata(last,time_col), true);
        fprintf(file, '\t<wpt lat="%.7f" lon="%.7f">\n\t  <name>Stop</name>\n\t  <time>%s</time>\n\t</wpt>\n', lat, lng, time);
    end
    
end
fprintf(file, '</gpx>\n');

end