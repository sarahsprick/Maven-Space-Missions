/*
Recommended Analysis questions provided by Maven Analytics

1. How have rocket launches trended across time? Has mission success rate increased?
2. Which countries have had the most successful space missions? Has it always been that way?
3. Which rocket has been used for the most space missions? Is it still active?
4. Are there any patterns you can notice with the launch locations?
*/

--DATA EXPLORATION

--Number of missions attempted per year

SELECT DISTINCT 
	LEFT(date, 4) AS year
	, COUNT(mission) AS 'Count'
FROM projects..spacemissions
GROUP BY LEFT(date, 4)
ORDER BY LEFT(date, 4)

--Success rate (mission_status = 'Success'/ total missions) by year

WITH cte AS (
	SELECT *
		, CASE WHEN missionstatus = 'Success' THEN 1 ELSE 0 END AS status_success
	FROM projects..spacemissions
)
SELECT LEFT(date, 4) AS year
	, ROUND(((CAST(SUM(status_success) AS FLOAT)/CAST(COUNT(status_success) AS FLOAT)) * 100), 2) AS success_rate
FROM cte
GROUP BY LEFT(date, 4)

--Success and failure rates by country

WITH cte AS (
	SELECT *
		, CASE WHEN missionstatus = 'Success' THEN 1 ELSE 0 END AS status_success
		, CASE WHEN missionstatus = 'Failure' THEN 1 ELSE 0 END AS status_fail
		, REVERSE(left(REVERSE(REPLACE((location), ',', '.')), charindex('.', REVERSE(REPLACE((location), ',', '.')))-1)) AS country
	FROM projects..spacemissions
)
SELECT country
	, ROUND(((CAST(SUM(status_success) AS FLOAT)/CAST(COUNT(mission) AS FLOAT)) * 100), 2) AS success_rate
	, ROUND(((CAST(SUM(status_fail) AS FLOAT)/CAST(COUNT(mission) AS FLOAT)) * 100), 2) AS failture_rate
FROM cte
GROUP BY country

--Total number of rockets

SELECT COUNT(DISTINCT(rocket)) AS total_rocket_count
FROM projects..spacemissions

--Number of rockets per country

WITH cte AS (
	SELECT *
		, REVERSE(left(REVERSE(REPLACE((location), ',', '.')), charindex('.', REVERSE(REPLACE((location), ',', '.')))-1)) AS country
	FROM projects..spacemissions
)
SELECT country, COUNT(DISTINCT(rocket)) AS total_rocket_count
FROM cte
GROUP BY country
ORDER BY COUNT(DISTINCT(rocket)) DESC

--Number of countries and launch locations

WITH cte AS (
	SELECT *
		, REVERSE(left(REVERSE(REPLACE((location), ',', '.')), charindex('.', REVERSE(REPLACE((location), ',', '.')))-1)) AS country
	FROM projects..spacemissions
)
SELECT COUNT(DISTINCT(country)) AS country_count
	, COUNT(DISTINCT(location)) AS unique_location
FROM cte

--Total cost

WITH cte AS (
	SELECT *
		, CAST((REPLACE(price, ',', '')) AS float) as price_updated
	FROM projects..spacemissions
)
SELECT SUM(price_updated * 1000000) AS total_cost
FROM cte

--Total cost by country, added success and fail rates to see whether there was a connection between money spent and success

WITH cte AS (
	SELECT *
		, CAST((REPLACE(price, ',', '')) AS float) as price_updated
		, REVERSE(left(REVERSE(REPLACE((location), ',', '.')), charindex('.', REVERSE(REPLACE((location), ',', '.')))-1)) AS [country]
		, CASE WHEN missionstatus = 'Success' THEN 1 ELSE 0 END AS status_success
		, CASE WHEN missionstatus = 'Failure' THEN 1 ELSE 0 END AS status_fail
	FROM projects..spacemissions
)
SELECT country
	, SUM(price_updated * 1000000) AS total_cost
	, ROUND(((CAST(SUM(status_success) AS FLOAT)/CAST(COUNT(mission) AS FLOAT)) * 100), 2) AS success_rate
	, ROUND(((CAST(SUM(status_fail) AS FLOAT)/CAST(COUNT(mission) AS FLOAT)) * 100), 2) AS failture_rate
FROM cte
GROUP BY country
ORDER BY SUM(price_updated * 1000000) DESC

-- Final query used for Tableau file (filled NULLs with 0s)

WITH cte AS (
	SELECT *
		, CASE WHEN missionstatus = 'Success' THEN 1 ELSE 0 END AS status_success
		, CASE WHEN missionstatus = 'Partial Failure' THEN 1 ELSE 0 END AS status_part_fail
		, CASE WHEN missionstatus = 'Prelaunch Failure' THEN 1 ELSE 0 END AS status_pre_fail
		, CASE WHEN missionstatus = 'Failure' THEN 1 ELSE 0 END AS status_fail
		, REVERSE(left(REVERSE(REPLACE((location), ',', '.')), charindex('.', REVERSE(REPLACE((location), ',', '.')))-1)) AS [country]
		, REVERSE(REVERSE(PARSENAME(REPLACE((location), ',', '.'), 2))) AS [state]
		, REVERSE(REVERSE(PARSENAME(REPLACE((location), ',', '.'), 3))) AS [base]
		, REVERSE(REVERSE(PARSENAME(REPLACE((location), ',', '.'), 4))) AS [site]
		, REVERSE(REVERSE(PARSENAME(REPLACE((date), '-', '.'), 3))) AS [year]
		, CAST((REPLACE(price, ',', '')) AS float) as price_updated
	FROM projects..spacemissions
)
SELECT *
	, price_updated * 1000000 as price_final
FROM cte

