DROP DOMAIN IF EXISTS spottype CASCADE;
CREATE DOMAIN spottype AS TEXT
DEFAULT NULL
CHECK (VALUE IN ('Bike Rack', 'Angled Bike Rack', 'Bike Corral',
'Bike Shelter', 'Rack', 'Ring', 'Art Stand', 'Other', 'Shelter'));

DROP TABLE IF EXISTS bikeshop CASCADE;
CREATE TABLE bikeShop (
stName TEXT not null references Streets(stName),
stNumber INTEGER not null,
hasRental BOOLEAN not null,
PRIMARY KEY ( stName, stNumber));

DROP TABLE IF EXISTS ParkingSpots CASCADE;
CREATE TABLE ParkingSpots(
	ID INTEGER not null,
	stNumber INTEGER not null,
	stName TEXT not null references Streets(stName),
	spotType spottype,
	capacity INTEGER not null,
	PRIMARY KEY (ID));
	
	
DROP TABLE IF EXISTS redLightCamera CASCADE;	
CREATE TABLE redLightCamera(
 stName1 TEXT not null references Streets(stName),
 stName2 TEXT not null references Streets(stName),
 PRIMARY KEY(stName1, stName2));

\COPY bikeshop FROM 'bike_shop.csv' with csv header

\COPY parkingSpots FROM 'parking.csv' with csv header

\COPY redLightCamera FROM 'red lights camera.csv' with csv header