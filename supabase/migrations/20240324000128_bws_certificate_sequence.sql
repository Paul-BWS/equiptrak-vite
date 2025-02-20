-- Drop existing sequence
DROP SEQUENCE IF EXISTS service_certificate_seq;

-- Create the sequence
CREATE SEQUENCE service_certificate_seq START 24570;

-- Modify the service_records table to use the sequence with BWS prefix
ALTER TABLE service_records 
    ALTER COLUMN certificate_number SET DEFAULT 'BWS-' || nextval('service_certificate_seq')::TEXT,
    ALTER COLUMN certificate_number SET NOT NULL;

-- Grant permissions
GRANT USAGE ON SEQUENCE service_certificate_seq TO authenticated; 