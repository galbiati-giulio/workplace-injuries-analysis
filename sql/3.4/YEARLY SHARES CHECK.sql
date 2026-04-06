WITH base AS (
    SELECT
        category_id,
        subcategory_id,
        time_period,
        SUM(obs_value) AS subcat_value
    FROM WRI_CIRCUMSTANCE_HC10
    WHERE time_period BETWEEN 2014 AND 2023
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
)
SELECT
    c.category_description,
    s.time_period,
    ROUND(SUM(s.share_in_category) * 100, 2) AS total_share_pct
FROM shares s
JOIN CIRCUMSTANCE_CATEGORIES c
  ON s.category_id = c.category_id
GROUP BY
    c.category_description,
    s.time_period
ORDER BY
    c.category_description,
    s.time_period;