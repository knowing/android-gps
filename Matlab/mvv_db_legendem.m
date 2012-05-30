% LEGENDE für mvv_db

% Spalten:
% Latitude   Longitude   'Name Haltestelle'   Liniennummern in Vektor

U1 1        S1 101      Metrobus50 50
bis         bis         bis
U7 7        S27 127     Metrobus60 60        

Tram12 12
Tram15 15 
Tram16 16
Tram17 17
Tram18 18
Tram20 20
Tram21 21
Tram23 23
Tram25 25
Tram27 27

% Der Abstand zwischen zwei Breitengraden/Latitude ist immer gleich und entspricht 111,32 km.
% Longitude bei 40° Breite:	85,28 km und bei 50° Breite: 71,55 km 	

load('mvv_db.mat')
save('mvv_db.mat', 'mvv_db')
