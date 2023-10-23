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
