WITH activity_year AS (
    SELECT
        activity_id,
        time_period,
        SUM(obs_value) AS total_employment
    FROM EMPLOYMENT_ITAU
    WHERE country_id = 'IT'
      AND time_period BETWEEN 2014 AND 2023
    GROUP BY activity_id, time_period
),
activity_avg AS (
    SELECT
        activity_id,
        ROUND(AVG(total_employment), 1) AS avg_employment_2014_2023
    FROM activity_year
    GROUP BY activity_id
)
SELECT
    activity_id,
    avg_employment_2014_2023,
    CASE
        WHEN activity_id = 'A' THEN 'A Agriculture, forestry and fishing'
        WHEN activity_id = 'B' THEN 'B Mining and quarrying'
        WHEN activity_id = 'C' THEN 'C Manufacturing'
        WHEN activity_id = 'D' THEN 'D Electricity, gas, steam and air conditioning supply'
        WHEN activity_id = 'E' THEN 'E Water supply; sewerage, waste management and remediation'
        WHEN activity_id = 'F' THEN 'F Construction'
        WHEN activity_id = 'G' THEN 'G Wholesale and retail trade; repair of motor vehicles and motorcycles'
        WHEN activity_id = 'H' THEN 'H Transportation and storage'
        WHEN activity_id = 'I' THEN 'I Accommodation and food service activities'
        WHEN activity_id = 'J' THEN 'J Information and communication'
        WHEN activity_id = 'K' THEN 'K Financial and insurance activities'
        WHEN activity_id = 'L' THEN 'L Real estate activities'
        WHEN activity_id = 'M' THEN 'M Professional, scientific and technical activities'
        WHEN activity_id = 'N' THEN 'N Administrative and support service activities'
        WHEN activity_id = 'O' THEN 'O Public administration and defence; compulsory social security'
        WHEN activity_id = 'P' THEN 'P Education'
        WHEN activity_id = 'Q' THEN 'Q Human health and social work activities'
        WHEN activity_id = 'R' THEN 'R Arts, entertainment and recreation'
        WHEN activity_id = 'S' THEN 'S Other service activities'
        WHEN activity_id = 'T' THEN 'T Activities of households as employers; undifferentiated goods- and services-producing activities'
        WHEN activity_id = 'U' THEN 'U Activities of extraterritorial organisations and bodies'
        ELSE activity_id
    END AS activity_label,
    CASE
        WHEN activity_id = 'H' THEN 'Transportation and Storage'
        ELSE 'Other sectors'
    END AS highlight_group
FROM activity_avg
ORDER BY avg_employment_2014_2023 DESC;