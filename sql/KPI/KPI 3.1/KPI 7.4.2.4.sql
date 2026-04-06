WITH country_year_rates AS (
    SELECT
        country_id,
        time_period,
        SUM(casualties_x1k) AS total_rate_x1k
    FROM WRI_TOTALS_HC10
    WHERE activity_id = 'H'
      AND time_period BETWEEN 2014 AND 2023
    GROUP BY country_id, time_period
),
country_avg_rates AS (
    SELECT
        country_id,
        AVG(total_rate_x1k) AS avg_rate_x1k
    FROM country_year_rates
    GROUP BY country_id
),
peer_avg AS (
    SELECT AVG(avg_rate_x1k) AS peer_avg_rate_x1k
    FROM country_avg_rates
),
italy_avg AS (
    SELECT avg_rate_x1k AS italy_avg_rate_x1k
    FROM country_avg_rates
    WHERE country_id = 'IT'
)
SELECT
    ROUND(i.italy_avg_rate_x1k / p.peer_avg_rate_x1k, 2) AS italy_relative_risk_vs_peer_avg
FROM italy_avg i
CROSS JOIN peer_avg p;