CREATE DOMAIN spottype AS TEXT
DEFAULT NULL
CHECK (VALUE IN ('Bike Rack', 'Angled Bike Rack', 'Bike Corral',
'Bike Shelter', 'Rack', 'Ring', 'Art Stand', 'Other'));


CREATE TABLE bikeShop (
stName TEXT not null,
stNumber INTEGER not null,
hasRental BOOLEAN not null,
PRIMARY KEY ( stName, stNumber));


CREATE TABLE ParkingSpots(
	ID INTEGER not null,
	stName TEXT not null,
	stNumber INTEGER not null,
	capacity INTEGER not null,
	spotType spottype,
	PRIMARY KEY (ID));
	
CREATE TABLE redLightCamera(
 stName1 TEXT not null,
 stName2 TEXT not null,
 PRIMARY KEY(stName1, stName2));
 
COPY bikeshope(stName, stNumber, hasRental)
FROM 'dbsrv1:~/semester long project/CSC343-Project/data-clean/bike_shope.csv'
DELIMITER ','
CSV HEADER;

COPY parkingSpots(ID, stName, stNumber, capacity, spotType)
FROM 'dbsrv1:~/semester long project/CSC343-Project/data-clean/parking.csv'
DELIMITER ','
CSV HEADER;

COPY redLightCamera(stName1, stName2)
FROM 'dbsrv1:~/semester long project/CSC343-Project/data-clean/red lights camera.csv'
DELIMITER ','
CSV HEADER;