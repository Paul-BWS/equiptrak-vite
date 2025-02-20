-- Drop existing policies
DROP POLICY IF EXISTS "profiles_policy" ON profiles;

-- Create a simple policy for profiles that avoids recursion
CREATE POLICY "profiles_policy" ON profiles
FOR ALL USING (
  auth.uid() = id OR 
  auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
);

-- Ensure the certificate number function doesn't depend on profiles
DROP FUNCTION IF EXISTS generate_certificate_number();

-- Create a simpler certificate number function
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
    
    -- Return the number as is
    RETURN next_num::TEXT;
END;
$$;

-- Grant necessary permissions
GRANT USAGE ON SEQUENCE certificate_number_seq TO authenticated;
GRANT EXECUTE ON FUNCTION generate_certificate_number() TO authenticated; 