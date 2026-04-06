WITH yearly_employment AS (
    SELECT
        activity_id,
        time_period,
        SUM(obs_value) AS total_employment
    FROM EMPLOYMENT_ITAU
    WHERE country_id = 'IT'
      AND time_period BETWEEN 2014 AND 2023
    GROUP BY activity_id, time_period
),
total_economy AS (
    SELECT
        'TOTAL_AU' AS activity_id,
        time_period,
        SUM(total_employment) AS total_employment
    FROM yearly_employment
    GROUP BY time_period
)
SELECT
    activity_id,
    time_period,
    total_employment
FROM yearly_employment
WHERE activity_id IN ('C','F','G','H','Q')

UNION ALL

SELECT
    activity_id,
    time_period,
    total_employment
FROM total_economy

ORDER BY activity_id, time_period;