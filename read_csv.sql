/*
Run the code in this table to read in CSV files

These commands must be run from the psql in command line.
I tried using the COPY command (wich works in PGAdmin) but I was getting errors

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

CREATE TABLE silver_reliability (
gtfs_route_long_name VARCHAR(255) PRIMARY KEY,
otp_value NUMERIC
);



-------------import data----------------------

\copy bus_reliability FROM 'datashare\reliability\bus_reliability.csv' DELIMITER ',' CSV
\copy rail_reliability FROM 'datashare\reliability\rail_reliability.csv' DELIMITER ',' CSV
\copy silver_reliability FROM 'datashare\reliability\silver_reliability.csv' DELIMITER ',' CSV




/*
shp2pgsql commands used to create .sql files of spatial datasets

shp2pgsql -s 26986 -I datashare\rail\rail.shp public.rail_points > sql_tables\rail_points.sql
shp2pgsql -s 26986 -I datashare\bus\MBTABUSSTOPS_PT.shp public.bus_points > sql_tables\bus_points.sql
shp2pgsql -s 26986 -I datashare\silver\silver_stops.shp public.silver_points > sql_tables\silver_points.sql
shp2pgsql -s 26986 -I datashare\Demographics\GreaterBostonMedianHouseholdIncome.shp public.demographics > sql_tables\demographics.sql
*/