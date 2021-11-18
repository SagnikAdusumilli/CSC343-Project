DROP DOMAIN IF EXISTS spottype CASCADE;
CREATE DOMAIN spottype AS TEXT
DEFAULT NULL
CHECK (VALUE IN ('Bike Rack', 'Angled Bike Rack', 'Bike Corral',
'Bike Shelter', 'Rack', 'Ring', 'Art Stand', 'Other'));

DROP TABLE IF EXISTS bikeshop CASCADE;
CREATE TABLE bikeShop (
stName TEXT not null,
stNumber INTEGER not null,
hasRental BOOLEAN not null,
PRIMARY KEY ( stName, stNumber));

DROP TABLE IF EXISTS ParkingSpots CASCADE;
CREATE TABLE ParkingSpots(
	ID INTEGER not null,
	stNumber INTEGER not null,
	stName TEXT not null,
	spotType spottype,
	capacity INTEGER not null,
	PRIMARY KEY (ID));
	
	
DROP TABLE IF EXISTS redLightCamera CASCADE;	
CREATE TABLE redLightCamera(
 id INTEGER not null,
 stName1 TEXT not null,
 stName2 TEXT not null,
 PRIMARY KEY(id));

\COPY bikeshop FROM 'bike_shop.csv' with csv

\COPY parkingSpots FROM 'parking.csv' with csv

\COPY redLightCamera FROM 'red lights camera.csv' with csv