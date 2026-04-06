WITH base AS (
    SELECT
        country_id,
        sex_id,
        SUM(obs_value) AS employment
    FROM EMPLOYMENT_H36C
    WHERE activity_id = 'H'
      AND age_id = 'Y_GE15'
      AND time_period BETWEEN 2014 AND 2023
      AND country_id NOT IN ('UK','TR')
    GROUP BY country_id, sex_id
)

SELECT
    'EU' AS area,
    sex_id,
    SUM(employment) AS employment
FROM base
GROUP BY sex_id

UNION ALL

SELECT
    'Italy' AS area,
    sex_id,
    SUM(employment) AS employment
FROM base
WHERE country_id = 'IT'
GROUP BY sex_id

ORDER BY area, sex_id;