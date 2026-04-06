WITH italy_year_rates AS (
    SELECT
        time_period,
        ROUND(SUM(casualties_x1k), 2) AS total_rate_x1k
    FROM WRI_TOTALS_HC10
    WHERE activity_id = 'H'
      AND country_id = 'IT'
      AND time_period BETWEEN 2014 AND 2023
    GROUP BY time_period
)
SELECT
    ROUND(AVG(total_rate_x1k), 2) AS italy_avg_injury_incidence
FROM italy_year_rates;