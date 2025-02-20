-- Drop and recreate the sequence starting from 24570
DROP SEQUENCE IF EXISTS certificate_number_seq;
CREATE SEQUENCE certificate_number_seq START 24570;

-- Drop the existing function if it exists
DROP FUNCTION IF EXISTS generate_certificate_number();

-- Create a new sequential function
CREATE OR REPLACE FUNCTION generate_certificate_number()
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    next_num INT;
BEGIN
    -- Get the next number from the sequence
    SELECT nextval('certificate_number_seq') INTO next_num;
    
    -- Format: number as is (e.g., 24570, 24571, etc.)
    RETURN next_num::TEXT;
END;
$$;

-- Grant usage on the sequence to authenticated users
GRANT USAGE ON SEQUENCE certificate_number_seq TO authenticated; 