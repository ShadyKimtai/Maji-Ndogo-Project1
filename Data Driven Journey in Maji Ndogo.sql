--Project 1 - Beginning Our Data-Driven Journey in Maji Ndogo
SHOW tables --List of all tables in the database
USE md_water_services; --Pull table from database
SHOW TABLES;
---Maji Ndogo Project
--Tables in database
data_dictionary
employee
global_water_access
location
water_quality
visits
water_source
well_pollution

SELECT *
FROM employee;

SELECT *
FROM data_dictionary;

SELECT *
FROM global_water_access;

SELECT *
FROM location
LIMIT 5;

WITH t1 as (
	SELECT q.record_id
	FROM water_quality q
	JOIN visits v ON v.record_id = q.record_id
	JOIN water_source s on s.source_id = v.source_id
    )
SELECT COUNT(*)
FROM t1
WHERE t1.subjective_quality_score = 10 and t1.visit_count = 2;


SELECT *
FROM water_quality q
JOIN visits v ON v.record_id = q.record_id
JOIN water_source s on s.source_id = v.source_id
WHERE q.subjective_quality_score = 10 and q.visit_count = 2
		and type_of_water_source LIKE 'tap_in_home';



SELECT *
FROM visits
LIMIT 5;

SELECT s.source_id, s.type_of_water_source, s.number_of_people_served
FROM visits v
JOIN water_source s
ON v.source_id = s.source_id
WHERE time_in_queue > 500 AND s.source_id LIKE 'HaZa21742224' OR s.source_id LIKE 'AkRu05234224'
		OR s.source_id LIKE 'AkLu01628224'  OR s.source_id LIKE 'SoRu36096224'
ORDER BY s.source_id
LIMIT 10;

SELECT distinct type_of_water_source
FROM water_source
LIMIT 5;

SELECT *
FROM water_source
LIMIT 5;

SELECT *
FROM well_pollution
WHERE pollutant_ppm > 0.01
LIMIT 10;

SET SQL_SAFE_UPDATES = 0;
UPDATE well_pollution
SET description = REPLACE(description, 'Clean Bacteria: Giardia Lamblia', 'Bacteria: Giardia Lamblia')
WHERE biological > 0.01 AND description LIKE 'Clean Bacteria: Giardia Lamblia';

UPDATE well_pollution
SET description = REPLACE(description, 'Clean Bacteria: E. coli', 'Bacteria: E. coli')
WHERE biological > 0.01 AND description LIKE 'Clean Bacteria: E. coli';

UPDATE well_pollution
SET results = REPLACE(results, 'Clean', 'Contaminated: Biological')
WHERE biological > 0.01 AND results LIKE 'Clean';

SELECT *
FROM well_pollution
WHERE biological > 0.01 AND results LIKE 'Clean';

UPDATE well_pollution
SET description = REPLACE(description, 'Clean%', '')
WHERE description LIKE 'Clean%';


SELECT employee_name, phone_number, position
FROM employee
WHERE position LIKE 'Micro biologist';

SELECT *
FROM employee
WHERE position = 'Civil Engineer' AND town_name = 'Dahabu'

SELECT *
FROM employee
WHERE
		(phone_number LIKE '%86%' OR phone_number LIKE '%11%')
        AND (employee_name LIKE '% A%' OR employee_name LIKE '% M%')
        AND position = 'Field Surveyor'

SELECT employee_name
FROM employee
WHERE
    (phone_number LIKE '%86%'
    OR phone_number LIKE '%11%')
    AND (employee_name LIKE '% A%'
    OR employee_name LIKE '% M%')
    AND position = 'Field Surveyor';


SELECT *
FROM water_source
WHERE number_of_people_served > 900
ORDER BY number_of_people_served DESC;

SELECT pop_n
FROM global_water_access
WHERE name LIKE 'Maji Ndogo';

SELECT *
FROM well_pollution
WHERE description LIKE 'Clean_%'
		OR results = 'Clean' AND biological < 0.01;


SELECT *
FROM well_pollution
WHERE description
IN ('Parasite: Cryptosporidium', 'biologically contaminated')
OR (results = 'Clean' AND biological > 0.01);

--Project 2 - Clustering data to unveil Maji Ndogo's Water crisis
USE md_water_services;
SHOW TABLES;


SELECT *
FROM employee;

SELECT REPLACE(employee_name, ' ','.')
FROM employee;

SELECT LOWER(REPLACE(employee_name, ' ','.')) as altered_employee_name
FROM employee;

SELECT CONCAT(LOWER(REPLACE(employee_name, ' ', '.')), '@ndogowater.gov') as new_email
FROM employee;

SET SQL_SAFE_UPDATES = 0;
UPDATE employee
SET email = CONCAT(LOWER(REPLACE(employee_name, ' ', '.')), '@ndogowater.gov');

SELECT LENGTH(phone_number)
FROM employee;

SELECT TRIM(phone_number)
FROM employee;

UPDATE employee
SET phone_number = TRIM(phone_number);

SELECT town_name, province_name, COUNT(*) as num_employees
FROM employee
WHERE town_name = 'Harare' AND province_name = 'Kilimani'
GROUP BY 1;

SELECT *
FROM employee;

SELECT e.assigned_employee_id, e.employee_name, e.email, e.phone_number, COUNT(v.visit_count) AS visit_count
FROM employee e
JOIN visits v ON e.assigned_employee_id = v.assigned_employee_id
GROUP BY 1, 2, 3, 4
ORDER BY visit_count asc
LIMIT 3;

SELECT assigned_employee_id, COUNT(assigned_employee_id) AS visit_count
FROM visits
GROUP BY 1
ORDER BY visit_count DESC;

SELECT *
FROM location;

SELECT town_name, COUNT(*) AS records_per_town
FROM location
GROUP BY 1
ORDER BY 2 DESC;

SELECT province_name, COUNT(*) AS records_per_province
FROM location
GROUP BY 1
ORDER BY 2 DESC;

SELECT province_name, town_name, COUNT(*) AS records_per_town
FROM location
GROUP BY 1, 2
ORDER BY 3 DESC;

SELECT location_type, COUNT(*) AS records_per_location
FROM location
GROUP BY 1
ORDER BY 2 DESC;

SELECT 23740/(23740+15910)*100 AS percentage_in_rural;

SELECT *
FROM water_source;

SELECT SUM(number_of_people_served) AS total_people_served
FROM water_source;

SELECT type_of_water_source, COUNT(DISTINCT source_id) as num_of_water_sources
FROM water_source
GROUP BY 1;

SELECT type_of_water_source, AVG(number_of_people_served) as avg_people_per_source
FROM water_source
GROUP BY 1;

SELECT type_of_water_source, SUM(number_of_people_served) as people_served_per_water_source
FROM water_source
GROUP BY 1
ORDER BY 2 DESC;

With t1 as(
	SELECT type_of_water_source, SUM(number_of_people_served) as people_served_per_water_source
	FROM water_source
	GROUP BY 1
	)
SELECT type_of_water_source,
	ROUND((people_served_per_water_source / (SELECT SUM(number_of_people_served) FROM water_source))*100, 0) as percentage_of_people_per_source
FROM t1
ORDER BY 2 DESC;

WITH water_source_summary AS (
    SELECT
        type_of_water_source,
        SUM(number_of_people_served) AS people_served_per_water_source
    FROM
        water_source
    GROUP BY
        type_of_water_source
)

SELECT
    type_of_water_source,
    ROUND((people_served_per_water_source / (SELECT SUM(number_of_people_served) FROM water_source)) * 100, 0) AS percentage_of_people_per_source
FROM
    water_source_summary
ORDER BY
    percentage_of_people_per_source DESC;


WITH t2 as(
	SELECT type_of_water_source, SUM(number_of_people_served) as people_served_per_water_source
	FROM water_source
	GROUP BY 1
    )
SELECT type_of_water_source, people_served_per_water_source, RANK() OVER (ORDER BY people_served_per_water_source DESC) as rank_by_population
FROM t2
ORDER BY 2 DESC;

WITH t3 as (
	SELECT DISTINCT source_id, type_of_water_source, AVG(number_of_people_served) as total_people_served
	FROM water_source
	GROUP BY 1, 2
	)
SELECT DISTINCT source_id, type_of_water_source, number_of_people_served,
					RANK() OVER (ORDER BY type_of_Water_source DESC) as priority_rank
FROM water_source
WHERE source_id = 'HaDj16848224'
GROUP BY 1, 2
ORDER BY 3;

SELECT *
FROM water_source
WHERE source_id = 'HaDj16848224';

SELECT *
FROM visits;

SELECT CONCAT(day(time_of_record), " ", monthname(time_of_record), " ", year(time_of_record)) FROM visits;

SELECT day(time_of_record), monthname(time_of_record), year(time_of_record) FROM visits;

SELECT CONCAT(monthname(time_of_record), " ", day(time_of_record), ", ", year(time_of_record)) FROM visits;

SELECT CONCAT(day(time_of_record), " ", month(time_of_record), " ", year(time_of_record)) FROM visits;

SELECT  LENGTH(address)
FROM employee
WHERE employee_name = 'Farai Nia';

SELECT TRIM(address)
FROM employee
WHERE employee_name = 'Farai Nia'

SELECT type_of_water_source, SUM(number_of_people_served) AS population_served
FROM water_source
WHERE type_of_water_source LIKE '%tap%'
GROUP BY type_of_water_source
ORDER BY population_served DESC;

--Question 10
SELECT *
FROM visits;

SELECT
    'Saturday 12:00-13:00' AS time_period,
    AVG(time_in_queue) AS average_queue_time
FROM
    visits
WHERE
    DAYNAME(time_of_record) = 'Saturday'
    AND TIME(time_of_record) BETWEEN '12:00:00' AND '13:00:00'

UNION

SELECT
    'Tuesday 18:00-19:00' AS time_period,
    AVG(time_in_queue) AS average_queue_time
FROM
    visits
WHERE
    DAYNAME(time_of_record) = 'Tuesday'
    AND TIME(time_of_record) BETWEEN '18:00:00' AND '19:00:00'

UNION

SELECT
    'Sunday 09:00-10:00' AS time_period,
    AVG(time_in_queue) AS average_queue_time
FROM
    visits
WHERE
    DAYNAME(time_of_record) = 'Sunday'
    AND TIME(time_of_record) BETWEEN '09:00:00' AND '10:00:00';
