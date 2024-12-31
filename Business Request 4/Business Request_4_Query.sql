with rankcitys as (
		SELECT 
			c.city_name as city_name, sum(p.new_passengers) as total_new_passengers,
			rank() over (order by sum(p.new_passengers) desc) as rank_desc,
			 rank() over (order by sum(p.new_passengers) asc) as rank_asc
		FROM 
			fact_passenger_summary p
		join 
			dim_city c
			on p.city_id = c.city_id
		group by 
			c.city_name
)
SELECT 
    city_name,
    total_new_passengers,
    CASE 
        WHEN rank_desc <= 3 THEN 'Top 3'
        WHEN rank_asc <= 3 THEN 'Bottom 3 '
        ELSE NULL
    END AS city_category
FROM 
    rankcitys
WHERE 
    rank_desc <= 3 OR rank_asc <= 3
order by 
	total_new_passengers desc;