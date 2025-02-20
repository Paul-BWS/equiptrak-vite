-- Update any NULL serial numbers to a temporary value
UPDATE equipment 
SET serial_number = 'UNKNOWN-' || id::text
WHERE serial_number IS NULL OR serial_number = ''; 