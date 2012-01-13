function [gap_index, tab, tab_date] = find_pauses( data, cln, tgap )
%FIND_PAUSES returns index of elements before and after gaps of tgap
%minutes
% and table with timestamps before and after gaps (tab=data(gap_index,1);)

tgap = tgap * 60* 1000;
% tgap = 5000; cln = 1; data = acc; 
t_data = data(:,cln);
n=2;
gap_index = zeros(50,1);
tab = zeros(50,1);
tab_date = cell(50,1);

gap_index(1) = 1;
tab(1) = t_data(1);
tab_date(1,1) = {epoch2date(t_data(1), false)};


for i = 2:length(t_data)
    act_gap = t_data(i) - t_data(i-1);
    if act_gap > tgap
        gap_index(n:n+1) = [i-1; i];
        tab(n:n+1) = [t_data(i-1); t_data(i)];
        tab_date(n:n+1) = {epoch2date(t_data(i-1), false), epoch2date(t_data(i), false)};
        n=n+2;
    end    
end

gap_index(n) = length(t_data);
tab(n) = t_data(end);
tab_date(n) = {epoch2date(t_data(end), false)};
if n>50
    fprintf('Error: size of gap_index, tab and tab_date too small. wrong data.');
end
gap_index = gap_index(1:n);
tab = tab(1:n);
tab_date = tab_date(1:n);

clear act_gap cln data t_data i;
fprintf('Done. (find_pauses)\n');
end

