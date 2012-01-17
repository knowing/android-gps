function [ route_table ] = route_finder( pause_table )
%ROUTE_FINDER analyses pause_table to find the TWO (?) routes that were
%traced most often
%   Detailed explanation goes here

%% Create route_table containing only points of "rest"
route_table = pause_table; i=2;
while i<=size(route_table,1) 
   if strcmp(route_table{i,14},'rest') == 0
       route_table(i,:) = [];
   else
       i=i+1;
   end
end

%% Save order of visited routes and show most typical???
for i = 2:size(route_table,1)
    %abfolge der orte speichern
end

end

