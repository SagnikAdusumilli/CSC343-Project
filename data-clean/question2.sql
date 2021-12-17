--Question 2
--count number of parking spots on a streat
DROP VIEW IF EXISTS spotsperstreet CASCADE;
CREATE VIEW spotsperstreet AS (
SELECT count(*) as numspots, stNAME
FROM ParkingSpots
GROUPBY stName);


-- spots and traffic light on each street 
DROP VIEW IF EXISTS spots-TL CASCADE;
CREATE VIEW  spots-TL AS(
SELECT trafficlightcount, numspots, streets.stName
FROM spotsperstreet, streets
WHERE spotsperstreet.stNAME = streets.stName);

-- also share spots
DROP VIEW IF EXISTS share-spots-tl CASCADE;
CREATE VIEW share-spots-tl AS(
SELECT spots-TL.trafficlightcount, numspots, streets.stName,
 bikeStationcount
FROM streets, spots-TL
WHERE spots-TL.stName = streets.stName);

\COPY (SELECT * FROM spots-TL) TO 'spots_tl.csv' DELIMITER ',' CSV HEADER;

\COPY (SELECT * FROM share-spots-TL) TO 'share-spots-tl.csv' DELIMITER ',' CSV HEADER;

-- regression analysis in R

-- do streets with a higher count of a certain type of parking spot have lower traffic
create VIEW stnameSpottype AS(
SELECT stName, type as spotType, county(type) as typecount
FROM ParkingSpots
GROUP BY stName, spotType)

create view spotypetraffic AS(
SELECT trafficCountAvg, spotType, typecount
FROM stnameSpottype, streets
WHERE streets.stName = stnameSpottype.stName);


\COPY (SELECT * FROM spottypetraffic) TO 'spottypetraffic.csv' DELIMITER ',' CSV HEADER;

-- Move over to R for analysis