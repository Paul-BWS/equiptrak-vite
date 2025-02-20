-- Drop everything related to certificate numbers
DROP FUNCTION IF EXISTS generate_certificate_number();
DROP SEQUENCE IF EXISTS certificate_number_seq;

-- Create a dead simple sequence
CREATE SEQUENCE certificate_number_seq START 24570;

-- Create the simplest possible function - no security, no policies, no nothing
CREATE OR REPLACE FUNCTION generate_certificate_number()
RETURNS TEXT
LANGUAGE sql
AS $$
  SELECT nextval('certificate_number_seq')::TEXT;
$$;

-- Grant permissions to everyone (we can tighten this later)
GRANT ALL ON ALL TABLES IN SCHEMA public TO PUBLIC;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO PUBLIC;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO PUBLIC; 