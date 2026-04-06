SELECT
    country_id,
    time_period,

    SUM(CASE WHEN sex_id = 'F' THEN obs_value ELSE 0 END) AS female_employment,
    SUM(CASE WHEN sex_id = 'M' THEN obs_value ELSE 0 END) AS male_employment,

    SUM(obs_value) AS total_employment,

    ROUND(
        SUM(CASE WHEN sex_id = 'F' THEN obs_value ELSE 0 END) * 100.0
        / SUM(obs_value), 2
    ) AS female_share_pct,

    ROUND(
        SUM(CASE WHEN sex_id = 'M' THEN obs_value ELSE 0 END) * 100.0
        / SUM(obs_value), 2
    ) AS male_share_pct

FROM EMPLOYMENT_H36C
WHERE activity_id = 'H'
AND age_id = 'Y_GE15'
AND time_period BETWEEN 2014 AND 2023
GROUP BY country_id, time_period
ORDER BY country_id, time_period;