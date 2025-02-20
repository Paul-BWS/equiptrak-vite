-- Drop any existing unique constraints
ALTER TABLE equipment 
DROP CONSTRAINT IF EXISTS equipment_serial_number_key,
DROP CONSTRAINT IF EXISTS equipment_customer_serial_unique; 