WITH yearly_totals AS (
    SELECT
        a.activity_id,
        a.activity_description,
        w.time_period,
        SUM(w.obs_value) AS annual_casualties
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
    AVG(annual_casualties) AS avg_annual_casualties
FROM yearly_totals
GROUP BY
    activity_id,
    activity_description
ORDER BY
    avg_annual_casualties DESC;