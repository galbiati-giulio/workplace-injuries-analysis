WITH yearly_activity_rates AS (
    SELECT
        w.activity_id,
        w.time_period,
        SUM(w.casualties_x1k) AS activity_casualties_x1k,
        MAX(w.employment_au) AS activity_employment
    FROM WRI_IT_TOTALS_AU w
    WHERE
        w.country_id = 'IT'
        AND w.time_period BETWEEN 2014 AND 2023
    GROUP BY
        w.activity_id,
        w.time_period
),

yearly_total_economy AS (
    SELECT
        time_period,
        SUM(activity_casualties_x1k * activity_employment) / SUM(activity_employment) AS total_economy_casualties_x1k
    FROM yearly_activity_rates
    GROUP BY
        time_period
)

SELECT
    AVG(total_economy_casualties_x1k) AS avg_total_economy_casualties_x1k
FROM yearly_total_economy;