-- Drop everything first
DROP FUNCTION IF EXISTS generate_certificate_number();
DROP SEQUENCE IF EXISTS certificate_number_seq;

-- Create a new sequence
CREATE SEQUENCE certificate_number_seq START 24570;

-- Create the absolute simplest possible function
CREATE OR REPLACE FUNCTION generate_certificate_number()
RETURNS TEXT
LANGUAGE sql
AS $$
    SELECT nextval('certificate_number_seq')::TEXT;
$$;

-- Grant permissions to authenticated users
GRANT USAGE ON SEQUENCE certificate_number_seq TO authenticated;
GRANT EXECUTE ON FUNCTION generate_certificate_number() TO authenticated; 