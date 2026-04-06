WITH base AS (
    SELECT
        category_id,
        subcategory_id,
        time_period,
        SUM(obs_value) AS subcat_value
    FROM WRI_CIRCUMSTANCE_HC10
    WHERE time_period BETWEEN 2014 AND 2023
      AND country_id = 'IT'
    GROUP BY category_id, subcategory_id, time_period
),
category_totals AS (
    SELECT
        category_id,
        time_period,
        SUM(subcat_value) AS category_total
    FROM base
    GROUP BY category_id, time_period
),
shares AS (
    SELECT
        b.category_id,
        b.subcategory_id,
        b.time_period,
        CAST(b.subcat_value AS REAL) / ct.category_total AS share_in_category
    FROM base b
    JOIN category_totals ct
      ON b.category_id = ct.category_id
     AND b.time_period = ct.time_period
),
avg_shares AS (
    SELECT
        category_id,
        subcategory_id,
        ROUND(AVG(share_in_category) * 100, 2) AS avg_share_pct
    FROM shares
    GROUP BY category_id, subcategory_id
),
ranked AS (
    SELECT
        category_id,
        subcategory_id,
        avg_share_pct,
        ROW_NUMBER() OVER (
            PARTITION BY category_id
            ORDER BY avg_share_pct DESC, subcategory_id
        ) AS rn
    FROM avg_shares
)
SELECT
    c.category_description,
    sc.subcategory_description,
    r.avg_share_pct
FROM ranked r
JOIN CIRCUMSTANCE_CATEGORIES c
  ON r.category_id = c.category_id
JOIN CIRCUMSTANCE_SUBCATEGORIES sc
  ON r.subcategory_id = sc.subcategory_id
WHERE r.rn <= 2
ORDER BY
    c.category_description,
    r.avg_share_pct DESC;