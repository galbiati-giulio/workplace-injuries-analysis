SELECT
    country_id,
    time_period,
    sex_id,
    SUM(obs_value) AS employment_value
FROM EMPLOYMENT_H36C
WHERE activity_id = 'H'
  AND age_id = 'Y_GE15'
  AND time_period BETWEEN 2014 AND 2023
GROUP BY country_id, time_period, sex_id
ORDER BY country_id, time_period, sex_id;