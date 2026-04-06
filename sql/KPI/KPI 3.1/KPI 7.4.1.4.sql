WITH yearly_sex_total AS (
    SELECT
        e.time_period,
        e.sex_id,
        SUM(e.obs_value) AS year_employment
    FROM EMPLOYMENT_H36C e
    JOIN COUNTRIES c
        ON e.country_id = c.country_id
    WHERE
        e.time_period BETWEEN 2014 AND 2023
        AND c.country NOT IN ('United Kingdom', 'Turkey')
        AND e.sex_id IN ('M','F')
    GROUP BY e.time_period, e.sex_id
),

avg_sex_employment AS (
    SELECT
        sex_id,
        AVG(year_employment) AS avg_employment
    FROM yearly_sex_total
    GROUP BY sex_id
)

SELECT
    ROUND(
        MAX(CASE WHEN sex_id = 'F' THEN avg_employment END) * 100.0
        /
        SUM(avg_employment),
        2
    ) AS female_workforce_share_pct
FROM avg_sex_employment;