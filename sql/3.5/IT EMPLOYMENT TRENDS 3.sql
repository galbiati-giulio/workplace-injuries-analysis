WITH yearly_employment AS (
    SELECT
        activity_id,
        time_period,
        SUM(obs_value) AS employment
    FROM EMPLOYMENT_ITAU
    WHERE country_id = 'IT'
      AND time_period BETWEEN 2014 AND 2023
    GROUP BY activity_id, time_period
),

sector_groups AS (
    SELECT
        activity_id,
        time_period,
        employment,
        CASE
            WHEN activity_id = 'H'
                THEN 'Transportation & Storage (H)'
            WHEN activity_id IN ('G','C','Q')
                THEN 'Top sectors (G, C, Q)'
            WHEN activity_id IN ('F','I','O')
                THEN 'Medium sectors (F, I, O)'
            WHEN activity_id IN ('M','N','J')
                THEN 'Medium-low sectors (M, N, J)'
            ELSE 'Low sectors (A,B,D,E,K,L,R,S,T,U)'
        END AS sector_group
    FROM yearly_employment
),

group_totals AS (
    SELECT
        sector_group,
        time_period,
        SUM(employment) AS employment
    FROM sector_groups
    GROUP BY sector_group, time_period
),

total_economy AS (
    SELECT
        'Total Economy (A–U)' AS sector_group,
        time_period,
        SUM(employment) AS employment
    FROM yearly_employment
    GROUP BY time_period
)

SELECT *
FROM group_totals

UNION ALL

SELECT *
FROM total_economy

ORDER BY sector_group, time_period;