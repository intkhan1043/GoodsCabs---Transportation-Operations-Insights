WITH MonthlyMetrics AS (
    SELECT
        c.city_name,
        ps.month,
        ps.total_passengers,
        ps.repeat_passengers,
        (ps.repeat_passengers * 100 / ps.total_passengers) AS monthly_repeat_passenger_rate
    FROM 
        fact_passenger_summary ps
    JOIN 
        dim_city c ON ps.city_id = c.city_id
),
CityMetrics AS (
    SELECT
        c.city_name,
        SUM(ps.total_passengers) AS city_total_passengers,
        SUM(ps.repeat_passengers) AS city_repeat_passengers,
        (SUM(ps.repeat_passengers) * 100 / SUM(ps.total_passengers)) AS city_repeat_passenger_rate
    FROM 
        fact_passenger_summary ps
    JOIN 
        dim_city c ON ps.city_id = c.city_id
    GROUP BY 
        c.city_name
)
SELECT 
    mm.city_name,
    mm.month,
    mm.total_passengers,
    mm.repeat_passengers,
    ROUND(mm.monthly_repeat_passenger_rate, 2) AS monthly_repeat_passenger_rate,
    ROUND(cm.city_repeat_passenger_rate, 2) AS city_repeat_passenger_rate
FROM 
    MonthlyMetrics mm
JOIN 
    CityMetrics cm ON mm.city_name = cm.city_name
ORDER BY 
    mm.city_name, mm.month;
