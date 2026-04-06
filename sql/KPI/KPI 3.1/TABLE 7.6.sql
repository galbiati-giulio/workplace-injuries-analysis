WITH yearly_sector AS (
    SELECT
        'Transportation and Storage (H)' AS sector,
        sex_id,
        time_period,
        SUM(obs_value) AS employment
    FROM EMPLOYMENT_ITAU
    WHERE activity_id = 'H'
      AND country_id = 'IT'
      AND time_period BETWEEN 2014 AND 2023
      AND sex_id IN ('M', 'F')
    GROUP BY sex_id, time_period
),
yearly_total AS (
    SELECT
        'Total Economy (A–U)' AS sector,
        sex_id,
        time_period,
        SUM(obs_value) AS employment
    FROM EMPLOYMENT_ITAU
    WHERE country_id = 'IT'
      AND time_period BETWEEN 2014 AND 2023
      AND sex_id IN ('M', 'F')
    GROUP BY sex_id, time_period
),
combined AS (
    SELECT * FROM yearly_sector
    UNION ALL
    SELECT * FROM yearly_total
),
avg_by_gender AS (
    SELECT
        sector,
        sex_id,
        AVG(employment) AS avg_employment
    FROM combined
    GROUP BY sector, sex_id
),
sector_totals AS (
    SELECT
        sector,
        SUM(avg_employment) AS total_avg_employment
    FROM avg_by_gender
    GROUP BY sector
)

SELECT
    a.sector,
    ROUND(SUM(CASE WHEN a.sex_id = 'M' THEN a.avg_employment END), 0) AS "Male Employment",
    ROUND(SUM(CASE WHEN a.sex_id = 'F' THEN a.avg_employment END), 0) AS "Female Employment",
    ROUND(
        100.0 * SUM(CASE WHEN a.sex_id = 'M' THEN a.avg_employment END) / st.total_avg_employment,
        2
    ) AS "Male Employment Share (%)",
    ROUND(
        100.0 * SUM(CASE WHEN a.sex_id = 'F' THEN a.avg_employment END) / st.total_avg_employment,
        2
    ) AS "Female Employment Share (%)"
FROM avg_by_gender a
JOIN sector_totals st
    ON a.sector = st.sector
GROUP BY a.sector, st.total_avg_employment
ORDER BY
    CASE
        WHEN a.sector = 'Transportation and Storage (H)' THEN 1
        WHEN a.sector = 'Total Economy (A–U)' THEN 2
    END;