USE vanguard;

-- Completion Rate: clients that reached the 'confirm' step" 47,800
SELECT clients.client_id, COUNT(process_step)
FROM clients
JOIN interactions
ON clients.client_id = interactions.client_id
WHERE interactions.process_step = 'confirm'
GROUP BY clients.client_id;

-- Completion Rate: clients that did not reach the 'confirm' step: 70,291
SELECT clients.client_id, COUNT(process_step)
FROM clients
JOIN interactions
ON clients.client_id = interactions.client_id
WHERE interactions.process_step != 'confirm'
GROUP BY clients.client_id;