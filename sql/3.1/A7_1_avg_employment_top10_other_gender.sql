WITH country_year_sex AS (
    SELECT
        country_id,
        time_period,
        sex_id,
        SUM(obs_value) AS employment
    FROM EMPLOYMENT_H36C
    WHERE activity_id = 'H'
      AND age_id = 'Y_GE15'
      AND time_period BETWEEN 2014 AND 2023
      AND country_id NOT IN ('UK', 'TR')
    GROUP BY country_id, time_period, sex_id
),

country_year_total AS (
    SELECT
        country_id,
        time_period,
        SUM(employment) AS total_employment
    FROM country_year_sex
    GROUP BY country_id, time_period
),

country_avg AS (
    SELECT
        country_id,
        AVG(total_employment) AS avg_employment
    FROM country_year_total
    GROUP BY country_id
),

top10 AS (
    SELECT country_id
    FROM country_avg
    ORDER BY avg_employment DESC
    LIMIT 10
),

grouped_year_sex AS (
    SELECT
        CASE
            WHEN country_id IN (SELECT country_id FROM top10) THEN country_id
            ELSE 'Other'
        END AS country_group,
        time_period,
        sex_id,
        SUM(employment) AS employment
    FROM country_year_sex
    GROUP BY
        CASE
            WHEN country_id IN (SELECT country_id FROM top10) THEN country_id
            ELSE 'Other'
        END,
        time_period,
        sex_id
),

grouped_year_total AS (
    SELECT
        country_group,
        time_period,
        SUM(employment) AS total_employment,
        SUM(CASE WHEN sex_id = 'F' THEN employment ELSE 0 END) AS female_employment,
        SUM(CASE WHEN sex_id = 'M' THEN employment ELSE 0 END) AS male_employment
    FROM grouped_year_sex
    GROUP BY country_group, time_period
),

final AS (
    SELECT
        country_group,
        AVG(total_employment) AS avg_employment,
        AVG(female_employment) AS avg_female_employment,
        AVG(male_employment) AS avg_male_employment
    FROM grouped_year_total
    GROUP BY country_group
),

grand_total AS (
    SELECT SUM(avg_employment) AS total_avg_employment
    FROM final
)

SELECT
    f.country_group,
    ROUND(f.avg_employment, 2) AS avg_employment,
    ROUND(f.avg_employment * 100.0 / g.total_avg_employment, 2) AS pct_of_total,
    ROUND(f.avg_female_employment * 100.0 / f.avg_employment, 2) AS female_share_pct,
    ROUND(f.avg_male_employment * 100.0 / f.avg_employment, 2) AS male_share_pct
FROM final f
CROSS JOIN grand_total g
ORDER BY
    CASE WHEN f.country_group = 'Other' THEN 2 ELSE 1 END,
    f.avg_employment DESC;