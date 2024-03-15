------Create Tables----------

CREATE TABLE mbta_subway_stops (
STOPID SERIAL PRIMARY KEY -- Need to create a primary key
STATION VARCHAR(255)
LINE_NAME VARCHAR(255) 
TERMINUS VARCHAR(255)
ROUTE VARCHAR(255)
GEOM GEOMETRY(point, 26986) -- NAD 83 Massachusetts Stateplane
);


CREATE TABLE mbta_bus_stops (
STOP_ID INT PRIMARY KEY
STOP_NAME VARCHAR(255)
GEOM GEOMETRY(point, 26986)
);
-- To attribute but stops to the bus routes, we must join an additional table 
CREATE TABLE mbta_busstop_events (
EVENT_ID SERIAL PRIMARY KEY --
STOP_ID INT	-- Foreign key
MBTA_ROUTE INT -- I'm not sure wich route ID will be correct to join to the metrics data
CTPS_ROUTE INT -- 
FOREIGN KEY (STOP_ID) REFERENCES mbta_bus_stops(STOP_ID)
);

--Reliability Metrics


CREATE TABLE bus_rail_metrics (
METRIC_ID SERIAL PRIMARY KEY
service_date DATE 
gtfs_route_id VARCHAR(255)  
gtfs_route_name VARCHAR(255)
mode_type VARCHAR(255) -- Includes 'Rail' and 'Bus'
metric_type VARCHAR(255) -- Includes 'passenger wait time' for rail and 'headway/schedule' for bus
otp_numerator NUMERIC -- The numerator and denominator for the given metric 
otp_denominator NUMERIC
metric_value NUMERIC -- To be created by deviding numerator by denominator bounded between 0 and 1.
-- For 'passenger wait time' the value is the percent of customers who wait less than the scheduled time between trains
--
);



