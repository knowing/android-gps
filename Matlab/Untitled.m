% test for irregularities: time step back
clc

for i=2:size(test,1)
    if (test(i,1)-test(i-1,1)) < 0
        fprintf('%i  ', i);
    end
end

for i=2:size(test,1)
    if (test(i,1)-test(i-1,1)) < 0
    fprintf('\n%.0f %.0f', test(i-1,1), test(i,1));
    end
end

provider = divide_provider(provider);

% plot provider time 
plot (provider(:,1), 'r'); hold on; plot(provider(:,3), 'b--');

%% Erg�nzungen f�r fehlende Aufnahmen
fixes =[

1323286500000, 3, 1323280734514, 58.0, 48.16017056, 11.57777982, 0.0, 0.0; % eingef�gt: Sport
1323286550000, 3, 1323280734514, 56.0, 48.160317,11.575016, 0.0, 0.0; % eingef�gt: dazwischen
1323286560000, 3, 1323287806889, 5.0, 48.161241,11.568462, 0.0, 0.0; %eingef�gt: UBahn Hohenzollernplatz

1323443915524, 3, 0, 58.0, 48.12037101, 11.57280799, 298.5, 0.5; %eingef�gt: zu Hause
1323443915524, 3, 0, 58.0, 48.119945,11.574234, 298.5, 0.5; %eingef�gt: zu Hause zur Ubahn I
1323287780000, 3, 0, 5.0, 48.119823,11.575552, 0.0, 0.0; %eingef�gt: zu Hause zur Ubahn II
1323287760000, 3, 0, 5.0, 48.1201670,11.575660, 0.0, 0.0; %eingef�gt: UBahn Kolumbusplatz

1323692400000, 3, 1323287806889, 5.0, 48.1201670,11.575660, 0.0, 0.0; %eingef�gt: UBahn Kolumbusplatz
1323692450000, 3, 1323287806889, 5.0, 48.119823,11.575552, 0.0, 0.0; %eingef�gt: zu Hause zur Ubahn II
1323692500000, 3, 1323443915522, 58.0, 48.119945,11.574234, 298.5, 0.5; %eingef�gt: zu Hause zur Ubahn I
1323692550000, 3, 1323443915522, 58.0, 48.12037101, 11.57280799, 298.5, 0.5; %eingef�gt: zu Hause

1323336627695, 3, 1323346731288, 51.0, 48.14874854, 11.56714105, 0.0, 0.0; %eingef�gt: TUM
1323336627695, 3, 1323336627692, 30.0, 48.1508117, 11.56499124, 121.4, 1.25; %eingef�gt: Ubahn Theresienstr.

1325674520000, 3, 0, 22.0, 48.15006778, 11.57552588, 239.8, 0.5; % eingef�gt: Tea House T�rkenstr
1325674570000, 3, 0, 35.0, 48.14929706, 11.58057588, 0.0, 0.0; %eingef�gt: U Uni S�d

1325675820000, 3, 0, 5.0, 48.1201670,11.575660, 0.0, 0.0; %eingef�gt: UBahn Kolumbusplatz
1325675870000, 3, 0, 5.0, 48.119823,11.575552, 0.0, 0.0; %eingef�gt: zu Hause zur Ubahn II
1325675920000, 3, 0, 58.0, 48.119945,11.574234, 298.5, 0.5; %eingef�gt: zu Hause zur Ubahn I
1325675970000, 3, 0, 58.0, 48.12037101, 11.57280799, 298.5, 0.5]; %eingef�gt: zu Hause
