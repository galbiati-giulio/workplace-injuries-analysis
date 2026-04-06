WITH base AS (
    SELECT
        category_id,
        subcategory_id,
        time_period,
        country_id,
        SUM(obs_value) AS subcat_value,
        SUM(m_casualties) AS male_value,
        SUM(f_casualties) AS female_value
    FROM WRI_CIRCUMSTANCE_HC10
    WHERE time_period BETWEEN 2014 AND 2023
    GROUP BY category_id, subcategory_id, time_period, country_id
),

top10_base AS (
    SELECT
        category_id,
        subcategory_id,
        time_period,
        SUM(subcat_value) AS subcat_value
    FROM base
    GROUP BY category_id, subcategory_id, time_period
),

category_totals AS (
    SELECT
        category_id,
        time_period,
        SUM(subcat_value) AS category_total
    FROM top10_base
    GROUP BY category_id, time_period
),

shares AS (
    SELECT
        b.category_id,
        b.subcategory_id,
        b.time_period,
        CAST(b.subcat_value AS REAL) / ct.category_total AS share_in_category
    FROM top10_base b
    JOIN category_totals ct
      ON b.category_id = ct.category_id
     AND b.time_period = ct.time_period
),

avg_shares AS (
    SELECT
        category_id,
        subcategory_id,
        AVG(share_in_category) AS avg_share
    FROM shares
    GROUP BY category_id, subcategory_id
),

ranked AS (
    SELECT
        category_id,
        subcategory_id,
        ROW_NUMBER() OVER (
            PARTITION BY category_id
            ORDER BY avg_share DESC
        ) AS rn
    FROM avg_shares
),

selected AS (
    SELECT
        category_id,
        subcategory_id
    FROM ranked
    WHERE rn <= 2
),

grouped AS (
    SELECT
        CASE
            WHEN country_id = 'IT' THEN 'Italy'
            ELSE 'Top10_excl_IT'
        END AS country_scope,
        category_id,
        subcategory_id,
        time_period,
        SUM(subcat_value) AS subcat_value,
        SUM(male_value) AS male_value,
        SUM(female_value) AS female_value
    FROM base
    GROUP BY
        country_scope,
        category_id,
        subcategory_id,
        time_period
),

shares_gender AS (
    SELECT
        g.country_scope,
        g.category_id,
        g.subcategory_id,
        g.time_period,
        CASE
            WHEN g.subcat_value > 0
            THEN CAST(g.male_value AS REAL) / g.subcat_value
        END AS male_share,
        CASE
            WHEN g.subcat_value > 0
            THEN CAST(g.female_value AS REAL) / g.subcat_value
        END AS female_share
    FROM grouped g
    JOIN selected s
      ON g.category_id = s.category_id
     AND g.subcategory_id = s.subcategory_id
),

avg_gender AS (
    SELECT
        country_scope,
        category_id,
        subcategory_id,
        ROUND(AVG(male_share) * 100,2) AS male_share_pct,
        ROUND(AVG(female_share) * 100,2) AS female_share_pct
    FROM shares_gender
    GROUP BY country_scope, category_id, subcategory_id
)

SELECT
    a.country_scope,
    c.category_description,
    sc.subcategory_description,
    'Male' AS gender,
    male_share_pct AS gender_share_pct
FROM avg_gender a
JOIN CIRCUMSTANCE_CATEGORIES c
  ON a.category_id = c.category_id
JOIN CIRCUMSTANCE_SUBCATEGORIES sc
  ON a.subcategory_id = sc.subcategory_id

UNION ALL

SELECT
    a.country_scope,
    c.category_description,
    sc.subcategory_description,
    'Female' AS gender,
    female_share_pct AS gender_share_pct
FROM avg_gender a
JOIN CIRCUMSTANCE_CATEGORIES c
  ON a.category_id = c.category_id
JOIN CIRCUMSTANCE_SUBCATEGORIES sc
  ON a.subcategory_id = sc.subcategory_id

ORDER BY
    country_scope,
    category_description,
    subcategory_description,
    gender;