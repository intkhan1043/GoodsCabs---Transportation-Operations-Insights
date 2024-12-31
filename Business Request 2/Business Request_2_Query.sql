with monthly_city_level_trips_target_performance as (
SELECT 
    c.city_name,
    d.month_name,
    count(f.trip_id) AS actual_trips,
    t.total_target_trips AS target_trips,
    CASE 
        WHEN count(f.trip_id) > t.total_target_trips THEN 'Above Target'
        ELSE 'Below Target'
    END AS performance_status
FROM 
    dim_city c
JOIN 
    fact_trips f
    ON c.city_id = f.city_id
JOIN 
    dim_date d
    ON f.date = d.date
JOIN 
    targets_db.monthly_target_trips t
    ON c.city_id = t.city_id AND d.start_of_month = t.month
GROUP BY 
    c.city_name, d.start_of_month, t.total_target_trips)

select
	*,
	ROUND((actual_trips-target_trips) / (target_trips) * 100, 2) AS percentage_difference
from
	monthly_city_level_trips_target_performance
