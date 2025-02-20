-- Delete duplicate equipment entries, keeping only the first occurrence
WITH duplicates AS (
  SELECT id
  FROM (
    SELECT 
      id,
      ROW_NUMBER() OVER (PARTITION BY customer_id, serial_number ORDER BY id) as rn
    FROM equipment
  ) t
  WHERE rn > 1
)
DELETE FROM equipment
WHERE id IN (SELECT id FROM duplicates); 