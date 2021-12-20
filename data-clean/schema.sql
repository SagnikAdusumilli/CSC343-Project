-- we removed the relatio of bikestations. The reason we removed it
-- is because the nature of the data which we collected makes it 
-- difficult to interact with the other relations in our schema

DROP SCHEMA IF EXISTS bikeTO CASCADE;
CREATE SCHEMA bikeTO;
SET SEARCH_PATH to bikeTO;


DROP DOMAIN IF EXISTS spottype CASCADE;
CREATE DOMAIN spottype AS TEXT
DEFAULT 'Unknown'
CHECK (VALUE IN ('Bike Rack', 'Angled Bike Rack', 'Bike Corral',
'Bike Shelter', 'Rack', 'Ring', 'Art Stand', 'Other', 'Shelter', 'Unknown'));

--information about streets in toronto
DROP TABLE IF EXISTS streets CASCADE;
CREATE TABLE streets (
	stName TEXT not null,
	trafficCountAvg FLOAT not null,
	trafficlightcount INTEGER not null,
	bikeStationCount INTEGER not null,
	subwayStationCount INTEGER not null,
	bikeShopCount INTEGER not null,
	--check bikeStationCount <= (select count(*) from bikeStation),
	--check subwayStationCount <= (select count(*) from subwayStations),
	--check bikeShopCount <= (select count(*) from bikeshops)
	PRIMARY KEY(stNAME));

--intersections with redlight cameras	
DROP TABLE IF EXISTS intersection CASCADE;	
CREATE TABLE intersection(
 stName1 TEXT not null references Streets(stName),
 stName2 TEXT not null references Streets(stName),
 trafficCountAvg FLOAT not null,
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
	totalUsage INTEGER not null,
	hasBikeStation BOOLEAN not null,
	hasRepairStand BOOLEAN not null,
 --hasBikeStation BOOLEAN not null check( sum(hasBikeStation::INTEGER) <= (select count(*) FROM bikeStation)),
	PRIMARY KEY (stationName)
);


--information about different bike parking spots in toronto. 
DROP TABLE IF EXISTS ParkingSpots CASCADE;
CREATE TABLE ParkingSpots(
	ID INTEGER not null,
	stNumber INTEGER not null,
	stName TEXT not null references Streets(stName),
	type spottype not null,
	capacity INTEGER not null,
	PRIMARY KEY (ID));
	
	

 

\COPY streets FROM 'streets.csv' with csv header;
\COPY intersection FROM 'intersection_clean.csv' with csv header;
\COPY bikeshops FROM 'bike_shop.csv' with csv header;
\COPY subwayStations FROM 'ttc_data_clean.csv' with csv header;
\COPY bikeStation FROM 'bike_station_data.csv' with csv header;
\COPY parkingSpots FROM 'parking.csv' with csv header;

--\COPY redLightCamera FROM 'red lights camera.csv' with csv header