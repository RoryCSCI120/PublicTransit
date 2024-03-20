------Create Tables----------

CREATE TABLE mbta_subway_stops (
STOPID SERIAL PRIMARY KEY -- Need to create a primary key
STATION VARCHAR(255) -- Name of station
GEOM GEOMETRY(point, 26986) -- NAD 83 Massachusetts Stateplane
);
-- events tables are needed, as some stops have more than one line that service them 
CREATE TABLE mbta_subway_events (
EVENT_ID SERIAL PRIMARY KEY --
STOPID INT	-- Foreign key
LINE VARCHAR(255) -- Line name is route ID, acts as foreign key to reliability table
FOREIGN KEY (STOPID) REFERENCES mbta_subway_stops(STOPID)
FOREIGN KEY (LINE) REFERENCES rail_reliability(gtfs_route_id)
);

-- Bus data
CREATE TABLE mbta_bus_stops (
STOP_ID INT PRIMARY KEY
STOP_NAME VARCHAR(255)
GEOM GEOMETRY(point, 26986)
);
-- events tables are needed, as some stops have more than one line that service them 
CREATE TABLE mbta_busstop_events (
EVENT_ID SERIAL PRIMARY KEY --
STOP_ID INT	-- Foreign key
MBTA_ROUTE VARCHAR(255) -- MBTA route ID, acts as foreign key to reliability table
FOREIGN KEY (STOP_ID) REFERENCES mbta_bus_stops(STOP_ID)
FOREIGN KEY (MBTA_ROUTE) REFERENCES bus_reliability(gtfs_route_id)
);

-- also need to create seperate table for silver line as it is under 'bus' in reliability data but under'rapid transit' in other data
-- Silver line routes and IDs do not match up in the database, so we will have to average reliability metrics for silver line
CREATE TABLE mbta_silver_stops (
STOP_ID INT PRIMARY KEY
STOP_NAME VARCHAR(255)
GEOM GEOMETRY(point, 26986)
);
-- events tables are needed, as some stops have more than one line that service them 
CREATE TABLE mbta_silver_events (
EVENT_ID SERIAL PRIMARY KEY
STOP_ID INT	-- Foreign key
ROUTE VARCHAR(255) -- route: 'SL1, SL2, etc.'
FOREIGN KEY (STOP_ID) REFERENCES mbta_silver_stops(STOP_ID)
FOREIGN KEY (ROUTE) REFERENCES silver_reliability(route_name)
);

--Reliability Metrics

-- Metric for bus is Headway / Schedule adherance
CREATE TABLE bus_reliability (
gtfs_route_id VARCHAR(255) PRIMARY KEY -- route ids for bus are characters (ex. '47', '57A')
otp_numerator NUMERIC -- The numerator and denominator the reliability metric 
otp_denominator NUMERIC
metric_value NUMERIC -- To be created by deviding numerator by denominaton. Value bounded between 0 and 1
);

-- Metric for rail is Passenger Wait Time
CREATE TABLE rail_reliability (
gtfs_route_id VARCHAR(255) PRIMARY KEY -- route ids for rail are characters (ex. 'Orange')
gtfs_route_name VARCHAR(255)
otp_numerator NUMERIC -- The numerator and denominator the reliability metric 
otp_denominator NUMERIC
metric_value NUMERIC -- To be created by deviding numerator by denominaton. Value bounded between 0 and 1
-- For 'passenger wait time' the value is the percent of customers who wait less than the scheduled time between trains
);
CREATE TABLE silver_reliability (
route_name VARCHAR(255) PRIMARY KEY -- route nam for silver line are characters (ex. 'SL1' 'SL2')
otp_numerator NUMERIC -- The numerator and denominator the reliability metric 
otp_denominator NUMERIC
metric_value NUMERIC -- To be created by deviding numerator by denominaton. Value bounded between 0 and 1
);



--Demographics Data: Median Household Income by Census Tract for Boston Metropolitan Area
CREATE TABLE demographics (
DEMOGRAPHICSID SERIAL PRIMARY KEY --Create a primary key
NAME VARCHAR(255) -- Census Tract
STATE VARCHAR(255)
COUNTY VARCHAR(255)
MEDIAN_INCOME NUMERIC -- Median Household Income Value
GEOM GEOMETRY(polygon, 26986) -- NAD 83 Massachusetts Stateplane
);
