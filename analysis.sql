/*
Analysis
*/
-----------------------------------
SELECT rail_events.station, AVG(rail_reliability.otp_value) as mean_reliability, rail_points.geom
FROM rail_events 
LEFT JOIN rail_reliability 
ON rail_events.line = rail_reliability.gtfs_route_id
RIGHT JOIN rail_points
ON rail_events.station = rail_points.station
GROUP BY rail_events.station;


SELECT rail_points.station, AVG(rail_reliability.otp_value) as mean_reliability, rail_points.geom
FROM rail_points
LEFT JOIN rail_reliability 
ON rail_events.line = rail_reliability.gtfs_route_id
RIGHT JOIN rail_points
ON rail_events.station = rail_points.station
GROUP BY rail_events.station;



