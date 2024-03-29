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

-- RAIL STOPS
-- n rail stops per income level
SELECT demographics.b19049_001, count(rail_points.geom) AS n_stations -- median HH income data 
FROM demographics
LEFT JOIN rail_points ON st_contains(demographics.geom,rail_points.geom)
GROUP BY demographics.gid
ORDER BY n_stations DESC;

-- n rail stops per population level
SELECT population_tracts.total_popu, count(rail_points.geom) AS n_stations  
FROM population_tracts
LEFT JOIN rail_points ON st_contains(population_tracts.geom,rail_points.geom)
GROUP BY population_tracts.gid
ORDER BY n_stations DESC;


-- BUS STOPS
-- n bus stops per income level
SELECT demographics.b19049_001, count(bus_points.geom) AS n_stops -- median HH income data 
FROM demographics
LEFT JOIN bus_points ON st_contains(demographics.geom,bus_points.geom)
GROUP BY demographics.gid
ORDER BY n_stops DESC;

-- n bus stops per population level
SELECT population_tracts.total_popu, count(bus_points.geom) AS n_stops  
FROM population_tracts
LEFT JOIN bus_points ON st_contains(population_tracts.geom, bus_points.geom)
GROUP BY population_tracts.gid
ORDER BY n_stops DESC;