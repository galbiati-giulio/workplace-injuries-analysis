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
),

casualty_totals AS (
    SELECT
        activity_id,
        time_period,
        SUM(casualties_x1k) AS total_casualties
    FROM WRI_IT_TOTALS_AU
    GROUP BY activity_id, time_period
)

SELECT
    c.activity_id,
    c.time_period,
    c.total_casualties
FROM casualty_totals c
JOIN au_activities t
    ON c.activity_id = t.activity_id
ORDER BY
    c.activity_id,
    c.time_period;