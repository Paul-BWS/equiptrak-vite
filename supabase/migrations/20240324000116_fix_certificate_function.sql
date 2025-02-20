DROP FUNCTION IF EXISTS generate_certificate_number();
DROP SEQUENCE IF EXISTS certificate_number_seq;

CREATE SEQUENCE certificate_number_seq START 24570;

CREATE OR REPLACE FUNCTION generate_certificate_number()
RETURNS TEXT
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT nextval('certificate_number_seq')::TEXT;
$$;

GRANT USAGE ON SEQUENCE certificate_number_seq TO PUBLIC;
GRANT EXECUTE ON FUNCTION generate_certificate_number() TO PUBLIC; 