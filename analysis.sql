/*
Analysis
*/
------------------Mean -----------------
SELECT rail_events.station, AVG(rail_reliability.otp_value) as mean_reliability
FROM rail_events 
LEFT JOIN rail_reliability 
ON rail_events.line = rail_reliability.gtfs_route_id
GROUP BY rail_events.station;

SELECT bus_events.STOP_ID, AVG(bus_reliability.otp_value) as mean_reliability
FROM bus_events 
LEFT JOIN bus_reliability 
ON bus_events.MBTA_ROUTE = bus_reliability.gtfs_route_id
GROUP BY bus_events.STOP_ID;

--- Stops per income level

SELECT  demographics.b19049_001, count(*) AS n_stops
FROM grid, kioskdhd3
WHERE st_contains(grid.geom,kioskdhd3.geom)
GROUP BY grid.gid;

-- n rail stops per income level
SELECT demographics.b19049_001, count(rail_points.geom) AS n_stations -- median HH income data 
FROM demographics
LEFT JOIN rail_points ON st_contains(demographics.geom,rail_points.geom)
GROUP BY demographics.gid
ORDER BY n_stations DESC;

-- n rail stops per population level
SELECT demographics_population.total_popu, count(rail_points.geom) AS n_stations -- median HH income data 
FROM demographics_population
LEFT JOIN rail_points ON st_contains(demographics_population.geom,rail_points.geom)
GROUP BY demographics_population.gid
ORDER BY n_stations DESC;