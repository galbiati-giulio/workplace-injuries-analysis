SELECT 
    country_id,
    SUM(CASE WHEN time_period = 2014 THEN obs_value END) AS "2014",
    SUM(CASE WHEN time_period = 2015 THEN obs_value END) AS "2015",
    SUM(CASE WHEN time_period = 2016 THEN obs_value END) AS "2016",
    SUM(CASE WHEN time_period = 2017 THEN obs_value END) AS "2017",
    SUM(CASE WHEN time_period = 2018 THEN obs_value END) AS "2018",
    SUM(CASE WHEN time_period = 2019 THEN obs_value END) AS "2019",
    SUM(CASE WHEN time_period = 2020 THEN obs_value END) AS "2020",
    SUM(CASE WHEN time_period = 2021 THEN obs_value END) AS "2021",
    SUM(CASE WHEN time_period = 2022 THEN obs_value END) AS "2022",
	SUM(CASE WHEN time_period = 2023 THEN obs_value END) AS "2023"
FROM WRI_TOTALS_HC10
GROUP BY country_id
ORDER BY country_id;