function [ pause_table ] = create_pause_table( pause_table, t_gap, max_accu, name, gpx )
%CREATE PAUSE TABLE analyses all on the Matlab Path available data (Jan11 -
%   Dec12) and writes start and stop point of pauses of more than "t_gap" in
%   the gps data in "pause_table"

%   Input:
%     pause_table = pause_table, first row only
%     t_gap = minimum pause length
%     max_accu = max accuracy [m] classed as accurate for variable gps_accu
%     varargin = if additional [name] is given, a gpx file of gps data of
%                each single day is created in JOSM folder if not yet existant

for y = 2011:2012
    for m = 1:12
        for d = 1:31
            date = strcat(num2str(y),num2str(m, '%02.f'),num2str(d, '%02.f'));
            % check if location data of required date is available (every day in 2011 and 2012)
            file_loc = strcat('D:\Documents\Studienarbeit_PC\App-Aufnahmen\', name, '\locprovider_', date, '.m');
            if (exist(file_loc, 'file') ~= 0) % if file exists...
%                 fprintf('%s  ', date);
                run(file_loc);
                if exist('provider', 'var') ~= 0 && size(provider,1) > 1
                    % identify gps and network location data and save in seperate files
                    gps = provider; % net = provider;
                    gps(any(gps(:,2)==7, 2),:)=[]; % net(any(net(:,2)==3, 2),:)=[];
                    
                    % delete any provider data points less accurate than "max_accu"
                    gps(any(gps(:,4)> max_accu, 2),:)=[]; 
                    % if gps data is available write start and stops of every pause of more than tgap in first 8 columns of following rows of "pause_table"
                    pause_table = build_table(pause_table, gps, date, t_gap); %data, filename, minutes of gap
                end
                % create gpx file of gps data of each single day in JOSM folder if gpx ==1
                if gpx == 1
                    file_loc = strcat('D:\Documents\Studienarbeit_PC\JOSM\', name);
                    points_folder = strcat(file_loc, '\Points');
                    if exist(points_folder, 'dir') == 0
                        mkdir(points_folder); %Folder Points is used later
                        fprintf('New folder in JOSM created: %s\n\n', points_folder);
                    end
                    %                     [s,mess,messid] = mkdir('../testdata','newFolder');
                    gpx_creator(provider, strcat(file_loc, '\', date, '.gpx'))
                end
            end
        end
    end
end
% fprintf('\n');
% error message if pause_table is empty because no data was found in said folder
if size(pause_table,1) == 1
    error('No gps data files in folder: %s\nMaybe name is spelled wrong?', file_loc);
end
end