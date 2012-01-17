function [ pause_table ] = create_pause_table( pause_table, t_gap, gps_type, max_accu, name )
%CREATE PAUSE TABLE analyses all on the Matlab Path available data (Jan11 -
%   Dec12) and writes start and stop point of pauses of more than "t_gap" in
%   the gps data in "pause_table"

%   Input:
%     pause_table = pause_table, first row only
%     t_gap = minimum pause length
%     gps_type = 'gps' or 'gps_accu'
%     max_accu = max accuracy [m] classed as accurate for variable gps_accu
%     varargin = if additional [name] is given, a gpx file of gps data of 
%                each single day is created in JOSM folder if not yet existant

no_col = size(pause_table, 2);

for y = 2011:2012
    for m = 1:12
        for d = 1:31
            date = strcat(num2str(y),num2str(m, '%02.f'),num2str(d, '%02.f'));
            %% check if location data of required date is available (every day in 2011 and 2012)
            file_loc = strcat('locprovider_', date);
            if (exist(file_loc, 'file') ~= 0)
                fprintf('%s  ', file_loc);
                run(file_loc);
                %% identify gps and network location data and save in seperate files
                [gps, net, gps_accu, net_accu] = divide_provider(provider, max_accu); % teilt provider in "gps" und "network"
                
                %% create gpx file of gps data of each single day in JOSM folder if not yet existant and if name is string
                if ischar(name) 
                    if (exist(strcat('D:\Documents\Studienarbeit_PC\JOSM\', name, '\', date, '.gpx'), 'file') == 0)
                        gpx_creator(gps, strcat('D:\Documents\Studienarbeit_PC\JOSM\', name, '\', date, '.gpx'))
                    end
                    if (exist(strcat('D:\Documents\Studienarbeit_PC\JOSM\', name, '\', date, '_accurate.gpx'), 'file') == 0)
                        gpx_creator(gps_accu, strcat('D:\Documents\Studienarbeit_PC\JOSM\', name, '\', date, '_accurate.gpx'))
                    end
                end
                %% if accurate gps data is available write start and stops in first 8 columns of "tabelle"
                if strcmp(gps_type, 'gps');
                    if exist('gps', 'var') ~= 0
                        [new_table] = build_table(gps, file_loc, t_gap, no_col); %data, filename, minutes of gap, no. of columns in pause_table
                        pause_table = [pause_table;new_table]; %#ok
                    end
                elseif strcmp(gps_type, 'gps_accu');
                    if exist('gps_accu', 'var') ~= 0
                        [new_table] = build_table(gps_accu, file_loc, t_gap, no_col); %data, filename, minutes of gap, no. of columns in pause_table
                        pause_table = [pause_table;new_table]; %#ok
                    end
                end
            end
        end
    end
    
    fprintf('\n\n');
    
end

