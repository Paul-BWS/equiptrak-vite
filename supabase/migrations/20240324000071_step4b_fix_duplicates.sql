-- Fix duplicates by appending a suffix to all but the first occurrence
WITH duplicates AS (
  SELECT 
    id,
    customer_id,
    serial_number,
    ROW_NUMBER() OVER (PARTITION BY customer_id, serial_number ORDER BY id) as occurrence
  FROM equipment
  WHERE (customer_id, serial_number) IN (
    SELECT customer_id, serial_number
    FROM equipment
    GROUP BY customer_id, serial_number
    HAVING COUNT(*) > 1
  )
)
UPDATE equipment e
SET serial_number = e.serial_number || '-' || d.occurrence
FROM duplicates d
WHERE e.id = d.id
AND d.occurrence > 1; 