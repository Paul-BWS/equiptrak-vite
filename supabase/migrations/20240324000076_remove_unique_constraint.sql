-- Remove the unique constraint on serial numbers
ALTER TABLE equipment 
DROP CONSTRAINT IF EXISTS equipment_customer_serial_unique;

-- Keep the NOT NULL constraint since we still want serial numbers to be required
ALTER TABLE equipment 
ALTER COLUMN serial_number SET NOT NULL; 