WITH activity_year AS (
    SELECT
        activity_id,
        time_period,
        SUM(obs_value) AS total_employment
    FROM EMPLOYMENT_ITAU
    WHERE country_id = 'IT'
      AND time_period BETWEEN 2014 AND 2023
    GROUP BY activity_id, time_period
)
SELECT
    activity_id,
    ROUND(AVG(total_employment), 1) AS avg_employment_2014_2023
FROM activity_year
GROUP BY activity_id
ORDER BY avg_employment_2014_2023 DESC;