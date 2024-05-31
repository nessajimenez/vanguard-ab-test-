USE vanguard;

-- Completion Rate: clients that reached the 'confirm' step" 47,800
SELECT clients.client_id, COUNT(process_step)
FROM clients
JOIN interactions
ON clients.client_id = interactions.client_id
WHERE interactions.process_step = 'confirm'
GROUP BY clients.client_id;

-- Completion Rate: clients that did not reach the 'confirm' step: 22,809
SELECT clients.client_id, COUNT(process_step)
FROM clients
JOIN interactions
ON clients.client_id = interactions.client_id
WHERE clients.client_id NOT IN (SELECT clients.client_id
								FROM clients
								JOIN interactions
								ON clients.client_id = interactions.client_id
								WHERE interactions.process_step = 'confirm')
GROUP BY clients.client_id;

--  Approx. 68% of people reached the confirm step

-- 18687 clients in the test group made it to the end
SELECT clients.client_id, COUNT(process_step)
FROM clients
JOIN interactions
ON clients.client_id = interactions.client_id
JOIN group_id
ON group_id.client_id = interactions.client_id
WHERE interactions.process_step = 'confirm' AND group_id.variation = 'Test'
GROUP BY clients.client_id;

-- 8281 people in the test did not complete the process
SELECT clients.client_id, COUNT(process_step)
FROM clients
JOIN interactions
ON clients.client_id = interactions.client_id
JOIN group_id
ON group_id.client_id = interactions.client_id
WHERE group_id.variation = 'Test' AND group_id.client_id NOT IN (SELECT clients.client_id
																FROM clients
																JOIN interactions
																ON clients.client_id = interactions.client_id
																JOIN group_id
																ON group_id.client_id = interactions.client_id
																WHERE interactions.process_step = 'confirm' AND group_id.variation = 'Test')
GROUP BY clients.client_id;

-- 15434 people in the control group completed the process
SELECT clients.client_id,  COUNT(process_step)
FROM clients
JOIN interactions
ON clients.client_id = interactions.client_id
JOIN group_id
ON group_id.client_id = interactions.client_id
WHERE interactions.process_step = 'confirm' AND group_id.variation = 'Control'
GROUP BY clients.client_id;

-- 8098 people in the control group did not complete the process
SELECT clients.client_id, COUNT(process_step)
FROM clients
JOIN interactions
ON clients.client_id = interactions.client_id
JOIN group_id
ON group_id.client_id = interactions.client_id
WHERE group_id.variation = 'Control' AND clients.client_id NOT IN (SELECT clients.client_id
																FROM clients
																JOIN interactions
																ON clients.client_id = interactions.client_id
																JOIN group_id
																ON group_id.client_id = interactions.client_id
																WHERE interactions.process_step = 'confirm' AND group_id.variation = 'Control')
GROUP BY clients.client_id;

-- 26,968 were IN the test group
SELECT distinct(clients.client_id)
FROM clients
JOIN group_id
ON group_id.client_id = clients.client_id
WHERE group_id.variation = 'Test';

-- 23532 were in the control group
SELECT COUNT(clients.client_id)
FROM clients
JOIN group_id
ON group_id.client_id = clients.client_id
WHERE group_id.variation = 'Control';

-- 20109 were in neither group
SELECT * 
FROM group_id 
WHERE group_id.variation IS NULL;

-- dropping those in neither group
DELETE FROM group_id WHERE variation IS NULL;

-- making column datetime
ALTER TABLE interactions
MODIFY date_time DATETIME;

-- all data on those in the test group 
SELECT *
FROM clients
JOIN interactions
ON clients.client_id = interactions.client_id
JOIN group_id
ON group_id.client_id = interactions.client_id
WHERE group_id.variation = 'Test';

-- all data on those in the control group 
SELECT *
FROM clients
JOIN interactions
ON clients.client_id = interactions.client_id
JOIN group_id
ON group_id.client_id = interactions.client_id
WHERE group_id.variation = 'Control';


-- WITH StepDurations AS (
--     SELECT 
--         a.client_id,
--         b.process_step AS current_step,
--         MIN(b.date_time) AS next_step_time,
--         TIMESTAMPDIFF(SECOND, a.date_time, MIN(b.date_time)) AS duration_seconds
--     FROM 
--         interactions a
--     LEFT JOIN 
--         interactions b
--     ON 
--         a.client_id = b.client_id
--         AND a.date_time < b.date_time
--     GROUP BY 
--         a.client_id, b.process_step, a.date_time
-- )

-- SELECT 
--     current_step,
--     AVG(duration_seconds) AS average_duration_seconds
-- FROM 
--     StepDurations
-- GROUP BY 
--     current_step
-- ORDER BY 
--     current_step;
    
    
-- How far each person got in the process    
SELECT clients.client_id,
	clients.clnt_age, 
    clients.gendr, 
    COUNT(distinct(interactions.process_step)) AS count_of_steps,
    group_id.variation
FROM clients
JOIN interactions
ON clients.client_id = interactions.client_id
INNER JOIN group_id
ON group_id.client_id = clients.client_id
GROUP BY clients.client_id, clients.clnt_age, clients.gendr,group_id.variation;

-- how many of each step, even if they repeated
SELECT clients.client_id,
	clients.clnt_age, 
    clients.gendr, 
    COUNT(interactions.process_step) AS count_of_steps,
    group_id.variation
FROM clients
JOIN interactions
ON clients.client_id = interactions.client_id
INNER JOIN group_id
ON group_id.client_id = clients.client_id
GROUP BY clients.client_id, clients.clnt_age, clients.gendr,group_id.variation
ORDER BY count_of_steps desc;

-- how many steps even if they repeated, by group they were in
SELECT clients.client_id, 
	interactions.visit_id,
	clients.clnt_age, 
    clients.gendr, 
    group_id.variation,
	COUNT(interactions.process_step) AS count_of_steps
FROM clients
JOIN interactions
ON clients.client_id = interactions.client_id
INNER JOIN group_id
ON group_id.client_id = clients.client_id
GROUP BY clients.client_id, interactions.visit_id,
	clients.clnt_age, 
    clients.gendr, 
    group_id.variation ;