WITH yearly_activity_sex AS (
    SELECT
        activity_id,
        time_period,
        sex_id,
        SUM(obs_value) AS employment
    FROM EMPLOYMENT_ITAU
    WHERE country_id = 'IT'
      AND time_period BETWEEN 2014 AND 2023
      AND sex_id IN ('M', 'F')
    GROUP BY activity_id, time_period, sex_id
),

h_avg AS (
    SELECT
        'Transportation and Storage (H)' AS group_name,
        sex_id,
        ROUND(AVG(employment), 1) AS avg_employment
    FROM yearly_activity_sex
    WHERE activity_id = 'H'
    GROUP BY sex_id
),

total_au_yearly AS (
    SELECT
        time_period,
        sex_id,
        SUM(employment) AS employment
    FROM yearly_activity_sex
    GROUP BY time_period, sex_id
),

total_au_avg AS (
    SELECT
        'Total Economy (A–U)' AS group_name,
        sex_id,
        ROUND(AVG(employment), 1) AS avg_employment
    FROM total_au_yearly
    GROUP BY sex_id
),

combined AS (
    SELECT * FROM h_avg
    UNION ALL
    SELECT * FROM total_au_avg
),

totals AS (
    SELECT
        group_name,
        SUM(avg_employment) AS group_total
    FROM combined
    GROUP BY group_name
)

SELECT
    c.group_name,
    c.sex_id,
    c.avg_employment,
    ROUND((c.avg_employment * 100.0) / t.group_total, 1) AS employment_share_pct,
    CASE
        WHEN c.sex_id = 'M' THEN 'Male'
        WHEN c.sex_id = 'F' THEN 'Female'
        ELSE c.sex_id
    END AS sex_label
FROM combined c
JOIN totals t
    ON c.group_name = t.group_name
ORDER BY
    CASE WHEN c.group_name = 'Transportation and Storage (H)' THEN 1 ELSE 2 END,
    CASE WHEN c.sex_id = 'M' THEN 1 ELSE 2 END;