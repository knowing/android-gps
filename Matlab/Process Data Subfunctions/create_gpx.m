function create_gpx( pause_table, poi_table, name )
%CREATE GPX creates gpx files of all points as track or waypoints and all
%POIs as waypoints

%% Create GPX file to show all points in JOS (pause_table)
gpx_file = strcat('D:\Documents\Studienarbeit_PC\JOSM\', name,'\Points\', name,'_Points.gpx');
gpx_wpt_creator(pause_table, gpx_file);

%% Create GPX file to show all points as track in JOS (pause_table)
gpx_file = strcat('D:\Documents\Studienarbeit_PC\JOSM\', name,'\Points\', name,'_Tracks.gpx');
gpx_track_creator(pause_table, gpx_file);

%% Create GPX file to show all POI in JOS (poi_table)
gpx_file = strcat('D:\Documents\Studienarbeit_PC\JOSM\', name,'\Points\', name,'_POI.gpx');
gpx_wpt_creator(poi_table, gpx_file);

end

