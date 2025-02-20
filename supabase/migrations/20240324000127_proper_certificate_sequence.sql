-- Drop the function as we don't need it anymore
DROP FUNCTION IF EXISTS generate_certificate_number();
DROP SEQUENCE IF EXISTS certificate_number_seq;

-- Create the sequence
CREATE SEQUENCE service_certificate_seq START 24570;

-- Modify the service_records table to use the sequence directly
ALTER TABLE service_records 
    ALTER COLUMN certificate_number SET DEFAULT nextval('service_certificate_seq')::TEXT,
    ALTER COLUMN certificate_number SET NOT NULL;

-- Grant permissions
GRANT USAGE ON SEQUENCE service_certificate_seq TO authenticated; 