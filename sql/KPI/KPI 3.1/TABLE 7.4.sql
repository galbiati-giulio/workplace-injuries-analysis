WITH yearly_totals AS (
    SELECT
        activity_id,
        time_period,
        SUM(obs_value) AS yearly_casualties,
        MAX(employment_au) AS yearly_employment,
        SUM(obs_value) * 1.0 / MAX(employment_au) AS yearly_injury_rate_x1k
    FROM WRI_IT_TOTALS_AU
    WHERE time_period BETWEEN 2014 AND 2023
    GROUP BY activity_id, time_period
),
activity_avg AS (
    SELECT
        activity_id,
        ROUND(AVG(yearly_casualties), 0) AS avg_casualties,
        ROUND(AVG(yearly_employment), 0) AS avg_employment,
        ROUND(AVG(yearly_injury_rate_x1k), 2) AS injury_rate_per_1000
    FROM yearly_totals
    GROUP BY activity_id
)

SELECT
    a.activity_description AS activity,
    aa.avg_casualties AS "Avg Casualties",
    aa.avg_employment AS "Avg Employment",
    aa.injury_rate_per_1000 AS "Injury Rate (per 1,000 employees)",
    ROW_NUMBER() OVER (
        ORDER BY aa.injury_rate_per_1000 DESC
    ) AS rank
FROM activity_avg aa
JOIN ACTIVITIES a
    ON aa.activity_id = a.activity_id
ORDER BY rank;