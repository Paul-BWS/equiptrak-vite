-- Check for case-insensitive matches of serial numbers
SELECT id, name, serial_number, customer_id, status
FROM equipment
WHERE customer_id = '0cd307a7-c938-49da-b005-17746587ca8a'
  AND LOWER(serial_number) = LOWER('1234567')  -- Replace with the actual serial number
ORDER BY serial_number; 