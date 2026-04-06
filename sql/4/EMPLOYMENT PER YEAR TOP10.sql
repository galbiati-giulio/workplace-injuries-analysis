WITH employment_totals AS (
    SELECT
        country_id,
        time_period,
        SUM(obs_value) AS total_employment
    FROM EMPLOYMENT_H36C
	WHERE country_id NOT IN ('UK','TR')
    GROUP BY country_id, time_period
),

top10_countries AS (
    SELECT
        country_id,
        AVG(total_employment) AS avg_employment
    FROM employment_totals
    GROUP BY country_id
    ORDER BY avg_employment DESC
	LIMIT 10
)

SELECT
    e.country_id,
    e.time_period,
    e.total_employment
FROM employment_totals e
JOIN top10_countries t
    ON e.country_id = t.country_id
ORDER BY
    e.country_id,
    e.time_period;