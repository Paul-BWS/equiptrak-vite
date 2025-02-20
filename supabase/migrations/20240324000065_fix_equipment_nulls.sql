-- First, update any NULL serial numbers to a temporary value
UPDATE equipment 
SET serial_number = 'UNKNOWN-' || id::text
WHERE serial_number IS NULL OR serial_number = '';

-- Add NOT NULL constraint
ALTER TABLE equipment 
ALTER COLUMN serial_number SET NOT NULL;

-- Drop any existing unique constraints
ALTER TABLE equipment 
DROP CONSTRAINT IF EXISTS equipment_serial_number_key,
DROP CONSTRAINT IF EXISTS equipment_customer_serial_unique;

-- Add the combined unique constraint
ALTER TABLE equipment 
ADD CONSTRAINT equipment_customer_serial_unique 
UNIQUE (customer_id, serial_number);

-- Grant necessary permissions
GRANT ALL ON equipment TO authenticated; 