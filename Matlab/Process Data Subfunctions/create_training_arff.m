function create_training_arff( data, attributes, updaterate, mode, new, classes )
%CREATE_ARFF erstellt arff-Trainingsdatei

    filename = 'D:\Documents\Studienarbeit_PC\WEKA\ARFF\training.arff';
if new ==1
    fid = fopen(filename,'w'); % Open File
    
    % Header
    fprintf(fid, '%% Feature Vector for Classification of Transport Modes\n%% Author: Johanna Maisel\n');
    fprintf(fid, '%% Trainig data\n%% Sensor Type: Acceleration / GPS, Data Rate: %.2fHz / ca. 1Hz\n\n', updaterate);
    fprintf(fid, '@RELATION "Tranport Mode"\n\n@ATTRIBUTE "%s" DATE \n', attributes{1});
    for i = 2:size(attributes, 2)
        fprintf(fid, '@ATTRIBUTE "%s" NUMERIC \n', attributes{i});
    end
    fprintf(fid, '@ATTRIBUTE "class" %s \n', classes);
    fprintf(fid, '\n@DATA\n');

else
    fid = fopen(filename,'a'); % Open File
end

% Body
for r = 1:size(data,1)
    fprintf(fid,'"%s",', epoch2date(data(r,1),3));    % Zeit in lesbares Format umwandeln
    for c = 2:size(attributes, 2)
        fprintf(fid,'%.5f,', data(r,c));
    end
    fprintf(fid,'"%s"\n', mode);    % Tranportmittelklasse
end

fclose(fid); % Close File