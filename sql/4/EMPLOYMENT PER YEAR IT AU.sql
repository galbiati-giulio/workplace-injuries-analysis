WITH employment_totals AS (
    SELECT
        activity_id,
        time_period,
        SUM(obs_value) AS total_employment
    FROM EMPLOYMENT_ITAU
    GROUP BY activity_id, time_period
),

au_activities AS (
    SELECT
        activity_id,
        AVG(total_employment) AS avg_employment
    FROM employment_totals
    GROUP BY activity_id
    ORDER BY avg_employment DESC
)

SELECT
    e.activity_id,
    e.time_period,
    e.total_employment
FROM employment_totals e
JOIN au_activities t
    ON e.activity_id = t.activity_id
ORDER BY
    e.activity_id,
    e.time_period;