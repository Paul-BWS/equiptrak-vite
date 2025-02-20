-- Drop the existing function
DROP FUNCTION IF EXISTS generate_certificate_number();

-- Create a new sequence if it doesn't exist
DROP SEQUENCE IF EXISTS certificate_number_seq;
CREATE SEQUENCE certificate_number_seq START 24570;

-- Create a completely independent function
CREATE OR REPLACE FUNCTION generate_certificate_number()
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    next_num INT;
BEGIN
    -- Get the next number from the sequence
    SELECT nextval('certificate_number_seq') INTO next_num;
    RETURN next_num::TEXT;
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION generate_certificate_number() TO authenticated;
GRANT USAGE ON SEQUENCE certificate_number_seq TO authenticated;

-- Disable RLS for profiles temporarily
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY; 