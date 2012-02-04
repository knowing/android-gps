%Codeabschnitte

%% test for irregularities: time step back
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

%% plot provider time 
plot (provider(:,1), 'r'); hold on; plot(provider(:,3), 'b--');

%% plot test (=acc) time and mark time steps of more than 1 minute
test = acc(1);
% gap_index = 0;
% for i=2:size(test,1)
%     if (test(i)-test(i-1)) > 30000 %1 Minute
%         gap_index = [gap_index; i-1; i]; %#ok
%     end
% end
t=1:size(test, 1);
plot (test, t, 'g');
% for i=2:length(gap_index)
%     hold on;
%     plot(test(gap_index(i)), t(gap_index(i)), 'bx');
% end
%%in acc_20120117.m Wechsel zwischen
% ui: 1326809115879 bis 1326810021794 = index: 0 - 5194
% normal: 1326810113389 bis 1326811388469  = index: 5195 - 7365
% game: 1326811425339 bis 1326813205753 = index: 7366 - 32365
% fastest: 1326819206667 bis 1326820335198 = index: 32366 - end
% fprintf('%.0f\n', test(1), test(5194), test(5195), test(7365), test(7366),...
%     test(32365), test(32366), test(end));
i=5195;
hold on; plot(test(i), t(i),'rx');  %, 'text', 'start normal');
i=7366;
hold on; plot(test(i), t(i),'rx');  %, 'text', 'start game');
i=32366;
hold on; plot(test(i), t(i),'rx');  %, 'text', 'start fastest');

%% find recording rate for ui, normal, game and fastest:
ui1   = 1000/ (test(2070)  - test(1   ))  * (2070-1);        % 14 Hz
ui2   = 1000/ (test(3340)  - test(2071))  * (3340-2071);     % 14
ui3   = 1000/ (test(4818)  - test(4188))  * (4818-4188);     % 3.3
nor   = 1000/ (test(7233)  - test(5340))  * (7233-5340);     % 1.7 Hz
gam1  = 1000/ (test(20570) - test(8000))  * (20570-8000);    % 27 Hz
gam2  = 1000/ (test(31110) - test(22770)) * (31110-22770);   % 9
fast1 = 1000/ (test(38710) - test(33170)) * (38710-33170);   % 25 Hz
fast2 = 1000/ (test(42600) - test(40000)) * (42600-40000);   % 31

figure(5)
subplot(2,2,1)
plot(acc(:,1), acc(:,4), 'g', acc(:,1), acc(:,5), 'r', acc(:,1), acc(:,6), 'b');
legend('x', 'y', 'z');
title('normal');
subplot(2,2,1)
plot(acc(1:2070,1), acc(1:2070,4), 'g', acc(1:2070,1), acc(1:2070,5), 'r', acc(1:2070,1), acc(1:2070,6), 'b');
legend('x', 'y', 'z');
title('ui');
subplot(2,2,1)
plot(acc(:,1), acc(:,4), 'g', acc(:,1), acc(:,5), 'r', acc(:,1), acc(:,6), 'b');
legend('x', 'y', 'z');
title('game');
subplot(2,2,1)
plot(acc(:,1), acc(:,4), 'g', acc(:,1), acc(:,5), 'r', acc(:,1), acc(:,6), 'b');
legend('x', 'y', 'z');
title('fastest');



%% Ergänzungen für fehlende Aufnahmen
fixes =[

1323286500000, 3, 1323280734514, 58.0, 48.16017056, 11.57777982, 0.0, 0.0; % eingefügt: Sport
1323286550000, 3, 1323280734514, 56.0, 48.160317,11.575016, 0.0, 0.0; % eingefügt: dazwischen
1323286560000, 3, 1323287806889, 5.0, 48.161241,11.568462, 0.0, 0.0; %eingefügt: UBahn Hohenzollernplatz

1323443915524, 3, 0, 58.0, 48.12037101, 11.57280799, 298.5, 0.5; %eingefügt: zu Hause
1323443915524, 3, 0, 58.0, 48.119945,11.574234, 298.5, 0.5; %eingefügt: zu Hause zur Ubahn I
1323287780000, 3, 0, 5.0, 48.119823,11.575552, 0.0, 0.0; %eingefügt: zu Hause zur Ubahn II
1323287760000, 3, 0, 5.0, 48.1201670,11.575660, 0.0, 0.0; %eingefügt: UBahn Kolumbusplatz

1323692400000, 3, 1323287806889, 5.0, 48.1201670,11.575660, 0.0, 0.0; %eingefügt: UBahn Kolumbusplatz
1323692450000, 3, 1323287806889, 5.0, 48.119823,11.575552, 0.0, 0.0; %eingefügt: zu Hause zur Ubahn II
1323692500000, 3, 1323443915522, 58.0, 48.119945,11.574234, 298.5, 0.5; %eingefügt: zu Hause zur Ubahn I
1323692550000, 3, 1323443915522, 58.0, 48.12037101, 11.57280799, 298.5, 0.5; %eingefügt: zu Hause

1323336627695, 3, 1323346731288, 51.0, 48.14874854, 11.56714105, 0.0, 0.0; %eingefügt: TUM
1323336627695, 3, 1323336627692, 30.0, 48.1508117, 11.56499124, 121.4, 1.25; %eingefügt: Ubahn Theresienstr.

1325674520000, 3, 0, 22.0, 48.15006778, 11.57552588, 239.8, 0.5; % eingefügt: Tea House Türkenstr
1325674570000, 3, 0, 35.0, 48.14929706, 11.58057588, 0.0, 0.0; %eingefügt: U Uni Süd

1325675820000, 3, 0, 5.0, 48.1201670,11.575660, 0.0, 0.0; %eingefügt: UBahn Kolumbusplatz
1325675870000, 3, 0, 5.0, 48.119823,11.575552, 0.0, 0.0; %eingefügt: zu Hause zur Ubahn II
1325675920000, 3, 0, 58.0, 48.119945,11.574234, 298.5, 0.5; %eingefügt: zu Hause zur Ubahn I
1325675970000, 3, 0, 58.0, 48.12037101, 11.57280799, 298.5, 0.5]; %eingefügt: zu Hause
