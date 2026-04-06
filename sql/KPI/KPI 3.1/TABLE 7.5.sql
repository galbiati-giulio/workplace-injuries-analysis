WITH subcat_totals AS (
    SELECT
        category_id,
        subcategory_id,
        time_period,
        SUM(obs_value) AS yearly_casualties
    FROM WRI_CIRCUMSTANCE_HC10
    WHERE time_period BETWEEN 2014 AND 2023
    GROUP BY category_id, subcategory_id, time_period
),
subcat_avg AS (
    SELECT
        category_id,
        subcategory_id,
        AVG(yearly_casualties) AS avg_casualties
    FROM subcat_totals
    GROUP BY category_id, subcategory_id
),
category_totals AS (
    SELECT
        category_id,
        SUM(avg_casualties) AS category_avg_total
    FROM subcat_avg
    GROUP BY category_id
)

SELECT
    sca.category_id,
    cc.category_description AS category,
    sca.subcategory_id,
    sc.subcategory_description AS subcategory,
    ROUND(sca.avg_casualties, 0) AS "Avg Casualties",
    ROUND(
        100.0 * sca.avg_casualties / ct.category_avg_total,
        2
    ) AS "Share within Category (%)",
    ROW_NUMBER() OVER (
        PARTITION BY sca.category_id
        ORDER BY sca.avg_casualties DESC
    ) AS category_rank
FROM subcat_avg sca
JOIN category_totals ct
    ON sca.category_id = ct.category_id
JOIN CIRCUMSTANCE_CATEGORIES cc
    ON sca.category_id = cc.category_id
JOIN CIRCUMSTANCE_SUBCATEGORIES sc
    ON sca.subcategory_id = sc.subcategory_id
ORDER BY sca.category_id, category_rank;