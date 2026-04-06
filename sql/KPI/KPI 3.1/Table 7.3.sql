WITH yearly_totals AS (
    SELECT
        country_id,
        time_period,
        SUM(obs_value) AS yearly_casualties,
        MAX(employment_h) AS yearly_employment,
        SUM(obs_value) * 1.0 / MAX(employment_h) AS yearly_injury_rate_x1k
    FROM WRI_TOTALS_HC10
    WHERE time_period BETWEEN 2014 AND 2023
    GROUP BY country_id, time_period
),
country_avg AS (
    SELECT
        country_id,
        ROUND(AVG(yearly_casualties), 0) AS avg_casualties,
        ROUND(AVG(yearly_employment), 0) AS avg_employment,
        ROUND(AVG(yearly_injury_rate_x1k), 2) AS injury_rate_per_1000
    FROM yearly_totals
    GROUP BY country_id
)

SELECT
    c.country AS country,
    ca.avg_casualties AS "Avg Casualties",
    ca.avg_employment AS "Avg Employment",
    ca.injury_rate_per_1000 AS "Injury Rate (per 1,000 employees)",
    ROW_NUMBER() OVER (
        ORDER BY ca.injury_rate_per_1000 DESC
    ) AS rank
FROM country_avg ca
JOIN COUNTRIES c
    ON ca.country_id = c.country_id
ORDER BY rank;