SELECT
    time_period,
    SUM(obs_value) AS total_employment
FROM EMPLOYMENT_H36C
WHERE activity_id = 'H'
AND age_id = 'Y_GE15'
AND time_period BETWEEN 2014 AND 2023
GROUP BY time_period
ORDER BY time_period;