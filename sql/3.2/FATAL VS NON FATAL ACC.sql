WITH annual_totals AS (
    SELECT
        time_period,
        SUM(CASE WHEN severity_id = 'FAT' THEN obs_value ELSE 0 END) AS fatal_casualties,
        SUM(CASE WHEN severity_id = 'D_GE4' THEN obs_value ELSE 0 END) AS nonfatal_casualties
    FROM WRI_TOTALS_HC10
    WHERE time_period BETWEEN 2014 AND 2023
    GROUP BY time_period
),
yearly AS (
    SELECT
        CAST(time_period AS TEXT) AS period,
        fatal_casualties,
        nonfatal_casualties,
        (fatal_casualties + nonfatal_casualties) AS total_casualties,
        ROUND(
            fatal_casualties * 100.0 /
            (fatal_casualties + nonfatal_casualties),
            3
        ) AS fatal_share_pct
    FROM annual_totals
),
overall AS (
    SELECT
        '2014–2023 Total' AS period,
        SUM(fatal_casualties) AS fatal_casualties,
        SUM(nonfatal_casualties) AS nonfatal_casualties,
        SUM(fatal_casualties + nonfatal_casualties) AS total_casualties,
        ROUND(
            SUM(fatal_casualties) * 100.0 /
            SUM(fatal_casualties + nonfatal_casualties),
            3
        ) AS fatal_share_pct
    FROM annual_totals
)
SELECT *
FROM yearly

UNION ALL

SELECT *
FROM overall;