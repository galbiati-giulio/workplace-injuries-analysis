WITH yearly_rates AS (
    SELECT
        a.activity_id,
        a.activity_description,
        w.time_period,
        SUM(w.casualties_x1k) AS annual_casualties_x1k
    FROM WRI_IT_TOTALS_AU w
    JOIN ACTIVITIES a
        ON w.activity_id = a.activity_id
    JOIN COUNTRIES c
        ON w.country_id = c.country_id
    WHERE
        c.country = 'Italy'
        AND w.time_period BETWEEN 2014 AND 2023
    GROUP BY
        a.activity_id,
        a.activity_description,
        w.time_period
)
SELECT
    activity_id,
    activity_description,
    AVG(annual_casualties_x1k) AS avg_casualties_x1k
FROM yearly_rates
GROUP BY
    activity_id,
    activity_description
ORDER BY
    avg_casualties_x1k DESC;