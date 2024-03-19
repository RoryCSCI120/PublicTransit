# Public Transit Group Project
## IDCE 376
Adlai Nelson, Isack Walube, Rory Dickinson

### Introduction
In an era characterized by rapid urban development, the effectiveness of public transportation networks is vital for the welfare of urban dwellers. This project evaluates the efficiency of public transit systems in Boston, focusing on metrics such as coverage, frequency, and connectivity across various block groups. By conducting a comprehensive analysis, we aim to derive actionable insights that can refine transit systems, ultimately enhancing accessibility and sustainability in public transportation.


### Data

Transportation data, including bus and subway stops, as well as wich route was associated with the stops, were downloaded from MassGIS. Reliability data for 2015 - March 2024 were downloaded from MBTAs open data portal. 

Demographics data, US Census tracts containing data regarding median household income, as well as median household income based on race, self vs nonself employment. Data collected by the American Community Survey, downloaded from ESRI's Covid-19 Resources page.


#### Data preprocessing

Reliability data were preprocessed using R 4.3.2. Reliability metrics were averaged for each bus and rapid transit route across the lifespan of the data. Spatial Data was processd in QGIS. All layers were reporojected to NAD 83 Massachusetts stateplane, and clipped to the study area region.
