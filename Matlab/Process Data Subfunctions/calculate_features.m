function [ fvector ] = calculate_features( attributes, segmentsize, name, date, i_start, i_stop, max_accu )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% disp('   Load data...');
clear acc provider gps;
file_loc = strcat('D:\Documents\Studienarbeit_PC\App-Aufnahmen\', name, '\locprovider_', date, '.m');
file_acc = strcat('D:\Documents\Studienarbeit_PC\App-Aufnahmen\', name, '\accelerometer_', date, '.m');
run(file_loc); run(file_acc); % ergibt "acc" und "provider"

% disp('   Calculate and save GPS speed...');
if exist('provider', 'var') ~= 0 && size(provider,1) > 1
    gps = provider; % net = provider;
    gps(any(gps(:,2)~=3, 2),:)=[]; % net(any(net(:,2)==3, 2),:)=[];
    gps(any(gps(:,4)> max_accu, 2),:)=[];
    
    if ~isnan(i_stop)
        gps = gps(i_start:i_stop,:);
    end
    %Lösche alle Zeilen, in den Koordinaten gleich NaN sind
    gps(any(isnan(gps(:,5)),2),:)=[];
    % Sortiere nach Zeit wg evtl. Fehler
    gps = sortrows(gps);
    
    % Lösche Zeilen mit gleichem Timestamp
    samegps = find(diff(gps(:,1))==0);
    gps(samegps,:)=[]; %#ok
    clear provider samegps i_stop file_acc file_loc;
    if size(gps,1) > 1
        %% Col1: Erzeuge Feature Vektor Variable mit GPS Startzeit
        % (vorherige und spätere acc-Daten werden ignoriert !!!)
        col = 1;% Initialisiere Spaltennummer
        % rounded total number of seconds, letztes Teilsegement wird ignoriert
        NoOfSegments = floor((gps(end,1) - gps(1,1)) / segmentsize);
        fvector = zeros(NoOfSegments,size(attributes,2)+2); % +2 für Lat. und Longitude
        fvector(1,col) = gps(1,1); % Startzeit
        for i = 2:NoOfSegments
            fvector(i,col) = fvector(1,col) + (i-1)*segmentsize; % erste Spalte: Zeit in ms in 1s-Schritten
        end
        
        %% Col15 und Col16 für Latitude und Longitude
        m = 0;
        for i = 1:NoOfSegments
            cnt = 0; lat = 0; lng = 0;
            if (m+1) > size(gps,1); break; end
            while gps(m+1,1) < (fvector(i,1)+segmentsize) % VORSICHT bei unregelmäßigen Segementgrößen, besser fvector(i+1,1) (vorsicht bei letzter Zeile!)
                m = m+1;
                lat = lat + gps(m,5);
                lng = lng + gps(m,6);
                cnt = cnt+1;
                if (m+1) > size(gps,1); break; end
            end
            
            if cnt ~= 0
                fvector(i,15) =  lng / cnt;
                fvector(i,16) =  lat / cnt;
            else
                fvector(i,15) = -1;
                fvector(i,16) = -1;
            end
        end
        
        %% Col2: Übertrage GPS Speed und schreibe NaN, falls keine Daten vorhanden sind
        %  Col3: Berechne Speed aus vorherigem und nachfolgenden Wert, d.h. v = s/t
        col = 2; % 2. Spalte für GPS Speed
        
        % verdopple  letzte Zeile von GPS für leichtere Berechnung
        gps = [gps; gps(end,:)];
        gps(end,1) = gps(end,1) + 2*segmentsize; % Stoppt while-Schleife bevor Matrixindices überschritten werden
        
        m = 1; %Index in GPS Variable (dh. gps(m,1) >= fvector(i,1))
        for i = 1:NoOfSegments
            % Berechne Geschwindigkeit, m ist erster Wert dieses Segements
                      
            if m==1
                loc1 = [gps(m,5) gps(m,6)];
                time1 = gps(m,1)-1*segmentsize; % Verhindert, dass durch 0 geteilt wird
            else
                loc1 = [gps(m-1,5) gps(m-1,6)];
                time1 = gps(m-1,1);
            end
            
            cnt = 0; speed = 0;
            while gps(m,1) < (fvector(i,1)+segmentsize) % VORSICHT bei unregelmäßigen Segementgrößen, besser fvector(i+1,1) (vorsicht bei letzter Zeile!)
                speed = speed + gps(m,8); m = m+1; cnt = cnt+1;
            end
            
            if cnt ~= 0
                fvector(i,col) =  speed / cnt;
            else
                fvector(i,col) = -1;
            end
            
            % Berechne Geschwindigkeit, m ist erster Wert des nächsten Segements
            loc2 = [gps(m,5) gps(m,6)];
            dist = haversine(loc1, loc2);
            time = gps(m,1) - time1;
            fvector(i,col+1) = dist*3600000 / time; %km/ms *1000*60*60 = km / h
        end
        
        clear dist time loc1 loc2 cnt speed time1;
        
        %     disp('   Calculate accelerometer features...');
        if exist('acc', 'var') ~= 0 && size(acc,1) > 1 %#ok<NODEF> acc wird durch run(file_acc) erzeugt
            % identify acceleration and orientations sensor data and save in seperate variables
            % orient = acc; orient(any(orient(:,3)~=3, 2),:)=[]; % 3 ist orientation sensor
            acc(any(acc(:,3)~=1, 2),:)=[];      % 1 ist acceleration sensor
            % Sortiere nach Zeit wg evtl. Fehler
            acc = sortrows(acc);
            % Lösche alle Daten außerhalb des untersuchten Zeitfensters inkl. Puffer
            acc(any(acc(:,1) < fvector(1,1), 2),:)=[];
            acc(any(acc(:,1) > (fvector(end,1) + 2*segmentsize), 2),:)=[];
            % Lösche Zeilen mit gleichem Timestamp
            sameacc = find(diff(acc(:,1))==0);
            acc(sameacc,:)=[]; %#ok
            
            if size(acc,1) < 1
                error('No acc data!');
            else
                % Bilde Betrag der Achsen in 2. Spalte von acc
                abs_value = sqrt(acc(:,4).^2 + acc(:,5).^2 + acc(:,6).^2);
                
                %         % Running Average Filter, Windowsize 3
                %         windowSize = 3;
                %         avg_value = filter(ones(1,windowSize)/windowSize,1,abs_value);
                %         % interpolierten Wert nochmal averagen oder andersrum?
                
                %% Setze alle Pausen von mehr als 10 Segmenten gleich 0
                m = 0; %Index in acc Variable (dh. acc(m,1) >= fvector(i,1))
                for i = 1:NoOfSegments
                    first = m; %erstes Element dieses Segments
                    while acc(m+1,1) < (fvector(i,1)+segmentsize) % VORSICHT bei unregelmäßigen Segementgrößen, besser fvector(i+1,1) (vorsicht bei letzter Zeile!)
                        m = m+1;
                        if (m+1) > size(acc,1)
                            break
                        end
                    end
                    fin = m; %letztes Element dieses Segments
                    if fin == first
                        % Für dieses Intervall gibt es keine Beschleunigsdaten:
                        % Lösche Intervall
                        fvector(i,1) = 0;
                        %                     disp('Segment ohne Inhalt gelöscht!');
                    end
                    if (m+1) > size(acc,1)
                        break
                    end
                end
                
                %             for i = size(fvector,1):size(fvector,1)-9
                %                 if fvector(i,1) == 0
                %                     fvector(i+1:end,1) = 0;
                %                 end
                %             end
                %             for i = size(fvector,1)-10:1
                %                 if fvector(i,1) == 0
                %                     fvector(i+1:i+9,1) = 0;
                %                 end
                %             end
                
                
                
                % Interpoliere AccBetrag und taste gleichmäßig ab, da Datenrate unregelmäßig
                x = acc(:,1); %Zeitachse
                y = abs_value; % Originaldaten
                int_time = (acc(1,1):20:acc(end,1))'; % Neue Abtastrate
                int_value = interp1(x,y,int_time); % Regelmäßig abgetastete Daten mit 50Hz
                %         plot(x,y,'o',xi,yi)
                
                %% Beschleunigungssensordaten (Col 4 und folgende)
                col = 4; % 4.Spalte mit arithmetischem Mittel der Einzelachsen
                
                updaterate = zeros(NoOfSegments,1);
                m = 1; %Index in acc Variable (dh. acc(m,1) >= fvector(i,1))
                for i = 1:NoOfSegments
                    
                    first = m; %erstes Element dieses Segments
                    while int_time(m,1) < (fvector(i,1)+segmentsize) % VORSICHT bei unregelmäßigen Segementgrößen, besser fvector(i+1,1) (vorsicht bei letzter Zeile!)
                        m = m+1;
                    end
                    fin = m-1; %letztes Element dieses Segments
                    if fin < first
                        % Für dieses Intervall gibt es keine Beschleunigsdaten:
                        % Lösche Intervall
                        fvector(i,1) = 0;
                        %                 fprintf('Mindestgröße: %i\n', acc(first,1)-acc(fin,1));
                        %                     disp('Segment ohne Inhalt gelöscht!');
                    else
                        if fvector(i,1) ~= 0
                            siz = fin - first + 1; % Anzahl Elemente in diesem Segment
                            
                            updaterate(i) = (1000*siz)/segmentsize;
                            
                            % 4: Mittelwert aus Betrag (absvalue)SINGAL MAGNITUDE AREA
                            fvector(i,col) = mean(int_value(first:fin));
                            
                            % 5: Varianz aus Betrag
                            fvector(i,col+1) = var(int_value(first:fin));
                            
                            % 6: Peak Finder
                            % Mit max, dann linken und rechten nachbarn auf 0 setzen, nächster Durchlauf
                            values = int_value(first:fin);
                            [maxi1,ind1] = max(values);
                            values(ind1) = 0;
                            [maxi2,ind2] = max(values);
                            values(ind2) = 0;
                            [maxi3] = max(values);
                            fvector(i,col+2) = (maxi1+maxi2+maxi3)/3;
                            
                            % 7: FFT
                            N = 2^(ceil(log2(siz))); %nächsthöhere 2er Potenz für die FFT
                            spectrum = 2/N * abs(fft(int_value(first:fin)));
                            p = spectrum(1:N/2).^2; %% take the power of positve freq. half
                            freq = ((0:N/2-1)/segmentsize*1000)';
                            
                            p5 = find(freq > 5);
                            if isempty(p5)
                                p5 = size(p,1);
                            end
                            fvector(i,col+3) = mean(p(1:p5(1))); % Summe der quadrierten FT-Koeffizienten
                            fvector(i,col+7) = mean(p(find(freq > 0.5 & freq < 1.5 ))); %#ok
                            fvector(i,col+8) = mean(p(find(freq > 1.5 & freq < 2.5 ))); %#ok
                            fvector(i,col+9) = mean(p(find(freq > 2.5 & freq < 3.5 ))); %#ok
                            fvector(i,col+10) = mean(p(find(freq > 3.5 & freq < 4.5 ))); %#ok
                            
                            % 8 - 10: AR coefficients:
                            coeff = arburg(int_value(first:fin), 3);
                            if isnan(coeff)
                                coeff = [0 0 0 0];
                            end
                            fvector(i,col+4) = coeff(1);
                            fvector(i,col+5) = coeff(2);
                            fvector(i,col+6) = coeff(3);
                        end
                    end
                    
                    %         figure(10) % Feature Plot
                    %         plot(fvector(:,2), 'bx'); hold on; plot(fvector(:,3), 'rx'); hold on; plot(fvector(:,4), 'm-'); hold on; plot(fvector(:,5), 'c*'); hold on;
                    %         plot(fvector(:,6), 'm--'); hold on; plot(fvector(:,7), 'mo'); hold on; plot(fvector(:,8), 'k.'); hold on; plot(fvector(:,9), 'b.'); hold on;
                    %         plot(fvector(:,10), 'g.'); hold on; plot(fvector(:,11), 'b^'); hold on; plot(fvector(:,12), 'g^'); hold on; plot(fvector(:,13), 'r^'); hold on;
                    %         plot(fvector(:,14), 'c^');
                    %         legend('provider speed', 'calculated speed', 'mean', 'variance','peaks', 'spectral energy', 'AR coefficient 1', 'AR coefficient 2',...
                    %             'AR coefficient 3', 'FFT coeff 1Hz', 'FFT coeff 2Hz', 'FFT coeff 3Hz', 'FFT coeff 4Hz');
                    
                    %         totalupdaterate = mean(updaterate);
                    %         minrate = min(updaterate);
                    %         maxrate = max(updaterate);
                    %         fprintf('      Abtastrate: %.1fHz, Min.: %.1fHz, Max.: %.1fHz\n', totalupdaterate, minrate, maxrate);
                end
                %         fvector(find(fvector(:,1)==0),:) = [];
            end
        else disp('No sensor data available.'); fvector = [];
        end
    else disp('No gps data available.'); fvector = [];
    end
else disp('No GPS data available.'); fvector = [];
end
end

