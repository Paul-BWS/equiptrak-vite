-- Create a sequence for rivet tool certificate numbers
CREATE SEQUENCE IF NOT EXISTS rivet_tool_certificate_number_seq;

-- Create or replace the function to generate rivet tool certificate numbers
CREATE OR REPLACE FUNCTION generate_rivet_tool_certificate_number()
RETURNS text
LANGUAGE plpgsql
AS $$
DECLARE
    next_number INTEGER;
    certificate_number TEXT;
BEGIN
    -- Get the next number from the sequence
    SELECT nextval('rivet_tool_certificate_number_seq') INTO next_number;
    
    -- Format the certificate number as BWS-XXXX
    certificate_number := 'BWS-' || LPAD(next_number::text, 4, '0');
    
    RETURN certificate_number;
END;
$$; 