WITH yearly_totals AS (
    SELECT
        country_id,
        time_period,
        SUM(obs_value) AS annual_casualties
    FROM WRI_TOTALS_HC10
    WHERE time_period BETWEEN 2014 AND 2023
    GROUP BY country_id, time_period
)
SELECT
    c.country AS country,
    ROUND(AVG(y.annual_casualties), 0) AS avg_annual_casualties
FROM yearly_totals y
JOIN COUNTRIES c
    ON y.country_id = c.country_id
GROUP BY c.country
ORDER BY avg_annual_casualties DESC;