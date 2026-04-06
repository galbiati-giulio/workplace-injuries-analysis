WITH country_rates AS (
    SELECT
        w.time_period AS year,
        c.country AS country,
        SUM(w.casualties_x1k) AS injury_rate_x1k
    FROM WRI_TOTALS_HC10 w
    JOIN COUNTRIES c
        ON w.country_id = c.country_id
    WHERE w.time_period BETWEEN 2014 AND 2023
    GROUP BY w.time_period, c.country
)

SELECT
    year,
    country,
    ROUND(injury_rate_x1k, 2) AS injury_rate_x1k,
    ROUND(AVG(injury_rate_x1k) OVER (PARTITION BY year), 2) AS peer_avg_rate
FROM country_rates
ORDER BY year, country;