-- Drop existing function and sequence
DROP FUNCTION IF EXISTS generate_certificate_number();
DROP SEQUENCE IF EXISTS certificate_number_seq;

-- Create new sequence starting at 24570
CREATE SEQUENCE certificate_number_seq START 24570;

-- Create a new, simpler function that just returns the next sequence number
CREATE OR REPLACE FUNCTION generate_certificate_number()
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    next_num INT;
BEGIN
    -- Simply get and return the next number
    SELECT nextval('certificate_number_seq') INTO next_num;
    RETURN next_num::TEXT;
END;
$$;

-- Grant necessary permissions
GRANT USAGE ON SEQUENCE certificate_number_seq TO authenticated;
GRANT EXECUTE ON FUNCTION generate_certificate_number() TO authenticated; 