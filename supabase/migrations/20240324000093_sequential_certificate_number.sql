-- First create a sequence for certificate numbers
DROP SEQUENCE IF EXISTS certificate_number_seq;
CREATE SEQUENCE certificate_number_seq START 1;

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
    
    -- Format: 6-digit number padded with zeros (e.g., 000001, 000002, etc.)
    RETURN LPAD(next_num::TEXT, 6, '0');
END;
$$;

-- Grant usage on the sequence to authenticated users
GRANT USAGE ON SEQUENCE certificate_number_seq TO authenticated; 