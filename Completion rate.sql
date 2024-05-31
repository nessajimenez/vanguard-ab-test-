USE vanguard;

-- Completion Rate: clients that reached the 'confirm' step" 47,800
SELECT clients.client_id, COUNT(process_step)
FROM clients
JOIN interactions
ON clients.client_id = interactions.client_id
WHERE interactions.process_step = '4'
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
								WHERE interactions.process_step = '4')
GROUP BY clients.client_id;

--  Approx. 68% of people reached the confirm step

-- 18687 clients in the test group made it to the end
SELECT clients.client_id, COUNT(process_step)
FROM clients
JOIN interactions
ON clients.client_id = interactions.client_id
JOIN group_id
ON group_id.client_id = interactions.client_id
WHERE interactions.process_step = '4' AND group_id.variation = 'Test'
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
																WHERE interactions.process_step = '4' AND group_id.variation = 'Test')
GROUP BY clients.client_id;

-- 15434 people in the control group completed the process
SELECT clients.client_id,  COUNT(process_step)
FROM clients
JOIN interactions
ON clients.client_id = interactions.client_id
JOIN group_id
ON group_id.client_id = interactions.client_id
WHERE interactions.process_step = '4' AND group_id.variation = 'Control'
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
																WHERE interactions.process_step = '4' AND group_id.variation = 'Control')
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
    group_id.variation 
ORDER BY clients.client_id;

-- the count of how many times each client attempted a step, regardless of visit
SELECT clients.client_id,
		interactions.process_step,
        count(interactions.process_step) AS step_attempts
FROM clients
JOIN interactions
ON clients.client_id = interactions.client_id
GROUP BY process_step, client_id;

-- number of visits per client
#CREATE TEMPORARY TABLE visits AS
SELECT interactions.client_id AS client_id,
		count(visit_id) AS num_of_visits
FROM interactions
JOIN group_id
ON group_id.client_id = interactions.client_id
GROUP BY interactions.client_id
ORDER BY client_id;

-- 6.25 average visits per client
SELECT AVG(visits.num_of_visits)
FROM visits;

-- change steps to a logical order
UPDATE interactions
SET process_step = CASE 
    WHEN process_step = 'start' THEN '0'
    WHEN process_step = 'step_1' THEN '1'
    WHEN process_step = 'step_2' THEN '2'
    WHEN process_step = 'step_3' THEN '3'
    WHEN process_step = 'confirm' THEN '4'
    ELSE process_step
END;

-- how much time each client spent on each step by second
WITH time AS (
    SELECT 
        visit_id,
        client_id,
        process_step,
        date_time,
        LEAD(date_time) OVER (PARTITION BY visit_id, client_id ORDER BY process_step) AS next_step_time
    FROM interactions
)
SELECT 
    visit_id,
    client_id,
    process_step,
    date_time,
    next_step_time,
    TIMESTAMPDIFF(SECOND, date_time, next_step_time) AS time_difference_seconds
FROM time
GROUP BY visit_id,
    client_id,
    process_step, 
    date_time,
    next_step_time,
    time_difference_seconds
ORDER BY client_id, 
		visit_id, 
        process_step, 
        date_time;



-- problem is it's just showing me the same value twice, unless people went back to that step.
SELECT 
        visit_id,
        client_id,
        process_step,
        MIN(TIME(date_time)) AS min_time,
        MAX(TIME(date_time)) AS max_time
    FROM interactions
    GROUP BY client_id, visit_id, process_step;