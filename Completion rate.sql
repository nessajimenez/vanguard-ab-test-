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

-- 26679 people in the test group started the process
SELECT clients.client_id, COUNT(process_step)
FROM clients
JOIN interactions
ON clients.client_id = interactions.client_id
JOIN group_id
ON group_id.client_id = interactions.client_id
WHERE interactions.process_step = 'start' AND group_id.variation = 'Test'
GROUP BY clients.client_id;

-- 23397 started in the control group
SELECT clients.client_id,  COUNT(process_step)
FROM clients
JOIN interactions
ON clients.client_id = interactions.client_id
JOIN group_id
ON group_id.client_id = interactions.client_id
WHERE interactions.process_step = 'start' AND group_id.variation != 'Test'
GROUP BY clients.client_id;

-- 23496 completed in the control group
SELECT clients.client_id, COUNT(process_step)
FROM clients
JOIN interactions
ON clients.client_id = interactions.client_id
JOIN group_id
ON group_id.client_id = interactions.client_id
WHERE interactions.process_step != 'confirm' AND group_id.variation != 'Test'
GROUP BY clients.client_id;

-- 26,968 were IN the test group
SELECT distinct(clients.client_id)
FROM clients
JOIN group_id
ON group_id.client_id = clients.client_id
WHERE group_id.variation = 'Test';

-- 23532 were NOT in the test group
SELECT COUNT(clients.client_id)
FROM clients
JOIN group_id
ON group_id.client_id = clients.client_id
WHERE group_id.variation != 'Test';

-- 20109 were in neither group
SELECT * 
FROM group_id 
WHERE group_id.variation IS NULL;

-- dropping those in neither group
DELETE FROM group_id WHERE variation IS NULL;

-- making column datetime
ALTER TABLE interactions
MODIFY date_time DATETIME;

SELECT * 
FROM clients
JOIN group_id;

SELECT *
FROM clients
JOIN interactions
ON clients.client_id = interactions.client_id
JOIN group_id
ON group_id.client_id = interactions.client_id
WHERE interactions.process_step != 'confirm' AND group_id.variation != 'Test';



WITH StepDurations AS (
    SELECT 
        interactions.user_id,
        interactions.process_step AS current_step,
        MIN(b.step_datetime) AS next_step_time,
        TIMESTAMPDIFF(SECOND, a.step_datetime, MIN(b.step_datetime)) AS duration_seconds
    FROM 
        user_steps a
    LEFT JOIN 
        user_steps b
    ON 
        a.user_id = b.user_id
        AND a.step_datetime < b.step_datetime
    GROUP BY 
        a.user_id, a.step_name, a.step_datetime
)

SELECT 
    current_step,
    AVG(duration_seconds) AS average_duration_seconds
FROM 
    StepDurations
GROUP BY 
    current_step
ORDER BY 
    current_step;
    
    
-- How far each person got in the process    
SELECT clients.client_id,clients.clnt_age, clients.gendr, COUNT(distinct(interactions.process_step)) AS count_of_steps
FROM clients
JOIN interactions
ON clients.client_id = interactions.client_id
GROUP BY clients.client_id, clients.clnt_age, clients.gendr;