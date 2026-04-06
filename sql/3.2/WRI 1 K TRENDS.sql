SELECT
    w.time_period AS year,
    c.country AS country,
    ROUND(AVG(w.casualties_x1k),2) AS injury_rate_x1k
FROM WRI_TOTALS_HC10 w
JOIN COUNTRIES c
    ON w.country_id = c.country_id
WHERE w.time_period BETWEEN 2014 AND 2023
GROUP BY year, c.country
ORDER BY year, country;