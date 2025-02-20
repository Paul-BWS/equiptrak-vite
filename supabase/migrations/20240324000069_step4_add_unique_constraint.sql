-- Add the combined unique constraint
ALTER TABLE equipment 
ADD CONSTRAINT equipment_customer_serial_unique 
UNIQUE (customer_id, serial_number); 