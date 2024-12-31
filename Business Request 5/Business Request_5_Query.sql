WITH monthly_revenue AS (
    SELECT 
        c.city_name,
        d.month_name,
        SUM(t.fare_amount) AS monthly_revenue
    FROM 
        fact_trips t
    JOIN 
        dim_city c ON t.city_id = c.city_id
    JOIN 
        dim_date d ON t.date = d.date
    GROUP BY 
        c.city_name, d.month_name
),
city_total_revenue AS (
    SELECT 
        city_name,
        SUM(monthly_revenue) AS total_revenue
    FROM 
        monthly_revenue
    GROUP BY 
        city_name
),
city_highest_revenue AS (
    SELECT 
        mr.city_name,
        mr.month_name AS highest_revenue_month,
        mr.monthly_revenue AS revenue,
        (mr.monthly_revenue * 100.0 / ctr.total_revenue) AS percentage_contribution
    FROM 
        monthly_revenue mr
    JOIN 
        city_total_revenue ctr ON mr.city_name = ctr.city_name
    WHERE 
        mr.monthly_revenue = (
            SELECT MAX(mr2.monthly_revenue)
            FROM monthly_revenue mr2
            WHERE mr2.city_name = mr.city_name
        )
)
SELECT 
    city_name,
    highest_revenue_month,
    revenue,
    ROUND(percentage_contribution, 2) AS percentage_contribution
FROM 
    city_highest_revenue
ORDER BY 
    revenue desc;
