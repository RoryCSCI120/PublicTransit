# Public Transit Group Project
## IDCE 376
Adlai Nelson, Isack Walube, Rory Dickinson

### Introduction
In an era characterized by rapid urban development, the effectiveness of public transportation networks is vital for the welfare of urban dwellers. This project evaluates the efficiency of public transit systems in Boston, focusing on metrics such as coverage, and reliability. By conducting a comprehensive analysis, we aim to derive actionable insights that can refine transit systems, ultimately enhancing accessibility and sustainability in public transportation.
This project aims to address issues such as; accessibility and equity, urban mobility optimization, resource allocation, environmental sustainability, and data-driven decision-making by gaining insights into historical trends to identify areas for improvement. 

### Data

Transportation data, including bus and subway stops, as well as which route was associated with the stops, were downloaded from MassGIS (See figure 1). Reliability data for 2015 - March 2024 were downloaded from the MBTA open data portal. 

Demographics data, US Census tracts containing data regarding median household income. Data collected by the American Community Survey was downloaded from ESRI's Covid-19 Resources page. The original dataset was for the entire United States but was clipped down to the Boston Metropolitan Area, as defined by the Metropolitan Area Planning Council. Another demographics dataset will also be used of US census tracts regarding population count. This data is from the US Census and was retrieved from ESRI's Livign Atlas. Both clip layers were created from a Massachusetts town boundary shapefile downloaded from MassGIS. 

Figure 1

![data_layers1](https://github.com/adlai-nelson/PublicTransit/assets/131007848/a7cfb7d0-3d71-4c4b-abb6-3ccec2a568ab)
(Made in QGIS)

Sources:

[Demographics](https://coronavirus-resources.esri.com/datasets/esri::county-28/explore?location=33.307776%2C-119.918825%2C4.00) - Median Household Income Census Tract Data polygons

[MA Cities](https://www.mass.gov/info-details/massgis-data-2020-us-census-towns) - Massachusetts Towns

[MBTA Rapid Transit](https://www.mass.gov/info-details/massgis-data-mbta-rapid-transit) - Rapid Transit Stop Data, shapefile points containing stations and the lines that service those stations

[MBTA Bus](https://www.mass.gov/info-details/massgis-data-mbta-bus-routes-and-stops) - Bus stop Data, containing shapefile points and additional bus events table

[Reliability Data](https://mbta-massdot.opendata.arcgis.com/datasets/b3a24561c2104422a78b593e92b566d5_0/explore) - Transit Reliability tables contianed one entry for every day and every line from 2015-2024. 
For both subway and bus lines, reliability ranges between 0 and 1, where 1 is most reliable.
For bus lines, reliability was the perportion of busses that depart no more than 3 minues late for frequent routes, and 6 minutes late for infrequent routes.
For subway lines, reliability was "the percentage of riders who waited less than or equal to the amount of time scheduled between trains."
See [MBTA website](https://www.mbta.com/performance-metrics/service-reliability) for more detail. I was unable to access the origonal data they used to create these datasets, so the bus and rail metrics are not directly comperable.

ESRI Living Atlas - Population Census Tract Data

#### Data preprocessing

Spatial Data was processed in QGIS. All layers were reprojected to NAD 83 Massachusetts stateplane, and clipped to the study area region.

Reliability data were preprocessed using R 4.3.2. Reliability metrics were averaged for each bus and rapid transit route across the lifespan of the data. 


#### Table normalization
The Bus data did not require any normalization. From Massgis/MassDOT, there was one table containing bus stop IDs and the point location, and one table containing the IDs and each bus stop, where each unique combination of ID and bus stop was on its own row. This was compliant with 1NF, as all of the values were atomic. In addition, they were all of the same type, and order did not matter. 

The rail stops data had to be normalized.
This shapefile listed station ID, station location, and the lines that serviced the station. 
There sometimes multiple lines serviced the same station, so the data was normalized by creating a seperate table (rail_events) to store station names and routes. 
They were normalized, so each place where a route name was repeated it was instead on its own row. Since both, route name and station ID repeated in the table, a new event ID table had to be created.

Non normalized rail data:

<img src="figures/non-normalized_rail.png" alt="non normalized table" width="200"/>

Normalized rail data:

<img src="figures/normalized_rail.png" alt="normalized rail table" width="300"/>

### Methods

To load in the data to a database, the following sql scripts must be run in postgres:
bus_points.sql, rail_points.sql, demographics.sql, and read_csv.sql.
These files are contained within the sql folder.
Note: read_csv.sql must be run in command line psql, as PGAdmin does not support the `\copy` command


Next, analysis.sql was run. The outputs of each query were exported as .csv and imported into QGIS and R to visualize.
The package ggplot2 for R software was used for graphical visualizations. 
The data was plotted and trendlines were drawn using the geom_smooth command and 'lm' model. Below is an in depth explanation of some of the queries available in analysis.sql.

To calculate number of stops, a simple spatal query was run, using the st_contains command in postgis. The results of this query were exported and visualized in R.

```
SELECT demographics.b19049_001 AS median_hh_inc, -- median household income
count(rail_points.geom) AS n_stations -- count n stations within each census tract
FROM demographics
LEFT JOIN rail_points ON st_contains(demographics.geom,rail_points.geom) -- spatial join
GROUP BY demographics.gid -- group by census tracts
ORDER BY n_stations DESC;
```

To calculate average reliability per tract, a more complex query was run. 
First, rail events and rail reliability tables were joined, and grouped by station name, calculating the mean reliability value for each rail station. 
Next, the resultant table was joined with rail points, to add the geometry column to the reliability value.
Finally, the resulting table containing station points and reliability values was joined with the census tracts using st_contains.
The output of this query was exported and visualized in R, and imported into QGIS to be visualized as well.

```
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
```

### Results

Most of the census tracts in our study area do not contain any bus or train stops. 
This is due to the priotiries of the MBTA, as their subway and bus lines do not seek to service the enitre Boston metro area, only the urban center and immidiately surrounding areas.
In this analysis, we chose to exclude the commuter rail as well, as we wanted to focus on only the Boston area, but adding in the commuter rail would increase coverage.


![Two bar graphs showing distribution of n stops/stations per census block](figures/distribution_stops.png)

Number of rail stations seems to have little relationship with census tract population (a, c). N bus stops has a weak positive relationship with income (b). 
N bus stops and population seems to be positively correlated, census tracts with higher population have more bus stops, although that isn't a strong relationship (d).
This indicates that there are more bus stops in census tracts with higher population.
This is good, as the goal of any public transportation system is to service the greatest amount of people.
There are some inconsistencies and outliers in this data, however, as some of the bus stops and subway stations were in census tracts with very low population, as they were zoned for industial or park use.
Census tracts are not a perfect measure of how many people can easily access the stop, as the stop may be easily accesable by those in nearby census tracts.

![Four scatter plot graphs showing relationship between income, population, and n stops/stations](figures/n_per_tract.png)

Income made little difference on rail or bus reliability (A, B). 
Population showed a weak negative relationship with rail and bus reliability, although the slope was very shallow (C, D).
One possible explanation for lower reliability in higher populated census tracts is that there are more stations and stops, and it could be also in more congested urban areas, increasing the amount of delays.

![Four scatter plot graphs showing relationship between income, population, and reliability](figures/rely_per_tract.png)

Due to the small amount of subway lines, the map of subway reliability by census tract is not particularly illuminating. 
From it we can see that the blue line has the highest reliability, followed by the orange and red lines, and the green line has the lowest reliability.
The bus map is more interesting, reliability appears to be spatially varied, with some pockets of higher reliability, the largest of wich is in the Watertown area.

![Map showing spatial dimention of reliability for rail and bus lines](figures/reliability.png)

### Conclusion

One of the major flaws of this research project was using census tracts to get population and income data. 
In some cases, these numbers were not representative of the people who are near to those stops.
Future reasearch could seek alternative data sources, such as gridded population data, or census block groups (perhaps using network analysis to select those within a short walk).
Overall, this reserach project shows that reliability does not vary greatly in tracts of differing incomes or populations.


