-- Question 4

SELECT avg(totalUsage) as avgusage, hasBikestation
FROM subwaystations
GROUP BY hasBikestation
ORDER BY avgusage DESC;

SELECT avg(totalUsage) as avgusage, hasRepairStand
FROM subwaystations
GROUP BY hasRepairStand
ORDER BY avgusage DESC;