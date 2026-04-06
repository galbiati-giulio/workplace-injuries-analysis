WITH employment_totals AS (
    SELECT
        country_id,
        time_period,
        SUM(obs_value) AS total_employment
    FROM EMPLOYMENT_H36C
    WHERE activity_id = 'H'
      AND age_id = 'Y_GE15'
      AND country_id NOT IN ('UK', 'TR')
    GROUP BY country_id, time_period
),

top10_countries AS (
    SELECT
        country_id,
        AVG(total_employment) AS avg_employment
    FROM employment_totals
    GROUP BY country_id
    ORDER BY avg_employment DESC
    LIMIT 10
),

casualty_totals AS (
    SELECT
        country_id,
        time_period,
        SUM(obs_value) AS total_casualties
    FROM WRI_TOTALS_HC10
    WHERE activity_id = 'H'
    GROUP BY country_id, time_period
)

SELECT
    c.country_id,
    c.time_period,
    c.total_casualties
FROM casualty_totals c
JOIN top10_countries t
    ON c.country_id = t.country_id
ORDER BY
    c.country_id,
    c.time_period;