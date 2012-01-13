%% Linear acceleration aus Variabel acc erhalten, falls auch mgn active war
[linacc, mgn] = divide_acc(acc);

%% Finde und schreibe zeitliche Lücken von mehr als 0,5s auf
% fprintf('\n\nFirst element: 7500\n');
% for i=7500:size(linacc,1)
%    if linacc(i,2) - linacc(i-1,2) >0.5
%        fprintf('%i: %.3f \t\t %i: %.3f \n', i-1, linacc(i-1,1), i, linacc(i,1));
%    end
% end
% fprintf('Last element: %i\n\n', size(linacc,1));

%% Füge 7.Spalte mit Betrag der Linearen Acceleration ein
linacc(:,7) = ones(size(linacc,1),1);
for i=7500:size(linacc,1)
   linacc(i,7) = abs(linacc(i,4) + linacc(i,5) + linacc(i,6));
end

%% Plotte den Betrag
% hold on; grid on; i=7500:15366; plot(i, linacc(7500:15366,7), 'm');

%% Ersatze alle Werte, deren Betrag unter 0,15g liegt, mit 0
i=7500;counter=0;
while i < size(linacc,1)+1
   if linacc(i,7) < 0.15
       linacc(i,4:7)=zeros(1,4);
       counter=counter+1;
   end
   i=i+1;
end

fin = size(linacc,1); % variabel für anzahl von elementen in linacc

%% Laufenden Mittelwert aus 11 Werten des Betrags berechnen und zeichnen
% WICHTIG: Falls vorher niedrige Werte durch 0 ersetzt werden, ist der
% Gesamtwert hier niedriger.
med=zeros(fin,1);
for i=7510:fin-10
   med(i)= (linacc(i-5,7) + linacc(i-4,7) + linacc(i-3,7) + linacc(i-2,7) + linacc(i-1,7) + linacc(i,7) + linacc(i+1,7) + linacc(i+2,7) + linacc(i+3,7) + linacc(i+4,7) + linacc(i+5,7)) / 11;
end
hold on; grid on; plot(linacc(7500:fin,2),med(7500:fin),'m');

%% Plotte die x, y und z-Werte
% hold on; grid on;
% plot(linacc(7500:fin,2), linacc(7500:fin,4), '.r', linacc(7500:fin,2), linacc(7500:fin,5), '.b',linacc(7500:fin,2), linacc(7500:fin,6), '.g');
