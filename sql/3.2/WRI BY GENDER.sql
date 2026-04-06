WITH yearly_gender_rates AS (
    SELECT
        country_id,
        time_period,
        SUM(m_casualties_x1km) AS male_rate_x1k,
        SUM(f_casualties_x1kf) AS female_rate_x1k
    FROM WRI_TOTALS_HC10
    WHERE time_period BETWEEN 2014 AND 2023
    GROUP BY country_id, time_period
)
SELECT
    c.country AS country,
    ROUND(AVG(y.male_rate_x1k), 2) AS male_rate_x1k,
    ROUND(AVG(y.female_rate_x1k), 2) AS female_rate_x1k
FROM yearly_gender_rates y
JOIN COUNTRIES c
    ON y.country_id = c.country_id
GROUP BY c.country
ORDER BY male_rate_x1k DESC;