DROP SCHEME IF EXISTS bikeTO CASCADE;
CREATE SCHEMA bikeTO;
SET SEARCH_PATH to bikeTO;


DROP DOMAIN IF EXISTS spottype CASCADE;
CREATE DOMAIN spottype AS TEXT
DEFAULT 'Unknown'
CHECK (VALUE IN ('Bike Rack', 'Angled Bike Rack', 'Bike Corral',
'Bike Shelter', 'Rack', 'Ring', 'Art Stand', 'Other', 'Shelter'));

--information about streets in toronto

--intersections with redlight cameras	
DROP TABLE IF EXISTS intersection CASCADE;	
CREATE TABLE intersection(
 stName1 TEXT not null references Streets(stName),
 stName2 TEXT not null references Streets(stName),
 trafficCountAvg INTEGER not null
 PRIMARY KEY(stName1, stName2));

-- information about bikeshops in toronto
DROP TABLE IF EXISTS bikeshops CASCADE;
CREATE TABLE bikeShops (
stName TEXT not null references Streets(stName),
stNumber INTEGER not null,
hasRental BOOLEAN not null,
PRIMARY KEY ( stName, stNumber));

--information about subwaystations in toronto
DROP TABLE IF EXISTS subwayStations CASCADE;
CREATE TABLE subwayStations(
	stationName TEXT not null,
	stName TEXT not null REFERENCES Streets(stNAme),
	stNumber INTEGER not null,
	hasRepairStand BOOLEAN not null,
	hasBikeStation BOOLEAN not null check( sum(hasBikeStation::INTEGER) <= (select count(*) FROM bikeStation)),
	PRIMARY KEY (stationName)
);

--information about bikeTO, bike share, stations in toronto
DROP TABLE IF EXISTS bikeStation CASCADE;
CREATE TABLE bikeStation (
	id INTEGER not null,
	checkinAvg FLOAT not null,
	checkoutAvg FLOAT not null,
	PRIMARY KEY (id));


--information about different bike parking spots in toronto. 
DROP TABLE IF EXISTS ParkingSpots CASCADE;
CREATE TABLE ParkingSpots(
	ID INTEGER not null,
	stNumber INTEGER not null,
	stName TEXT not null references Streets(stName),
	spotType spottype not null,
	capacity INTEGER not null,
	PRIMARY KEY (ID));
	
DROP TABLE IF EXISTS streets CASCADE;
CREATE TABLE streets (
	stName TEXT not null,
	trafficCountAvg FLOAT not null,
	trafficlighcount INTEGER not null,
	bikeStationCount INTEGER not null,
	subwayStationCount INTEGER not null,
	bikeShopCount INTEGER not null,
	check bikeStationCount <= (select count(*) from bikeStation),
	check subwayStationCount <= (select count(*) from subwayStations),
	check bikeShopCount <= (select count(*) from bikeshops)
	PRIMARY KEY(stNAME))
	
	

 
 

\COPY bikeshops FROM 'bike_shop.csv' with csv header

\COPY parkingSpots FROM 'parking.csv' with csv header

--\COPY redLightCamera FROM 'red lights camera.csv' with csv header