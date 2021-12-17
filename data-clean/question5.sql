--q 5 any intersections that don't have bike stations on either streets

CREATE view stations-st1 AS(
SELECT stName, bikestationcount as countst1
from streets, intersection
WHERE intersection.stName1 = streets.stName
AND bikestationcount > 0);

CREATE view stations-st2 AS(
SELECT stName, bikestationcount as countst2
from streets, intersection
WHERE intersection.stName2 = streets.stName
AND bikestationcount > 0);

CReate view nostations AS(
SELECT stName1, stName2, trafficCountAvg
FROM intersection, stations-st2, stations-st1
WHERE stations-st1.stName = stName1 AND
stations-st2.stName = stName2);

--q6 is the traffic count avg higher for these intersections
create view havestations As(
(SELECT *
FROM intersection)
MINUS
(SELECT *
FROM  nostations));

(SELECT AVG(trafficCountAvg), 'havestations'
from havestations)
UNION
(SELECT AVG(trafficCountAvg), 'Nostations'
from nostations);