WITH yearly_gender_rates AS (
    SELECT
        w.activity_id,
        w.time_period,
        SUM(w.m_casualties_x1km) AS male_rate,
        SUM(w.f_casualties_x1kf) AS female_rate
    FROM WRI_IT_TOTALS_AU w
    JOIN COUNTRIES c
        ON w.country_id = c.country_id
    WHERE
        c.country = "Italy"
        AND w.time_period BETWEEN 2014 AND 2023
    GROUP BY
        w.activity_id,
        w.time_period
)

SELECT
    a.activity_id,
    a.activity_description,
    AVG(male_rate) AS avg_male_rate,
    AVG(female_rate) AS avg_female_rate
FROM yearly_gender_rates y
JOIN ACTIVITIES a
    ON y.activity_id = a.activity_id
GROUP BY
    a.activity_id,
    a.activity_description
ORDER BY
    avg_male_rate DESC;