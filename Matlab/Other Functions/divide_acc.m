function [linacc, mgn, acc] = divide_acc(acc)
%DIVIDE_ACC divides 'acc' in its accelerometer and magnetic sensor parts
%   ALWAYS CHECK LOGFILE IF ASSUMED ORDER OF SENSORS IS CORRECT!!

%% divide acc in accelerometer and magnetic field data
if (size(acc,2) == 5)
    mgn = [];
    acc = [acc(:,1:2) ones(size(acc,1),1) acc(:,3:5)];
elseif (size(acc,2) ==6)
    mgn = acc;
    linacc = acc;
    linacc(any(linacc(:,3)==2, 2),:)=[]; %delete all rows containing a '2' in the 3rd col.
    mgn(any(mgn(:,3)==10, 2),:)=[]; %delete all rows containing a '1' in the 3rd col.
else
    fprintf('Error: Wrong number of columns in "acc"');
end
fprintf('Done. (divide_acc)\n');

end