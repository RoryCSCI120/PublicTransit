--Demographics - Population Data
CREATE TABLE demographics_population (
POPULATIONID SERIAL PRIMARY KEY --Create a primary key
NAME VARCHAR(255) -- Census Tract
STATE VARCHAR(255)
COUNTY VARCHAR(255)
TOTAL_POPULATION NUMERIC -- Median Household Income Value
GEOM GEOMETRY(polygon, 26986) -- NAD 83 Massachusetts Stateplane
);