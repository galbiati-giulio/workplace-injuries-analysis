WITH yearly_total AS (
    SELECT
        e.time_period,
        SUM(e.obs_value) AS total_employment
    FROM EMPLOYMENT_H36C e
    JOIN COUNTRIES c
        ON e.country_id = c.country_id
    WHERE
        e.time_period IN (2014, 2023)
        AND c.country NOT IN ('United Kingdom','Turkey')
    GROUP BY e.time_period
)

SELECT
    y2023.total_employment AS employment_2023,
    y2014.total_employment AS employment_2014,
    ROUND(
        y2023.total_employment * 100.0 / y2014.total_employment,
        1
    ) AS growth_index_2014_100
FROM yearly_total y2023
JOIN yearly_total y2014
    ON y2023.time_period = 2023
   AND y2014.time_period = 2014;