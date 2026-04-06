SELECT
    sex_id,
    SUM(obs_value) AS total_employment,
    ROUND(
        SUM(obs_value) * 100.0 /
        SUM(SUM(obs_value)) OVER (),
        2
    ) AS share_pct
FROM EMPLOYMENT_H36C
WHERE activity_id = 'H'
AND age_id = 'Y_GE15'
AND time_period BETWEEN 2014 AND 2023
GROUP BY sex_id
ORDER BY sex_id;