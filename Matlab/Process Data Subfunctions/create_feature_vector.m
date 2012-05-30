function [fvector] = create_feature_vector( name, date, i_start, i_stop, max_accu )
%CREATE_FEATURE_VECTOR Erstellt Feature Vektor im arff-Format von
%übergebenen Daten

% GPS Attributes:
% system time, 3, 0, pr. accuracy, pr. latitude, pr. longitude, pr. bearing, pr. speed
% ACCELEROMETER Attributes:
% system time, 0, sensor type (1 or 3), x_value, y_value, z_value

attributes = {'timestamp', 'provider speed', 'calculated speed',...
    'mean', 'variance','average peak amplitude', 'spectral energy (1-5Hz)',...
    'AR coefficient 1', 'AR coefficient 2', 'AR coefficient 3',...
    'FFT coeff 1Hz', 'FFT coeff 2Hz', 'FFT coeff 3Hz', 'FFT coeff 4Hz'};
segmentsize = 10000; %Millisekunden

%% Calculate Features
fvector = calculate_features(attributes, segmentsize, name, date, i_start, i_stop, max_accu);
if ~isempty(fvector)
    %% Classify segments according to calculated features
    % disp('     Start classification...');
    q=zeros(size(fvector,1),1);
    t=zeros(size(fvector,1),1);
    p=zeros(size(fvector,1),1);
    
    for i=1:size(fvector,1)
        q(i) = classification1(fvector(i,1:14));
        t(i) = classification_aktiv_inaktiv(fvector(i,1:14));
        p(i) = classificationall(fvector(i,1:14));
        if q(i) >= 8 || t(i) >= 8 || p(i) >= 8 % 8, da p = p' + 1;
            fprintf('%i', i);
            error('Feature other than provider speed is NaN');
        end
    end
    
    %% Plot calculated classes over time in one window
    % % Calculate time axis / Convert Epoch time to Matlab serial date number
    % posixTime = fvector(1,1)/1000;
    % epoch = datenum(1970,1,1,2,0,0);% Get the serial date number representing the POSIX epoch
    % posixDays = posixTime/(60*60*24);% Divide the timestamp you want to convert by the number of seconds in a day
    % start_st = epoch + posixDays;% Add this value to the serial date number representing the epoch
    % segm = segmentsize/(1000*60*60*24);
    % timeData = start_st:segm:(start_st + segm*(size(fvector,1)-1));
    % date_ts = datestr(start_st, 'dd/mm/yyyy');% Use datestr to format this value as a stringified date to confirm
    % %% Sommerzeit!!!
    %
    % figure1 = figure(11);
    % axes1 = axes('Parent',figure1,...
    %     'YTickLabel',{'','Auto/Bus','Rad','Gehen','U-Bahn','Tram','S-Bahn/Zug','Still',''},...
    %     'YTick',[0 1 2 3 4 5 6 7 8], 'XMinorTick','on');
    % ylim(axes1,[0 8]); box(axes1,'on'); hold(axes1,'all');
    %
    % % plot(timeData, q, 'bo'); hold on;
    % plot(timeData, q, 'rx');
    % % hold on; plot(timeData, p, 'm+');
    %
    % set(gca,'XTick',timeData); datetickzoom('x',13)
    % titl = strcat('Klassifizierung:  ', date_ts); title(titl);
    % ylabel('Klasse'); xlabel('Zeit'); hold off;
    
    
    %% Verify classification using regional public transport data
    % disp('     Start verifcation...');
    cls_data = t;   % define classified data to use from here on
    cls_size = size(cls_data,1); % number of segments
    
    % Route in ähnliche Abschnitte einteilen zur besseren Weiterverarbeitung
    % Mindestdauer eines Abschnitts sind min. 2 Minuten = 2*60*1000 = 120 000 ms
    part_size = floor(120000 / segmentsize); %abgerundet = Abschnittlänge -1
    if part_size < 5
        part_size = 5; %sinnvoll?
    end
    i=1; counter = 0; part_db =[]; part_info = [];
    while i <= (cls_size - part_size) % Startwert von 1 bis Ende - Abschnittlänge
        next_i = i +1;
        for j = (i + part_size) : cls_size
            if cls_data(i) == cls_data(j) % Anfang und Ende eines Abschnitts sind gleich
                % Mindestens 80% des Abschnittes sind aus gleicher Klasse:
                perc = size(find(cls_data(i:j) == cls_data(i)),1) / (j-i+1);
                if perc >= 0.80
                    part_info = [i cls_data(i);j cls_data(j)];
                    next_i = j+1;
                    counter = 0;
                end
            else
                counter = counter + 1;
                if counter == part_size % eine Abschnittlänge ohne gleiche Klasse
                    break % bricht for-Schleife ab
                end
            end
        end
        part_db = [part_db; part_info]; %#ok
        part_info = [];
        i = next_i;
    end
    
    if ~isempty(part_db)
        % Still-Abschnitte mit mindestens 20 Sekunden auch in AbschnittDB part_db übernehmen
        % Mindestdauer eines Still-Abschnitts sind min. 20s = 20*1000 = 20 000 ms
        % Still ist cls_data(i) == 3
        part_size = floor(20000 / segmentsize); %abgerundet = Abschnittlänge -1
        if part_size < 2
            part_size = 2; %sinnvoll?
        end
        i=1;
        while i <= (cls_size - part_size) % Startwert von 1 bis Ende - Abschnittlänge
            if cls_data(i) == 3 %Anfang des Abschnitts == Still
                next_i = i +1;
                counter = 0; part_info = [];
                for j = (i + part_size) : cls_size
                    if cls_data(j) == 3 % Ende des Abschnitts == Still
                        % Mindestens 80% des Abschnittes sind Still:
                        perc = size(find(cls_data(i:j) == 3),1) / (j-i+1);
                        if perc >= 0.80
                            part_info = [i 3;j 3];
                            next_i = j+1;
                            counter = 0;
                        end
                    else
                        counter = counter + 1;
                        if counter == part_size % eine Abschnittlänge ohne Still
                            break % bricht for-Schleife ab
                        end
                    end
                end
                part_db = [part_db; part_info]; %#ok
            else
                next_i = i+1;
            end
            i = next_i;
        end
        % part_db sortieren und gleiche löschen
        part_db = sortrows(part_db);
        % Lösche Zeilen mit gleichem Timestamp
        samestop = find(diff(part_db(:,1))==0);
        part_db(samestop,:)=[]; %#ok
        
        % Was tun, wenn Abschnitte zu stark wechseln und nicht zugeordnet werden können?
        %% Koordinaten zu jedem Punkt abspeichern
        load mvv_db.mat
        parts = part_db;
        part_db = num2cell(part_db);
        
        for i = 1:size(part_db,1)
            sgm_ind = part_db{i,1};
            if fvector(sgm_ind, 16) > 0 %funktioniert alles nur auf nordhalbkugel
                part_db{i,3} = [fvector(sgm_ind, 16) fvector(sgm_ind, 15)]; %Koordinaten kopiert in part_db
            else
                for j=sgm_ind:-1:1%rückwärts suchen
                    if  fvector(j, 16) > 1
                        j_back = j;
                        break;
                    end
                end
                for j=sgm_ind:size(fvector,1) %vorwärts suchen
                    if  fvector(j, 16) > 1
                        j_forw = j;
                        break;
                    end
                end
                if (j_forw-sgm_ind) < (sgm_ind-j_back)
                    part_db{i,3} = [fvector(j_forw, 16) fvector(j_forw, 15)]; %Koordinaten kopiert in part_db
                else
                    part_db{i,3} = [fvector(j_back, 16) fvector(j_back, 15)]; %Koordinaten kopiert in part_db
                end
            end
            dist = zeros(size(mvv_db,1),1); %#ok
            for j = 1:size(mvv_db,1)
                dist(j) = haversine(part_db{i,3}, mvv_db{j,1});
            end
            [sh_dist, nearest_station] = min(dist);
            if sh_dist < 0.1 %Abstand kleiner 100m von Haltestelle
                part_db{i,4} = mvv_db{nearest_station,2};
                part_db{i,5} = mvv_db{nearest_station,3};
            else
                part_db{i,4} = 'Keine Haltestelle in der Nähe';
                part_db{i,5} = [];
            end
        end
        
        datum = epoch2date(fvector(part_db{1,1},1),4);
        fprintf('\nDer Nutzer bewegte sich am %s\n', datum);
        for i = 1:size(part_db,1)/2
            date1 = epoch2date(fvector(part_db{i*2-1,1},1),5);
            date2 = epoch2date(fvector(part_db{i*2,1},1),5);
            switch part_db{i*2-1,2}
                case 1 %Inaktive Bewegung
                    if strcmp(part_db{i*2-1,4},part_db{i*2,4}) == 0 %Start und Stop nicht an gleicher Haltestelle
                        trlines = part_db{i*2-1,5};
                        trlines = trlines(ismember(trlines,part_db{i*2,5}));  %CAREFUL: ismember changes behaviour in Matlab2012a
                        if ~isempty(trlines)
                            numlines = numel(trlines);
                            trline = cell(numlines,1);
                            for k = 1:numlines
                                switch trlines(k)
                                    case 1, trline{k} = 'U1';
                                    case 2, trline{k} = 'U2';
                                    case 3, trline{k} = 'U3';
                                    case 4, trline{k} = 'U4';
                                    case 5, trline{k} = 'U5';
                                    case 6, trline{k} = 'U6';
                                    case 7, trline{k} = 'U7';
                                    case 15, trline{k} = 'Tram 15';
                                    case 18, trline{k} = 'Tram 18';
                                    case 19, trline{k} = 'Tram 19';
                                    case 20, trline{k} = 'Tram 20';
                                    case 21, trline{k} = 'Tram 21';
                                    case 25, trline{k} = 'Tram 25';
                                    case 101, trline{k} = 'S1';
                                    case 102, trline{k} = 'S2';
                                    case 103, trline{k} = 'S3';
                                    case 104, trline{k} = 'S4';
                                    case 106, trline{k} = 'S6';
                                    case 107, trline{k} = 'S7';
                                    case 108, trline{k} = 'S8';
                                    case 127, trline{k} = 'S27';
                                        
                                    otherwise
                                        trline{k} = 'unerkannt'; fprintf('%i\n',trlines(k));
                                end
                            end
                            fprintf('   inaktiv von %s bis %s', date1, date2);
                            fprintf('(%s', trline{1});
                            if numlines == 2
                                fprintf(' oder %s ',trline{2}); %maximal 2 Linien zur Auswahl
                            else 
                                fprintf(', %s etc. ',trline{2}); %maximal 2 Linien zur Auswahl
                            end
                        else
                            fprintf('   inaktiv von %s bis %s', date1, date2);
                            fprintf('(mit Umsteigen '); %umsteigen noch nicht implementiert
                        end
                        fprintf('von %s bis %s)\n', part_db{i*2-1,4}, part_db{i*2,4})
                    else %Start und Stop an gleicher Haltestelle
                    end
                case 2 %Aktive Bewegung
                    fprintf('   aktiv von %s bis %s\n', date1, date2);
                case 3,case 4 %Still
                    %             fprintf('   nicht von %s bis %s\n', date1, date2);
                otherwise %Fehler?
                    fprintf('   nicht nachvollziehbar von %s bis %s\n', date1, date2);
                    fprintf('%i\n',part_db{i*2-1,2});
            end
        end
        fprintf('\n');
        
        % Beweis dass sich Tram/U-Bahn etc. wenig untereinander unterscheiden durch
        % Kovarianz?
        
        
        % %% Plot Abschnittbeginne
        % if ~isempty(part_db)
        %     figure14 = figure(14);
        %     axes14 = axes('Parent',figure14,...
        %         'YTickLabel',{'','Inaktiv','Aktiv','Still','Pause', ''},...
        %         'YTick',[0 1 2 3 4 5], 'XMinorTick','on');
        %     ylim(axes14,[0 5]); box(axes14,'on'); hold(axes14,'all');
        %     titl = strcat('Klassifizierung:  ', date_ts); title(titl);
        %     ylabel('Klasse'); xlabel('Zeit');
        %     plot(parts(:,1), parts(:,2), 'kv'); hold on; plot(t,'rx');
        % end
        
        % %% Plot calculated classes over time in subplots
        % figure(12);
        % subplot(3,1,1); plot(q, 'bo');
        % subplot(3,1,2); plot(t, 'ro');
        % subplot(3,1,3); plot(p, 'm+');
        
        
        %% Save more training data or test data to .mat
        %         tr = fvector(60:90,2:14);
        %         tr = num2cell(tr);
        %         S = cell(size(tr,1),1);
        %         tr = [tr S];
        %         for i = 1:size(tr,1)
        %             tr{i,14} = 'Ubahn';
        %         end
        % %         save('test_ubahn.mat', 'tr')
        %         load training
        %         training = [training;tr]; %#ok
        %         save('training.mat', 'training')
        
        %% Save test or training data to .arff directly
        %         class_string = '{Auto, Rad, Gehen, Ubahn, Tram, Zug, Still}';
        %         classes = {'Auto', 'Rad', 'Gehen', 'Ubahn', 'Tram', 'Zug', 'Still'};
        %         create_arff(name, date, i_start, fvector(:,1:14), attributes, totalupdaterate, class_string);
        %         create_training_arff( fvector( 400:1000 ,1:14), attributes, totalupdaterate, 'Zug', 1 , class_string)
        %         create_training_arff( fvector( 255:308 ,1:14), attributes, totalupdaterate, 'Gehen', 0 , class_string)
        
    else
        disp('Keine eindeutigen Segmente erkannt.');
    end
else
    disp('Keine eindeutigen Segmente erkannt.');
end
end