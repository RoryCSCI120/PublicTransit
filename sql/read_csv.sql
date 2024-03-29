/*
Run the code in this table to read in CSV files

These commands must be run from the psql in command line.
I tried using the COPY command (wich works in PGAdmin) but I was getting errors

NOTE: you must read in the spatial data first, using the following command for example:

psql -U postgres -d database -f sql\bus_points.sql


NOTE: ALL FILE PATHS ARE RELATIVE TO THE LOCATION OF THE PUBLICTRANSIT FOLDER
IF YOU ARE NOT IN THAT FOLDER, YOU MAY NEED TO MODIFY THE FILE PATHS.
*/
-------------Create tables----------------------

-- reliability tables

CREATE TABLE bus_reliability (
gtfs_route_id VARCHAR(255) PRIMARY KEY,
otp_value NUMERIC
);

CREATE TABLE rail_reliability (
gtfs_route_id VARCHAR(255) PRIMARY KEY,
otp_value NUMERIC
);


-- events tables
CREATE TABLE bus_events (
ID INT PRIMARY KEY,
MBTA_ROUTE VARCHAR(255),
STOP_ID DOUBLE PRECISION,
FOREIGN KEY (MBTA_ROUTE) REFERENCES bus_reliability(gtfs_route_id),
FOREIGN KEY (STOP_ID) REFERENCES bus_points(stop_id)
);

CREATE TABLE rail_events (
ID INT PRIMARY KEY,
STATION VARCHAR(255),
LINE VARCHAR(255),
FOREIGN KEY (LINE) REFERENCES rail_reliability(gtfs_route_id),
FOREIGN KEY (STATION) REFERENCES rail_points(station)
);



-------------import data----------------------

\copy bus_reliability FROM 'datashare\reliability\bus_reliability.csv' DELIMITER ',' CSV
\copy rail_reliability FROM 'datashare\reliability\rail_reliability.csv' DELIMITER ',' CSV


\copy bus_events FROM 'datashare\bus\bus_events.csv' DELIMITER ',' CSV
\copy rail_events FROM 'datashare\rail\rail_events.csv' DELIMITER ',' CSV



/*
shp2pgsql commands used to create .sql files of spatial datasets

shp2pgsql -s 26986 -I datashare\rail\rail.shp public.rail_points > sql_tables\rail_points.sql
shp2pgsql -s 26986 -I datashare\bus\MBTABUSSTOPS_PT.shp public.bus_points > sql_tables\bus_points.sql
shp2pgsql -s 26986 -I datashare\silver\silver_stops.shp public.silver_points > sql_tables\silver_points.sql
shp2pgsql -s 26986 -I datashare\Demographics\GreaterBostonMedianHouseholdIncome.shp public.demographics > sql_tables\demographics.sql
*/