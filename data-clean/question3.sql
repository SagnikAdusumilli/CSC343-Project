--QUESTION 3

DROP VIEW IF EXISTS trcount CASCADE;
CREATE VIEW trcount AS(
SELECT stNAME, trafficlightcount, rank() OVER (PARTITION BY stNAME ORDER BY trafficlightcount) 
from streets);

DROP VIEW IF EXISTS Bstationcount CASCADE;
CREATE VIEW Bstationcount AS(
SELECT stNAME, bikestationcount, rank() OVER (PARTITION BY stNAME ORDER BY BikeStationCount DESC)
from streets);

DROP VIEW IF EXISTS Bshopcount CASCADE;
CREATE VIEW Bshopcount AS(
SELECT stNAME, bikestationcount, rank() OVER (PARTITION BY stNAME ORDER BY BikeShopcount DESC)
from streets);

DROP VIEW IF EXISTS spotsperstreet CASCADE;
CREATE VIEW spotsperstreet AS (
SELECT count(*) as numspots, stNAME
FROM ParkingSPOTS
GROUP BY stName);

DROP VIEW IF EXISTS spotscount CASCADE;
CREATE VIEW spotscount AS(
SELECT streets.stNAME, numspots, rank() OVER (PARTITION BY streets.stNAME ORDER BY numspots DESC)
from streets, spotsperstreet
WHERE streets.stName = spotsperstreet.stName);


SELECT trcount.stName, AVG(trcount.rank + Bstationcount.rank + Bshopcount.rank + spotscount.rank) as avgscore
FROM trcount, Bstationcount, bshopcount, spotscount
WHERE trcount.stNAME = Bstationcount.stName AND
Bstationcount.stName = Bshopcount.stName AND
Bshopcount.stName = spotscount.stName
GROUP BY trcount.stNAME
ORDER BY avgscore DESC;
