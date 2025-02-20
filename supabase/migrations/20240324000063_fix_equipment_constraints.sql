-- Drop any existing unique constraints on serial_number
ALTER TABLE equipment 
DROP CONSTRAINT IF EXISTS equipment_serial_number_key;

-- Add a unique constraint that combines customer_id and serial_number
ALTER TABLE equipment 
ADD CONSTRAINT equipment_customer_serial_unique 
UNIQUE (customer_id, serial_number);

-- Grant necessary permissions
GRANT ALL ON equipment TO authenticated; 