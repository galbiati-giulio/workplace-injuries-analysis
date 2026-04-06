WITH country_year_rates AS (
    SELECT
        country_id,
        time_period,
        ROUND(SUM(casualties_x1k), 2) AS total_rate_x1k
    FROM WRI_TOTALS_HC10
    WHERE activity_id = 'H'
      AND time_period BETWEEN 2014 AND 2023
    GROUP BY country_id, time_period
),
country_avg_rates AS (
    SELECT
        country_id,
        ROUND(AVG(total_rate_x1k), 2) AS avg_rate_x1k
    FROM country_year_rates
    GROUP BY country_id
)
SELECT
    ROUND(AVG(avg_rate_x1k), 2) AS peer_group_avg_injury_incidence
FROM country_avg_rates;