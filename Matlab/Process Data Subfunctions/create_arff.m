function create_arff( name, date, i_start, data, attributes, updaterate, classes )
%CREATE_ARFF erstellt arff-Datei aus übergebener "data"

% logfile = strcat('D:\Documents\Studienarbeit_PC\App-Aufnahmen\', name, '\logfile.m');
% run(logfile);

%% TODO logfile wird nicht korrekt gelesen, keine Variablen gespeichert
if exist('phoneinfo', 'var') ~= 0
    info = phoneinfo;
else info = 'unbekannt';
end
relation = 'Transport Mode';

% Open File
dirname = strcat('D:\Documents\Studienarbeit_PC\WEKA\ARFF\', name);
if exist(dirname, 'dir') == 0
    mkdir(dirname);
end
filename = strcat(dirname, '\', date, '_', num2str(i_start), '.arff');
fid = fopen(filename,'w');

% Header
fprintf(fid, '%% Feature Vector for Classification of Transport Modes\n%% Author: Johanna Maisel \n');
fprintf(fid, '%% Person ID: %s, Date: %s, Start Index: %i \n%%  %s \n', name, date, i_start, info);
fprintf(fid, '%% Sensor Type: Acceleration / GPS, Data Rate: %.2fHz / ca. 1Hz\n\n', updaterate);
fprintf(fid, '@RELATION "%s"\n\n@ATTRIBUTE "%s" DATE \n', relation, attributes{1});

for i = 2:size(attributes, 2)
    fprintf(fid, '@ATTRIBUTE "%s" NUMERIC \n', attributes{i});
end
fprintf(fid, '@ATTRIBUTE "class" %s \n', classes);
fprintf(fid, '\n@DATA\n');

% Body
for r = 1:size(data,1)
    % Zeit in lesbares Format umwandeln
    fprintf(fid,'"%s",', epoch2date(data(r,1),3));
    for c = 2:size(attributes, 2)
        fprintf(fid,'%.5f,', data(r,c));
    end
    % Tranportmittelklasse als Unbekannte
    fprintf(fid,'?\n');
end

% Close File
fclose(fid);

