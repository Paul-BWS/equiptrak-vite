-- Drop everything related to certificates
DROP FUNCTION IF EXISTS generate_certificate_number();
DROP SEQUENCE IF EXISTS certificate_number_seq;

-- Create a new sequence
CREATE SEQUENCE certificate_number_seq START 24570;

-- Create the simplest possible function
CREATE OR REPLACE FUNCTION generate_certificate_number()
RETURNS TEXT
LANGUAGE sql
AS $$
  SELECT nextval('certificate_number_seq')::TEXT;
$$;

-- Grant ALL permissions
GRANT USAGE ON SEQUENCE certificate_number_seq TO PUBLIC;
GRANT EXECUTE ON FUNCTION generate_certificate_number() TO PUBLIC;
GRANT ALL ON ALL TABLES IN SCHEMA public TO PUBLIC; 