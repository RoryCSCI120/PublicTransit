/*
Analysis
*/
------------------Mean reliability by tract-----------------
-- Query to be exported as csv and imported to QGIS
SELECT demographics.b19049_001 AS median_hh_inc, -- Median HH income
AVG(table2.reliability) AS reliability, -- reliability data, averaged for each polygon
st_AsText(demographics.geom) as geometry -- geometry in WKT format
FROM demographics
LEFT JOIN (SELECT rail_points.station, table1.mean_reliability as reliability, rail_points.geom as geom -- Select desired columns
		   FROM (SELECT rail_events.station, AVG(rail_reliability.otp_value) as mean_reliability -- average reliabilty per station
				 FROM rail_events -- We first must join rail events with rail reliability
				 LEFT JOIN rail_reliability 
				 ON rail_events.line = rail_reliability.gtfs_route_id -- line = route id 
				 GROUP BY rail_events.station) as table1
		   LEFT JOIN rail_points -- join to rail points to get spatial attribute
		   ON  table1.station = rail_points.station) as table2
ON st_contains(demographics.geom, table2.geom) -- where the census tract contains the station points
GROUP BY demographics.gid; -- group by census tracts

-- bus reliability by income
-- Same as above, except using bus data rather than rail data, see above comments
SELECT demographics.b19049_001 AS median_hh_inc, 
AVG(table2.reliability) AS reliability, 
st_AsText(demographics.geom) as geometry
FROM demographics
LEFT JOIN (SELECT bus_points.STOP_ID, table1.mean_reliability as reliability, bus_points.geom as geom
		   FROM (SELECT bus_events.STOP_ID, AVG(bus_reliability.otp_value) as mean_reliability 
				 FROM bus_events
				 LEFT JOIN bus_reliability 
				 ON bus_events.MBTA_ROUTE = bus_reliability.gtfs_route_id
				 GROUP BY bus_events.STOP_ID) as table1
		   LEFT JOIN bus_points
		   ON  table1.STOP_ID = bus_points.STOP_ID) as table2
ON st_contains(demographics.geom, table2.geom)
GROUP BY demographics.gid;

-- rail reliability by population
--- same as above, except using population and not exporting geometry
SELECT population_tracts.total_popu AS population, -- populaiton
AVG(table2.reliability) AS reliability -- reliability data, averaged for each polygon
FROM population_tracts
LEFT JOIN (SELECT rail_points.station, table1.mean_reliability as reliability, rail_points.geom as geom -- Select desired columns
		   FROM (SELECT rail_events.station, AVG(rail_reliability.otp_value) as mean_reliability -- average reliabilty per station
				 FROM rail_events -- We first must join rail events with rail reliability
				 LEFT JOIN rail_reliability 
				 ON rail_events.line = rail_reliability.gtfs_route_id -- line = route id 
				 GROUP BY rail_events.station) as table1
		   LEFT JOIN rail_points -- join to rail points to get spatial attribute
		   ON  table1.station = rail_points.station) as table2
ON st_contains(population_tracts.geom, table2.geom) -- where the census tract contains the station points
GROUP BY population_tracts.gid; -- group by census tracts

-- bus reliability by population
SELECT population_tracts.total_popu AS population, 
AVG(table2.reliability) AS reliability
FROM population_tracts
LEFT JOIN (SELECT bus_points.STOP_ID, table1.mean_reliability as reliability, bus_points.geom as geom
		   FROM (SELECT bus_events.STOP_ID, AVG(bus_reliability.otp_value) as mean_reliability 
				 FROM bus_events
				 LEFT JOIN bus_reliability 
				 ON bus_events.MBTA_ROUTE = bus_reliability.gtfs_route_id
				 GROUP BY bus_events.STOP_ID) as table1
		   LEFT JOIN bus_points
		   ON  table1.STOP_ID = bus_points.STOP_ID) as table2
ON st_contains(population_tracts.geom, table2.geom)
GROUP BY population_tracts.gid;
------------------N stops per data level-----------------

-- RAIL STOPS
-- n rail stops per income level
SELECT demographics.b19049_001 AS median_hh_inc, count(rail_points.geom) AS n_stations -- median HH income data, count n stations
FROM demographics
LEFT JOIN rail_points ON st_contains(demographics.geom,rail_points.geom) -- 
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
SELECT demographics.b19049_001 AS median_hh_inc, count(bus_points.geom) AS n_stops -- median HH income data 
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