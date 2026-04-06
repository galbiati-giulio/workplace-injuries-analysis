WITH yearly_rates AS (
    SELECT
        w.activity_id,
        w.time_period,
        SUM(w.casualties_x1k) AS annual_rate
    FROM WRI_IT_TOTALS_AU w
    JOIN COUNTRIES c
        ON w.country_id = c.country_id
    WHERE
        c.country = "Italy"
        AND w.time_period BETWEEN 2014 AND 2023
    GROUP BY
        w.activity_id,
        w.time_period
),

cross_sector_avg AS (
    SELECT
        time_period,
        AVG(annual_rate) AS rate
    FROM yearly_rates
    GROUP BY
        time_period
),

nace_h_rate AS (
    SELECT
        time_period,
        annual_rate AS rate
    FROM yearly_rates
    WHERE activity_id = "H"
)

SELECT
    time_period,
    "Transportation and Storage (H)" AS series,
    rate
FROM nace_h_rate

UNION ALL

SELECT
    time_period,
    "Italy cross-sector average" AS series,
    rate
FROM cross_sector_avg

ORDER BY
    time_period,
    series;