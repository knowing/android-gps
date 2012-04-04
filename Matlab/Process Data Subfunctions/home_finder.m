function [home_ind, work_ind] = home_finder( poi_table )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Calculate where most 3 a.m.s where spent (saved in poi_table(2:end, 7) )
nights_at_poi = cell2mat(poi_table(2:end,7)); % nights_at_poi(x): number of nights spent at POI no. x
[max_nights, home_ind] = max(nights_at_poi); % place where most 3 a.m.s were spent
% Condition: only ONE home, otherwise:
    % nights_at_poi2 = nights_at_poi; nights_at_poi2(nights_ind) = 0;
    % [max_nights2, home_ind2] = max(nights_at_poi2); % place where second most 3 a.m.s were spent
    
%% Calculate where most rest time was spent
max_rest_ind = zeros(3,1);
rest_time = cell2mat(poi_table(2:end,5));
[max_rest1,max_rest_ind(1)] = max(rest_time);    % place where most rest time was spent
rest_time2 = rest_time; rest_time2(max_rest_ind(1)) = 0;
[max_rest2, max_rest_ind(2)] = max(rest_time2); % place where second most rest time was spent
% rest_time3 = rest_time; rest_time3(max_rest_ind(2)) = 0;
% [max_rest3, max_rest_ind(3)] = max(rest_time3); % place where third most rest time was spent

%% Output home and work place
if home_ind == max_rest_ind(1)  % home is where most rest time and most 3a.m.s where spent
    work_ind = max_rest_ind(2); % work is where second most rest time was spent
else 
    work_ind = max_rest_ind(1); % work is where most rest time was spent
    home_ind = max_rest_ind(2); % home is where most 3a.m.s are spent
end

fprintf('These are your home coordinates (POI No. %i): \t %2.4f, %2.4f\n', home_ind, poi_table{home_ind+1,2}, poi_table{home_ind+1,3});
fprintf('\t http://maps.google.de/maps?q=%2.4f,+%2.4f\n', poi_table{home_ind+1,2}, poi_table{home_ind+1,3});

fprintf('You spent most time besides your home at POI No. %i: \t %2.4f, %2.4f\n', work_ind, poi_table{work_ind+1,2}, poi_table{work_ind+1,3});
fprintf('\t http://maps.google.de/maps?q=%2.4f,+%2.4f\n\n', poi_table{work_ind+1,2}, poi_table{work_ind+1,3});

end

