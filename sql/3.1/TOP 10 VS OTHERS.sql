WITH country_year AS (
    SELECT
        country_id,
        time_period,
        SUM(obs_value) AS employment
    FROM EMPLOYMENT_H36C
    WHERE activity_id = 'H'
      AND age_id = 'Y_GE15'
      AND time_period BETWEEN 2014 AND 2023
      AND country_id NOT IN ('UK', 'TR')
    GROUP BY country_id, time_period
),

country_avg AS (
    SELECT
        country_id,
        AVG(employment) AS avg_employment
    FROM country_year
    GROUP BY country_id
),

top10 AS (
    SELECT country_id
    FROM country_avg
    ORDER BY avg_employment DESC
    LIMIT 10
),

grouped AS (
    SELECT
        CASE
            WHEN country_id IN (SELECT country_id FROM top10) THEN 'Top 10 Countries'
            ELSE 'Other Countries'
        END AS group_name,
        SUM(avg_employment) AS avg_employment
    FROM country_avg
    GROUP BY
        CASE
            WHEN country_id IN (SELECT country_id FROM top10) THEN 'Top 10 Countries'
            ELSE 'Other Countries'
        END
),

total AS (
    SELECT SUM(avg_employment) AS total_avg_employment
    FROM grouped
)

SELECT
    g.group_name,
    ROUND(g.avg_employment, 2) AS avg_employment,
    ROUND(g.avg_employment * 100.0 / t.total_avg_employment, 2) AS employment_share_pct
FROM grouped g
CROSS JOIN total t
ORDER BY g.avg_employment DESC;