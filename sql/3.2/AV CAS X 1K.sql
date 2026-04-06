WITH yearly_rates AS (
    SELECT
        country_id,
        time_period,
        SUM(casualties_x1k) AS yearly_injury_rate_x1k
    FROM WRI_TOTALS_HC10
    WHERE time_period BETWEEN 2014 AND 2023
    GROUP BY country_id, time_period
)
SELECT
    c.country AS country,
    ROUND(AVG(y.yearly_injury_rate_x1k), 2) AS avg_injury_rate_x1k
FROM yearly_rates y
JOIN COUNTRIES c
    ON y.country_id = c.country_id
GROUP BY c.country
ORDER BY avg_injury_rate_x1k DESC;