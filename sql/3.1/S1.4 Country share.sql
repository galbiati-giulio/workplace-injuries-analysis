WITH country_avg AS (
    SELECT
        country_id,
        AVG(total_employment) AS avg_emp
    FROM (
        SELECT
            country_id,
            time_period,
            SUM(obs_value) AS total_employment
        FROM EMPLOYMENT_H36C
        WHERE activity_id = 'H'
        AND age_id = 'Y_GE15'
        AND time_period BETWEEN 2014 AND 2023
        GROUP BY country_id, time_period
    )
    GROUP BY country_id
),

total_avg AS (
    SELECT SUM(avg_emp) AS total_emp
    FROM country_avg
)

SELECT
    c.country_id,
    ROUND(c.avg_emp,2) AS avg_employment,
    ROUND(c.avg_emp * 100.0 / t.total_emp,2) AS employment_share_pct
FROM country_avg c
CROSS JOIN total_avg t
ORDER BY avg_employment DESC;