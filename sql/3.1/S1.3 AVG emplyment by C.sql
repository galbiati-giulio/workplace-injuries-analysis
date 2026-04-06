SELECT
    country_id,
    ROUND(AVG(total_employment),2) AS avg_employment
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
ORDER BY avg_employment DESC;