function mat2arff
%CREATE_ARFF erstellt arff-Trainingsdatei

load training.mat;
data = training;
classes = '{Auto, Rad, Gehen, Ubahn, Tram, Zug, Still}';
attributes = {'timestamp', 'provider speed', 'calculated speed',...
    'mean', 'variance','average peak amplitude', 'spectral energy (1-5Hz)',...
    'AR coefficient 1', 'AR coefficient 2', 'AR coefficient 3',...
    'FFT coeff 1Hz', 'FFT coeff 2Hz', 'FFT coeff 3Hz', 'FFT coeff 4Hz'};
new = 1;

filename = 'D:\Documents\Studienarbeit_PC\WEKA\ARFF\trainingubahn.arff';
if new ==1
    fid = fopen(filename,'w'); % Open File
    
    % Header
    fprintf(fid, '%% Feature Vector for Classification of Transport Modes\n%% Author: Johanna Maisel\n');
    fprintf(fid, '%% Trainig data\n%% Sensor Type: Acceleration / GPS, Data Rate: 50Hz / ca. 1Hz\n\n');
    fprintf(fid, '@RELATION "Tranport Mode"\n\n');
    
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
    for c = 1:size(attributes, 2)-1
        fprintf(fid,'%.5f,', data{r,c});
    end
    fprintf(fid,'"%s"\n', data{r,c+1});    % Fortbewegungsmittel
end
fclose(fid); % Close File