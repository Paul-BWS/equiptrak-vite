-- Find duplicate serial numbers for each customer
SELECT customer_id, serial_number, COUNT(*), array_agg(id) as equipment_ids
FROM equipment
GROUP BY customer_id, serial_number
HAVING COUNT(*) > 1
ORDER BY customer_id, serial_number; 