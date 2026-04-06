WITH yearly_country_total AS (
    SELECT
        e.country_id,
        e.time_period,
        SUM(e.obs_value) AS year_employment
    FROM EMPLOYMENT_H36C e
    WHERE e.time_period BETWEEN 2014 AND 2023
    GROUP BY e.country_id, e.time_period
),

avg_country_employment AS (
    SELECT
        c.country,
        AVG(y.year_employment) AS avg_employment
    FROM yearly_country_total y
    JOIN COUNTRIES c
        ON y.country_id = c.country_id
    WHERE c.country NOT IN ('United Kingdom','Turkey')
    GROUP BY c.country
),

top10 AS (
    SELECT
        country,
        avg_employment
    FROM avg_country_employment
    ORDER BY avg_employment DESC
    LIMIT 10
),

totals AS (
    SELECT
        (SELECT SUM(avg_employment) FROM top10) AS top10_total,
        (SELECT SUM(avg_employment) FROM avg_country_employment) AS overall_total
)

SELECT
    ROUND(top10_total,2) AS top10_avg_employment,
    ROUND(overall_total,2) AS total_avg_employment,
    ROUND(top10_total * 100.0 / overall_total,2) AS employment_exposure_concentration_pct
FROM totals;