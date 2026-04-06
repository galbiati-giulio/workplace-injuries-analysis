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
        AVG(employment) AS avg_emp
    FROM country_year
    GROUP BY country_id
),

top10 AS (
    SELECT country_id
    FROM country_avg
    ORDER BY avg_emp DESC
    LIMIT 10
)

SELECT
    time_period,
    CASE
        WHEN country_id IN (SELECT country_id FROM top10) THEN country_id
        ELSE 'Other'
    END AS display_country,
    SUM(employment) AS employment
FROM country_year
GROUP BY
    time_period,
    CASE
        WHEN country_id IN (SELECT country_id FROM top10) THEN country_id
        ELSE 'Other'
    END
ORDER BY
    time_period,
    CASE
        WHEN display_country = 'Other' THEN 2
        ELSE 1
    END,
    employment DESC;