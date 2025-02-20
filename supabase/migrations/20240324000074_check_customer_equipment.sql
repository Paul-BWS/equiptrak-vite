-- Check existing equipment for this customer
SELECT id, name, serial_number, customer_id, status
FROM equipment
WHERE customer_id = '0cd307a7-c938-49da-b005-17746587ca8a'
ORDER BY serial_number; 