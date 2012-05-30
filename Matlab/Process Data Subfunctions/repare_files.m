function repare_files( name )
%REPARE_FILES fügt "];" an jede neue Datei an

for y = 2011:2012
    for m = 1:12
        for d = 1:31
            date = strcat(num2str(y),num2str(m, '%02.f'),num2str(d, '%02.f'));
            
            
            % check if accelerometer data of specific date is available (every day in 2011 and 2012)
            file_loc = strcat('D:\Documents\Studienarbeit_PC\App-Aufnahmen\', name, '\accelerometer_', date, '.m');
            if (exist(file_loc, 'file') ~= 0) % if file exists...
                fprintf('\n%s  ', date);
                % korrigiere, dass letzte zeile jeder datei kein "];" enthält
                try
                    run(file_loc);
                    fprintf('acc: %i  ', size(acc,2));                    
                    clear acc;
                catch %#ok
                    fileID = fopen(file_loc,'a');
                    fprintf(fileID,'\n];');
                    fclose(fileID);
                    try
                        run(file_loc);
                        clear acc;
                        fprintf('acc %s repared\n', date);
                    catch %#ok
                        fprintf('acc %s still faulty\n', date);
                    end
                end
            end
            
            % check if location data of specific date is available (every day in 2011 and 2012)
            file_loc = strcat('D:\Documents\Studienarbeit_PC\App-Aufnahmen\', name, '\locprovider_', date, '.m');
            if (exist(file_loc, 'file') ~= 0) % if file exists...
                % korrigiere, dass letzte zeile jeder datei kein "];" enthält
                try
                    run(file_loc);
                    fprintf('gps: %i  ', size(provider,2));
                    clear provider;
                catch %#ok
                    fileID = fopen(file_loc,'a');
                    fprintf(fileID,'\n];');
                    fclose(fileID);
                    try
                        run(file_loc);
                        clear provider;
                        fprintf('loc %s repared\n', date);
                    catch %#ok
                        fprintf('loc %s still faulty\n', date);
                    end
                end
            end
            
            
        end
    end
end
fprintf('\nAll files checked.\n\n');
end
