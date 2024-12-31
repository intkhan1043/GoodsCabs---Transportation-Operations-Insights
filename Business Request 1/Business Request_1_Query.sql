with City_lev_fare_trip_summary as (
SELECT 
    dc.city_name AS City_Name,
    COUNT(ft.trip_id) AS total_trips,
    ROUND(SUM(ft.fare_amount) / SUM(ft.distance_travelled_km), 2) AS Avg_Fare_Per_Km,
    ROUND(SUM(ft.fare_amount) / COUNT(ft.trip_id), 2) AS Avg_Fare_Per_Trip
FROM 
	fact_trips ft
JOIN 
	dim_city dc
using 
	(city_id)
GROUP BY
	dc.city_name
)
select 
	*, 
    round(total_trips*100 / sum(total_trips) over (),2) as pct_contribution_to_total_trips
from 
	City_lev_fare_trip_summary
order by 
	total_trips desc;