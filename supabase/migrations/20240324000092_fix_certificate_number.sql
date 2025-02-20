-- Drop the existing function if it exists
DROP FUNCTION IF EXISTS generate_certificate_number();

-- Create a new simplified function
CREATE OR REPLACE FUNCTION generate_certificate_number()
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    year TEXT := to_char(CURRENT_DATE, 'YY');
    month TEXT := to_char(CURRENT_DATE, 'MM');
    sequence_num INT;
    certificate_num TEXT;
BEGIN
    -- Get the next sequence number for today
    WITH new_sequence AS (
        SELECT COALESCE(MAX(SUBSTRING(certificate_number FROM '\d+$')::INTEGER), 0) + 1 as next_num
        FROM service_records
        WHERE certificate_number LIKE year || month || '%'
    )
    SELECT next_num INTO sequence_num FROM new_sequence;

    -- Format: YYMM0001 (e.g., 24030001 for March 2024, first certificate)
    certificate_num := year || month || LPAD(sequence_num::TEXT, 4, '0');
    
    RETURN certificate_num;
END;
$$; 