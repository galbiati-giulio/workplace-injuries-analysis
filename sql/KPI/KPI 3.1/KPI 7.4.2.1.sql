WITH country_year_rates AS (
    SELECT
        country_id,
        time_period,
        SUM(obs_value) AS total_casualties,
        MAX(employment_h) AS employment_h,
        ROUND(SUM(obs_value) / MAX(employment_h), 2) AS casualties_per_1k
    FROM WRI_TOTALS_HC10
    WHERE activity_id = 'H'
      AND time_period BETWEEN 2014 AND 2023
    GROUP BY country_id, time_period
),

country_avg_rates AS (
    SELECT
        country_id,
        ROUND(AVG(casualties_per_1k), 2) AS avg_casualties_per_1k_2014_2023
    FROM country_year_rates
    GROUP BY country_id
),

peer_average AS (
    SELECT
        ROUND(AVG(avg_casualties_per_1k_2014_2023), 2) AS peer_avg_casualties_per_1k
    FROM country_avg_rates
)

SELECT
    'Average Injury Incidence — NACE H' AS indicator,
    peer_avg_casualties_per_1k AS peer_group_value,
    (
        SELECT avg_casualties_per_1k_2014_2023
        FROM country_avg_rates
        WHERE country_id = 'IT'
    ) AS italy_value,
    '2014-2023 avg' AS period
FROM peer_average;