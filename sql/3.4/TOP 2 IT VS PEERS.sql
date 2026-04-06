WITH top2_base AS (
    SELECT
        category_id,
        subcategory_id,
        time_period,
        SUM(obs_value) AS subcat_value
    FROM WRI_CIRCUMSTANCE_HC10
    WHERE time_period BETWEEN 2014 AND 2023
    GROUP BY category_id, subcategory_id, time_period
),
top2_category_totals AS (
    SELECT
        category_id,
        time_period,
        SUM(subcat_value) AS category_total
    FROM top2_base
    GROUP BY category_id, time_period
),
top2_shares AS (
    SELECT
        b.category_id,
        b.subcategory_id,
        b.time_period,
        CAST(b.subcat_value AS REAL) / ct.category_total AS share_in_category
    FROM top2_base b
    JOIN top2_category_totals ct
      ON b.category_id = ct.category_id
     AND b.time_period = ct.time_period
),
top2_avg AS (
    SELECT
        category_id,
        subcategory_id,
        AVG(share_in_category) AS avg_share
    FROM top2_shares
    GROUP BY category_id, subcategory_id
),
top2_ranked AS (
    SELECT
        category_id,
        subcategory_id,
        avg_share,
        ROW_NUMBER() OVER (
            PARTITION BY category_id
            ORDER BY avg_share DESC, subcategory_id
        ) AS rn
    FROM top2_avg
),
selected_top2 AS (
    SELECT
        category_id,
        subcategory_id
    FROM top2_ranked
    WHERE rn <= 2
),
grouped_base AS (
    SELECT
        w.category_id,
        w.subcategory_id,
        w.time_period,
        CASE
            WHEN w.country_id = 'IT' THEN 'Italy'
            ELSE 'Top-10 excl. Italy'
        END AS country_group,
        SUM(w.obs_value) AS subcat_value
    FROM WRI_CIRCUMSTANCE_HC10 w
    JOIN selected_top2 t
      ON w.category_id = t.category_id
     AND w.subcategory_id = t.subcategory_id
    WHERE w.time_period BETWEEN 2014 AND 2023
      AND (
            w.country_id = 'IT'
            OR w.country_id <> 'IT'
          )
    GROUP BY
        w.category_id,
        w.subcategory_id,
        w.time_period,
        country_group
),
grouped_category_totals AS (
    SELECT
        category_id,
        time_period,
        country_group,
        SUM(subcat_value) AS category_total
    FROM grouped_base
    GROUP BY
        category_id,
        time_period,
        country_group
),
grouped_shares AS (
    SELECT
        gb.category_id,
        gb.subcategory_id,
        gb.time_period,
        gb.country_group,
        CAST(gb.subcat_value AS REAL) / gct.category_total AS share_in_category
    FROM grouped_base gb
    JOIN grouped_category_totals gct
      ON gb.category_id = gct.category_id
     AND gb.time_period = gct.time_period
     AND gb.country_group = gct.country_group
),
final_avg AS (
    SELECT
        category_id,
        subcategory_id,
        country_group,
        ROUND(AVG(share_in_category) * 100, 2) AS avg_share_pct
    FROM grouped_shares
    GROUP BY
        category_id,
        subcategory_id,
        country_group
)
SELECT
    c.category_description,
    sc.subcategory_description,
    f.country_group,
    f.avg_share_pct
FROM final_avg f
JOIN CIRCUMSTANCE_CATEGORIES c
  ON f.category_id = c.category_id
JOIN CIRCUMSTANCE_SUBCATEGORIES sc
  ON f.subcategory_id = sc.subcategory_id
ORDER BY
    c.category_description,
    sc.subcategory_description,
    CASE
        WHEN f.country_group = 'Italy' THEN 1
        ELSE 2
    END;