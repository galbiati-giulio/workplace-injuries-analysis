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
base_year AS (
    SELECT
        activity_id,
        total_employment AS base_2014
    FROM yearly_employment
    WHERE time_period = 2014
)
SELECT
    y.activity_id,
    y.time_period,
    y.total_employment,
    ROUND((y.total_employment / b.base_2014) * 100, 1) AS employment_index,
    CASE
        WHEN y.activity_id = 'H'
        THEN 'Transportation and Storage'
        ELSE 'Other sectors'
    END AS highlight_group
FROM yearly_employment y
JOIN base_year b
ON y.activity_id = b.activity_id
ORDER BY y.activity_id, y.time_period;