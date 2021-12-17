--q 5 which intersections that don't have bike stations on either streets
DROP VIEW IF EXISTS stationsst1 CASCADE;
CREATE view stationsst1 AS(
SELECT stName, bikestationcount as countst1
from streets, intersection
WHERE intersection.stName1 = streets.stName
AND bikestationcount > 0);

DROP VIEW IF EXISTS stationsst2 CASCADE;
CREATE view stationsst2 AS(
SELECT stName, bikestationcount as countst2
from streets, intersection
WHERE intersection.stName2 = streets.stName
AND bikestationcount > 0);
;
DROP VIEW IF EXISTS nostations CASCADE;
CReate view nostations AS(
SELECT stName1, stName2, trafficCountAvg
FROM intersection, stationsst2, stationsst1
WHERE stationsst1.stName = stName1 AND
stationsst2.stName = stName2);

SELECT distinct(stName1, stName2)
FROM nostations;

SELECT count( distinct(stName1, stName2))
FROM nostations;

--q6 is the traffic count avg higher for these intersections
DROP VIEW IF EXISTS havestations CASCADE;
create view havestations As(
(SELECT *
FROM intersection)
EXCEPT
(SELECT *
FROM  nostations));

(SELECT AVG(trafficCountAvg), 'havestations'
from havestations)
UNION
(SELECT AVG(trafficCountAvg), 'Nostations'
from nostations);