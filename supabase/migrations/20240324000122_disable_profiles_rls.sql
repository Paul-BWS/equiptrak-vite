-- Drop any existing policies
DROP POLICY IF EXISTS "profiles_policy" ON profiles;

-- Disable RLS on profiles
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;

-- Drop and recreate certificate function with no dependencies
DROP FUNCTION IF EXISTS generate_certificate_number();
DROP SEQUENCE IF EXISTS certificate_number_seq;

-- Create sequence
CREATE SEQUENCE certificate_number_seq START 24570;

-- Create simple function
CREATE OR REPLACE FUNCTION generate_certificate_number()
RETURNS TEXT
LANGUAGE sql
AS $$
  SELECT nextval('certificate_number_seq')::TEXT;
$$;

-- Grant permissions
GRANT USAGE ON SEQUENCE certificate_number_seq TO authenticated;
GRANT EXECUTE ON FUNCTION generate_certificate_number() TO authenticated; 