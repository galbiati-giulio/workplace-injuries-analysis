WITH yearly_activity AS (
    SELECT
        activity_id,
        sex_id,
        time_period,
        SUM(obs_value) AS employment
    FROM EMPLOYMENT_ITAU
    WHERE country_id = 'IT'
      AND time_period BETWEEN 2014 AND 2023
      AND sex_id IN ('M','F')
    GROUP BY activity_id, sex_id, time_period
),

avg_by_gender AS (
    SELECT
        activity_id,
        sex_id,
        AVG(employment) AS avg_employment
    FROM yearly_activity
    GROUP BY activity_id, sex_id
),

activity_totals AS (
    SELECT
        activity_id,
        SUM(avg_employment) AS total_avg_employment
    FROM avg_by_gender
    GROUP BY activity_id
),

activity_table AS (
    SELECT
        a.activity_id,
        a.activity_description AS activity,
        ROUND(SUM(CASE WHEN g.sex_id='M' THEN g.avg_employment END),0) AS male_employment,
        ROUND(SUM(CASE WHEN g.sex_id='F' THEN g.avg_employment END),0) AS female_employment,
        ROUND(
            100.0 * SUM(CASE WHEN g.sex_id='M' THEN g.avg_employment END) / t.total_avg_employment,
            2
        ) AS male_share,
        ROUND(
            100.0 * SUM(CASE WHEN g.sex_id='F' THEN g.avg_employment END) / t.total_avg_employment,
            2
        ) AS female_share
    FROM avg_by_gender g
    JOIN activity_totals t
        ON g.activity_id = t.activity_id
    JOIN ACTIVITIES a
        ON g.activity_id = a.activity_id
    GROUP BY
        a.activity_id,
        a.activity_description,
        t.total_avg_employment
),

total_economy AS (
    SELECT
        'A-U' AS activity_id,
        'Total Economy (A–U)' AS activity,
        ROUND(SUM(male_employment),0) AS male_employment,
        ROUND(SUM(female_employment),0) AS female_employment,
        ROUND(
            100.0 * SUM(male_employment) /
            (SUM(male_employment)+SUM(female_employment)),
            2
        ) AS male_share,
        ROUND(
            100.0 * SUM(female_employment) /
            (SUM(male_employment)+SUM(female_employment)),
            2
        ) AS female_share
    FROM activity_table
)

SELECT
    activity_id,
    activity,
    male_employment AS "Male Employment",
    female_employment AS "Female Employment",
    male_share AS "Male Employment Share (%)",
    female_share AS "Female Employment Share (%)"
FROM activity_table

UNION ALL

SELECT
    activity_id,
    activity,
    male_employment,
    female_employment,
    male_share,
    female_share
FROM total_economy

ORDER BY activity_id;